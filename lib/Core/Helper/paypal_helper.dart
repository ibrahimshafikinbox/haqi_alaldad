// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:store_managment/Core/Helper/constants.dart';

// class PayPalService {
//   static const String clientId = AppConstants.client_id;
//   static const String secret = AppConstants.client_secret;
//   static const String domain =
//       'https://api-m.sandbox.paypal.com'; // sandbox for testing

//   static Future<String?> getAccessToken() async {
//     final credentials = base64Encode(utf8.encode('$clientId:$secret'));
//     final response = await http.post(
//       Uri.parse('$domain/v1/oauth2/token'),
//       headers: {
//         'Authorization': 'Basic $credentials',
//         'Content-Type': 'application/x-www-form-urlencoded'
//       },
//       body: {'grant_type': 'client_credentials'},
//     );
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['access_token'];
//     } else {
//       print('Failed to get token: ${response.body}');
//       return null;
//     }
//   }

//   static Future<String?> createOrder(String accessToken, double total) async {
//     final response = await http.post(
//       Uri.parse('$domain/v2/checkout/orders'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//       body: jsonEncode({
//         'intent': 'CAPTURE',
//         'purchase_units': [
//           {
//             'amount': {
//               'currency_code': 'USD',
//               'value': total.toStringAsFixed(2),
//             }
//           }
//         ],
//         'application_context': {
//           'return_url': 'https://example.com/success',
//           'cancel_url': 'https://example.com/cancel',
//         }
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = json.decode(response.body);
//       final links = data['links'];
//       final approveLink = links.firstWhere(
//         (link) => link['rel'] == 'approve',
//         orElse: () => null,
//       );
//       return approveLink?['href'];
//     } else {
//       print('Failed to create order: ${response.body}');
//       return null;
//     }
//   }
// }
