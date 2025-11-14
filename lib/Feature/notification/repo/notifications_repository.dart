// notifications_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notifications';

  Future<String> sendNotification(AppNotification notif) async {
    final ref = await _firestore.collection(_collection).add(notif.toMap());
    return ref.id;
  }

  // ✅ الحل البديل: اجلب البيانات وافرزها في التطبيق
  Stream<List<AppNotification>> getUserNotificationsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        // ❌ احذف هذا السطر
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          // ✅ افرز البيانات هنا بدلاً من Firestore
          final notifications = snap.docs
              .map((d) => AppNotification.fromFirestore(d))
              .toList();

          // فرز حسب التاريخ (الأحدث أولاً)
          notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return notifications;
        });
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection(_collection).doc(notificationId).update({
      'read': true,
    });
  }
}
