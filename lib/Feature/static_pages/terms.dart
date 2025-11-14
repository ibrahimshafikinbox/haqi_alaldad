import 'package:flutter/material.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Widget/app_button.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.grey.shade200;
    final Color textColor = Colors.black87;
    final Color iconColor = Colors.teal;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate("clinic_terms_services"),
          style: AppTextStyle.textStyleBoldBlack,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before_sharp,
            color: AppColors.black,
            size: 35,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerCard(context, borderColor, textColor, iconColor),
              const SizedBox(height: 16),
              _servicesCard(context, borderColor, textColor, iconColor),
              const SizedBox(height: 16),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(
                  context,
                ).translate("appointments_cancellations"),
                icon: Icons.schedule,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(
                    context,
                  ).translate("appointments_bullet_1"),
                  AppLocalizations.of(
                    context,
                  ).translate("appointments_bullet_2"),
                  AppLocalizations.of(
                    context,
                  ).translate("appointments_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(
                  context,
                ).translate("treatment_consent_medical_records"),
                icon: Icons.health_and_safety,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(context).translate("treatment_bullet_1"),
                  AppLocalizations.of(context).translate("treatment_bullet_2"),
                  AppLocalizations.of(context).translate("treatment_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(
                  context,
                ).translate("medications_prescriptions"),
                icon: Icons.vaccines,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(
                    context,
                  ).translate("medications_bullet_1"),
                  AppLocalizations.of(
                    context,
                  ).translate("medications_bullet_2"),
                  AppLocalizations.of(
                    context,
                  ).translate("medications_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(context).translate("telemedicine"),
                icon: Icons.video_call,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(
                    context,
                  ).translate("telemedicine_bullet_1"),
                  AppLocalizations.of(
                    context,
                  ).translate("telemedicine_bullet_2"),
                  AppLocalizations.of(
                    context,
                  ).translate("telemedicine_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(
                  context,
                ).translate("payments_billing"),
                icon: Icons.payments,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(context).translate("payments_bullet_1"),
                  AppLocalizations.of(context).translate("payments_bullet_2"),
                  AppLocalizations.of(context).translate("payments_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(context).translate("privacy_data"),
                icon: Icons.privacy_tip,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(context).translate("privacy_bullet_1"),
                  AppLocalizations.of(context).translate("privacy_bullet_2"),
                  AppLocalizations.of(context).translate("privacy_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                context: context,
                title: AppLocalizations.of(
                  context,
                ).translate("emergency_care_liability"),
                icon: Icons.emergency,
                borderColor: borderColor,
                textColor: textColor,
                bullets: [
                  AppLocalizations.of(context).translate("emergency_bullet_1"),
                  AppLocalizations.of(context).translate("emergency_bullet_2"),
                  AppLocalizations.of(context).translate("emergency_bullet_3"),
                ],
              ),
              const SizedBox(height: 20),

              _disclaimer(context, borderColor, textColor),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(
                    AppLocalizations.of(context).translate("i_agree_continue"),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).translate("by_continuing_agree"),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard(
    BuildContext context,
    Color borderColor,
    Color textColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.pets, color: iconColor, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  ).translate("veterinary_clinic_terms"),
                  style: AppTextStyle.textStyleBoldBlack,
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context).translate("terms_description"),
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _servicesCard(
    BuildContext context,
    Color borderColor,
    Color textColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services_outlined, color: iconColor),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).translate("core_services"),
                style: AppTextStyle.textStyleBoldBlack,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("wellness_exams"),
                Icons.vaccines,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("vaccinations"),
                Icons.vaccines,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(
                  context,
                ).translate("diagnostics_lab_imaging"),
                Icons.biotech,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("surgery_anesthesia"),
                Icons.local_hospital,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("dental_care"),
                Icons.health_and_safety,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("emergency_urgent_care"),
                Icons.emergency,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("telehealth_followups"),
                Icons.video_call,
                borderColor,
                textColor,
                iconColor,
              ),
              _serviceChip(
                context,
                AppLocalizations.of(context).translate("preventive_care_plans"),
                Icons.shield_outlined,
                borderColor,
                textColor,
                iconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color borderColor,
    required Color textColor,
    required List<String> bullets,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: AppTextStyle.textStyleBoldBlack),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...bullets.map((b) => _bulletItem(b, textColor)).toList(),
        ],
      ),
    );
  }

  Widget _bulletItem(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(color: textColor, fontSize: 16)),
          Expanded(
            child: Text(text, style: TextStyle(color: textColor, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _serviceChip(
    BuildContext context,
    String label,
    IconData icon,
    Color borderColor,
    Color textColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer(BuildContext context, Color borderColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        AppLocalizations.of(context).translate("terms_disclaimer"),
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }
}
