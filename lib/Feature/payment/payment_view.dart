// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:dio/dio.dart';
// // import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

// // class ZainCashPaymentDemo extends StatefulWidget {
// //   const ZainCashPaymentDemo({super.key});

// //   @override
// //   State<ZainCashPaymentDemo> createState() => _ZainCashPaymentDemoState();
// // }

// // class _ZainCashPaymentDemoState extends State<ZainCashPaymentDemo> {
// //   final Dio dio = Dio();

// //   // 🧪 بيانات الاختبار الرسمية من ZainCash
// //   final String merchantId = "5ffacf6612b5777c6d44266f";
// //   final String secret =
// //       r"$2y$10$hBbAZo2GfSSvyqAyV2SaqOfYewgYpfR1O19gIh4SqyGWdmySZYPuS";
// //   final String msisdn = "9647835077893"; // رقم محفظة التاجر التجريبية
// //   final String redirectUrl = "https://zaincash.iq"; // أي رابط مقبول للتجربة

// //   bool loading = false;

// //   Future<void> startPayment() async {
// //     setState(() => loading = true);

// //     final jwt = JWT({
// //       "amount": 250, // الحد الأدنى حسب الوثائق
// //       "serviceType": "Test Purchase",
// //       "msisdn": msisdn,
// //       "orderId": "order_${DateTime.now().millisecondsSinceEpoch}",
// //       "redirectUrl": redirectUrl,
// //       "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
// //       "exp":
// //           DateTime.now().add(const Duration(hours: 4)).millisecondsSinceEpoch ~/
// //           1000,
// //     });

// //     final token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256);

// //     try {
// //       final response = await dio.post(
// //         "https://test.zaincash.iq/transaction/init",
// //         options: Options(
// //           headers: {"Content-Type": "application/x-www-form-urlencoded"},
// //         ),
// //         data: {"token": token, "merchantId": merchantId, "lang": "ar"},
// //       );

// //       final data = response.data;
// //       if (data["id"] != null) {
// //         final transactionId = data["id"];
// //         final payUrl =
// //             "https://test.zaincash.iq/transaction/pay?id=$transactionId";

// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (_) => PaymentWebView(url: payUrl)),
// //         );
// //       } else {
// //         _showSnack("فشل إنشاء المعاملة: ${data.toString()}");
// //       }
// //     } catch (e) {
// //       _showSnack("خطأ أثناء الاتصال: $e");
// //     }

// //     setState(() => loading = false);
// //   }

// //   void _showSnack(String message) {
// //     ScaffoldMessenger.of(
// //       context,
// //     ).showSnackBar(SnackBar(content: Text(message)));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("دفع تجريبي عبر ZainCash")),
// //       body: Center(
// //         child: loading
// //             ? const CircularProgressIndicator()
// //             : ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   padding: const EdgeInsets.all(16),
// //                 ),
// //                 onPressed: startPayment,
// //                 child: const Text("ابدأ الدفع الآن"),
// //               ),
// //       ),
// //     );
// //   }
// // }

// // class PaymentWebView extends StatefulWidget {
// //   final String url;
// //   const PaymentWebView({super.key, required this.url});

// //   @override
// //   State<PaymentWebView> createState() => _PaymentWebViewState();
// // }

