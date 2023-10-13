import "dart:convert";

import "package:flutter/material.dart";

import "package:http/http.dart" as http;
import "package:firebase_auth/firebase_auth.dart";
// import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_paystack/flutter_paystack.dart";

var publicKey =
    "pk_test_1a1b2a3b4c5d6e7f8g9h0i1j2k3l4m5n6o7p8q9r0s1t2u3v4w5x6y7z8a9b0c1";

/* Map<String, String> recommendationsServiceConn = { */
/*   "host": dotenv.env["PAYMENT"] ?? "localhost", */
/*   "port": dotenv.env["PAYMENT_PORT"] ?? "443", */
/* }; */

Map<String, String> recommendationsServiceConn = {
  "host": "localhost",
  "port": "8080",
};

class InitializeResponse {
  final String reference;
  final String accessCode;

  const InitializeResponse({
    required this.reference,
    required this.accessCode,
  });
}

class PaymentService {
  final PaystackPlugin _paystackPlugin = PaystackPlugin();

  final paymentUrl = "http://${recommendationsServiceConn["host"]}"
      ":${recommendationsServiceConn["port"]}";

  final _logo = Container(
    width: 100,
    height: 100,
    color: Colors.red,
  );

  PaymentService() {
    _paystackPlugin.initialize(publicKey: publicKey);
  }

  Future<String> _getFirebaseAuthToken() async {
    String token;
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      token = "";
    } else {
      token = await user.getIdToken() ?? "";
    }
    return token;
  }

  Future<InitializeResponse> initializePayment({
    String? discountCode,
    required String userId,
    required List<String> courseIds,
  }) async {
    // Make a request to backend to initialize payment
    var res = await http.post(
      Uri.parse("$paymentUrl/initialize"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await _getFirebaseAuthToken()}",
      },
      body: jsonEncode({
        "userId": userId,
        "courseId": courseIds,
        "discountCode": discountCode,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to initialize payment");
    }

    // Parse the response
    var data = jsonDecode(res.body) as Map<String, String>;

    return InitializeResponse(
      reference: data["reference"]!,
      accessCode: data["accessCode"]!,
    );
  }

  Future<Map<String, dynamic>> validateDiscount({
    required String discountCode,
    required List<String> courseIds,
  }) async {
    // Make a request to backend to validate discount
    // ignore: todo

    var res = await http.post(
      Uri.parse("$paymentUrl/validateDiscount"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await _getFirebaseAuthToken()}",
      },
      body: jsonEncode({
        "discountCode": discountCode,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Discount code is invalid");
    }

    // Parse the response
    var data = jsonDecode(res.body) as Map<String, dynamic>;

    var valid = data["valid"] as bool;
    if (!valid) {
      throw Exception("Discount code is invalid");
    }

    var resultantAmount = double.parse(data["resultantAmount"] as String);

    return {
      "valid": valid,
      "resultantAmount": resultantAmount,
    };
  }

  Future<bool> verifyPayment(String reference) async {
    // Make a request to backend to initialize payment
    var res = await http.post(
      Uri.parse("$paymentUrl/verify"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await _getFirebaseAuthToken()}",
      },
      body: jsonEncode({
        "reference": reference,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to initialize payment");
    }

    // Parse the response
    var data = jsonDecode(res.body) as Map<String, bool>;

    return data["status"]!;
  }

  Future<void> sample({
    required String email,
    required String reference,
    required BuildContext context,
  }) async {
    final Charge charge = Charge()
      ..amount = 10000
      ..reference = "123456789"
      ..email = email;

    CheckoutResponse response;

    try {
      // ignore: use_build_context_synchronously
      response = await _paystackPlugin.checkout(
        context,
        logo: _logo,
        charge: charge,
        fullscreen: false,
        method: CheckoutMethod.card,
      );
      if (response.status == false) {
        throw Exception("Payment status is false");
      }
    } catch (e) {
      print("Payment failed");
      print(e);
      throw e;
    }
  }

  Future<CheckoutResponse> checkout({
    required String email,
    required String reference,
    required String accessCode,
    required BuildContext context,
  }) async {
    final Charge charge = Charge()
      ..email = email
      ..reference = reference
      ..accessCode = accessCode;

    CheckoutResponse response;

    try {
      // ignore: use_build_context_synchronously
      response = await _paystackPlugin.checkout(
        context,
        logo: _logo,
        charge: charge,
        fullscreen: false,
        method: CheckoutMethod.card,
      );
      if (response.status == false) {
        throw Exception("Payment status is false");
      }
    } catch (e) {
      print("Payment failed");
      print(e);
      throw e;
    }

    return response;
  }
}
