import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "package:flutter/scheduler.dart";

import "package:firebase_crashlytics/firebase_crashlytics.dart";

import "../utils.dart";
import "../service.dart";

class UserSetup extends StatefulWidget {
  final Function prev;
  final Function next;
  final Function goHome;

  const UserSetup({
    super.key,
    required this.next,
    required this.prev,
    required this.goHome,
  });

  @override
  State<UserSetup> createState() => _UserSetup();
}

class _UserSetup extends State<UserSetup> with TickerProviderStateMixin {
  late TabController _controller;
  final formKey = GlobalKey<FormState>();
  final _loginService = OnboardingService();

  String _password = "";
  String _fullName = "";
  String _phoneNumber = "";
  String _emailAddress = "";

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final Map<String, int> _showButton = {};

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _onSignup() async {
    await _loginService.signUpWithPassword(
      _fullName,
      _emailAddress,
      _password,
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: Text("Hello"),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          FirebaseCrashlytics.instance.log("Back button pressed");
        },
      ),
      title: Text(
        "CREATE AN ACCOUNT",
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _privacyPolicy() {
    var linkStyle = TextStyle(color: Theme.of(context).colorScheme.primary);
    const defaultStyle = TextStyle(color: Colors.grey, fontSize: 16.0);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          const TextSpan(
            text: "By Creating an account, you accept Excel Academy",
          ),
          TextSpan(
            text: " Terms of Use ",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print("Terms of Use");
              },
          ),
          const TextSpan(text: "and "),
          TextSpan(
            text: "Privacy Policy",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print("Privacy Policy");
              },
          ),
        ],
      ),
    );
  }

  Widget _phoneNumberField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        hintText: "Phone Number",
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _phoneNumber = value;
          });
        });
      },
      validator: (value) {
        if (value == null || value == "") {
          return null;
        } else if (value.length != 11) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _showButton["phoneNumber"] = 0;
            });
          });
          return "Phone number must be eleven digits long";
        } else {
          if (_showButton["phoneNumber"] != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _showButton.remove("phoneNumber");
              });
            });
          }
          return null;
        }
      },
    );
  }

  Widget _fullNameField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        hintText: "Full name",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value == "") {
          return null;
        }
        if (!StringValidator.isLongerThan(6, value)) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _showButton["fullname"] = 0;
            });
          });
          return "Choose longer full name";
        } else {
          if (_showButton["fullname"] != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _showButton.remove("fullname");
              });
            });
          }
          return null;
        }
      },
      onChanged: (value) {
        setState(() {
          _fullName = value;
        });
      },
    );
  }

  Widget _emailAddressField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: "Email Address",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value == "") {
          return null;
        }
        if (!StringValidator.isValidEmail(value)) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _showButton["email"] = 0;
            });
          });
          return "Invalid Email";
        } else {
          if (_showButton["email"] != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _showButton.remove("email");
              });
            });
          }
          return null;
        }
      },
      onChanged: (value) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _emailAddress = value;
          });
        });
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: !_showConfirmPassword,
      decoration: InputDecoration(
        hintText: "Confirm Password",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
          icon: !_showConfirmPassword
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
      ),
      validator: (value) {
        if (value == null || value == "") {
          return null;
        } else if (value != _password) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _showButton["confirmPassword"] = 0;
            });
          });
          return "Password does not match";
        } else {
          if (_showButton["confirmPassword"] != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _showButton.remove("confirmPassword");
              });
            });
          }
          return null;
        }
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        hintText: "Password",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          icon: !_showPassword
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
      ),
      validator: (value) {
        if (value == null || value == "") {
          return null;
        }
        if (!StringValidator.isLongerThan(8, value)) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _showButton["password"] = 0;
            });
          });
          return "Use a password longer than 8 characters";
        } else {
          if (_showButton["password"] != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _showButton.remove("password");
              });
            });
          }
          return null;
        }
      },
      onChanged: (value) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _password = value;
          });
        });
      },
    );
  }

  bool _canShowButton() => _showButton.values.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "What’s your email",
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Let’s begin by saving your email for next time",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _fullNameField(),
                    const SizedBox(height: 8),
                    _emailAddressField(),
                    const SizedBox(height: 8),
                    _phoneNumberField(),
                    const SizedBox(height: 8),
                    _passwordField(),
                    const SizedBox(height: 8),
                    _confirmPasswordField(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _canShowButton()
                          ? () async {
                              try {
                                setState(() {
                                  _showButton["loading"] = 1;
                                });
                                await _onSignup();
                                widget.next();
                              } catch (e) {
                                print("An error occured");
                              } finally {
                                setState(() {
                                  _showButton.remove("loading");
                                });
                              }
                            }
                          : null,
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _privacyPolicy(),
            ],
          ),
        ),
      ),
    );
    // child: Column(children: _getStep(0)),
  }
}
