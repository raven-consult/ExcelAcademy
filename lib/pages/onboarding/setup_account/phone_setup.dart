import "dart:io";
import "package:flutter/material.dart";

import "package:file_picker/file_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";

import "../service.dart";
import "loading_indicator.dart";

User getCurrentUser() {
  return FirebaseAuth.instance.currentUser!;
}

Reference getUserStoragePath(String uid, String extension) {
  return FirebaseStorage.instance
      .ref()
      .child("users/$uid/public/avatar.$extension");
}

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

  File? _selectedFile;

  void _skipToHome() {
    widget.goHome();
  }

  Future<void> _uploadFileStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["jpg", "png", "jpeg"],
    );
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("Current user is null");
      return;
    } else {
      print("Current user is not null");
    }
    if (result != null) {
      print("File is not null");
      PlatformFile platformFile = result.files.first;
      final file = File(platformFile.path!);
      // upload file to firebase storage
      final ref = getUserStoragePath(currentUser.uid, platformFile.extension!);
      try {
        await ref.putFile(file);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(ref.fullPath);
        setState(() {
          _selectedFile = file;
        });
      } catch (e) {
        print("An ERROR OCCURED");
        print(e);
      }
    }
  }

  Widget _topSection() {
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: ClipOval(
              child: _selectedFile != null
                  ? Image.file(
                      _selectedFile!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _uploadFileStorage();
            },
            child: const Text("CHANGE PROFILE PHOTO"),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String subtitle, String slugName,
      void Function(Function([bool])) onTap) {
    return InkWell(
      onTap: () {
        onTap(([bool done = false]) {
          setState(() {
            if (done) {
              _value[slugName] = true;
            } else if (_value[slugName] != null) {
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

  Widget _bottomSection(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "Easy setup to get started",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            _item(
              "Setup Fingerprint",
              "Add a fingerprint authentication to access your account next time",
              "fingerprint",
              (done) async {
                var didAuthenticate = await _biometicService
                    .fingerprintAuth("Setup FingerPrint Authentication");
                if (didAuthenticate) {
                  done(true);
                }
              },
            ),
            _item(
              "Choose System Color",
              "Add a default background system color",
              "system_color",
              (done) {
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        color: Colors.amber,
                      );
                    });
                done();
              },
            ),
            _item(
              "Assign a default avatar",
              "Kindly choose an avatar to pick from to use.",
              "assign_avatar",
              (done) {
                LoadingIndicatorDialog().show(context);
                _uploadFileStorage().whenComplete(() {
                  LoadingIndicatorDialog().dismiss();
                  done(true);
                });
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
        builder: (_, BoxConstraints viewportConstraints) {
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
                    _bottomSection(context),
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
