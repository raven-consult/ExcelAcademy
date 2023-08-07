import "package:flutter/material.dart";

import "package:mobile/components/shimmer.dart";
import "package:mobile/services/available_programs.dart";

import '../components/course_program_item.dart';

class CourseProgramsList extends StatefulWidget {
  final Function gotoCategories;

  const CourseProgramsList({
    super.key,
    required this.gotoCategories,
  });

  @override
  State<CourseProgramsList> createState() => _CourseProgramsList();
}

class _CourseProgramsList extends State<CourseProgramsList> {
  final ProgramsService _programsService = ProgramsService();

  late Future<List<CourseProgramItemData>> _programs;

  @override
  void initState() {
    super.initState();
    _programs = _programsService.getAllPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Programs",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 2),
            Text(
              "Browse through our available programs",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: _programs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  6,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 6,
                      ),
                      child: ShimmerWidget.rectangular(),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error fetching data"),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No data found"),
              );
            } else {
              var snapshotData = snapshot.data!;
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshotData.map((item) {
                  return InkWell(
                    onTap: () {
                      print("Tapped ${item.fullName}");
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 6,
                      ),
                      child: CourseProgramItem(item: item),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            widget.gotoCategories();
          },
          child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: ShapeDecoration(
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "See more programs",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
