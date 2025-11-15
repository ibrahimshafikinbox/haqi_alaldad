// models/market_order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketOrderModel {
  final String id;
  final String customerName;
  final List<OrderItem> items;
  final String orderId;
  final String orderStatus;
  final String paymentMethod;
  final String paymentStatus;
  final double totalAmount;
  final DateTime createdAt;

  MarketOrderModel({
    required this.id,
    required this.customerName,
    required this.items,
    required this.orderId,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalAmount,
    required this.createdAt,
  });

  factory MarketOrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return MarketOrderModel(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      items:
          (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      orderId: data['orderId'] ?? '',
      orderStatus: data['orderStatus'] ?? 'Pending',
      paymentMethod: data['paymentMethod'] ?? 'COD',
      paymentStatus: data['paymentStatus'] ?? 'Unpaid',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class OrderItem {
  final String image;
  final String name;
  final double price;
  final String productId;
  final int quantity;

  OrderItem({
    required this.image,
    required this.name,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}
