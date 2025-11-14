// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
// import 'package:store_mangment/Core/Widget/confirmation_dialog.dart';
// import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:store_mangment/Feature/payment/payment_view.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   final ZainCashPaymentService _paymentService = ZainCashPaymentService();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isProcessingPayment = false;

//   Future<void> _processPayment(double totalAmount) async {
//     if (_isProcessingPayment) return;

//     setState(() => _isProcessingPayment = true);

//     try {
//       if (totalAmount < 250) {
//         _showErrorDialog(
//           'الحد الأدنى للدفع',
//           'الحد الأدنى للدفع عبر ZainCash هو 250 دينار عراقي ',
//         );
//         return;
//       }

//       final String orderId = 'CART_${DateTime.now().millisecondsSinceEpoch}';

//       final String? paymentUrl = await _paymentService.createTransaction(
//         amount: totalAmount,
//         orderId: orderId,
//         serviceType: 'Cart Purchase',
//       );

//       if (paymentUrl == null) {
//         throw Exception('فشل إنشاء رابط الدفع');
//       }

//       // فتح شاشة الدفع
//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PaymentWebView(
//             url: paymentUrl,
//             orderId: orderId,
//             amount: totalAmount,
//           ),
//         ),
//       );

//       // معالجة نتيجة الدفع
//       if (result != null && mounted) {
//         await _handlePaymentResult(result);
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
//   Future<void> _handlePaymentResult(Map<String, dynamic> result) async {
//     final status = result['status'];

//     if (status == 'success') {
//       // حفظ الطلب في Firebase
//       await _saveOrderToFirestore(result['orderId'], result['amount']);

//       // إظهار رسالة النجاح
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
//       Fluttertoast.showToast(
//         msg: 'تم إلغاء عملية الدفع',
//         backgroundColor: Colors.orange,
//       );
//     }
//   }

//   /// حفظ الطلب في Firebase
//   Future<void> _saveOrderToFirestore(String orderId, double amount) async {
//     try {
//       final cartCubit = context.read<CartCubit>();
//       final cartItems = cartCubit.state.cartItems;

//       final userId = "user123"; // استبدل بمعرف المستخدم الحقيقي
//       final userName = "ibrahim shafik"; // استبدل باسم المستخدم الحقيقي

//       List<Map<String, dynamic>> orderItems = cartItems.map((item) {
//         return {
//           'productId': item['id'],
//           'name': item['name'],
//           'image': item['image'],
//           'price': item['price'],
//           'quantity': item['quantity'],
//         };
//       }).toList();

//       final orderData = {
//         'orderId': orderId,
//         'userId': userId,
//         'customerName': userName,
//         'items': orderItems,
//         'totalAmount': amount,
//         'createdAt': FieldValue.serverTimestamp(),
//         'orderStatus': 'Pending',
//         'paymentStatus': 'Completed',
//         'paymentMethod': 'ZainCash',
//       };

//       await _firestore.collection('market_orders').add(orderData);

//       // تفريغ السلة بعد نجاح الطلب
//       cartCubit.clearCart();

//       Fluttertoast.showToast(
//         msg: AppLocalizations.of(
//           context,
//         ).translate('order_placed_successfully'),
//         backgroundColor: const Color(0xFF00B894),
//       );
//     } catch (e) {
//       print("Error saving order: $e");
//       Fluttertoast.showToast(
//         msg: AppLocalizations.of(context).translate('failed_to_place_order'),
//         backgroundColor: Colors.red,
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
//                 color: const Color(0xFF00B894).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_circle,
//                 color: Color(0xFF00B894),
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
//               backgroundColor: const Color(0xFF00B894),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
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
//   void initState() {
//     super.initState();
//     context.read<CartCubit>().loadCart();
//   }

