import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String? id;
  final String userId; // صاحب الإشعار (صاحب الحجز)
  final String title;
  final String body;
  final String? bookingId; // ربط إشعار بحجز
  final String status; // مثل: approved, declined, info
  final DateTime createdAt;
  final bool read;

  AppNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.bookingId,
    required this.status,
    required this.createdAt,
    this.read = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'bookingId': bookingId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'read': read,
    };
  }

  static AppNotification fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      bookingId: data['bookingId'],
      status: data['status'] ?? 'info',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] ?? false,
    );
  }
}
