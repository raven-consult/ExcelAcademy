import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

const imageUrl = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fhomepage%2Fcontinue-learning.png?alt=media";

class AdPanel extends StatelessWidget {
  const AdPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            imageUrl,
          ),
        ),
      ),
    );
  }
}
