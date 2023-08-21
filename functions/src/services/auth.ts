import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import EmailService from "../utils/email";
import UserOTPRepository from "../repositories";
import {
  VerifyResetOTPRequest,
  VerifyResetOTPResponse,
  ConfirmResetPasswordRequest,
  SendPasswordResetEmailRequest,
  SetUserPhoneNumberRequest,
  SetUserPhoneNumberResponse,
} from "../types";


export const confirmResetPassword = functions
  .https
  .onCall(async (data: ConfirmResetPasswordRequest) => {
    const auth = admin.auth();
    const userOTPRepo = new UserOTPRepository();

    const shouldConfirm = await userOTPRepo.confirmOTPForUser(data.email, data.code, {shouldDelete: true});

    functions.logger.info("Confirming password reset", data);
    functions.logger.info("Result is", shouldConfirm);

    // TODO: Added return messages for all kinds
    if (shouldConfirm) {
      try {
        const user = await auth.getUserByEmail(data.email);
        await auth.updateUser(user.uid, {
          password: data.password,
        });
      } catch (e) {
        functions.logger.error("Error while updating password", e);
        throw new functions.https.HttpsError("internal", "Error while updating password");
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

  try {
    await emailService.sendEmail({
      subject: "Password Reset",
      recipientEmail: data.email,
      text: `Your password reset code is: ${code}`,
      html: `Your password reset code is: ${code}`,
    });
  } catch (e) {
    functions.logger.error("Error while sending email", e);
    throw new functions.https.HttpsError("internal", "Error while sending email");
  }

  functions.logger.info("Sending password reset email", data);
});

// The function set the user's phone number in the firebase auth
// This bypasses the phone number verification process from that
// is required by firebase auth in the client side
export const setUserPhoneNumber = functions.https.onCall(async (data: SetUserPhoneNumberRequest) => {
  const auth = admin.auth();

  await auth.updateUser(data.uid, {
    phoneNumber: data.phoneNumber,
  });

  return {} as SetUserPhoneNumberResponse;
});
