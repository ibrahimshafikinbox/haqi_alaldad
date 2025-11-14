import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminCouponScreen extends StatefulWidget {
  const AdminCouponScreen({super.key});

  @override
  State<AdminCouponScreen> createState() => _AdminCouponScreenState();
}

class _AdminCouponScreenState extends State<AdminCouponScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();

  bool _isLoading = false;
  bool _isLimited =
      false; // لتحديد ما إذا كان الكوبون له حد استخدام أم لا (اختياري)
  int _usageLimit = 0;

  @override
  void dispose() {
    _codeController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  /// دالة لإضافة الكوبون إلى Firestore
  Future<void> _addCoupon() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من أن الكود غير فارغ
    final couponCode = _codeController.text.trim().toUpperCase();
    if (couponCode.isEmpty) {
      Fluttertoast.showToast(
        msg: 'يرجى إدخال رمز الكوبون',
        backgroundColor: Colors.orange,
      );
      return;
    }

    // التحقق من نسبة الخصم
    final percentage = int.tryParse(_percentageController.text);
    if (percentage == null || percentage < 1 || percentage > 100) {
      Fluttertoast.showToast(
        msg: 'نسبة الخصم يجب أن تكون رقماً صحيحاً بين 1 و 100',
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // التحقق من وجود الكوبون مسبقاً (مهم جداً لمنع التكرار)
      final existingCoupon = await _firestore
          .collection('coupons')
          .where('code', isEqualTo: couponCode)
          .get();

      if (existingCoupon.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'هذا الكوبون (\$couponCode) موجود بالفعل.',
          backgroundColor: Colors.red,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // تحديد حد الاستخدام
      int finalLimit = 0;
      if (_isLimited) {
        final limitVal = int.tryParse(_usageLimitController.text);
        if (limitVal != null && limitVal > 0) {
          finalLimit = limitVal;
        } else {
          Fluttertoast.showToast(
            msg: 'يرجى إدخال حد استخدام صحيح.',
            backgroundColor: Colors.red,
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // إضافة البيانات إلى قاعدة البيانات
      await _firestore.collection('coupons').add({
        'code': couponCode,
        'discountPercentage': percentage,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'usageLimit': finalLimit, // 0 تعني غير محدود
        'currentUsage': 0,
        'appliedByAdmin': true, // لتتبع مصدر الإضافة
      });

      Fluttertoast.showToast(
        msg: 'تم إضافة الكوبون (\$couponCode) بنسبة \$percentage% بنجاح!',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );

      _clearForm();
    } catch (e) {
      print('Error adding coupon: $e');
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء الإضافة: ${e.toString()}',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _codeController.clear();
    _percentageController.clear();
    setState(() {
      _isLimited = false;
      _usageLimit = 0;
    });
  }

  final TextEditingController _usageLimitController = TextEditingController(
    text: '10',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة كوبون خصم جديد'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // 1. حقل رمز الكوبون
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'رمز الكوبون (مثال: SUMMER20)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال رمز الكوبون';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 20),

              // 2. حقل نسبة الخصم
              TextFormField(
                controller: _percentageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'نسبة الخصم (%)',
                  border: OutlineInputBorder(),
                  suffixText: '%',
                  prefixIcon: Icon(Icons.percent),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال النسبة';
                  }
                  final percentage = int.tryParse(value);
                  if (percentage == null ||
                      percentage < 1 ||
                      percentage > 100) {
                    return 'النسبة يجب أن تكون بين 1 و 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. خيار تحديد حد الاستخدام
              SwitchListTile(
                title: const Text('تحديد حد أقصى للاستخدام؟'),
                value: _isLimited,
                onChanged: (bool value) {
                  setState(() {
                    _isLimited = value;
                  });
                },
                activeColor: Colors.deepPurpleAccent,
              ),

              if (_isLimited)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 10),
                  child: TextFormField(
                    controller: _usageLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText:
                          'الحد الأقصى للاستخدام (0 يعني غير محدود عند الإلغاء)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.exposure_plus_1),
                    ),
                    validator: (value) {
                      if (_isLimited) {
                        final limit = int.tryParse(value ?? '');
                        if (limit == null || limit < 1) {
                          return 'الرجاء إدخال عدد صحيح موجب للحد الأقصى';
                        }
                      }
                      return null;
                    },
                  ),
                ),

              const SizedBox(height: 30),

              // 4. زر الإضافة
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _addCoupon,
                      icon: const Icon(Icons.add_circle),
                      label: const Text(
                        'إضافة الكوبون',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
