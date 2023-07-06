import "package:flutter/material.dart";

class OngoingCourse extends StatelessWidget {
  const OngoingCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        print("Ongoing course");
      },
      child: Container(
        height: 165,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ongoing course",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "ICAN Public Sector Accounting and Finance (Revision)",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    height: 4,
                    width: double.infinity,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                const Text("23% of 100%"),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Continue learning",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
