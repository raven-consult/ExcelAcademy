/**
 * Generate password from allowed word
 */

import * as crypto from "node:crypto";

const digits = "0123456789";
const specialChars = "#!&@";
const lowerCaseAlphabets = "abcdefghijklmnopqrstuvwxyz";
const upperCaseAlphabets = lowerCaseAlphabets.toUpperCase();

interface OTPOptions {
  maxDigits?: number;
  allowSpecialChars?: boolean;
  allowUpperCaseAlphabets?: false,
  allowLowerCaseAlphabets?: false,
}

class OTPGenerator {
  /**
   * Generate OTP of the length
   */
  public generate({
    maxDigits = 5,
    allowSpecialChars = false,
    allowUpperCaseAlphabets = false,
    allowLowerCaseAlphabets = false,
  }: OTPOptions) {
    const allowsChars = digits +
      ((allowLowerCaseAlphabets || "") && lowerCaseAlphabets) +
      ((allowUpperCaseAlphabets || "") && upperCaseAlphabets) +
      ((allowSpecialChars || "") && specialChars);

    let password = "";
    while (password.length < maxDigits) {
      const charIndex = crypto.randomInt(0, allowsChars.length)
      if (password.length === 0 && digits && allowsChars[charIndex] === "0") {
        continue
      }
      password += allowsChars[charIndex]
    }
    return password
  }
}

export default OTPGenerator;
