// lib/Feature/service/cubit/services_state.dart
import 'package:equatable/equatable.dart';

abstract class AddVetServiceState extends Equatable {
  const AddVetServiceState();

  @override
  List<Object?> get props => [];
}

class AddVetServiceInitial extends AddVetServiceState {}

class AddVetServiceLoading extends AddVetServiceState {}

// Image States
class ImagePickingInProgress extends AddVetServiceState {}

class ImageUploadingInProgress extends AddVetServiceState {
  final double progress;

  const ImageUploadingInProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ImageUploadSuccess extends AddVetServiceState {
  final String imageUrl;
  final String localPath;

  const ImageUploadSuccess({required this.imageUrl, required this.localPath});

  @override
  List<Object?> get props => [imageUrl, localPath];
}

class ImageUploadError extends AddVetServiceState {
  final String error;

  const ImageUploadError(this.error);

  @override
  List<Object?> get props => [error];
}

class AddVetServiceSuccess extends AddVetServiceState {
  final String message;

  const AddVetServiceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddVetServiceError extends AddVetServiceState {
  final String error;

  const AddVetServiceError(this.error);

  @override
  List<Object?> get props => [error];
}
/////////////////////////////////////////////////

abstract class VetServicesState extends Equatable {
  const VetServicesState();

  @override
  List<Object> get props => [];
}

class VetServicesInitial extends VetServicesState {}

class VetServicesLoading extends VetServicesState {}

class VetServicesLoaded extends VetServicesState {
  final List<Map<String, dynamic>> services;

  const VetServicesLoaded(this.services);

  @override
  List<Object> get props => [services];
}

class VetServicesError extends VetServicesState {
  final String message;

  const VetServicesError(this.message);

  @override
  List<Object> get props => [message];
}