//   String _formatPrice(num price) {
//     if (price % 1 == 0) {
//       return price.toInt().toString();
//     } else {
//       return price.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(color: Colors.white),
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: const EdgeInsets.only(
//                   top: 50,
//                   left: 20,
//                   right: 20,
//                   bottom: 20,
//                 ),
//                 child: Row(
//                   children: [
//                     Center(
//                       child: Text(
//                         AppLocalizations.of(context).translate('shopping_cart'),
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3436),
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SliverToBoxAdapter(
//               child: CustomPaint(
//                 size: Size(double.infinity, 100),
//                 painter: DecorativeShapesPainter(),
//               ),
//             ),

//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: BlocBuilder<CartCubit, CartState>(
//                   builder: (context, state) {
//                     if (state.cartItems.isEmpty) {
//                       return Container(
//                         height: MediaQuery.of(context).size.height * 0.5,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(50),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 8,
//                                     blurRadius: 20,
//                                     offset: const Offset(0, 8),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.shopping_cart_outlined,
//                                 size: 100,
//                                 color: Color(0xFF6C5CE7),
//                               ),
//                             ),
//                             const SizedBox(height: 30),
//                             Text(
//                               AppLocalizations.of(
//                                 context,
//                               ).translate('your_cart_is_empty'),
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF2D3436),
//                               ),
//                             ),
//                             const SizedBox(height: 15),
//                             Text(
//                               AppLocalizations.of(
//                                 context,
//                               ).translate('add_some_amazing_products'),
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Color(0xFF636E72),
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Cart items count header
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(20),
//                           margin: const EdgeInsets.only(bottom: 25),
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xFF74B9FF).withOpacity(0.4),
//                                 spreadRadius: 3,
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.shopping_bag_outlined,
//                                     color: Colors.white,
//                                     size: 28,
//                                   ),
//                                   const SizedBox(width: 15),
//                                   Text(
//                                     '${state.cartItems.length} ${AppLocalizations.of(context).translate('items')}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 15,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   '${_formatPrice(state.total ?? 0)} IQD',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Cart items list
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: state.cartItems.length,
//                           itemBuilder: (context, index) {
//                             final item = state.cartItems[index];
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 20.0),
//                               child: CartItem(
//                                 cartItem: item,
//                                 formatPrice: _formatPrice,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),

//             // Order summary section
//             SliverToBoxAdapter(
//               child: BlocBuilder<CartCubit, CartState>(
//                 builder: (context, state) {
//                   if (state.cartItems.isEmpty) return const SizedBox();

