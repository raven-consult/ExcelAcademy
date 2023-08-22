import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final Function gotoSearch;

  const Search({
    super.key,
    required this.gotoSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What would you want to learn today?",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Hero(
          tag: "search",
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => gotoSearch(),
              child: AbsorbPointer(
                absorbing: true,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Courses",
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 75,
                      child: TextButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: const Text("Search"),
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
