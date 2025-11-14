import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Widget/show_bottum_sheet.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';

// Off-white card background + subtle border vibe
const Color kCardBackground = Color(0xFFF3F4F6);

class AddProductScreen extends StatefulWidget {
  final String categoryName;
  const AddProductScreen({super.key, required this.categoryName});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  DateTime? expiredDate;
  DateTime? manufacturedDate;
  File? imageFile;
  bool isLoading = false;

  // ---------- Image picking ----------
  Future<void> pickImageFromSheet() async {
    await showImageSourceSheet(
      context: context,
      onImageSelected: (XFile file) {
        setState(() {
          imageFile = File(file.path);
        });
      },
    );
  }

  // ---------- Upload to ImgBB ----------
  Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      final apiKey = "fd92c702916d503b106bac9858b8856c";
      final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(url, body: {"image": base64Image});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  // استبدل دالة addProduct بهذه النسخة المحدثة
  Future<void> addProduct() async {
    final loc = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      _showSnack(loc.translate('error_fix_errors'));
      return;
    }
    if (imageFile == null) {
      _showSnack(loc.translate('error_add_image'));
      return;
    }
    if (manufacturedDate != null && expiredDate != null) {
      if (!expiredDate!.isAfter(manufacturedDate!)) {
        _showSnack(loc.translate('error_expiry_after_manufactured'));
        return;
      }
    }

    setState(() => isLoading = true);

    final imageUrl = await uploadImageToImgBB(imageFile!);
    if (imageUrl == null) {
      setState(() => isLoading = false);
      _showSnack(loc.translate('error_image_upload_failed'));
      return;
    }

    try {
      // احصل على supermarketId من حالة التطبيق (يجب تعديلها حسب تطبيقك)
      final supermarketId = "your_supermarket_id";

      // إضافة المنتج أولاً للحصول على ID
      final docRef = await FirebaseFirestore.instance
          .collection('supermarkets')
          .doc(supermarketId)
          .collection('categories')
          .doc(widget.categoryName)
          .collection('products')
          .add({
            'name': nameController.text.trim(),
            'price': double.tryParse(priceController.text) ?? 0,
            'description': descController.text.trim(),
            'imageUrl': imageUrl,
            'expiredDate': expiredDate != null
                ? Timestamp.fromDate(expiredDate!)
                : null,
            'manufacturedDate': manufacturedDate != null
                ? Timestamp.fromDate(manufacturedDate!)
                : null,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // إنشاء QR Value بصيغة: s:<supermarketId>:c:<categoryName>:p:<productId>
      final qrValue =
          "s:$supermarketId:c:${widget.categoryName}:p:${docRef.id}";

      // تحديث المنتج بإضافة qrValue
      await docRef.update({'qrValue': qrValue});

      if (mounted) {
        _showSnack(loc.translate('success_product_added'), success: true);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error adding product: $e');
      _showSnack(loc.translate('error_product_add_failed'));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  // // ---------- Add product ----------
  // Future<void> addProduct() async {
  //   final loc = AppLocalizations.of(context);

  //   if (!_formKey.currentState!.validate()) {
  //     _showSnack(loc.translate('error_fix_errors'));
  //     return;
  //   }
  //   if (imageFile == null) {
  //     _showSnack(loc.translate('error_add_image'));
  //     return;
  //   }
  //   if (manufacturedDate != null && expiredDate != null) {
  //     if (!expiredDate!.isAfter(manufacturedDate!)) {
  //       _showSnack(loc.translate('error_expiry_after_manufactured'));
  //       return;
  //     }
  //   }

  //   setState(() => isLoading = true);

  //   final imageUrl = await uploadImageToImgBB(imageFile!);
  //   if (imageUrl == null) {
  //     setState(() => isLoading = false);
  //     _showSnack(loc.translate('error_image_upload_failed'));
  //     return;
  //   }

  //   try {
  //     // TODO: replace with actual supermarket id from your app state
  //     final supermarketId = "your_supermarket_id";

  //     await FirebaseFirestore.instance
  //         .collection('supermarkets')
  //         .doc(supermarketId)
  //         .collection('categories')
  //         .doc(widget.categoryName)
  //         .collection('products')
  //         .add({
  //           'name': nameController.text.trim(),
  //           'price': double.tryParse(priceController.text) ?? 0,
  //           'description': descController.text.trim(),
  //           'imageUrl': imageUrl,
  //           'expiredDate': expiredDate != null
  //               ? Timestamp.fromDate(expiredDate!)
  //               : null,
  //           'manufacturedDate': manufacturedDate != null
  //               ? Timestamp.fromDate(manufacturedDate!)
  //               : null,
  //           'createdAt': FieldValue.serverTimestamp(),
  //         });

  //     if (mounted) {
  //       _showSnack(loc.translate('success_product_added'), success: true);
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     _showSnack(loc.translate('error_product_add_failed'));
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }

  // ---------- Date picker ----------
  Future<void> pickDate(bool isExpired) async {
    final loc = AppLocalizations.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate:
          (isExpired ? expiredDate : manufacturedDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: isExpired
          ? loc.translate('select_expiry_date')
          : loc.translate('select_manufactured_date'),
    );
    if (picked != null) {
      setState(() {
        if (isExpired) {
          expiredDate = picked;
        } else {
          manufacturedDate = picked;
        }
      });
    }
  }

  // ---------- UI Helpers ----------
  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: success
            ? Colors.green.shade600
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  InputDecoration _dec(
    String label, {
    String? hint,
    IconData? prefixIcon,
    Widget? suffix,
  }) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(14);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: kCardBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.8),
          width: 1.6,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
    );
  }

