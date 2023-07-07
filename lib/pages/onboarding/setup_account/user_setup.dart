// ignore_for_file: unused_field

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
  int _currentStep = 0;
  final _totalSteps = 3 - 1;
  bool _showPassword = false;
  final Map<String, int> _showButton = {};

  late TabController _controller;
  final formKey = GlobalKey<FormState>();
  final _loginService = OnboardingService();
  final _dateController = TextEditingController();

  String _gender = "";
  String _password = "";
  String _fullName = "";
  String _username = "";
  String _emailAddress = "";
  DateTime _dateOfBirth = DateTime.now();

  final _stepsRequirements = [
    ["fullname", "email"],
    ["username", "dateOfBirth"],
    ["gender", "password"],
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _showButton["email"] = 0;
    _showButton["fullname"] = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future _loginWithoutPassword() async {
    widget.goHome();
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

  Future _goToNextSection() async {
    setState(() {
      _showButton["loading"] = 1;
    });
    try {
      await _loginService.signUpWithPassword(_emailAddress, _password);
      widget.next();
    } catch (e) {
      showErrorDialog();
    } finally {
      setState(() {
        _showButton.remove("loading");
      });
    }
  }

  List<Widget> _getStep(int step) {
    return [
      [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("What’s your email", style: TextStyle(fontSize: 40)),
              SizedBox(height: 4),
              Text(
                "Let’s begin by saving your email for next time",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: "Fullname",
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
          onSaved: (value) {
            setState(() {
              _fullName = value ?? "";
            });
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
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
        ),
      ],
      [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("We keep it secure", style: TextStyle(fontSize: 40)),
              SizedBox(height: 4),
              Text(
                "We’re super-glad to see your progress so far. Your data is save and secure with us",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _username = value;
              });
            });
          },
          validator: (value) {
            if (value == null || !StringValidator.isLongerThan(6, value)) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  _showButton["username"] = 0;
                });
              });
              return "Choose longer username";
            } else {
              if (_showButton["username"] != null) {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    _showButton.remove("username");
                  });
                });
              }
              return null;
            }
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          controller: _dateController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: _dateOfBirth,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  setState(() {});
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      _dateOfBirth = date;
                      _dateController.text =
                          "${date.day}/${date.month}/${date.year}";
                      _showButton.remove("dateOfBirth");
                    });
                  });
                }
              },
              icon: const Icon(Icons.event),
            ),
            hintText: "Date of Birth",
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _username = value;
              });
            });
          },
        ),
      ],
      [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Getting you ready!", style: TextStyle(fontSize: 40)),
              SizedBox(height: 4),
              Text(
                "We are fired-up, we can’t wait for your to finally join us",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        _dropDownFormField(),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: _showPassword,
          decoration: InputDecoration(
            hintText: "Password",
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              icon: _showPassword
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
        ),
      ]
    ][step];
  }

  Widget _dropDownFormField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
        hintText: "Select your Gender",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      items: ["Male", "Female"].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _gender = newValue;
              _showButton.remove("gender");
            });
          });
        }
      },
    );
  }

  PreferredSizeWidget _appBar() {
    var stepText = _totalSteps - 1 == 0
        ? "THAT'S A WRAP"
        : "${_totalSteps - _currentStep} MORE STEPS";

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
          FirebaseCrashlytics.instance.log("Back button pressed");
        },
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "CREATE AN ACCOUNT",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            stepText,
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _stepsBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(10),
          right: Radius.circular(10),
        ),
      ),
      height: 8,
      child: Stack(
        children: [
          Positioned(
            height: 8,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                  right: Radius.circular(10),
                ),
              ),
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 600),
              width: (1 + _currentStep) *
                  ((MediaQuery.of(context).size.width - 20) / 3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scaffold({required Widget child}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLast = _totalSteps == _currentStep;
    const linkStyle = TextStyle(color: Colors.blue);
    const defaultStyle = TextStyle(color: Colors.grey, fontSize: 16.0);

    return Scaffold(
      appBar: _appBar(),
      body: _scaffold(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _stepsBar(context),
                SizedBox(
                  height: 2.7 * (MediaQuery.of(context).size.height / 8),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        Column(children: _getStep(0)),
                        Column(children: _getStep(1)),
                        Column(children: _getStep(2)),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    disabledBackgroundColor: Colors.blue,
                  ),
                  onPressed:
                      _showButton["loading"] == 1 || _showButton.isNotEmpty
                          ? null
                          : () async {
                              formKey.currentState?.validate();
                              if (isLast) {
                                await _goToNextSection();
                              } else {
                                // Check the _stepsRequirements and add the errors to be fixed
                                _controller.animateTo(_currentStep + 1);
                                setState(() {
                                  for (var item
                                      in _stepsRequirements[_currentStep + 1]) {
                                    _showButton[item] = 1;
                                  }
                                  _currentStep += 1;
                                });
                              }
                            },
                  child: isLast
                      ? const Text("Create account")
                      : const Text("Continue"),
                ),
              ],
            ),
            Positioned(
              bottom: 70,
              width: MediaQuery.of(context).size.width - 20,
              child: RichText(
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
              ),
            ),
            Positioned(
              bottom: 200,
              width: MediaQuery.of(context).size.width - 25,
              child: OutlinedButton(
                onPressed: () {
                  _loginWithoutPassword();
                },
                child: const Text("Login without password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
