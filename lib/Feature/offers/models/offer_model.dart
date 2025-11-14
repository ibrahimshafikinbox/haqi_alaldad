import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String productName;
  final String offerTitle;
  final String offerDescription;
  final String? productImage;
  final double? originalPrice;
  final double? discountPrice;
  final int? discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;

  OfferModel({
    required this.id,
    required this.productName,
    required this.offerTitle,
    required this.offerDescription,
    this.productImage,
    this.originalPrice,
    this.discountPrice,
    this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
  });

  // Convert from Firestore
  factory OfferModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OfferModel(
      id: doc.id,
      productName: data['productName'] ?? '',
      offerTitle: data['offerTitle'] ?? '',
      offerDescription: data['offerDescription'] ?? '',
      productImage: data['productImage'],
      originalPrice: data['originalPrice']?.toDouble(),
      discountPrice: data['discountPrice']?.toDouble(),
      discountPercentage: data['discountPercentage']?.toInt(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productName': productName,
      'offerTitle': offerTitle,
      'offerDescription': offerDescription,
      'productImage': productImage,
      'originalPrice': originalPrice,
      'discountPrice': discountPrice,
      'discountPercentage': discountPercentage,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Check if offer is valid (not expired)
  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}
