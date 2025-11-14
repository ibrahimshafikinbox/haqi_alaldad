import 'package:flutter/material.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class CategoriesBildWidget extends StatelessWidget {
  const CategoriesBildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.4,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(16),
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
            child: const Center(
                child: Text("Milks ", style: AppTextStyle.textStyleBoldBlack)));
      },
    );
  }
}
