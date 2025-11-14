import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VetSlider extends StatelessWidget {
  const VetSlider({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _getPromotions() {
    return FirebaseFirestore.instance.collection('promotions').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _getPromotions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink();
          }
          final items = snapshot.data!.docs;
          return PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final data = items[index].data();
              final imageUrl = data['imageUrl'] as String?;
              final title = data['title'] ?? '';
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Container(color: Colors.grey[200]),
                      if (title.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              title,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