//                   return Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       padding: const EdgeInsets.all(25),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(25),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.15),
//                             spreadRadius: 5,
//                             blurRadius: 20,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.receipt_long,
//                                 color: Color(0xFF6C5CE7),
//                                 size: 28,
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 AppLocalizations.of(
//                                   context,
//                                 ).translate('order_summary'),
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF2D3436),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 25),
//                           SummaryRow(
//                             label: AppLocalizations.of(
//                               context,
//                             ).translate('subtotal'),
//                             value: '${_formatPrice(state.total ?? 0)} IQD',
//                           ),
//                           SummaryRow(
//                             label: AppLocalizations.of(
//                               context,
//                             ).translate('shipping'),
//                             value: AppLocalizations.of(
//                               context,
//                             ).translate('free'),
//                             valueColor: const Color(0xFF00B894),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 15),
//                             height: 1,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.transparent,
//                                   Colors.grey.shade300,
//                                   Colors.transparent,
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SummaryRow(
//                             label: AppLocalizations.of(
//                               context,
//                             ).translate('total'),
//                             value: '${_formatPrice(state.total ?? 0)} IQD',
//                             isBold: true,
//                             valueColor: const Color(0xFF6C5CE7),
//                           ),
//                           const SizedBox(height: 30),
//                           GestureDetector(
//                             onTap: _isProcessingPayment
//                                 ? null
//                                 : () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => ConfirmationDialog(
//                                         title: AppLocalizations.of(
//                                           context,
//                                         ).translate('payment_confirmation'),
//                                         content: AppLocalizations.of(context)
//                                             .translate(
//                                               'payment_confirmation_message',
//                                             ),
//                                         onConfirm: () async {
//                                           final total = context
//                                               .read<CartCubit>()
//                                               .state
//                                               .total;
//                                           if (total != null && total > 0) {
//                                             await _processPayment(
//                                               total.toDouble(),
//                                             );
//                                           } else {
//                                             Fluttertoast.showToast(
//                                               msg: AppLocalizations.of(context)
//                                                   .translate(
//                                                     'invalid_total_amount',
//                                                   ),
//                                             );
//                                           }
//                                         },
//                                       ),
//                                     );
//                                   },
//                             child: Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(vertical: 20),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: _isProcessingPayment
//                                       ? [Colors.grey, Colors.grey.shade400]
//                                       : [Color(0xFF00B894), Color(0xFF00CEC9)],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: _isProcessingPayment
//                                         ? Colors.grey.withOpacity(0.3)
//                                         : const Color(
//                                             0xFF00B894,
//                                           ).withOpacity(0.5),
//                                     spreadRadius: 2,
//                                     blurRadius: 15,
//                                     offset: const Offset(0, 8),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   if (_isProcessingPayment)
//                                     const SizedBox(
//                                       width: 24,
//                                       height: 24,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Colors.white,
//                                             ),
//                                       ),
//                                     )
//                                   else
//                                     Icon(
//                                       Icons.payment_rounded,
//                                       color: Colors.white,
//                                       size: 28,
//                                     ),
//                                   SizedBox(width: 15),
//                                   Text(
//                                     _isProcessingPayment
//                                         ? 'جاري المعالجة...'
//                                         : AppLocalizations.of(
//                                             context,
//                                           ).translate('confirm_payment'),
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Bottom padding
//             SliverToBoxAdapter(child: SizedBox(height: 30)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CartItem extends StatelessWidget {
//   final Map<String, dynamic> cartItem;
//   final String Function(num) formatPrice;

//   CartItem({required this.cartItem, required this.formatPrice});

//   @override
//   Widget build(BuildContext context) {
//     final String image = cartItem['image'] ?? '';
//     final String name =
//         cartItem['name'] ?? AppLocalizations.of(context).translate('unnamed');
//     final int quantity = cartItem['quantity'] ?? 1;
//     final num price = cartItem['price'] ?? 0;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.12),
//             spreadRadius: 3,
//             blurRadius: 15,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: LinearGradient(
//                     colors: [Colors.grey.shade200, Colors.grey.shade100],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 10,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: image.isNotEmpty
//                       ? Image.network(
//                           image,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(
//                                 Icons.image_not_supported,
//                                 size: 50,
//                                 color: Colors.grey,
//                               ),
//                         )
//                       : const Icon(Icons.image, size: 50, color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2D3436),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFFE17055), Color(0xFFD63031)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Text(
//                         "${formatPrice(quantity * price)} IQD",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF8F9FA),
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               context.read<CartCubit>().decreaseQuantity(
//                                 cartItem['id'],
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFDDD6FE),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.remove,
//                                 color: Color(0xFF6C5CE7),
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20.0,
//                             ),
//                             child: Text(
//                               "$quantity",
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF2D3436),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               context.read<CartCubit>().increaseQuantity(
//                                 cartItem['id'],
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color(0xFF6C5CE7),
//                                     Color(0xFFA29BFE),
//                                   ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             top: -10,
//             right: -10,
//             child: GestureDetector(
//               onTap: () {
//                 context.read<CartCubit>().deleteItem(cartItem['id']);
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFE17055), Color(0xFFD63031)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFFE17055).withOpacity(0.4),
//                       spreadRadius: 1,
//                       blurRadius: 10,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.delete_outline,
//                   color: Colors.white,
//                   size: 22,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SummaryRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isBold;
//   final Color? valueColor;

//   SummaryRow({
//     required this.label,
//     required this.value,
//     this.isBold = false,
//     this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: isBold ? 20 : 18,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
//               color: const Color(0xFF636E72),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: isBold ? 22 : 18,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
//               color: valueColor ?? const Color(0xFF2D3436),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DecorativeShapesPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..style = PaintingStyle.fill;

//     // Draw stars
//     paint.color = Color(0xFF6C5CE7).withOpacity(0.1);
//     _drawStar(canvas, Offset(50, 30), 8, paint);
//     _drawStar(canvas, Offset(size.width - 80, 60), 6, paint);

//     // Draw squares
//     paint.color = Color(0xFF74B9FF).withOpacity(0.1);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(size.width - 40, 20),
//           width: 15,
//           height: 15,
//         ),
//         Radius.circular(3),
//       ),
//       paint,
//     );

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: Offset(100, 70), width: 12, height: 12),
//         Radius.circular(3),
//       ),
//       paint,
//     );

