import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Widget/earch_bar.dart';
import 'package:store_mangment/Feature/customer_section/Customer_categories/View/productView.dart';
import 'package:store_mangment/Feature/customer_section/Customer_categories/widget/catgoeires_build_item.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class CustomerCategoriesView extends StatelessWidget {
  const CustomerCategoriesView({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    return FirebaseFirestore.instance
        .collection('supermarkets')
        .doc(
            'your_supermarket_id') // Replace with actual ID dynamically if needed
        .collection('categories')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/img/app_logo.png",
            height: 40,
            width: 40,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.black,
            ),
          )
        ],
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "product categories",
            style: AppTextStyle.textStyleBoldBlack,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    final docs = snapshot.data?.docs ?? [];

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        final name = docs[index].id;
                        final imageUrl = data['image_url'] ?? '';

                        if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
                          print(
                              '❌ Image URL is invalid or missing for "$name": $imageUrl');
                        } else {
                          print('✅ Image URL loaded for "$name": $imageUrl');
                        }

                        return GestureDetector(
                          onTap: () {
                            navigateTo(context,
                                CustomerProductView(categoryName: name));
                          },
                          child: CategoriesBuildItem(
                            productName: name,
                            image_url: imageUrl, // pass this into your widget
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
