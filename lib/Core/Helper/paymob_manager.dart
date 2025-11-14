import 'package:dio/dio.dart';

class PaymobManager {
  Future<String> getPaymentKey(int amount, String currency) async {
    try {
      String authanticationToken = await _getAuthanticationToken();

      int orderId = await _getOrderId(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
      );

      String paymentKey = await _getPaymentKey(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
        orderId: orderId.toString(),
      );
      return paymentKey;
    } catch (e) {
      print("Exc==========================================");
      print(e.toString());
      throw Exception();
    }
  }

  Future<String> _getAuthanticationToken() async {
    final Response response =
        await Dio().post("https://accept.paymob.com/api/auth/tokens", data: {
      "api_key":
          "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBek56TXpOaXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS4ycmhsX3UxUFpGbFNMR2IxU3Z6Q205TjdGemMta0I4ZUIyQnE2UnNCRmRjUkVraDVYS3l1MHlYUUFzaFVGckhnNUxZT1l1QWNwRWtfb2hiSWpuMkxkUQ==",
    });
    print("==========================================");
    print(response.data);

    print(response.data["token"]);
    print("==========================================");

    return response.data["token"];
  }

  Future<int> _getOrderId({
    required String authanticationToken,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/ecommerce/orders", data: {
      "auth_token": authanticationToken,
      "amount_cents": amount, //  >>(STRING)<<
      "currency": currency, //Not Req
      "delivery_needed": "false",
      "items": [],
    });
    return response.data["id"]; //INTGER
  }

  Future<String> _getPaymentKey({
    required String authanticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    try {
      final Response response = await Dio().post(
        "https://accept.paymob.com/api/acceptance/payment_keys",
        data: {
          "expiration": 3600,
          "auth_token": authanticationToken,
          "order_id": orderId,
          "integration_id": 5043750,
          "amount_cents": amount,
          "currency": currency,
          "billing_data": {
            "first_name": "Clifford",
            "last_name": "Nicolas",
            "email": "claudette09@exa.com",
            "phone_number": "+86(8)9135210487",
            "apartment": "NA",
            "floor": "NA",
            "street": "NA",
            "building": "NA",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "state": "NA"
          },
        },
      );
      print("Payment Key Response: ${response.data}");
      return response.data["token"];
    } catch (e) {
      print("Error in _getPaymentKey: $e");
      if (e is DioError && e.response != null) {
        print("Dio Error Response: ${e.response?.data}");
      }
      rethrow;
    }
  }
}
