import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/vet_service.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class PopularServiceTile extends StatelessWidget {
  final VetService service;
  final VoidCallback? onTap;

  const PopularServiceTile({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = service.imageUrl;
    final title = service.name;
    final price = service.price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[100],
                        alignment: Alignment.center,
                        child: const Text("🐾", style: TextStyle(fontSize: 26)),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[100],
                      alignment: Alignment.center,
                      child: const Text("🐾", style: TextStyle(fontSize: 26)),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.textStyleBoldBlack,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null)
                    Text(
                      "From \$${price}",
                      style: AppTextStyle.textStyleMediumGray,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
