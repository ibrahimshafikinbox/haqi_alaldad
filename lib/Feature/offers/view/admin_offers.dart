import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:store_mangment/Core/Helper/img_bb.dart';

class AdminOffers extends StatefulWidget {
  const AdminOffers({Key? key}) : super(key: key);

  @override
  State<AdminOffers> createState() => _AdminOffersState();
}

class _AdminOffersState extends State<AdminOffers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _offerTitleController = TextEditingController();
  final _offerDescriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _discountPriceController = TextEditingController();

  File? _selectedImage;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _offerTitleController.dispose();
    _offerDescriptionController.dispose();
    _originalPriceController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  // اختيار صورة
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // اختيار تاريخ البداية
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C5CE7),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  // اختيار تاريخ النهاية
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C5CE7),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _addOffer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      Fluttertoast.showToast(
        msg: 'يرجى تحديد تاريخ البداية والنهاية',
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isUploading = false;
    });

    try {
      String? imageUrl;

      // رفع الصورة إلى ImgBB إذا تم اختيارها
      if (_selectedImage != null) {
        setState(() {
          _isUploading = true;
        });

        Fluttertoast.showToast(
          msg: 'جاري رفع الصورة... ⏳',
          backgroundColor: const Color(0xFF6C5CE7),
          toastLength: Toast.LENGTH_SHORT,
        );

        // رفع الصورة والحصول على النتيجة
        final uploadResult = await ImgBBService.uploadImage(_selectedImage!);

        if (uploadResult['success'] == true) {
          imageUrl = uploadResult['url'];

          Fluttertoast.showToast(
            msg: 'تم رفع الصورة بنجاح! ✓',
            backgroundColor: const Color(0xFF00B894),
            toastLength: Toast.LENGTH_SHORT,
          );
        } else {
          // عرض رسالة الخطأ المناسبة
          final errorType = uploadResult['errorType'];
          String errorMessage = uploadResult['error'] ?? 'فشل رفع الصورة';

          if (errorType == 'NO_INTERNET' || errorType == 'SOCKET_ERROR') {
            errorMessage =
                '❌ لا يوجد اتصال بالإنترنتيرجى التحقق من الاتصال والمحاولة مرة أخرى';
          } else if (errorType == 'INVALID_KEY') {
            errorMessage =
                '❌ مفتاح ImgBB API غير صحيحيرجى التحقق من المفتاح في الكود';
          } else if (errorType == 'TIMEOUT') {
            errorMessage = '❌ انتهت مهلة الاتصال يرجى المحاولة مرة أخرى';
          }

          Fluttertoast.showToast(
            msg: errorMessage,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );

          setState(() {
            _isLoading = false;
            _isUploading = false;
          });
          return;
        }
      }

      final originalPrice = double.tryParse(_originalPriceController.text);
      final discountPrice = double.tryParse(_discountPriceController.text);

      int? discountPercentage;
      if (originalPrice != null && discountPrice != null && originalPrice > 0) {
        discountPercentage =
            (((originalPrice - discountPrice) / originalPrice) * 100).round();
      }

      await _firestore.collection('offers').add({
        'productName': _productNameController.text.trim(),
        'offerTitle': _offerTitleController.text.trim(),
        'offerDescription': _offerDescriptionController.text.trim(),
        'productImage': imageUrl,
        'originalPrice': originalPrice,
        'discountPrice': discountPrice,
        'discountPercentage': discountPercentage,
        'startDate': Timestamp.fromDate(_startDate!),
        'endDate': Timestamp.fromDate(_endDate!),
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
        msg: 'تم إضافة العرض بنجاح! 🎉',
        backgroundColor: const Color(0xFF00B894),
        toastLength: Toast.LENGTH_LONG,
      );

      _clearForm();
    } catch (e) {
      print('Error adding offer: $e');
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء إضافة العرض: ${e.toString()}',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isUploading = false;
      });
    }
  } // مسح النموذج

  void _clearForm() {
    _formKey.currentState?.reset();
    _productNameController.clear();
    _offerTitleController.clear();
    _offerDescriptionController.clear();
    _originalPriceController.clear();
    _discountPriceController.clear();
    setState(() {
      _selectedImage = null;
      _startDate = null;
      _endDate = null;
    });
  }

  // حذف عرض
  Future<void> _deleteOffer(String offerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا العرض؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestore.collection('offers').doc(offerId).delete();
        Fluttertoast.showToast(
          msg: 'تم حذف العرض بنجاح',
          backgroundColor: const Color(0xFF00B894),
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'فشل حذف العرض',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // تغيير حالة العرض (تفعيل/تعطيل)
  Future<void> _toggleOfferStatus(String offerId, bool currentStatus) async {
    try {
      await _firestore.collection('offers').doc(offerId).update({
        'isActive': !currentStatus,
      });

      Fluttertoast.showToast(
        msg: !currentStatus ? 'تم تفعيل العرض' : 'تم تعطيل العرض',
        backgroundColor: const Color(0xFF00B894),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'فشل تغيير حالة العرض',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'إدارة العروض',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // نموذج إضافة عرض جديد
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.local_offer,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'إضافة عرض جديد',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // اسم المنتج
                    _buildTextField(
                      controller: _productNameController,
                      label: 'اسم المنتج',
                      icon: Icons.shopping_bag,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // عنوان العرض
                    _buildTextField(
                      controller: _offerTitleController,
                      label: 'عنوان العرض',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال عنوان العرض';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // وصف العرض
                    _buildTextField(
                      controller: _offerDescriptionController,
                      label: 'تفاصيل العرض',
                      icon: Icons.description,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال تفاصيل العرض';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // السعر الأصلي والسعر بعد الخصم
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _originalPriceController,
                            label: 'السعر الأصلي',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextField(
                            controller: _discountPriceController,
                            label: 'سعر الخصم',
                            icon: Icons.discount,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // اختيار الصورة
                    GestureDetector(
                      onTap: _isLoading ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: _selectedImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  if (_isUploading)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'جاري رفع الصورة...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 60,
                                    color: const Color(
                                      0xFF6C5CE7,
                                    ).withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'اضغط لاختيار صورة المنتج',
                                    style: TextStyle(
                                      color: const Color(0xFF636E72),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '(سيتم رفعها على ImgBB)',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // تواريخ البداية والنهاية
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateSelector(
                            label: 'تاريخ البداية',
                            date: _startDate,
                            onTap: _selectStartDate,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildDateSelector(
                            label: 'تاريخ النهاية',
                            date: _endDate,
                            onTap: _selectEndDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // زر الإضافة
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _addOffer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B894),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    _isUploading
                                        ? 'جاري رفع الصورة...'
                                        : 'جاري الإضافة...',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle, size: 28),
                                  SizedBox(width: 10),
                                  Text(
                                    'إضافة العرض',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // قائمة العروض الحالية
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'العروض الحالية',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('offers')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'لا توجد عروض حالياً',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final data = doc.data() as Map<String, dynamic>;

                          return _buildOfferCard(offerId: doc.id, data: data);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6C5CE7)),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: date != null
                ? const Color(0xFF6C5CE7)
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: const Color(0xFF6C5CE7),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  date != null
                      ? DateFormat('yyyy-MM-dd').format(date)
                      : 'اختر التاريخ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: date != null ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required String offerId,
    required Map<String, dynamic> data,
  }) {
    final isActive = data['isActive'] ?? true;
    final startDate = (data['startDate'] as Timestamp?)?.toDate();
    final endDate = (data['endDate'] as Timestamp?)?.toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (data['productImage'] != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                data['productImage'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['productName'] ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data['offerTitle'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF00B894).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'نشط' : 'معطل',
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFF00B894)
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Text(
                  data['offerDescription'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),

                if (data['originalPrice'] != null &&
                    data['discountPrice'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Text(
                          '${data['originalPrice']} IQD',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${data['discountPrice']} IQD',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE17055),
                          ),
                        ),
                        if (data['discountPercentage'] != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE17055),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${data['discountPercentage']}%-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                if (startDate != null && endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'من ${DateFormat('yyyy-MM-dd').format(startDate)} إلى ${DateFormat('yyyy-MM-dd').format(endDate)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleOfferStatus(offerId, isActive),
                        icon: Icon(isActive ? Icons.pause : Icons.play_arrow),
                        label: Text(isActive ? 'تعطيل' : 'تفعيل'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isActive
                              ? Colors.orange
                              : const Color(0xFF00B894),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _deleteOffer(offerId),
                        icon: const Icon(Icons.delete),
                        label: const Text('حذف'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
