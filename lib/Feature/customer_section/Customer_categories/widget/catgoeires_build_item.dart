import 'package:flutter/material.dart';

import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class CategoriesBuildItem extends StatelessWidget {
  final String productName;
  // ignore: non_constant_identifier_names
  final String image_url;

  const CategoriesBuildItem({
    Key? key,
    required this.productName,
    required this.image_url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Builder(
                  builder: (context) {
                    if (image_url.isEmpty || !image_url.startsWith('http')) {
                      debugPrint(
                          'Image URL is invalid or missing for "$productName": $image_url');
                      return const Icon(Icons.image_not_supported, size: 80);
                    }

                    debugPrint('Loading image for "$productName": $image_url');

                    return Image.network(
                      image_url,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          debugPrint('✅ Image loaded for "$productName"');
                          return child;
                        }
                        return const CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                            '❌ Failed to load image for "$productName": $error');
                        return const Icon(Icons.broken_image, size: 80);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // اسم المنتج والسعر
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              productName!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
