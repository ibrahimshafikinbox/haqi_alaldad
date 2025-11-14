// lib/Feature/orders/data/cet_order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CetOrder {
  final String id;
  final String petName;
  final String petOwner;
  final String petType;
  final String serviceType;
  final double serviceCharge;
  final String paymentStatus;
  final String serviceStatus;
  final String orderType; // 'vet' or 'market'
  final bool convertedFromMarket;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? convertedAt;

  CetOrder({
    required this.id,
    required this.petName,
    required this.petOwner,
    required this.petType,
    required this.serviceType,
    required this.serviceCharge,
    required this.paymentStatus,
    required this.serviceStatus,
    required this.orderType,
    required this.convertedFromMarket,
    this.createdAt,
    this.updatedAt,
    this.convertedAt,
  });

  factory CetOrder.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CetOrder(
      id: doc.id,
      petName: (data['pet_name'] ?? '') as String,
      petOwner: (data['pet_owner'] ?? '') as String,
      petType: (data['pet_type'] ?? '') as String,
      serviceType: (data['service_type'] ?? '') as String,
      serviceCharge: (data['service_charge'] ?? 0).toDouble(),
      paymentStatus: (data['payment_status'] ?? '') as String,
      serviceStatus: (data['service_status'] ?? '') as String,
      orderType: (data['order_type'] ?? 'vet') as String,
      convertedFromMarket: (data['converted_from_market'] ?? false) as bool,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
      convertedAt: (data['converted_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toCreateMap() => {
    'pet_name': petName,
    'pet_owner': petOwner,
    'pet_type': petType,
    'service_type': serviceType,
    'service_charge': serviceCharge,
    'payment_status': paymentStatus,
    'service_status': serviceStatus,
    'order_type': orderType,
    'converted_from_market': convertedFromMarket,
    'created_at': FieldValue.serverTimestamp(),
    'updated_at': FieldValue.serverTimestamp(),
  };

  Map<String, dynamic> toUpdateMap() => {
    'pet_name': petName,
    'pet_owner': petOwner,
    'pet_type': petType,
    'service_type': serviceType,
    'service_charge': serviceCharge,
    'payment_status': paymentStatus,
    'service_status': serviceStatus,
    'order_type': orderType,
    'converted_from_market': convertedFromMarket,
    'updated_at': FieldValue.serverTimestamp(),
  };
}
