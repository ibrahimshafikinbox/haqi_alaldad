import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';

class TopSalesBuildWidget extends StatelessWidget {
  const TopSalesBuildWidget({super.key});

  Future<List<Map<String, dynamic>>> fetchTopSales() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('top_sales')
          .limit(5)
          .get();

      final data = snapshot.docs.map((doc) => doc.data()).toList();
      print('Fetched top sales: $data');
      return data;
    } catch (e) {
      print('Error fetching top sales: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTopSales(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('FutureBuilder error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];

        return SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              print('Rendering product $index: $product');

              final id = product['product_id'] ?? 'N/A';
              final name = product['product_name'] ?? 'Unnamed';
              final image =
                  product['product_image'] ??
                  'https://via.placeholder.com/150'; // fallback image
              final description = product['product_description'] ?? '';
              final rawPrice = product['product_price'];

              final price = double.tryParse(rawPrice.toString()) ?? 0;

              return Container(
                width: MediaQuery.of(context).size.width / 2,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "\ ${(price).toStringAsFixed(2)} IQD ",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              spreadRadius: 3,
                              offset: Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              context.read<CartCubit>().addToCart(
                                id: id,
                                name: name,
                                image: image,
                                description: description,
                                price: price,
                              );
                              Fluttertoast.showToast(
                                backgroundColor: AppColors.green,
                                msg: 'Added to cart: $name (\ $price)',
                              );
                            },
                            child: const Text("Add to Cart"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
