// lib/Feature/service/cubit/add_vet_service_cubit.dart
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:store_mangment/Feature/service/cubit/services_state.dart';

class AddVetServiceCubit extends Cubit<AddVetServiceState> {
  final FirebaseFirestore _firestore;
  final ImagePicker _imagePicker;

  // 🔑 YOUR IMGBB API KEY
  String imgbbApiKey = '';

  static const String _imgbbUploadUrl = 'https://api.imgbb.com/1/upload';

  String? _uploadedImageUrl;
  String? _localImagePath;

  AddVetServiceCubit({FirebaseFirestore? firestore, ImagePicker? imagePicker})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _imagePicker = imagePicker ?? ImagePicker(),
      super(AddVetServiceInitial());

  // Getters
  String? get uploadedImageUrl => _uploadedImageUrl;
  String? get localImagePath => _localImagePath;

  // Set API Key
  void setImgbbApiKey(String key) {
    imgbbApiKey = key;
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      emit(ImagePickingInProgress());

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _localImagePath = image.path;
        await _uploadToImgBB(File(image.path));
      } else {
        emit(AddVetServiceInitial());
      }
    } catch (e) {
      emit(
        ImageUploadError('Failed to pick image from camera: ${e.toString()}'),
      );
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      emit(ImagePickingInProgress());

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _localImagePath = image.path;
        await _uploadToImgBB(File(image.path));
      } else {
        emit(AddVetServiceInitial());
      }
    } catch (e) {
      emit(
        ImageUploadError('Failed to pick image from gallery: ${e.toString()}'),
      );
    }
  }

  /// Upload image to ImgBB
  Future<void> _uploadToImgBB(File imageFile) async {
    try {
      if (imgbbApiKey.isEmpty) {
        emit(const ImageUploadError('ImgBB API key not set'));
        return;
      }

      emit(const ImageUploadingInProgress(0.0));

      // Read and encode image
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      emit(const ImageUploadingInProgress(0.3));

      // Create request
      final request = http.MultipartRequest('POST', Uri.parse(_imgbbUploadUrl));
      request.fields['key'] = imgbbApiKey;
      request.fields['image'] = base64Image;

      emit(const ImageUploadingInProgress(0.6));

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      emit(const ImageUploadingInProgress(0.9));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          _uploadedImageUrl = jsonResponse['data']['url'] as String;

          emit(
            ImageUploadSuccess(
              imageUrl: _uploadedImageUrl!,
              localPath: _localImagePath!,
            ),
          );
        } else {
          throw Exception(jsonResponse['error']['message'] ?? 'Upload failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      emit(ImageUploadError('Failed to upload image: ${e.toString()}'));
    }
  }

  /// Remove selected image
  void removeImage() {
    _uploadedImageUrl = null;
    _localImagePath = null;
    emit(AddVetServiceInitial());
  }

  /// Add new service
  Future<void> addVetService({
    required String name,
    required String description,
    required double price,
  }) async {
    try {
      emit(AddVetServiceLoading());

      if (name.isEmpty) {
        emit(const AddVetServiceError('Service name is required'));
        return;
      }
      if (description.isEmpty) {
        emit(const AddVetServiceError('Description is required'));
        return;
      }
      if (price <= 0) {
        emit(const AddVetServiceError('Price must be greater than 0'));
        return;
      }
      if (_uploadedImageUrl == null || _uploadedImageUrl!.isEmpty) {
        emit(const AddVetServiceError('Please upload a service image'));
        return;
      }

      final serviceData = {
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': _uploadedImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('vet_services').add(serviceData);

      _uploadedImageUrl = null;
      _localImagePath = null;

      emit(const AddVetServiceSuccess('Service added successfully!'));
    } catch (e) {
      emit(AddVetServiceError('Failed to add service: ${e.toString()}'));
    }
  }

  /// Update service
  Future<void> updateVetService({
    required String serviceId,
    required String name,
    required String description,
    required double price,
    String? existingImageUrl,
  }) async {
    try {
      emit(AddVetServiceLoading());

      if (name.isEmpty) {
        emit(const AddVetServiceError('Service name is required'));
        return;
      }
      if (description.isEmpty) {
        emit(const AddVetServiceError('Description is required'));
        return;
      }
      if (price <= 0) {
        emit(const AddVetServiceError('Price must be greater than 0'));
        return;
      }

      final imageUrl = _uploadedImageUrl ?? existingImageUrl;

      if (imageUrl == null || imageUrl.isEmpty) {
        emit(const AddVetServiceError('Please upload a service image'));
        return;
      }

      final serviceData = {
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('vet_services')
          .doc(serviceId)
          .update(serviceData);

      _uploadedImageUrl = null;
      _localImagePath = null;

      emit(const AddVetServiceSuccess('Service updated successfully!'));
    } catch (e) {
      emit(AddVetServiceError('Failed to update service: ${e.toString()}'));
    }
  }

  /// Delete service
  Future<void> deleteVetService(String serviceId) async {
    try {
      emit(AddVetServiceLoading());

      await _firestore.collection('vet_services').doc(serviceId).delete();

      emit(const AddVetServiceSuccess('Service deleted successfully!'));
    } catch (e) {
      emit(AddVetServiceError('Failed to delete service: ${e.toString()}'));
    }
  }

  void resetState() {
    _uploadedImageUrl = null;
    _localImagePath = null;
    emit(AddVetServiceInitial());
  }
}

////////////////////////////////////////////////////////////////////////
class VetServicesCubit extends Cubit<VetServicesState> {
  VetServicesCubit() : super(VetServicesInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Load all vet services from Firestore
  Future<void> loadVetServices() async {
    emit(VetServicesLoading());

    try {
      final snapshot = await _firestore
          .collection('vet_services')
          .orderBy('name')
          .get();

      final services = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id, // Include document ID for editing
          ...data,
        };
      }).toList();

      emit(VetServicesLoaded(services));
    } catch (e) {
      emit(VetServicesError('Failed to load services: $e'));
    }
  }

  /// Refresh services (call after adding/updating)
  void refresh() {
    loadVetServices();
  }
}
