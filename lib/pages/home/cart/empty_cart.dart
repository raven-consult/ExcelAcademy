import "package:flutter/material.dart";

class EmptyCart extends StatelessWidget {
  final Function gotoPrograms;

  const EmptyCart({
    super.key,
    required this.gotoPrograms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/pages/cart/red-cart.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your cart is empty",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Courses you add will appear here.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => gotoPrograms(),
          child: const Text("Explore courses"),
        ),
      ],
    );
  }
}
