export interface Course {
  title: string;
  price: number;
  rating: number;
  courseId: string;
  description: string;
  thumbnailUrl: string;
}

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

export interface SetUserPhoneNumberRequest {
  uid: string;
  phoneNumber: string;
}

export interface SetUserPhoneNumberResponse {}
