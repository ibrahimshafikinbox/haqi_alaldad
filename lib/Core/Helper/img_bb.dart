import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImgBBService {
  // ضع API Key الخاص بك هنا
  static const String _apiKey = 'fd92c702916d503b106bac9858b8856c';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  /// رفع صورة إلى ImgBB
  static Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      print('Starting image upload to ImgBB...');

      // التحقق من الاتصال بالإنترنت أولاً
      final hasConnection = await _checkInternetConnection();
      if (!hasConnection) {
        return {
          'success': false,
          'error':
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.',
          'errorType': 'NO_INTERNET',
        };
      }

      // قراءة الصورة كـ bytes
      final bytes = await imageFile.readAsBytes();
      print('Image size: ${bytes.length} bytes');

      // تحويل الصورة إلى base64
      final base64Image = base64Encode(bytes);
      print('Image converted to base64');

      // إنشاء الطلب
      print('Sending request to ImgBB...');
      final response = await http
          .post(
            Uri.parse(_uploadUrl),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {'key': _apiKey, 'image': base64Image},
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.');
            },
          );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final imageUrl = jsonResponse['data']['url'];
          final deleteUrl = jsonResponse['data']['delete_url'];

          print('✅ Image uploaded successfully: $imageUrl');

          return {'success': true, 'url': imageUrl, 'deleteUrl': deleteUrl};
        } else {
          final errorMessage =
              jsonResponse['error']['message'] ?? 'خطأ غير معروف';
          print('❌ ImgBB API error: $errorMessage');

          return {
            'success': false,
            'error': 'فشل رفع الصورة: $errorMessage',
            'errorType': 'API_ERROR',
          };
        }
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'error': 'مفتاح API غير صحيح أو الصورة غير صالحة',
          'errorType': 'INVALID_KEY',
        };
      } else {
        return {
          'success': false,
          'error': 'خطأ في الخادم (${response.statusCode})',
          'errorType': 'SERVER_ERROR',
        };
      }
    } on SocketException catch (e) {
      print('❌ Socket Exception: $e');
      return {
        'success': false,
        'error':
            'فشل الاتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.',
        'errorType': 'SOCKET_ERROR',
      };
    } on TimeoutException catch (e) {
      print('❌ Timeout Exception: $e');
      return {
        'success': false,
        'error': 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.',
        'errorType': 'TIMEOUT',
      };
    } on FormatException catch (e) {
      print('❌ Format Exception: $e');
      return {
        'success': false,
        'error': 'خطأ في معالجة البيانات. يرجى المحاولة مرة أخرى.',
        'errorType': 'FORMAT_ERROR',
      };
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {
        'success': false,
        'error': 'حدث خطأ غير متوقع: ${e.toString()}',
        'errorType': 'UNKNOWN',
      };
    }
  }

  /// التحقق من الاتصال بالإنترنت
  static Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('No internet connection: $e');
      return false;
    }
  }

  /// التحقق من صحة API Key
  static Future<bool> validateApiKey() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey'))
          .timeout(const Duration(seconds: 10));

      return response.statusCode != 401;
    } catch (e) {
      print('Error validating API key: $e');
      return false;
    }
  }

  /// ضغط الصورة قبل الرفع (اختياري)
  static Future<File> compressImage(File file) async {
    // يمكن استخدام مكتبة image_compression هنا
    // للآن نرجع الملف كما هو
    return file;
  }
}
