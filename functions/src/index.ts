import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import EmailService from "./services/email";
import UserOTPRepository from "./repositories";
import {
  VerifyResetOTPRequest,
  VerifyResetOTPResponse,
  ConfirmResetPasswordRequest,
  SendPasswordResetEmailRequest,
} from "./types";


admin.initializeApp();

export const confirmResetPassword = functions
  .https
  .onCall(async (data: ConfirmResetPasswordRequest, context) => {
    const auth = admin.auth();
    const userOTPRepo = new UserOTPRepository();

    const shouldConfirm = await userOTPRepo.confirmOTPForUser(data.email, data.code, {shouldDelete: true});

    console.log("Result is", shouldConfirm);

    // TODO: Added return messages for all kinds
    if (shouldConfirm) {
      try {
        const user = await auth.getUserByEmail(data.email);
        await auth.updateUser(user.uid, {
          password: data.password,
        });
      } catch (e) {
        console.log(e);
      }
    }
  });


export const verifyResetOTP = functions
  .https
  .onCall(async (data: VerifyResetOTPRequest) => {
    const userOTPRepo = new UserOTPRepository();
    const confirmed = await userOTPRepo.confirmOTPForUser(data.email, data.code);
    return {confirmed} as VerifyResetOTPResponse;
  });


export const sendPasswordResetEmail = functions.https.onCall(async (data: SendPasswordResetEmailRequest) => {
  const emailService = new EmailService();
  const userOTPRepo = new UserOTPRepository();

  const code = await userOTPRepo.generateOTPForUser(data.email);

  await emailService.sendEmail({
    subject: "Password Reset",
    recipientEmail: data.email,
    text: `Your password reset code is: ${code}`,
    html: `Your password reset code is: ${code}`,
  });

  functions.logger.info("Sending password reset email", data);
});

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
