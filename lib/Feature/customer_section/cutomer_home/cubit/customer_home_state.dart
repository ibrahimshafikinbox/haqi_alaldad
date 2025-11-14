import 'package:equatable/equatable.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/vet_service.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/categories_model.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/models/product_model.dart';

enum ActionStatus { none, inProgress, success, failure }

class CustomerHomeAction extends Equatable {
  final ActionStatus status;
  final String? message;

  const CustomerHomeAction({required this.status, this.message});

  factory CustomerHomeAction.none() =>
      const CustomerHomeAction(status: ActionStatus.none);
  factory CustomerHomeAction.inProgress(String msg) =>
      CustomerHomeAction(status: ActionStatus.inProgress, message: msg);
  factory CustomerHomeAction.success(String msg) =>
      CustomerHomeAction(status: ActionStatus.success, message: msg);
  factory CustomerHomeAction.failure(String msg) =>
      CustomerHomeAction(status: ActionStatus.failure, message: msg);

  @override
  List<Object?> get props => [status, message];
}

class CustomerHomeState extends Equatable {
  final bool isLoadingUser;
  final bool isLoadingCategories;
  final bool isLoadingServices;
  final bool isLoadingProducts;
  final String name;
  final String imageUrl;
  final List<AppCategory> categories;
  final List<VetService> services;
  final List<Product> products;
  final String? error;
  final CustomerHomeAction lastAction;

  const CustomerHomeState({
    required this.isLoadingUser,
    required this.isLoadingCategories,
    required this.isLoadingServices,
    required this.isLoadingProducts,
    required this.name,
    required this.imageUrl,
    required this.categories,
    required this.services,
    required this.products,
    required this.error,
    required this.lastAction,
  });

  factory CustomerHomeState.initial() => const CustomerHomeState(
    isLoadingUser: true,
    isLoadingCategories: true,
    isLoadingServices: true,
    isLoadingProducts: true,
    name: 'Guest',
    imageUrl:
        'https://images.unsplash.com/photo-1543852786-1cf6624b9987?q=80&w=600&auto=format&fit=crop',
    categories: [],
    services: [],
    products: [],
    error: null,
    lastAction: CustomerHomeAction(status: ActionStatus.none),
  );

  CustomerHomeState copyWith({
    bool? isLoadingUser,
    bool? isLoadingCategories,
    bool? isLoadingServices,
    bool? isLoadingProducts,
    String? name,
    String? imageUrl,
    List<AppCategory>? categories,
    List<VetService>? services,
    List<Product>? products,
    String? error,
    bool clearError = false,
    CustomerHomeAction? lastAction,
  }) {
    return CustomerHomeState(
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      // ✅ الحل: احتفظ بالبيانات القديمة إذا لم تُمرر بيانات جديدة
      categories: categories ?? this.categories,
      services: services ?? this.services,
      products: products ?? this.products,
      // ✅ التعامل الصحيح مع error
      error: clearError ? null : (error ?? this.error),
      lastAction: lastAction ?? this.lastAction,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingUser,
    isLoadingCategories,
    isLoadingServices,
    isLoadingProducts,
    name,
    imageUrl,
    categories,
    services,
    products,
    error,
    lastAction,
  ];
}
