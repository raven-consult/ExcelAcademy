import 'package:flutter/material.dart';

import "package:mobile/components/shimmer.dart";
import "package:mobile/services/available_programs.dart";

import '../components/course_program_item.dart';

class AllCategories extends StatelessWidget {
  final Future<List<CourseProgramItemData>> programs;
  final Function(CourseProgramItemData) onTapCategory;

  const AllCategories({
    super.key,
    required this.programs,
    required this.onTapCategory,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: programs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              4,
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
            child: Text("Error"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No data"),
          );
        } else {
          var snapshotData = snapshot.data!;
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshotData.map((item) {
              return CourseProgramItem(
                  item: item,
                  onTap: () {
                    onTapCategory(item);
                  });
            }).toList(),
          );
        }
      },
    );
  }
}
