import 'package:flutter/material.dart';

import "../service.dart";

class PhoneSetup extends StatefulWidget {
  final Function prev;
  final Function next;
  final Function goHome;

  const PhoneSetup({
    super.key,
    required this.prev,
    required this.next,
    required this.goHome,
  });

  @override
  State<PhoneSetup> createState() => _PhoneSetup();
}

class _PhoneSetup extends State<PhoneSetup> {
  final Map<String, bool> _value = {};

  final _biometicService = BiometricService();

  void _skipToHome() {
    widget.goHome();
  }

  Widget _topSection() {
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundColor: Colors.green,
            child: Text(
              "UU",
              style: TextStyle(fontSize: 50),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              print("Change profile photo");
            },
            child: const Text("CHANGE PROFILE PHOTO"),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String subtitle, String slugName,
      void Function(Function) onTap) {
    return InkWell(
      onTap: () {
        onTap(() {
          setState(() {
            if (_value[slugName] != null) {
              _value[slugName] = !_value[slugName]!;
            } else {
              _value[slugName] = true;
            }
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                checkColor: Colors.white,
                shape: const CircleBorder(),
                visualDensity: VisualDensity.standard,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: _value[slugName] ?? false,
                onChanged: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSection() {
    return Expanded(
      flex: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Easy setup to get started",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            _item(
              "Setup Fingerprint",
              "Add a fingerprint authentication to access your account next time",
              "fingerprint",
              (done) async {
                var didAuthenticate = await _biometicService.fingerprintAuth();
                print("didAuthenticate: $didAuthenticate");
                if (didAuthenticate) {
                  done();
                }
              },
            ),
            _item(
              "Choose System Color",
              "Add a default background system color",
              "system_color",
              (done) {
                done();
              },
            ),
            _item(
              "Assign a default avatar",
              "Kindly choose an avatar to pick from to use.",
              "assign_avatar",
              (done) {
                done();
              },
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: _skipToHome,
              child: const Text("SKIP NOW"),
            )
          ],
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _topSection(),
                    _bottomSection(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
