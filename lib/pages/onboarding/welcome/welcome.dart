import "package:flutter/material.dart";

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _Welcome();
}

class WelcomeItem {
  final String title;
  final String picture;
  final String subtitle;

  const WelcomeItem({
    required this.title,
    required this.picture,
    required this.subtitle,
  });
}

class _Welcome extends State<Welcome> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  final _lastStep = 3 - 1;

  late TabController _tabController;

  final List<WelcomeItem> _welcomeItems = [
    const WelcomeItem(
      title: "Easy way to learn at your own pace",
      picture: "assets/pages/onboarding/step_0.png",
      subtitle:
          "Whether you prefer to study intensively or gradually. Learn anywhere and anytime at your leisure.",
    ),
    const WelcomeItem(
      picture: "assets/pages/onboarding/step_1.png",
      title: "Learn from our Professional Instructors",
      subtitle:
          "Whether you prefer to study intensively or gradually. Learn anywhere and anytime at your leisure.",
    ),
    const WelcomeItem(
      title: "Connect with like minds Globally",
      picture: "assets/pages/onboarding/step_2.png",
      subtitle:
          "We believe that learning is a collaborative process. You’d connect with other professionals, share insights, and get fulltime support.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: GestureDetector(
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                _gotoLogin(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _step() {
    return Stack(
      children: [
        Positioned(
          // curve: Curves.easeOut,
          left: (0 * ((MediaQuery.of(context).size.width - 24) / 3)),
          // duration: const Duration(milliseconds: 600),
          child: Container(
            color: const Color(0xFFD9D9D9),
            width: ((MediaQuery.of(context).size.width - 24) / 3) - 5,
            height: 20,
          ),
        ),
        Positioned(
          // curve: Curves.easeOut,
          left: (1 * ((MediaQuery.of(context).size.width - 24) / 3)),
          // duration: const Duration(milliseconds: 600),
          child: Container(
            color: const Color(0xFFD9D9D9),
            width: ((MediaQuery.of(context).size.width - 24) / 3) - 5,
            height: 20,
          ),
        ),
        Positioned(
          // curve: Curves.easeOut,
          left: (2 * ((MediaQuery.of(context).size.width - 24) / 3)),
          // duration: const Duration(milliseconds: 600),
          child: Container(
            color: const Color(0xFFD9D9D9),
            width: ((MediaQuery.of(context).size.width - 24) / 3) - 5,
            height: 20,
          ),
        ),
        AnimatedPositioned(
          curve: Curves.easeOut,
          left: (_currentStep * ((MediaQuery.of(context).size.width - 24) / 3)),
          duration: const Duration(milliseconds: 600),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            width: ((MediaQuery.of(context).size.width - 24) / 3) - 5,
            height: 20,
          ),
        ),
      ],
    );
  }

  Widget _topSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 2 * (MediaQuery.of(context).size.height / 3),
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _welcomeItems
            .map(
              (item) => Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                        width: 10,
                        height: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(item.picture),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          item.subtitle,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  void _gotoLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/create_account");
  }

  Widget _bottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 0.3 * (MediaQuery.of(context).size.height / 3),
      child: Column(
        children: [
          SizedBox(
            height: 5,
            child: _step(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == _lastStep) {
                  _gotoLogin(context);
                } else {
                  setState(() {
                    var currentStep = (_currentStep + 1) % 3;

                    _currentStep = currentStep;
                    _tabController.animateTo(currentStep);
                  });
                }
              },
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _topSection(),
                  _bottomSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
