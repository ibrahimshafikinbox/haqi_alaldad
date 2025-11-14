import 'package:flutter/material.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class PrivacyAndSecurityScreen extends StatefulWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  State<PrivacyAndSecurityScreen> createState() =>
      _PrivacyAndSecurityScreenState();
}

class _PrivacyAndSecurityScreenState extends State<PrivacyAndSecurityScreen> {
  final Color borderColor = Colors.grey.shade200;
  final Color textColor = Colors.black87;
  final Color accentColor = Colors.indigo;

  bool remindersOptIn = true;
  bool marketingOptIn = false;
  bool analyticsOptIn = true;
  bool telehealthRecordingConsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate("privacy_security"),
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
              _headerCard(),
              const SizedBox(height: 16),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("data_collection_use"),
                icon: Icons.privacy_tip_outlined,
                bullets: [
                  AppLocalizations.of(
                    context,
                  ).translate("data_collection_bullet_1"),
                  AppLocalizations.of(
                    context,
                  ).translate("data_collection_bullet_2"),
                  AppLocalizations.of(
                    context,
                  ).translate("data_collection_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("data_sharing_third_parties"),
                icon: Icons.share_outlined,
                bullets: [
                  AppLocalizations.of(
                    context,
                  ).translate("data_sharing_bullet_1"),
                  AppLocalizations.of(
                    context,
                  ).translate("data_sharing_bullet_2"),
                  AppLocalizations.of(
                    context,
                  ).translate("data_sharing_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("security_practices"),
                icon: Icons.security,
                bullets: [
                  AppLocalizations.of(context).translate("security_bullet_1"),
                  AppLocalizations.of(context).translate("security_bullet_2"),
                  AppLocalizations.of(context).translate("security_bullet_3"),
                  AppLocalizations.of(context).translate("security_bullet_4"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(context).translate("access_rights"),
                icon: Icons.key,
                bullets: [
                  AppLocalizations.of(context).translate("access_bullet_1"),
                  AppLocalizations.of(context).translate("access_bullet_2"),
                  AppLocalizations.of(context).translate("access_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("retention_deletion"),
                icon: Icons.folder_outlined,
                bullets: [
                  AppLocalizations.of(context).translate("retention_bullet_1"),
                  AppLocalizations.of(context).translate("retention_bullet_2"),
                  AppLocalizations.of(context).translate("retention_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("authentication_account_safety"),
                icon: Icons.lock_outline,
                bullets: [
                  AppLocalizations.of(context).translate("auth_bullet_1"),
                  AppLocalizations.of(context).translate("auth_bullet_2"),
                  AppLocalizations.of(context).translate("auth_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("telehealth_privacy"),
                icon: Icons.video_call,
                bullets: [
                  AppLocalizations.of(context).translate("telehealth_bullet_1"),
                  AppLocalizations.of(context).translate("telehealth_bullet_2"),
                  AppLocalizations.of(context).translate("telehealth_bullet_3"),
                ],
              ),
              const SizedBox(height: 12),

              _sectionCard(
                title: AppLocalizations.of(
                  context,
                ).translate("incidents_legal_requests"),
                icon: Icons.report_gmailerrorred_outlined,
                bullets: [
                  AppLocalizations.of(context).translate("incidents_bullet_1"),
                  AppLocalizations.of(context).translate("incidents_bullet_2"),
                  AppLocalizations.of(context).translate("incidents_bullet_3"),
                ],
              ),

              const SizedBox(height: 20),
              _disclaimer(),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
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
                  onPressed: () {
                    // TODO: Persist privacy preferences if needed
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(
                  context,
                ).translate("acknowledge_privacy_policy"),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header card
  Widget _headerCard() {
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
          Icon(Icons.lock, color: accentColor, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  ).translate("privacy_security_policy"),
                  style: AppTextStyle.textStyleBoldBlack,
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context).translate("privacy_description"),
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quick actions row
  Widget _quickActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: borderColor),
              foregroundColor: accentColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.download_outlined),
            label: Text(
              AppLocalizations.of(context).translate("download_data"),
            ),
            onPressed: () {
              _confirmAction(
                context,
                title: AppLocalizations.of(
                  context,
                ).translate("request_data_export"),
                message: AppLocalizations.of(
                  context,
                ).translate("data_export_message"),
                onConfirm: () => _showSnack(
                  context,
                  AppLocalizations.of(
                    context,
                  ).translate("data_export_submitted"),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: borderColor),
              foregroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.delete_forever),
            label: Text(
              AppLocalizations.of(context).translate("delete_account"),
            ),
            onPressed: () {
              _confirmAction(
                context,
                title: AppLocalizations.of(
                  context,
                ).translate("delete_account_title"),
                message: AppLocalizations.of(
                  context,
                ).translate("delete_account_message"),
                onConfirm: () => _showSnack(
                  context,
                  AppLocalizations.of(
                    context,
                  ).translate("deletion_request_submitted"),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: borderColor),
              foregroundColor: accentColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.devices_other),
            label: Text(
              AppLocalizations.of(context).translate("manage_sessions"),
            ),
            onPressed: () {
              _showSnack(
                context,
                AppLocalizations.of(
                  context,
                ).translate("session_management_coming_soon"),
              );
            },
          ),
        ),
      ],
    );
  }

  // Preferences card with switches
  Widget _preferencesCard() {
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
              Icon(Icons.tune, color: accentColor),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).translate("privacy_preferences"),
                style: AppTextStyle.textStyleBoldBlack,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _switchTile(
            title: AppLocalizations.of(
              context,
            ).translate("appointment_reminders"),
            subtitle: AppLocalizations.of(
              context,
            ).translate("appointment_reminders_subtitle"),
            value: remindersOptIn,
            onChanged: (v) => setState(() => remindersOptIn = v),
          ),
          _switchTile(
            title: AppLocalizations.of(
              context,
            ).translate("marketing_communications"),
            subtitle: AppLocalizations.of(
              context,
            ).translate("marketing_communications_subtitle"),
            value: marketingOptIn,
            onChanged: (v) => setState(() => marketingOptIn = v),
          ),
          _switchTile(
            title: AppLocalizations.of(
              context,
            ).translate("analytics_improvements"),
            subtitle: AppLocalizations.of(
              context,
            ).translate("analytics_improvements_subtitle"),
            value: analyticsOptIn,
            onChanged: (v) => setState(() => analyticsOptIn = v),
          ),
          _switchTile(
            title: AppLocalizations.of(
              context,
            ).translate("telehealth_recording_consent"),
            subtitle: AppLocalizations.of(
              context,
            ).translate("telehealth_recording_consent_subtitle"),
            value: telehealthRecordingConsent,
            onChanged: (v) => setState(() => telehealthRecordingConsent = v),
          ),
        ],
      ),
    );
  }

  // Generic section card
  Widget _sectionCard({
    required String title,
    required IconData icon,
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
              Icon(icon, color: accentColor),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyle.textStyleBoldBlack),
            ],
          ),
          const SizedBox(height: 10),
          ...bullets.map((b) => _bulletItem(b)).toList(),
        ],
      ),
    );
  }

  // Bullet item
  Widget _bulletItem(String text) {
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

  // Switch tile
  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: value,
        onChanged: onChanged,
        activeColor: accentColor,
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }

  // Disclaimer
  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        AppLocalizations.of(context).translate("disclaimer"),
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: accentColor),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context).translate("cancel")),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: accentColor),
            child: Text(AppLocalizations.of(context).translate("confirm")),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
