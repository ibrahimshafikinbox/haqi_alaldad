// class VetService {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final String emoji;
//   final String imageUrl;
//   final bool isPopular;
//   final List<String> species;
//   final DateTime createdAt;

//   VetService({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.emoji,
//     required this.imageUrl,
//     required this.isPopular,
//     required this.species,
//     required this.createdAt,
//   });

//   factory VetService.fromFirestore(Map<String, dynamic> data, String docId) {
//     return VetService(
//       id: docId,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       price: (data['price'] ?? 0).toDouble(),
//       emoji: data['emoji'] ?? '🐾',
//       imageUrl: data['imageUrl'] ?? '',
//       isPopular: data['isPopular'] ?? false,
//       species: List<String>.from(data['species'] ?? []),
//       createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'description': description,
//       'price': price,
//       'emoji': emoji,
//       'imageUrl': imageUrl,
//       'isPopular': isPopular,
//       'species': species,
//       'createdAt': createdAt,
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class VetService {
  final String id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final String imageUrl;
  final bool isPopular;
  final List<String> species;
  final DateTime createdAt;

  VetService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.imageUrl,
    required this.isPopular,
    required this.species,
    required this.createdAt,
  });

  // إصلاح: تغيير اسم الميثود من fromFirestore إلى fromDoc
  factory VetService.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return VetService(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      emoji: data['emoji'] ?? '🐾',
      imageUrl: data['imageUrl'] ?? '',
      isPopular: data['isPopular'] ?? false,
      species: List<String>.from(data['species'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // إضافة factory للتعامل مع DocumentSnapshot العادي
  factory VetService.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return VetService(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      emoji: data['emoji'] ?? '🐾',
      imageUrl: data['imageUrl'] ?? '',
      isPopular: data['isPopular'] ?? false,
      species: List<String>.from(data['species'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'emoji': emoji,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'species': species,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  String toString() {
    return 'VetService(id: $id, name: $name, price: $price, species: $species)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VetService && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
