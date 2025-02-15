import "package:local_auth/local_auth.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:cloud_functions/cloud_functions.dart";

import "errors.dart";

class BiometricService {
  final _auth = LocalAuthentication();

  Future<bool> fingerprintAuth([String message = "Authentication"]) async {
    var canAuthenticate = await _auth.canCheckBiometrics;
    var isDeviceSupported = await _auth.isDeviceSupported();

    if (canAuthenticate && isDeviceSupported) {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: message,
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    }
    return false;
  }
}

class OnboardingService {
  final _googleSignIn = GoogleSignIn();
  final _fireaseAuth = FirebaseAuth.instance;
  final _firebaseFunctions = FirebaseFunctions.instance;

  Future signUpWithPassword(
    String displayName,
    String email,
    String password,
  ) async {
    try {
      var res = await _fireaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await res.user?.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        throw "The account already exists for that email.";
      }
    } catch (e) {
      print(e);
    }
  }

  Future signInWithPassword(String emailAddress, String password) async {
    try {
      await _fireaseAuth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw const UserDoesNotExistError();
      } else if (e.code == "wrong-password") {
        throw const IncorrectPasswordError();
      } else if (e.code == "invalid-email") {
        throw const InvalidEmailError();
      }
    }
  }

  Future signInWithGoogle() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user == null) return;

      var auth = await user.authentication;
      var credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );

      await _fireaseAuth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword(String emailAddress, {bool resend = false}) async {
    try {
      var callable =
          _firebaseFunctions.httpsCallable("auth-sendPasswordResetEmail");
      await callable.call(<String, dynamic>{
        "email": emailAddress,
        "resend": resend,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e.code);
    }
  }

  Future<bool> verifyOTP(String email, String code) async {
    try {
      var callable = _firebaseFunctions.httpsCallable("auth-verifyResetOTP");
      var res = await callable.call(<String, String>{
        "code": code,
        "email": email,
      });
      return res.data["confirmed"] as bool;
    } on FirebaseFunctionsException catch (e) {
      print("code ${e.code}");
      return false;
    }
  }

  Future confirmResetPassword(
      String newPassword, String emailAddress, String resetCode) async {
    var callable =
        _firebaseFunctions.httpsCallable("auth-confirmResetPassword");
    try {
      await callable.call(<String, String>{
        "code": resetCode,
        "email": emailAddress,
        "password": newPassword,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e);
      print(e.code);
      /* if(e.code == "") */
      // TODO: Check if it does not exist
      // TODO: Check for network problem
    }
  }

  Future signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();
    try {
      await _fireaseAuth.signInWithProvider(microsoftProvider);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    await _fireaseAuth.signOut();
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      // No need to check since this user did not sign in with google
    }
  }
}
