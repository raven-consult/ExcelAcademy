import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What would you want to learn today?",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Courses",
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            suffixIcon: SizedBox(
              width: 75,
              child: TextButton(
                onPressed: () {
                  print("Search");
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text("Search"),
              ),
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
