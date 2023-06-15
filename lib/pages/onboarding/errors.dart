class OnboardingException implements Exception {
  final String cause;
  OnboardingException(this.cause);
}

class UserDoesNotExistError implements OnboardingException {
  @override
  final String cause = "User does not exist";
  const UserDoesNotExistError();
}

class InvalidEmailError implements OnboardingException {
  @override
  final String cause = "Email is badly formatted";
  const InvalidEmailError();
}

class IncorrectPasswordError implements OnboardingException {
  @override
  final String cause = "Password Incorrect";
  const IncorrectPasswordError();
}

class EmailAlreadyInUseError implements OnboardingException {
  @override
  final String cause = "Email already in use";
  const EmailAlreadyInUseError();
}
