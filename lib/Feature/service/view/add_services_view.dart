// lib/Feature/service/view/add_services_view.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class AddVetServicePage extends StatefulWidget {
  final Map<String, dynamic>? editService;
  final String imgbbApiKey = 'fd92c702916d503b106bac9858b8856c';

  const AddVetServicePage({super.key, this.editService});

  @override
  State<AddVetServicePage> createState() => _AddVetServicePageState();
}

class _AddVetServicePageState extends State<AddVetServicePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;
  bool _isEditMode = false;
  bool _isUploadingImage = false;
  String? _serviceId;
  File? _selectedImage;
  String? _uploadedImageUrl;
  double _uploadProgress = 0.0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    // Check if editing
    if (widget.editService != null) {
      _isEditMode = true;
      _serviceId = widget.editService!['id'];
      _nameController.text = widget.editService!['name'] ?? '';
      _descriptionController.text = widget.editService!['description'] ?? '';
      _priceController.text = (widget.editService!['price'] ?? 0).toString();
      _uploadedImageUrl = widget.editService!['imageUrl'];
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImagePickerModal(),
    );
  }

  Widget _buildImagePickerModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context).translate("choose_image_source"),
              style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildPickerOption(
                    icon: Icons.camera_alt,
                    label: AppLocalizations.of(context).translate("camera"),
                    color: const Color(0xFF2196F3),
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromCamera();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPickerOption(
                    icon: Icons.image,
                    label: AppLocalizations.of(context).translate("gallery"),
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromGallery();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyle.textStyleBoldBlack.copyWith(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
      await _uploadImageToImgBB();
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
      await _uploadImageToImgBB();
    }
  }

  Future<void> _uploadImageToImgBB() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploadingImage = true;
      _uploadProgress = 0.0;
    });

    try {
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() => _uploadProgress = 0.3);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload'),
      );

      request.fields['key'] = widget.imgbbApiKey;
      request.fields['image'] = base64Image;

      setState(() => _uploadProgress = 0.6);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      setState(() => _uploadProgress = 0.9);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          setState(() {
            _uploadedImageUrl = jsonResponse['data']['url'];
            _uploadProgress = 1.0;
          });

          await Future.delayed(const Duration(milliseconds: 500));

          setState(() => _isUploadingImage = false);

          _showSuccessSnackBar(
            AppLocalizations.of(
              context,
            ).translate("image_uploaded_successfully"),
          );
        } else {
          throw Exception(jsonResponse['error']['message'] ?? 'Upload failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isUploadingImage = false);
      _showErrorSnackBar(
        '${AppLocalizations.of(context).translate("failed_to_upload_image")}: $e',
      );
    }
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    if (_uploadedImageUrl == null || _uploadedImageUrl!.isEmpty) {
      _showErrorSnackBar(
        AppLocalizations.of(context).translate("please_upload_image"),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final serviceData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'imageUrl': _uploadedImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (_isEditMode && _serviceId != null) {
        // Update existing service
        await FirebaseFirestore.instance
            .collection('vet_services')
            .doc(_serviceId)
            .update(serviceData);

        _showSuccessSnackBar(
          AppLocalizations.of(
            context,
          ).translate("service_updated_successfully"),
        );
      } else {
        // Add new service
        serviceData['createdAt'] = FieldValue.serverTimestamp();

        await FirebaseFirestore.instance
            .collection('vet_services')
            .add(serviceData);

        _showSuccessSnackBar(
          AppLocalizations.of(context).translate("service_added_successfully"),
        );
      }

      if (mounted) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(
          context,
        ).translate("error_occurred").replaceAll('{error}', '$e'),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteService() async {
    if (!_isEditMode || _serviceId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteConfirmDialog(),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('vet_services')
          .doc(_serviceId)
          .delete();

      _showSuccessSnackBar(
        AppLocalizations.of(context).translate("service_deleted_successfully"),
      );

      if (mounted) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      _showErrorSnackBar(
        AppLocalizations.of(
          context,
        ).translate("error_deleting_service").replaceAll('{error}', '$e'),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  AlertDialog _buildDeleteConfirmDialog() {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate("delete_service")),
      content: Text(
        AppLocalizations.of(context).translate("delete_service_confirmation"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context).translate("cancel")),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(AppLocalizations.of(context).translate("delete")),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildImageSection(),
                const SizedBox(height: 30),
                _buildTextField(
                  label: AppLocalizations.of(context).translate("service_name"),
                  controller: _nameController,
                  hint: AppLocalizations.of(
                    context,
                  ).translate("service_name_hint"),
                  icon: Icons.medical_services,
                  color: const Color(0xFF4CAF50),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate("enter_service_name");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: AppLocalizations.of(context).translate("description"),
                  controller: _descriptionController,
                  hint: AppLocalizations.of(
                    context,
                  ).translate("description_hint"),
                  icon: Icons.description,
                  color: const Color(0xFF2196F3),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate("enter_description");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: AppLocalizations.of(context).translate("price"),
                  controller: _priceController,
                  hint: AppLocalizations.of(context).translate("price_hint"),
                  icon: Icons.attach_money,
                  color: const Color(0xFFFF9800),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate("enter_price");
                    }
                    if (double.tryParse(value) == null) {
                      return AppLocalizations.of(
                        context,
                      ).translate("enter_valid_number");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      title: Text(
        _isEditMode
            ? AppLocalizations.of(context).translate("edit_service")
            : AppLocalizations.of(context).translate("new_service"),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_isEditMode)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _deleteService,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isEditMode
              ? AppLocalizations.of(context).translate("update_service")
              : AppLocalizations.of(context).translate("create_new_service"),
          style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).translate("fill_service_details"),
          style: AppTextStyle.textStyleMediumGray.copyWith(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context).translate("service_image"),
              style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                AppLocalizations.of(context).translate("required"),
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _isUploadingImage ? null : _pickImage,
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: _uploadedImageUrl != null
                    ? AppColors.green
                    : Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              color: _uploadedImageUrl != null
                  ? AppColors.green.withOpacity(0.05)
                  : Colors.grey[50],
            ),
            child: _isUploadingImage
                ? _buildUploadingState()
                : _uploadedImageUrl != null
                ? _buildImagePreview()
                : _buildUploadPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: _uploadProgress,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
            strokeWidth: 4,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${(_uploadProgress * 100).toStringAsFixed(0)}%',
          style: AppTextStyle.textStyleBoldBlack.copyWith(
            fontSize: 18,
            color: AppColors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).translate("uploading_to_server"),
          style: AppTextStyle.textStyleMediumGray.copyWith(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            _uploadedImageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildImageErrorPlaceholder();
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _uploadedImageUrl = null;
                _selectedImage = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context).translate("image_ready"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.green.withOpacity(0.15),
                AppColors.green.withOpacity(0.05),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 56,
            color: AppColors.green,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context).translate("upload_service_image"),
          style: AppTextStyle.textStyleBoldBlack.copyWith(
            fontSize: 16,
            color: AppColors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(
            context,
          ).translate("choose_from_camera_or_gallery"),
          style: AppTextStyle.textStyleMediumGray.copyWith(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            AppLocalizations.of(context).translate("supported_formats"),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: AppColors.green.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 48,
              color: AppColors.green.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).translate("failed_to_load_image"),
              style: TextStyle(
                color: AppColors.green.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: color),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            filled: true,
            fillColor: color.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Save Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveService,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              disabledBackgroundColor: AppColors.green.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: AppColors.green.withOpacity(0.4),
            ),
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    _isEditMode ? Icons.update : Icons.add_circle_outline,
                    color: Colors.white,
                    size: 22,
                  ),
            label: Text(
              _isLoading
                  ? AppLocalizations.of(context).translate("processing")
                  : (_isEditMode
                        ? AppLocalizations.of(
                            context,
                          ).translate("update_service_button")
                        : AppLocalizations.of(
                            context,
                          ).translate("add_service_button")),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        if (_isEditMode) ...[
          const SizedBox(height: 12),
          // Delete Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _deleteService,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 22,
              ),
              label: Text(
                AppLocalizations.of(context).translate("delete_service_button"),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
