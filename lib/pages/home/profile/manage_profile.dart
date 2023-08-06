import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({super.key});

  @override
  State<ManageProfile> createState() => _ManageProfile();
}

class _ManageProfile extends State<ManageProfile> {
  late User _user;

  final Map<String, String> _changedFields = {};
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _user = auth.currentUser!;
  }

  bool _shouldShowSaveButton() => _changedFields.isNotEmpty;

  bool _shouldEnableEmailOrPassword() {
    for (final provider in _user.providerData) {
      if (provider.providerId == "password") {
        return true;
      }
    }
    return false;
  }

  final _nigeriaPhonePrefix = "+234";

  Future<void> _onSave() async {
    if (_changedFields["name"] != null) {
      await _user.updateDisplayName(_changedFields["name"]!);
    }

    if (_changedFields["email"] != null) {
      await _user.updateEmail(_changedFields["email"]!);
    }

    if (_changedFields["password"] != null) {
      await _user.updatePassword(_changedFields["password"]!);
    }

    if (_changedFields["phone"] != null) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _nigeriaPhonePrefix + _changedFields["phone"]!,
        verificationCompleted: (PhoneAuthCredential credential) {
          _user.updatePhoneNumber(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          String smsCode = "";

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                title: const Text("Enter SMS Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        smsCode = value;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: smsCode);

                        _user.updatePhoneNumber(phoneAuthCredential);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );

      setState(() {
        _changedFields.clear();
      });
    }
  }

  Widget _buildTextField({
    required String id,
    String? defaultValue,
    bool enabled = true,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType? keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        TextFormField(
          enabled: enabled,
          validator: validator,
          keyboardType: keyboardType,
          initialValue: defaultValue,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            if (value != defaultValue) {
              setState(() {
                _changedFields[id] = value;
              });
            } else {
              setState(() {
                _changedFields.remove(id);
              });
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manage Profile",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Setup your profile for better experience. "
                    "You can change your profile picture, name, email and password.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _buildTextField(
                      id: "name",
                      hintText: "Full name",
                      defaultValue: _user.displayName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      id: "email",
                      hintText: "Email address",
                      defaultValue: _user.email,
                      enabled: _shouldEnableEmailOrPassword(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!_shouldEnableEmailOrPassword()) return null;

                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      id: "phone",
                      hintText: "Phone number",
                      keyboardType: TextInputType.phone,
                      defaultValue: _user.phoneNumber!.replaceAll(
                        _nigeriaPhonePrefix,
                        "0",
                      ),
                      validator: (value) {
                        if (_user.phoneNumber == null && value == null) {
                          return null;
                        }

                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }

                        return null;
                      },
                    ),
                    _buildTextField(
                      id: "password",
                      hintText: "Password",
                      enabled: _shouldEnableEmailOrPassword(),
                      validator: (value) {
                        if (!_shouldEnableEmailOrPassword()) return null;

                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      id: "confirm_password",
                      hintText: "Confirm password",
                      enabled: _shouldEnableEmailOrPassword(),
                      validator: (value) {
                        if (!_shouldEnableEmailOrPassword()) return null;

                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: _shouldShowSaveButton() ? _onSave : null,
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
