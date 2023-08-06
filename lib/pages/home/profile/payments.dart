import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _Payments();
}

class _Payments extends State<Payments> {
  Widget _buildPaymentItem() {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.4),
            child: const Text("AC", style: TextStyle(color: Colors.white)),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Category: ICAN"),
              SizedBox(height: 4),
              Text("ICAN Public Sector Accounting and Finance"),
              SizedBox(height: 6),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  animation: CurvedAnimation(
                    parent: const AlwaysStoppedAnimation(1),
                    curve: Curves.easeInOut,
                  ),
                  behavior: SnackBarBehavior.floating,
                  content: const Text("Downloading receipt..."),
                ),
              );
            },
            icon: Icon(
              Icons.receipt,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: const Text("Purchased on 12th May, 2021"),
        ),
        const SizedBox(
          height: 16,
        ),
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment History",
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Setup your payments for better experience.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: List.generate(
                    3,
                    (index) => _buildPaymentItem(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
