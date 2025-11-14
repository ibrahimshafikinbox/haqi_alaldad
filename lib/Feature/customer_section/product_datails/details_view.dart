import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Widget/app_button.dart';
import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class ProductDetailsView extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String description;
  final String productId;

  const ProductDetailsView({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1A1A1A),
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFF8FFFE),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('product_details'),
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Hero(
              tag: 'product_$productId',
              child: Container(
                height: 350,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            // Product Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Price Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '$price IQD',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  Text(
                    AppLocalizations.of(context).translate('details'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CartCubit>().addToCart(
                          id: productId,
                          name: name,
                          image: imageUrl,
                          description: description,
                          price: double.parse(price),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('added_to_cart'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF4CAF50),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 22),
                      label: Text(
                        AppLocalizations.of(context).translate('add_to_cart'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Buy Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Add Buy Now functionality
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, size: 22),
                      label: Text(
                        AppLocalizations.of(context).translate('buy_now'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4CAF50),
                        side: const BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
// import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
// import 'package:store_mangment/Feature/payment/payment_view.dart';

// class ProductDetailsView extends StatefulWidget {
//   final String imageUrl;
//   final String name;
//   final String price;
//   final String description;
//   final String productId;

//   const ProductDetailsView({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//     required this.price,
//     required this.description,
//     required this.productId,
//   });

//   @override
//   State<ProductDetailsView> createState() => _ProductDetailsViewState();
// }

// class _ProductDetailsViewState extends State<ProductDetailsView> {
//   final ZainCashPaymentService _paymentService = ZainCashPaymentService();
//   bool _isProcessingPayment = false;

//   /// معالجة الشراء المباشر
//   Future<void> _handleBuyNow() async {
//     setState(() => _isProcessingPayment = true);

//     try {
//       // تحويل السعر إلى رقم
//       final double amount = double.parse(widget.price);

//       // التحقق من الحد الأدنى
//       if (amount < 250) {
//         _showErrorDialog(
//           'الحد الأدنى للدفع',
//           'الحد الأدنى للدفع عبر ZainCash هو 250 دينار عراقي',
//         );
//         setState(() => _isProcessingPayment = false);
//         return;
//       }

//       // إنشاء رقم الطلب
//       final String orderId =
//           'ORD_${widget.productId}_${DateTime.now().millisecondsSinceEpoch}';

//       // إنشاء معاملة الدفع
//       final String? paymentUrl = await _paymentService.createTransaction(
//         amount: amount,
//         orderId: orderId,
//         serviceType: widget.name,
//       );

//       if (paymentUrl == null) {
//         throw Exception('فشل إنشاء رابط الدفع');
//       }

//       // فتح شاشة الدفع
//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               PaymentWebView(url: paymentUrl, orderId: orderId, amount: amount),
//         ),
//       );

//       // معالجة نتيجة الدفع
//       if (result != null && mounted) {
//         _handlePaymentResult(result);
//       }
//     } catch (e) {
//       _showErrorDialog('خطأ في الدفع', e.toString());
//     } finally {
//       if (mounted) {
//         setState(() => _isProcessingPayment = false);
//       }
//     }
//   }

//   /// معالجة نتيجة الدفع
//   void _handlePaymentResult(Map<String, dynamic> result) {
//     final status = result['status'];

//     if (status == 'success') {
//       _showSuccessDialog(
//         'تم الدفع بنجاح! ✅',
//         'تم استلام طلبك وسيتم معالجته قريباً.رقم الطلب: ${result['orderId']}المبلغ: ${result['amount']} IQD',
//       );
//     } else if (status == 'failed') {
//       _showErrorDialog(
//         'فشل الدفع',
//         'لم يتم إتمام عملية الدفع. يرجى المحاولة مرة أخرى.',
//       );
//     } else if (status == 'cancelled') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('تم إلغاء عملية الدفع'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }

//   /// إظهار رسالة نجاح
//   void _showSuccessDialog(String title, String message) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF4CAF50).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_circle,
//                 color: Color(0xFF4CAF50),
//                 size: 32,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           message,
//           style: const TextStyle(
//             fontSize: 15,
//             height: 1.5,
//             color: Color(0xFF666666),
//           ),
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4CAF50),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: () {
//               Navigator.pop(context); // إغلاق الحوار
//               Navigator.pop(context); // الرجوع للصفحة السابقة
//             },
//             child: const Text(
//               'حسناً',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// إظهار رسالة خطأ
//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline,
//                 color: Colors.red,
//                 size: 32,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           message,
//           style: const TextStyle(fontSize: 15, height: 1.5),
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () => Navigator.pop(context),
//             child: const Text('حسناً'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FFFE),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.arrow_back_ios_new,
//               color: Color(0xFF1A1A1A),
//               size: 20,
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: const Color(0xFFF8FFFE),
//         elevation: 0,
//         title: Text(
//           AppLocalizations.of(context).translate('product_details'),
//           style: const TextStyle(
//             color: Color(0xFF1A1A1A),
//             fontSize: 20,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Hero(
//               tag: 'product_${widget.productId}',
//               child: Container(
//                 height: 350,
//                 margin: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.12),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Image.network(
//                     widget.imageUrl,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//             ),

//             // Product Info Card
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 16,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Name and Price Row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w900,
//                             color: Color(0xFF1A1A1A),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4CAF50),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF4CAF50).withOpacity(0.3),
//                               blurRadius: 12,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           '${widget.price} IQD',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Description Section
//                   Text(
//                     AppLocalizations.of(context).translate('details'),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w900,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     widget.description,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF666666),
//                       height: 1.6,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Action Buttons
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   // Add to Cart Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         context.read<CartCubit>().addToCart(
//                           id: widget.productId,
//                           name: widget.name,
//                           image: widget.imageUrl,
//                           description: widget.description,
//                           price: double.parse(widget.price),
//                         );

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.check_circle_rounded,
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     AppLocalizations.of(
//                                       context,
//                                     ).translate('added_to_cart'),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             backgroundColor: const Color(0xFF4CAF50),
//                             behavior: SnackBarBehavior.floating,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             margin: const EdgeInsets.all(16),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.add_shopping_cart, size: 22),
//                       label: Text(
//                         AppLocalizations.of(context).translate('add_to_cart'),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF4CAF50),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 4,
//                         shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Buy Now Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: OutlinedButton.icon(
//                       onPressed: _isProcessingPayment ? null : _handleBuyNow,
//                       icon: _isProcessingPayment
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Color(0xFF4CAF50),
//                                 ),
//                               ),
//                             )
//                           : const Icon(Icons.payment, size: 22),
//                       label: Text(
//                         _isProcessingPayment
//                             ? 'جاري المعالجة...'
//                             : AppLocalizations.of(context).translate('buy_now'),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: const Color(0xFF4CAF50),
//                         side: const BorderSide(
//                           color: Color(0xFF4CAF50),
//                           width: 2,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }
