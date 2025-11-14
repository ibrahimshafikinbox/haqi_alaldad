// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
// import 'package:store_mangment/Core/Widget/app_button.dart';
// import 'package:store_mangment/Core/Widget/app_form_field.dart';
// import 'package:store_mangment/Feature/Login/View/login_view.dart';
// import 'package:store_mangment/Feature/resources/colors/colors.dart';
// import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
// import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

// class ForgotPassView extends StatefulWidget {
//   const ForgotPassView({super.key});

//   @override
//   State<ForgotPassView> createState() => _ForgotPassViewState();
// }

// class _ForgotPassViewState extends State<ForgotPassView>
//     with TickerProviderStateMixin {
//   final TextEditingController emailController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLoading = false;
//   bool isEmailSent = false;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }

//   Future<void> resetPassword() async {
//     final String email = emailController.text.trim();

//     // Validate email
//     if (email.isEmpty) {
//       Fluttertoast.showToast(msg: 'Please enter your email.');
//       return;
//     }
//     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
//       Fluttertoast.showToast(msg: 'Please enter a valid email.');
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       setState(() {
//         isLoading = false;
//         isEmailSent = true;
//       });

//       Fluttertoast.showToast(
//         timeInSecForIosWeb: 5,
//         toastLength: Toast.LENGTH_LONG,
//         msg: 'Password reset link sent! Check your email.',
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );

//       // Auto-navigate after delay
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted) {
//           navigateAndFinish(context, const LoginView());
//         }
//       });
//     } on FirebaseAuthException catch (e) {
//       setState(() => isLoading = false);
//       Fluttertoast.showToast(
//         msg: e.message ?? 'An error occurred. Please try again.',
//         backgroundColor: Colors.redAccent,
//         textColor: Colors.white,
//       );
//     }
//   }

//   void _resetForm() {
//     setState(() {
//       isEmailSent = false;
//       emailController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Reset Password',
//           style: AppTextStyle.textStyleBoldBlack,
//         ),
//         centerTitle: true,
//       ),
//       body: isEmailSent ? _buildSuccessView() : _buildResetView(),
//     );
//   }

//   // Main reset view
//   Widget _buildResetView() {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Illustration/Icon section
//               _buildIllustrationSection(),
//               AppSizedBox.sizedH30,

//               // Header section
//               _buildHeaderSection(),
//               AppSizedBox.sizedH40,

//               // Form section
//               _buildFormSection(),
//               AppSizedBox.sizedH30,

//               // Info box
//               _buildInfoBox(),
//               AppSizedBox.sizedH30,

//               // Reset button
//               _buildResetButton(),
//               AppSizedBox.sizedH20,

//               // Back to login link
//               _buildBackToLoginLink(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIllustrationSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.green.withOpacity(0.15),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Icon(Icons.mail_outline, size: 60, color: AppColors.green),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Column(
//       children: [
//         Text(
//           'Forgot Your Password?',
//           style: AppTextStyle.textStyleBoldBlack.copyWith(
//             fontSize: 26,
//             height: 1.3,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         AppSizedBox.sizedH10,
//         Text(
//           'No worries! Enter your email address and we\'ll send you a link to reset your password.',
//           style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.6),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildFormSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey[200]!, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Email Address',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: AppColors.black,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: emailController,
//             keyboardType: TextInputType.emailAddress,
//             enabled: !isLoading,
//             decoration: InputDecoration(
//               hintText: 'Enter your email address',
//               hintStyle: TextStyle(color: Colors.grey[400]),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: Icon(
//                   Icons.email_outlined,
//                   color: AppColors.green,
//                   size: 20,
//                 ),
//               ),
//               prefixIconConstraints: const BoxConstraints(
//                 minWidth: 0,
//                 minHeight: 0,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 14,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.green, width: 2),
//               ),
//               disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey[200]!),
//               ),
//             ),
//             style: const TextStyle(
//               fontSize: 14,
//               color: AppColors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoBox() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.green.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.green.withOpacity(0.2), width: 1),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.info_outline, color: AppColors.green, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               'Check your email (including spam folder) for the password reset link. The link will expire in 1 hour.',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: AppColors.green,
//                 height: 1.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResetButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.green,
//           foregroundColor: Colors.white,
//           elevation: isLoading ? 0 : 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: isLoading ? null : resetPassword,
//         child: isLoading
//             ? SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.white.withOpacity(0.8),
//                   ),
//                   strokeWidth: 2.5,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.send_outlined, size: 18),
//                   SizedBox(width: 8),
//                   Text(
//                     'Send Reset Link',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildBackToLoginLink() {
//     return TextButton(
//       onPressed: isLoading
//           ? null
//           : () => navigateAndFinish(context, const LoginView()),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.dark_green),
//           const SizedBox(width: 6),
//           Text(
//             'Back to Sign In',
//             style: AppTextStyle.textStyleBoldBlack.copyWith(
//               color: AppColors.dark_green,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Success view
//   Widget _buildSuccessView() {
//     return Center(
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Success animation
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: AppColors.green.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.green.withOpacity(0.2),
//                       blurRadius: 30,
//                       offset: const Offset(0, 15),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.check_circle,
//                   size: 80,
//                   color: AppColors.green,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // Success text
//               Text(
//                 'Check Your Email!',
//                 style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 24),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'We\'ve sent a password reset link to${emailController.text}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                   height: 1.6,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),

//               // Info box
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.amber[50],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.amber[200]!, width: 1),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.info_outline,
//                       color: Colors.amber[700],
//                       size: 20,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Next steps:',
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.amber[900],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '• Click the link in your email • Create a new password • Log in with your new password',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.amber[800],
//                               height: 1.6,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // Send again button
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: _resetForm,
//                   child: const Text(
//                     'Send Another Link',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Back button
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: AppColors.green, width: 1.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () =>
//                       navigateAndFinish(context, const LoginView()),
//                   child: const Text(
//                     'Back to Sign In',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.green,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart'
    show AppLocalizations;
