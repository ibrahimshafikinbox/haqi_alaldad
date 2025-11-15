import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const softBlue = Color(0xffe8f0fe);
    const softText = Color(0xff4a4a4a);

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "تواصل معنا",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
              decoration: BoxDecoration(
                color: softBlue,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.support_agent_rounded,
                    size: 65,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "يسعدنا تواصلك في أي وقت",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: softText,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            buildInfoCard(
              icon: Icons.person_rounded,
              title: "الاسم",
              value: "د. حقي العضاض",
            ),

            buildInfoCard(
              icon: Icons.phone_rounded,
              title: "الهاتف",
              value: "07823229222",
            ),

            buildInfoCard(
              icon: Icons.location_on_rounded,
              title: "العنوان",
              value: "الانبار – الرمادي",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffe8f0fe),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: Colors.blueAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
