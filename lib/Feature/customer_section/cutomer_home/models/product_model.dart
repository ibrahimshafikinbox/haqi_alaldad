import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final DateTime? createdAt;
  final DateTime? expiredDate;
  final DateTime? manufacturedDate;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.createdAt,
    this.expiredDate,
    this.manufacturedDate,
  });

  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      expiredDate: (data['expiredDate'] as Timestamp?)?.toDate(),
      manufacturedDate: (data['manufacturedDate'] as Timestamp?)?.toDate(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    price,
    createdAt,
    expiredDate,
    manufacturedDate,
  ];
}
