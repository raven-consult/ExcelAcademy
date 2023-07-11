import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import OTPGenerator from "./utils/otp";

interface UserOTPData {
  email: string;
  expiry: number;
}


class UserOTPRepository {
  private readonly otpGenerator = new OTPGenerator();
  private readonly database = admin.database().ref("userOTPs");

  public async generateOTPForUser(email: string): Promise<string> {
    const code = this.otpGenerator.generate({});
    const ref = this.database.child(code);

    const duration = 240 * 1000;
    const expiry = new Date().getTime() + duration;
    await ref.set(<UserOTPData>{email, expiry});
    return code;
  }

  public async confirmOTPForUser(email: string, code: string, {shouldDelete = false} = {}): Promise<boolean> {
    let res = false;

    const ref = this.database.child(code);
    const snapshot = await ref.get();

    if (snapshot.exists()) {
      const data = snapshot.toJSON() as UserOTPData;
      functions.logger.log(data);
      if (data.email == email) {
        res = true;
      }
    }
    if (shouldDelete) {
      await ref.remove();
    }
    return res;
  }
}


export default UserOTPRepository;
