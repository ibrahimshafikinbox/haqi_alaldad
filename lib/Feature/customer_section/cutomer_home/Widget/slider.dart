import 'package:flutter/material.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';

class Product {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;

  Product({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
  });
}

class ProductSlider extends StatelessWidget {
  final List<Product> products = [
    Product(
      title: "FRESH MILK",
      subtitle: "ORGANIC & NATURAL",
      description:
          "A fresh and natural milk sourced from organic farms, rich in nutrients...",
      imageUrl:
          "https://img.freepik.com/free-vector/realistic-natural-rustic-milk-package-ad-poster-with-milk-splashes-glass-camomile-field-with-text-illustration_1284-29515.jpg?ga=GA1.1.1159215571.1743146981&semt=ais_hybrid&w=740",
    ),
    Product(
      title: "PREMIUM COFFEE",
      subtitle: "RICH & AROMATIC",
      description:
          "A premium roasted coffee with a deep aroma and a smooth taste...",
      imageUrl:
          "https://img.freepik.com/free-vector/vector-icon-illustration-paper-coffee-cup-with-splash-coffe-background-premium-coffee-roasters_134830-2138.jpg?ga=GA1.1.1159215571.1743146981&semt=ais_hybrid&w=740",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              product.subtitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Buy now"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.network(
                        product.imageUrl,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