  Widget _dateCard({
    required String label,
    required DateTime? date,
    required VoidCallback onPick,
    required IconData icon,
    VoidCallback? onClear,
  }) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final text = date != null
        ? _formatDate(date)
        : loc.translate('tap_to_select');
    final subtle = date == null;

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCardBackground,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              child: Icon(icon, size: 18, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: subtle ? Colors.grey : theme.colorScheme.onSurface,
                      fontWeight: subtle ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (date != null)
              IconButton(
                tooltip: loc.translate('clear'),
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: onClear,
              )
            else
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(loc.translate('add_product')),
        centerTitle: true,
        elevation: 0.2,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : addProduct,
              icon: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Icon(Icons.check_circle_rounded),
              label: Text(
                isLoading
                    ? loc.translate('saving')
                    : loc.translate('add_product'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ---------- Image Card ----------
                    _ImageCard(
                      imageFile: imageFile,
                      onTapPick: pickImageFromSheet,
                      onRemove: imageFile == null
                          ? null
                          : () => setState(() => imageFile = null),
                    ),
                    const SizedBox(height: 16),

                    // ---------- Details Card ----------
                    Card(
                      color: kCardBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                loc.translate('details'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              decoration: _dec(
                                loc.translate('product_name'),
                                hint: loc.translate('product_name_hint'),
                                prefixIcon: Icons.inventory_2_outlined,
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? loc.translate('error_enter_product_name')
                                  : null,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_priceFocus),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: priceController,
                              focusNode: _priceFocus,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              decoration: _dec(
                                loc.translate('price'),
                                hint: loc.translate('price_hint'),
                                prefixIcon: Icons.attach_money_rounded,
                              ),
                              validator: (v) {
                                final value = double.tryParse(v ?? '');
                                if (value == null || value <= 0) {
                                  return loc.translate(
                                    'error_enter_valid_price',
                                  );
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_descFocus),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: descController,
                              focusNode: _descFocus,
                              minLines: 3,
                              maxLines: 6,
                              maxLength: 300,
                              decoration: _dec(
                                loc.translate('description'),
                                hint: loc.translate('description_hint'),
                                prefixIcon: Icons.description_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ---------- Dates Card ----------
                    Card(
                      color: kCardBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                loc.translate('dates'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _dateCard(
                                    label: loc.translate('manufactured'),
                                    date: manufacturedDate,
                                    icon: Icons.factory_outlined,
                                    onPick: () => pickDate(false),
                                    onClear: manufacturedDate == null
                                        ? null
                                        : () => setState(
                                            () => manufacturedDate = null,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _dateCard(
                                    label: loc.translate('expires'),
                                    date: expiredDate,
                                    icon: Icons.event_busy_rounded,
                                    onPick: () => pickDate(true),
                                    onClear: expiredDate == null
                                        ? null
                                        : () => setState(
                                            () => expiredDate = null,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------- Loading overlay (subtle) ----------
          if (isLoading)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: Colors.black.withOpacity(0.04),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTapPick;
  final VoidCallback? onRemove;

  const _ImageCard({
    required this.imageFile,
    required this.onTapPick,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final radius = 20.0;

    return Container(
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTapPick,
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: imageFile == null
                ? const _PlaceholderImage()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.broken_image, size: 48),
                            ),
                      ),
                      // Bottom gradient and caption
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.photo_camera_back_outlined,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                loc.translate('tap_to_change_photo'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_rounded,
            size: 44,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            loc.translate('add_product_image'),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            loc.translate('tap_to_choose_photo'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
