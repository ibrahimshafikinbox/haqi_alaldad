// cubit/admin_market_order_cubit.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_market_order_state.dart';
import '../models/market_order_model.dart';

class AdminMarketOrderCubit extends Cubit<AdminMarketOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminMarketOrderCubit() : super(AdminMarketOrderInitial());

  // جلب جميع الطلبات
  Future<void> fetchOrders() async {
    try {
      emit(AdminMarketOrderLoading());

      final querySnapshot = await _firestore
          .collection('market_orders')
          .orderBy('createdAt', descending: true)
          .get();

      final orders = querySnapshot.docs
          .map((doc) => MarketOrderModel.fromFirestore(doc))
          .toList();

      emit(AdminMarketOrderLoaded(orders));
    } catch (e) {
      emit(AdminMarketOrderError('خطأ في تحميل الطلبات: ${e.toString()}'));
    }
  }

  // جلب طلب معين
  Future<void> fetchOrderById(String orderId) async {
    try {
      emit(AdminMarketOrderLoading());

      final doc = await _firestore
          .collection('market_orders')
          .doc(orderId)
          .get();

      if (doc.exists) {
        final order = MarketOrderModel.fromFirestore(doc);
        emit(AdminMarketOrderLoaded([order]));
      } else {
        emit(const AdminMarketOrderError('الطلب غير موجود'));
      }
    } catch (e) {
      emit(AdminMarketOrderError('خطأ في تحميل الطلب: ${e.toString()}'));
    }
  }

  // تحديث حالة الطلب
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      emit(AdminMarketOrderUpdating());

      await _firestore.collection('market_orders').doc(orderId).update({
        'orderStatus': newStatus,
      });

      emit(const AdminMarketOrderUpdated('تم تحديث حالة الطلب بنجاح'));
      fetchOrders(); // إعادة تحميل الطلبات
    } catch (e) {
      emit(AdminMarketOrderError('خطأ في تحديث الطلب: ${e.toString()}'));
    }
  }

  // تحديث حالة الدفع
  Future<void> updatePaymentStatus(String orderId, String newStatus) async {
    try {
      emit(AdminMarketOrderUpdating());

      await _firestore.collection('market_orders').doc(orderId).update({
        'paymentStatus': newStatus,
      });

      emit(const AdminMarketOrderUpdated('تم تحديث حالة الدفع بنجاح'));
      fetchOrders();
    } catch (e) {
      emit(AdminMarketOrderError('خطأ في تحديث الدفع: ${e.toString()}'));
    }
  }

  // حذف طلب
  Future<void> deleteOrder(String orderId) async {
    try {
      emit(AdminMarketOrderUpdating());

      await _firestore.collection('market_orders').doc(orderId).delete();

      emit(const AdminMarketOrderUpdated('تم حذف الطلب بنجاح'));
      fetchOrders();
    } catch (e) {
      emit(AdminMarketOrderError('خطأ في حذف الطلب: ${e.toString()}'));
    }
  }
}
