import 'package:flutter/material.dart';
import 'package:store_mangment/Core/Helper/cache_helper.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Localizations/laocalizations_const.dart';
import 'package:store_mangment/Core/Localizations/lng.dart';
import 'package:store_mangment/Core/Widget/confirmation_dialog.dart';
import 'package:store_mangment/Feature/Change_password/change_password_view.dart';
import 'package:store_mangment/Feature/Login/View/login_view.dart';
import 'package:store_mangment/Feature/Login/cubit/login_cubit.dart';
import 'package:store_mangment/Feature/contact_us/contact_us_view.dart';
import 'package:store_mangment/Feature/static_pages/privacy.dart';
import 'package:store_mangment/Feature/static_pages/terms.dart';
import 'package:store_mangment/Feature/settings/cubit/setting_cubit.dart';
import 'package:store_mangment/Feature/settings/cubit/setting_state.dart';
import 'package:store_mangment/Feature/settings/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/main.dart' show MyApp;

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..getUserData(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context).translate("settings"),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).translate("loading"),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is SettingsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is SettingsLoaded) {
              final data = state.userData;
              final name =
                  data['firstName'] ??
                  AppLocalizations.of(context).translate("unknown_user");
              final email =
                  data['email'] ??
                  AppLocalizations.of(context).translate("no_email");
              final imageUrl = data["profileImage"];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Header Card
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[400]!, Colors.teal[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Avatar with Border
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 55,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage(
                                          'assets/images/default_avatar.png',
                                        )
                                        as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // User Name
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // User Email
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: Colors.white.withOpacity(0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Edit Profile Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                navigateTo(context, const EditProfileView());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.edit_outlined, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate("edit_profile"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Account Settings Section
                    _buildSectionTitle(
                      context,
                      AppLocalizations.of(
                        context,
                      ).translate("account_settings"),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsOption(
                      context,
                      AppLocalizations.of(context).translate("edit_profile"),
                      Icons.person_outline,
                      Colors.blue,
                      () {
                        navigateTo(context, const EditProfileView());
                      },
                    ),
                    _buildSettingsOption(
                      context,
                      AppLocalizations.of(context).translate("change_password"),
                      Icons.lock_outline,
                      Colors.orange,
                      () {
                        navigateTo(context, ForgotPassView());
                      },
                    ),
                    _buildSettingsOption(
                      context,
                      AppLocalizations.of(
                        context,
                      ).translate("terms_and_conditions"),
                      Icons.description_outlined,
                      Colors.purple,
                      () {
                        navigateTo(context, TermsAndConditionsScreen());
                      },
                    ),
                    const SizedBox(height: 28),

                    // App Settings Section (NEW)
                    _buildSectionTitle(
                      context,
                      AppLocalizations.of(context).translate("app_settings"),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsOption(
                      context,
                      AppLocalizations.of(context).translate("change_lang"),
                      Icons.language,
                      Colors.indigo,
                      () {
                        _showLanguageDialog(context);
                      },
                    ),
                    const SizedBox(height: 28),

                    // Security Section
                    _buildSectionTitle(
                      context,
                      AppLocalizations.of(context).translate("security"),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsOption(
                      context,
                      AppLocalizations.of(
                        context,
                      ).translate("security_and_privacy"),
                      Icons.security,
                      Colors.green,
                      () {
                        navigateTo(context, PrivacyAndSecurityScreen());
                      },
                    ),
                    _buildSettingsOption(
                      context,
                      AppLocalizations.of(context).translate("contact_us"),
                      Icons.call,
                      Colors.blue,
                      () {
                        navigateTo(context, ContactUsPage());
                      },
                    ),
                    const SizedBox(height: 28),

                    // Logout Button
                    _buildLogoutButton(context),
                    const SizedBox(height: 28),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[400]!, Colors.red[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: AppLocalizations.of(
                  context,
                ).translate("logout_confirmation"),
                content: AppLocalizations.of(
                  context,
                ).translate("logout_confirmation_message"),
                onConfirm: () {
                  LoginCubit.get(context).logoutUser().then((value) {
                    if (CachePrfHelper.getUid() == null) {
                      print(
                        "user logout and uid is : ${CachePrfHelper.getUid()}",
                      );
                      navigateAndFinish(context, const LoginView());
                    }
                  });
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).translate("logout"),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌍 NEW: Language Change Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.indigo[50]!, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.language,
                        color: Colors.indigo,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).translate("change_lang"),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Language Options
                ...Language.languageList().map((language) {
                  return _buildLanguageOption(
                    context: context,
                    dialogContext: dialogContext,
                    language: language,
                  );
                }).toList(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required BuildContext dialogContext,
    required Language language,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            Locale locale = await setLocale(language.languageCode);
            MyApp.setLocale(context, locale);
            Navigator.pop(dialogContext);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      '${AppLocalizations.of(context).translate("language_changed")} ${language.name}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Flag
                Text(language.flag, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                // Language Name
                Expanded(
                  child: Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Check Icon (if current language)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
