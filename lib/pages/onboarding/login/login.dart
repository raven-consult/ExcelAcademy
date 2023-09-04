import "package:flutter/material.dart";

import "../errors.dart";
import "../service.dart";

class Login extends StatefulWidget {
  final Function goHome;
  const Login({super.key, required this.goHome});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final _loginService = OnboardingService();

  bool _loading = false;

  String _email = "";
  String _password = "";
  bool _hidePassword = true;

  String? _emailError;
  String? _passwordError;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
    });
  }

  Widget _makeScrollable({required Widget child}) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _topSection() {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome back!", style: TextStyle(fontSize: 40)),
          SizedBox(height: 4),
          Text(
            "We are joyfully sparked to see you again our dearest friend.",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _middleSection() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email Address",
            border: const OutlineInputBorder(),
            errorText: _emailError,
          ),
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            errorText: _passwordError,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
              icon: _hidePassword
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),
          ),
          obscureText: _hidePassword,
        ),
      ],
    );
  }

  void _onClickLogin() async {
    try {
      setState(() {
        _loading = true;
        _emailError = null;
        _passwordError = null;
      });
      await _loginService.signInWithPassword(
        _email,
        _password,
      );
      widget.goHome();
    } on IncorrectPasswordError catch (e) {
      setState(() {
        _passwordError = e.cause;
      });
    } on UserDoesNotExistError catch (e) {
      setState(() {
        _emailError = e.cause;
      });
    } on InvalidEmailError catch (e) {
      setState(() {
        _emailError = e.cause;
      });
    } catch (e) {
      setState(() {
        _emailError = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _bottomSection(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/reset_password");
          },
          child: const Text("FORGOT PASSWORD?"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: _loading ? null : _onClickLogin,
          child: const Text("Log In"),
        ),
        const SizedBox(height: 130),
        OutlinedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 50),
          ),
          onPressed: () {
            widget.goHome();
          },
          child: const Text("Login without password"),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // backgroundColor: Colors.red,
        toolbarHeight: 70.0,
        title: Text(
          "LOG IN YOUR ACCOUNT",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _makeScrollable(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            children: [
              _topSection(),
              const SizedBox(height: 16),
              _middleSection(),
              const SizedBox(height: 16),
              _bottomSection(context),
            ],
          ),
        ),
      ),
    );
  }
}
