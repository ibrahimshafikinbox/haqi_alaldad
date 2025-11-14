import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppCategory extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final String imageUrl;
  final String description;
  final DateTime? createdAt;

  const AppCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.imageUrl,
    required this.description,
    this.createdAt,
  });

  factory AppCategory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppCategory(
      id: doc.id,
      name: data['name'] ?? '',
      emoji: data['emoji'] ?? '🏪',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    emoji,
    imageUrl,
    description,
    createdAt,
  ];
}