//     // Draw circles
//     paint.color = Color(0xFF00B894).withOpacity(0.1);
//     canvas.drawCircle(Offset(30, 70), 5, paint);
//     canvas.drawCircle(Offset(size.width - 30, 40), 7, paint);
//   }

//   void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
//     final path = Path();
//     final angle = (3.14159 * 2) / 5;

//     for (int i = 0; i < 5; i++) {
//       final x = center.dx + radius * cos(i * angle - 3.14159 / 2);
//       final y = center.dy + radius * sin(i * angle - 3.14159 / 2);

//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }

//       final innerX =
//           center.dx + (radius * 0.4) * cos((i + 0.5) * angle - 3.14159 / 2);
//       final innerY =
//           center.dy + (radius * 0.4) * sin((i + 0.5) * angle - 3.14159 / 2);
//       path.lineTo(innerX, innerY);
//     }

//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Widget/confirmation_dialog.dart';
import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _couponController = TextEditingController();

  // متغيرات الكوبون
  String? _appliedCouponCode;
  int _discountPercentage = 0;
  bool _isCouponApplied = false;
  bool _isCheckingCoupon = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  /// دالة للتحقق من الكوبون وتطبيقه
  Future<void> _applyCoupon() async {
    final couponCode = _couponController.text.trim().toUpperCase();

    if (couponCode.isEmpty) {
      Fluttertoast.showToast(
        msg: 'يرجى إدخال رمز الكوبون',
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() {
      _isCheckingCoupon = true;
    });

    try {
      // البحث عن الكوبون في قاعدة البيانات
      final couponQuery = await _firestore
          .collection('coupons')
          .where('code', isEqualTo: couponCode)
          .where('isActive', isEqualTo: true)
          .get();

      if (couponQuery.docs.isEmpty) {
        Fluttertoast.showToast(
          msg: 'الكوبون غير صالح أو منتهي الصلاحية',
          backgroundColor: Colors.red,
        );
        setState(() {
          _isCheckingCoupon = false;
        });
        return;
      }

      final couponData = couponQuery.docs.first.data();
      final int usageLimit = couponData['usageLimit'] ?? 0;
      final int currentUsage = couponData['currentUsage'] ?? 0;

      // التحقق من حد الاستخدام
      if (usageLimit > 0 && currentUsage >= usageLimit) {
        Fluttertoast.showToast(
          msg: 'عذراً، تم استنفاد حد استخدام هذا الكوبون',
          backgroundColor: Colors.red,
        );
        setState(() {
          _isCheckingCoupon = false;
        });
        return;
      }

      // تطبيق الكوبون
      setState(() {
        _appliedCouponCode = couponCode;
        _discountPercentage = couponData['discountPercentage'] ?? 0;
        _isCouponApplied = true;
        _isCheckingCoupon = false;
      });

      Fluttertoast.showToast(
        msg: 'تم تطبيق الكوبون! خصم $_discountPercentage%',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      print('Error applying coupon: $e');
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء التحقق من الكوبون',
        backgroundColor: Colors.red,
      );
      setState(() {
        _isCheckingCoupon = false;
      });
    }
  }

  /// إزالة الكوبون
  void _removeCoupon() {
    setState(() {
      _appliedCouponCode = null;
      _discountPercentage = 0;
      _isCouponApplied = false;
      _couponController.clear();
    });

    Fluttertoast.showToast(
      msg: 'تم إلغاء الكوبون',
      backgroundColor: Colors.grey,
    );
  }

  /// حساب الخصم
  double _calculateDiscount(double subtotal) {
    if (!_isCouponApplied || _discountPercentage == 0) return 0;
    return subtotal * (_discountPercentage / 100);
  }

  /// حساب الإجمالي بعد الخصم
  double _calculateFinalTotal(double subtotal) {
    return subtotal - _calculateDiscount(subtotal);
  }

  /// تحديث استخدام الكوبون عند إتمام الطلب
  Future<void> _updateCouponUsage() async {
    if (!_isCouponApplied || _appliedCouponCode == null) return;

    try {
      final couponQuery = await _firestore
          .collection('coupons')
          .where('code', isEqualTo: _appliedCouponCode)
          .get();

      if (couponQuery.docs.isNotEmpty) {
        final couponDoc = couponQuery.docs.first;
        await couponDoc.reference.update({
          'currentUsage': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print('Error updating coupon usage: $e');
    }
  }

  /// حفظ الطلب في Firebase
  Future<void> _placeOrder(double totalAmount, double finalAmount) async {
    try {
      final cartCubit = context.read<CartCubit>();
      final cartItems = cartCubit.state.cartItems;

      if (cartItems.isEmpty) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate('cart_is_empty_to_order'),
          backgroundColor: Colors.red,
        );
        return;
      }

      final String orderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
      const String assumedPaymentMethod = 'COD';

      final userId = "user123";
      final userName = "ibrahim shafik";

      List<Map<String, dynamic>> orderItems = cartItems.map((item) {
        return {
          'productId': item['id'],
          'name': item['name'],
          'image': item['image'],
          'price': item['price'],
          'quantity': item['quantity'],
        };
      }).toList();

      final orderData = {
        'orderId': orderId,
        'userId': userId,
        'customerName': userName,
        'items': orderItems,
        'subtotal': totalAmount,
        'discountPercentage': _discountPercentage,
        'discountAmount': _calculateDiscount(totalAmount),
        'appliedCoupon': _appliedCouponCode,
        'totalAmount': finalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'orderStatus': 'Pending',
        'paymentStatus': 'Unpaid',
        'paymentMethod': assumedPaymentMethod,
      };

      await _firestore.collection('market_orders').add(orderData);

      // تحديث استخدام الكوبون
      await _updateCouponUsage();

      // تفريغ السلة
      cartCubit.clearCart();

      // إعادة تعيين الكوبون
      setState(() {
        _appliedCouponCode = null;
        _discountPercentage = 0;
        _isCouponApplied = false;
        _couponController.clear();
      });

      _showSuccessDialog(
        'تم تقديم الطلب بنجاح! 🛒',
        'شكراً لطلبك. تم استلام طلبك رقم: $orderId وسيتم مراجعته قريباً.',
      );
    } catch (e) {
      print("Error saving order: $e");
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate('failed_to_place_order'),
        backgroundColor: Colors.red,
      );
    }
  }

  /// إظهار رسالة نجاح
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00B894).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF00B894),
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B894),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'حسناً',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  String _formatPrice(num price) {
    if (price % 1 == 0) {
      return price.toInt().toString();
    } else {
      return price.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context).translate('shopping_cart'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: CustomPaint(
                size: Size(double.infinity, 100),
                painter: DecorativeShapesPainter(),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    if (state.cartItems.isEmpty) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(50),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 8,
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 100,
                                color: Color(0xFF6C5CE7),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('your_cart_is_empty'),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('add_some_amazing_products'),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF636E72),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF74B9FF).withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    '${state.cartItems.length} ${AppLocalizations.of(context).translate('items')}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_formatPrice(state.total ?? 0)} IQD',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = state.cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: CartItem(
                                cartItem: item,
                                formatPrice: _formatPrice,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // قسم إدخال الكوبون
            SliverToBoxAdapter(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.cartItems.isEmpty) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 3,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: Color(0xFFE17055),
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'كود الخصم',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          if (!_isCouponApplied)
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _couponController,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      hintText: 'أدخل رمز الكوبون',
                                      filled: true,
                                      fillColor: Color(0xFFF8F9FA),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _isCheckingCoupon
                                    ? Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF6C5CE7),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: _applyCoupon,
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF6C5CE7),
                                                Color(0xFFA29BFE),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          if (_isCouponApplied)
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(0xFF00B894).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(0xFF00B894),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF00B894),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'تم تطبيق الكوبون',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF00B894),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            _appliedCouponCode ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF2D3436),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '$_discountPercentage%',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF00B894),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: _removeCoupon,
                                        child: Icon(
                                          Icons.close,
                                          color: Color(0xFFE17055),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ملخص الطلب
            SliverToBoxAdapter(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.cartItems.isEmpty) return const SizedBox();

                  final subtotal = state.total ?? 0;
                  final discount = _calculateDiscount(subtotal.toDouble());
                  final finalTotal = _calculateFinalTotal(subtotal.toDouble());

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                color: Color(0xFF6C5CE7),
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('order_summary'),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          SummaryRow(
                            label: AppLocalizations.of(
                              context,
                            ).translate('subtotal'),
                            value: '${_formatPrice(subtotal)} IQD',
                          ),
                          if (_isCouponApplied && discount > 0)
                            SummaryRow(
                              label: 'الخصم ($_discountPercentage%)',
                              value: '- ${_formatPrice(discount)} IQD',
                              valueColor: const Color(0xFFE17055),
                            ),
                          SummaryRow(
                            label: AppLocalizations.of(
                              context,
                            ).translate('shipping'),
                            value: AppLocalizations.of(
                              context,
                            ).translate('free'),
                            valueColor: const Color(0xFF00B894),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.grey.shade300,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          SummaryRow(
                            label: AppLocalizations.of(
                              context,
                            ).translate('total'),
                            value: '${_formatPrice(finalTotal)} IQD',
                            isBold: true,
                            valueColor: const Color(0xFF6C5CE7),
                          ),
                          if (_isCouponApplied && discount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00B894).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.savings,
                                      color: Color(0xFF00B894),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'وفّرت ${_formatPrice(discount)} IQD',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00B894),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              if (finalTotal > 0) {
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmationDialog(
                                    title: AppLocalizations.of(
                                      context,
                                    ).translate('order_confirmation'),
                                    content: AppLocalizations.of(context).translate(
                                      'are_you_sure_to_place_order_without_online_payment',
                                    ),
                                    onConfirm: () async {
                                      await _placeOrder(
                                        subtotal.toDouble(),
                                        finalTotal,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(
                                    context,
                                  ).translate('invalid_total_amount'),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00B894),
                                    Color(0xFF00CEC9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00B894,
                                    ).withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_box_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('confirm_order'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final Map<String, dynamic> cartItem;
  final String Function(num) formatPrice;

  CartItem({required this.cartItem, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    final String image = cartItem['image'] ?? '';
    final String name =
        cartItem['name'] ?? AppLocalizations.of(context).translate('unnamed');
    final int quantity = cartItem['quantity'] ?? 1;
    final num price = cartItem['price'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade200, Colors.grey.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: image.isNotEmpty
                      ? Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                        )
                      : const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE17055), Color(0xFFD63031)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "${formatPrice(quantity * price)} IQD",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<CartCubit>().decreaseQuantity(
                                cartItem['id'],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDD6FE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Color(0xFF6C5CE7),
                                size: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Text(
                              "$quantity",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<CartCubit>().increaseQuantity(
                                cartItem['id'],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6C5CE7),
                                    Color(0xFFA29BFE),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: () {
                context.read<CartCubit>().deleteItem(cartItem['id']);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE17055), Color(0xFFD63031)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE17055).withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 20 : 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: const Color(0xFF636E72),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 22 : 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}

class DecorativeShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Color(0xFF6C5CE7).withOpacity(0.1);
    _drawStar(canvas, Offset(50, 30), 8, paint);
    _drawStar(canvas, Offset(size.width - 80, 60), 6, paint);

    paint.color = Color(0xFF74B9FF).withOpacity(0.1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width - 40, 20),
          width: 15,
          height: 15,
        ),
        Radius.circular(3),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(100, 70), width: 12, height: 12),
        Radius.circular(3),
      ),
      paint,
    );

    paint.color = Color(0xFF00B894).withOpacity(0.1);
    canvas.drawCircle(Offset(30, 70), 5, paint);
    canvas.drawCircle(Offset(size.width - 30, 40), 7, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final angle = (3.14159 * 2) / 5;

    for (int i = 0; i < 5; i++) {
      final x = center.dx + radius * cos(i * angle - 3.14159 / 2);
      final y = center.dy + radius * sin(i * angle - 3.14159 / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      final innerX =
          center.dx + (radius * 0.4) * cos((i + 0.5) * angle - 3.14159 / 2);
      final innerY =
          center.dy + (radius * 0.4) * sin((i + 0.5) * angle - 3.14159 / 2);
      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
