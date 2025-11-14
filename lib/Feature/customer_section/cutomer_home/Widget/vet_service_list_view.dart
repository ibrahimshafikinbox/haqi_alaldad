import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class VetServiceListView extends StatelessWidget {
  final String serviceName;
  const VetServiceListView({super.key, required this.serviceName});

  Stream<QuerySnapshot<Map<String, dynamic>>> _queryServiceByName(String name) {
    return FirebaseFirestore.instance
        .collection('vet_services')
        .where('name', isEqualTo: name)
        .limit(1)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _queryServiceByName(serviceName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No details found for this service.'),
            );
          }
          final data = snapshot.data!.docs.first.data();
          final desc =
              data['description'] ?? 'A high-quality veterinary service.';
          final price = data['price'];
          final imageUrl = data['imageUrl'] as String?;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(serviceName, style: AppTextStyle.textStyleBoldBlack),
              if (price != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    "Price: \\$price",
                    style: AppTextStyle.textStyleMediumGray,
                  ),
                ),
              const SizedBox(height: 10),
              Text(desc),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Hook your booking flow here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking request sent.')),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryL,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
