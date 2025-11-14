// book_modek.dart (ensure location exists)
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final String serviceImage;
  final String customerName;
  final String customerPhone;
  final DateTime bookingDate;
  final String bookingTime;
  final String notes;
  final String status;
  final String userId;
  final DateTime createdAt;
  final String location; // NEW

  BookingModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceImage,
    required this.customerName,
    required this.customerPhone,
    required this.bookingDate,
    required this.bookingTime,
    required this.notes,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.location,
  });

  BookingModel copyWith({String? id}) => BookingModel(
    id: id ?? this.id,
    serviceId: serviceId,
    serviceName: serviceName,
    servicePrice: servicePrice,
    serviceImage: serviceImage,
    customerName: customerName,
    customerPhone: customerPhone,
    bookingDate: bookingDate,
    bookingTime: bookingTime,
    notes: notes,
    status: status,
    userId: userId,
    createdAt: createdAt,
    location: location,
  );

  Map<String, dynamic> toMap() => {
    'serviceId': serviceId,
    'serviceName': serviceName,
    'servicePrice': servicePrice,
    'serviceImage': serviceImage,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'bookingDate': Timestamp.fromDate(bookingDate),
    'bookingTime': bookingTime,
    'notes': notes,
    'status': status,
    'userId': userId,
    'createdAt': Timestamp.fromDate(createdAt),
    'location': location,
  };

  static BookingModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      servicePrice: (data['servicePrice'] ?? 0).toDouble(),
      serviceImage: data['serviceImage'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      bookingTime: data['bookingTime'] ?? '',
      notes: data['notes'] ?? '',
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: data['location'] ?? '',
    );
  }
}
