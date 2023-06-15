

export interface SendPasswordResetEmailRequest {
  email: string;
}

export interface SendPasswordResetEmailResponse {

}

export interface ConfirmResetPasswordRequest {
  code: string;
  email: string;
  password: string;
}

export interface ConfirmResetPasswordRequest {

}

export interface VerifyResetOTPRequest {
  code: string;
  email: string;
}

export interface VerifyResetOTPResponse {
  confirmed: boolean;
}