import 'package:store_mangment/Core/Widget/app_button.dart';
import 'package:store_mangment/Core/Widget/app_form_field.dart';
import 'package:store_mangment/Feature/Login/View/login_view.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class ForgotPassView extends StatefulWidget {
  const ForgotPassView({super.key});

  @override
  State<ForgotPassView> createState() => _ForgotPassViewState();
}

class _ForgotPassViewState extends State<ForgotPassView>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isEmailSent = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final localizations = AppLocalizations.of(context)!;
    final String email = emailController.text.trim();

    // Validate email
    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: localizations.translate('please_enter_email'),
      );
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      Fluttertoast.showToast(
        msg: localizations.translate('please_enter_valid_email'),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        isLoading = false;
        isEmailSent = true;
      });

      Fluttertoast.showToast(
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_LONG,
        msg: localizations.translate('password_reset_link_sent'),
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Auto-navigate after delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          navigateAndFinish(context, const LoginView());
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(
        msg: e.message ?? localizations.translate('error_occurred'),
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  void _resetForm() {
    setState(() {
      isEmailSent = false;
      emailController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.translate('reset_password'),
          style: AppTextStyle.textStyleBoldBlack,
        ),
        centerTitle: true,
      ),
      body: isEmailSent ? _buildSuccessView() : _buildResetView(),
    );
  }

  // Main reset view
  Widget _buildResetView() {
    final localizations = AppLocalizations.of(context)!;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration/Icon section
              _buildIllustrationSection(),
              AppSizedBox.sizedH30,

              // Header section
              _buildHeaderSection(),
              AppSizedBox.sizedH40,

              // Form section
              _buildFormSection(),
              AppSizedBox.sizedH30,

              // Info box
              _buildInfoBox(),
              AppSizedBox.sizedH30,

              // Reset button
              _buildResetButton(),
              AppSizedBox.sizedH20,

              // Back to login link
              _buildBackToLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(Icons.mail_outline, size: 60, color: AppColors.green),
    );
  }

  Widget _buildHeaderSection() {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(
          localizations.translate('forgot_password_title'),
          style: AppTextStyle.textStyleBoldBlack.copyWith(
            fontSize: 26,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        AppSizedBox.sizedH10,
        Text(
          localizations.translate('forgot_password_subtitle'),
          style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.translate('email_address'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
            decoration: InputDecoration(
              hintText: localizations.translate('enter_email'),
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.email_outlined,
                  color: AppColors.green,
                  size: 20,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.green, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizations.translate('check_email_info'),
              style: TextStyle(
                fontSize: 13,
                color: AppColors.green,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          elevation: isLoading ? 0 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : resetPassword,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    localizations.translate('send_reset_link'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    final localizations = AppLocalizations.of(context)!;

    return TextButton(
      onPressed: isLoading
          ? null
          : () => navigateAndFinish(context, const LoginView()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.dark_green),
          const SizedBox(width: 6),
          Text(
            localizations.translate('back_to_sign_in'),
            style: AppTextStyle.textStyleBoldBlack.copyWith(
              color: AppColors.dark_green,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Success view
  Widget _buildSuccessView() {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 30),

              // Success text
              Text(
                localizations.translate('check_your_email'),
                style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${localizations.translate('reset_link_sent_to')}${emailController.text}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber[700],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.translate('next_steps'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.translate('next_steps_details'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber[800],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Send again button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _resetForm,
                  child: Text(
                    localizations.translate('send_another_link'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Back button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.green, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () =>
                      navigateAndFinish(context, const LoginView()),
                  child: Text(
                    localizations.translate('back_to_sign_in'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