// // class _PaymentWebViewState extends State<PaymentWebView> {
// //   late final WebViewController _controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = WebViewController()
// //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //       ..setNavigationDelegate(
// //         NavigationDelegate(
// //           onNavigationRequest: (request) {
// //             if (request.url.contains("redirect")) {
// //               // تم التحويل بعد الدفع
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(
// //                   content: Text("تم إتمام عملية الدفع (تجريبياً)"),
// //                 ),
// //               );
// //               Navigator.pop(context);
// //               return NavigationDecision.prevent;
// //             }
// //             return NavigationDecision.navigate;
// //           },
// //         ),
// //       )
// //       ..loadRequest(Uri.parse(widget.url));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("صفحة الدفع ZainCash")),
// //       body: WebViewWidget(controller: _controller),
// //     );
// //   }
// // }
// import 'package:dio/dio.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentWebView extends StatefulWidget {
//   final String url;
//   final String orderId;
//   final double amount;

//   const PaymentWebView({
//     super.key,
//     required this.url,
//     required this.orderId,
//     required this.amount,
//   });

//   @override
//   State<PaymentWebView> createState() => _PaymentWebViewState();
// }

// class _PaymentWebViewState extends State<PaymentWebView> {
//   late final WebViewController _controller;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   void _initializeWebView() {
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             setState(() => isLoading = true);
//           },
//           onPageFinished: (url) {
//             setState(() => isLoading = false);
//           },
//           onNavigationRequest: (request) {
//             final url = request.url.toLowerCase();

//             // تحقق من إتمام الدفع بنجاح
//             if (url.contains('success') ||
//                 url.contains('zaincash.iq') && url.contains('?')) {
//               Navigator.pop(context, {
//                 'status': 'success',
//                 'orderId': widget.orderId,
//                 'amount': widget.amount,
//               });
//               return NavigationDecision.prevent;
//             }

//             // تحقق من إلغاء الدفع
//             if (url.contains('cancel') || url.contains('fail')) {
//               Navigator.pop(context, {
//                 'status': 'failed',
//                 'orderId': widget.orderId,
//               });
//               return NavigationDecision.prevent;
//             }

//             return NavigationDecision.navigate;
//           },
//           onWebResourceError: (error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('خطأ في تحميل الصفحة: ${error.description}'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // عند الرجوع، اعتبر العملية ملغاة
//         Navigator.pop(context, {
//           'status': 'cancelled',
//           'orderId': widget.orderId,
//         });
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text(
//             'إتمام الدفع',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//           ),
//           centerTitle: true,
//           backgroundColor: const Color(0xFF4CAF50),
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('إلغاء الدفع'),
//                   content: const Text('هل تريد إلغاء عملية الدفع؟'),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('لا'),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context); // إغلاق الحوار
//                         Navigator.pop(context, {
//                           'status': 'cancelled',
//                           'orderId': widget.orderId,
//                         });
//                       },
//                       child: const Text('نعم، إلغاء'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         body: Stack(
//           children: [
//             WebViewWidget(controller: _controller),
//             if (isLoading)
//               Container(
//                 color: Colors.white,
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Color(0xFF4CAF50),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'جاري تحميل صفحة الدفع...',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF666666),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ZainCashPaymentService {
//   final Dio dio = Dio();

//   // 🔐 بيانات الاختبار الرسمية من ZainCash
//   final String merchantId = "5ffacf6612b5777c6d44266f";
//   final String secret =
//       r"$2y$10$hBbAZo2GfSSvyqAyV2SaqOfYewgYpfR1O19gIh4SqyGWdmySZYPuS";
//   final String msisdn = "9647835077893";
//   final String redirectUrl = "https://zaincash.iq";

//   /// إنشاء معاملة دفع جديدة
//   Future<String?> createTransaction({
//     required double amount,
//     required String orderId,
//     required String serviceType,
//   }) async {
//     try {
//       // التحقق من الحد الأدنى للمبلغ
//       if (amount < 250) {
//         throw Exception('الحد الأدنى للدفع هو 250 دينار عراقي');
//       }

//       // إنشاء JWT Token
//       final jwt = JWT({
//         "amount": amount.toInt(),
//         "serviceType": serviceType,
//         "msisdn": msisdn,
//         "orderId": orderId,
//         "redirectUrl": redirectUrl,
//         "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         "exp":
//             DateTime.now()
//                 .add(const Duration(hours: 4))
//                 .millisecondsSinceEpoch ~/
//             1000,
//       });

//       final token = jwt.sign(SecretKey(secret), algorithm: JWTAlgorithm.HS256);

//       // إرسال الطلب
//       final response = await dio.post(
//         "https://test.zaincash.iq/transaction/init",
//         options: Options(
//           headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         ),
//         data: {"token": token, "merchantId": merchantId, "lang": "ar"},
//       );

//       final data = response.data;

//       if (data["id"] != null) {
//         final transactionId = data["id"];
//         return "https://test.zaincash.iq/transaction/pay?id=$transactionId";
//       } else {
//         throw Exception(
//           "فشل إنشاء المعاملة: ${data['err']?['msg'] ?? 'خطأ غير معروف'}",
//         );
//       }
//     } on DioException catch (e) {
//       throw Exception("خطأ في الاتصال: ${e.message}");
//     } catch (e) {
//       throw Exception("خطأ: $e");
//     }
//   }
// }
