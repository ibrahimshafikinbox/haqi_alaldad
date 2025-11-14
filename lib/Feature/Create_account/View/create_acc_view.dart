// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
// import 'package:store_mangment/Core/Widget/app_form_field.dart';
// import 'package:store_mangment/Feature/Create_account/cubit/create_account_cubit.dart';
// import 'package:store_mangment/Feature/Create_account/cubit/create_account_state.dart';
// import 'package:store_mangment/Feature/Login/View/login_view.dart';
// import 'package:store_mangment/Feature/resources/colors/colors.dart';
// import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

// class CreateAccountView extends StatefulWidget {
//   const CreateAccountView({super.key});

//   @override
//   State<CreateAccountView> createState() => _CreateAccountViewState();
// }

// class _CreateAccountViewState extends State<CreateAccountView>
//     with TickerProviderStateMixin {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController clinicNameController = TextEditingController();

//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//         );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     firstNameController.dispose();
//     emailController.dispose();
//     locationController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     clinicNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => CreateAccountCubit(),
//       child: Scaffold(
//         // الخلفية الأصلية لن تظهر لأننا أضفنا طبقة Gradient فوقها، لكن لا مشكلة لو بقيت
//         backgroundColor: Colors.grey[50],
//         body: BlocListener<CreateAccountCubit, CreateAccountState>(
//           listener: (context, state) {
//             if (state is CreateAccountSuccess) {
//               _showSuccessDialog(context);
//             } else if (state is CreateAccountFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text(
//                     "Something went wrong. Please check your details.",
//                   ),
//                   backgroundColor: Colors.red[400],
//                   duration: const Duration(seconds: 3),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             }
//           },
//           child: SafeArea(
//             child: GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: Stack(
//                 children: [
//                   // نفس الخلفية المتدرجة المستخدمة في شاشة تسجيل الدخول
//                   Positioned.fill(
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFFFFFFFF), Color(0xFFF4FFF7)],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // دوائر زخرفية خفيفة
//                   Positioned(
//                     top: -40,
//                     right: -30,
//                     child: Container(
//                       width: 140,
//                       height: 140,
//                       decoration: BoxDecoration(
//                         color: AppColors.green.withOpacity(0.08),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: -50,
//                     left: -30,
//                     child: Container(
//                       width: 180,
//                       height: 180,
//                       decoration: BoxDecoration(
//                         color: AppColors.dark_green.withOpacity(0.06),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),

//                   // المحتوى الأصلي كما هو (بدون تغيير منطق)
//                   SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SlideTransition(
//                         position: _slideAnimation,
//                         child: ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Logo Section
//                                 _buildLogoSection(),
//                                 const SizedBox(height: 28),

//                                 // Header Section
//                                 _buildHeaderSection(),
//                                 const SizedBox(height: 32),

//                                 // Form Fields Section
//                                 _buildFormFieldsCard(),
//                                 const SizedBox(height: 32),

//                                 // Create Account Button
//                                 _buildCreateAccountButton(),
//                                 const SizedBox(height: 18),

//                                 // Login Link
//                                 _buildLoginLink(),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoSection() {
//     return Center(child: Image.asset("assets/img/logo.png", height: 220));
//   }

//   Widget _buildHeaderSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Create Your Account",
//           style: AppTextStyle.textStyleBoldBlack.copyWith(
//             fontSize: 28,
//             color: AppColors.dark_green,
//             fontWeight: FontWeight.w700,
//             height: 1.2,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           "Join Dr. Haqi Al-Addadh Veterinary Clinic and start managing your pet's health easily.",
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//             height: 1.6,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFormFieldsCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(22),
//         child: Column(
//           children: [
//             // Full Name Field
//             _buildFormFieldSection(
//               label: "Full Name",
//               icon: Icons.person_outline,
//               child: DefaultFormField(
//                 controller: firstNameController,
//                 type: TextInputType.text,
//                 hint: 'Enter your full name',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your full name';
//                   }
//                   return null;
//                 },
//                 label: '',
//                 maxlines: 1,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Clinic or Pet Name Field
//             _buildFormFieldSection(
//               label: "Clinic or Pet Name",
//               icon: Icons.store_outlined,
//               child: DefaultFormField(
//                 maxlines: 1,
//                 controller: clinicNameController,
//                 type: TextInputType.text,
//                 hint: 'e.g., Bella Vet Clinic or Max',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a clinic or pet name';
//                   }
//                   return null;
//                 },
//                 label: '',
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Email Field
//             _buildFormFieldSection(
//               label: "Email Address",
//               icon: Icons.email_outlined,
//               child: DefaultFormField(
//                 maxlines: 1,
//                 controller: emailController,
//                 type: TextInputType.emailAddress,
//                 hint: 'you@example.com',
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email address';
//                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//                 label: '',
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Password Field
//             _buildFormFieldSection(
//               label: "Password",
//               icon: Icons.lock_outline,
//               child: DefaultFormField(
//                 maxlines: 1,
//                 controller: passwordController,
//                 type: TextInputType.visiblePassword,
//                 hint: 'Enter a secure password',
//                 isPassword: true,
//                 onValidate: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a password';
//                   } else if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//                 label: '',
//               ),
//             ),

//             // Password Tips
//             const SizedBox(height: 16),
//             _buildPasswordTips(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFormFieldSection({
//     required String label,
//     required IconData icon,
//     required Widget child,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 18, color: AppColors.green),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.black,
//               ),
//             ),
//             const Spacer(),
//             Container(
//               width: 5,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.red[400],
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         child,
//       ],
//     );
//   }

//   Widget _buildPasswordTips() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.blue[200]!, width: 1),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.info_outline, size: 18, color: Colors.blue[700]),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               'Use at least 6 characters with a mix of letters and numbers',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.blue[700],
//                 height: 1.4,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreateAccountButton() {
//     return BlocBuilder<CreateAccountCubit, CreateAccountState>(
//       builder: (context, state) {
//         final isLoading = state is CreateAccountLoading;

//         return SizedBox(
//           width: double.infinity,
//           height: 56,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.green,
//               foregroundColor: Colors.white,
//               elevation: isLoading ? 0 : 4,
//               disabledBackgroundColor: AppColors.green.withOpacity(0.6),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             onPressed: isLoading
//                 ? null
//                 : () {
//                     if (_formKey.currentState!.validate()) {
//                       context.read<CreateAccountCubit>().createAccount(
//                         firstName: firstNameController.text.trim(),
//                         email: emailController.text.trim(),
//                         password: passwordController.text,
//                         location: locationController.text,
//                         businessName: clinicNameController.text.trim(),
//                         profileImage:
//                             "https://img.freepik.com/premium-vector/3d-simple-user-icon-isolated_169241-7120.jpg",
//                         secondName: '',
//                       );
//                     }
//                   },
//             child: isLoading
//                 ? SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Colors.white.withOpacity(0.8),
//                       ),
//                       strokeWidth: 2.5,
//                     ),
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.person_add_outlined, size: 18),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Create Account',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLoginLink() {
//     return Center(
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: "Already have an account? ",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             TextSpan(
//               text: "Login here",
//               style: AppTextStyle.textStyleBoldBlack.copyWith(
//                 color: AppColors.dark_green,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   navigateTo(context, const LoginView());
//                 },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.green.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.check_circle,
//                     color: AppColors.green,
//                     size: 60,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Account Created Successfully!",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Welcome to Dr. Haqi Al-Addadh Clinic 🐾",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                     height: 1.5,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 28),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () {
//                       navigateAndFinish(dialogContext, const LoginView());
//                     },
//                     child: const Text(
//                       'Go to Login',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Widget/app_form_field.dart';
import 'package:store_mangment/Feature/Create_account/cubit/create_account_cubit.dart';
import 'package:store_mangment/Feature/Create_account/cubit/create_account_state.dart';
import 'package:store_mangment/Feature/Login/View/login_view.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController clinicNameController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    clinicNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => CreateAccountCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocListener<CreateAccountCubit, CreateAccountState>(
          listener: (context, state) {
            if (state is CreateAccountSuccess) {
              _showSuccessDialog(context);
            } else if (state is CreateAccountFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    localizations.translate('something_went_wrong'),
                  ),
                  backgroundColor: Colors.red[400],
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: [
                  // Background gradient
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFF4FFF7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -40,
                    right: -30,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.dark_green.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Main content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo Section
                                _buildLogoSection(),
                                const SizedBox(height: 28),

                                // Header Section
                                _buildHeaderSection(),
                                const SizedBox(height: 32),

                                // Form Fields Section
                                _buildFormFieldsCard(),
                                const SizedBox(height: 32),

                                // Create Account Button
                                _buildCreateAccountButton(),
                                const SizedBox(height: 18),

                                // Login Link
                                _buildLoginLink(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(child: Image.asset("assets/img/logo.png", height: 220));
  }

  Widget _buildHeaderSection() {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('create_your_account'),
          style: AppTextStyle.textStyleBoldBlack.copyWith(
            fontSize: 28,
            color: AppColors.dark_green,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          localizations.translate('create_account_subtitle'),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFieldsCard() {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // Full Name Field
            _buildFormFieldSection(
              label: localizations.translate('full_name'),
              icon: Icons.person_outline,
              child: DefaultFormField(
                controller: firstNameController,
                type: TextInputType.text,
                hint: localizations.translate('enter_full_name'),
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('please_enter_full_name');
                  }
                  return null;
                },
                label: '',
                maxlines: 1,
              ),
            ),
            const SizedBox(height: 20),

            // Clinic or Pet Name Field
            _buildFormFieldSection(
              label: localizations.translate('clinic_or_pet_name'),
              icon: Icons.store_outlined,
              child: DefaultFormField(
                maxlines: 1,
                controller: clinicNameController,
                type: TextInputType.text,
                hint: localizations.translate('clinic_pet_hint'),
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('please_enter_clinic_pet');
                  }
                  return null;
                },
                label: '',
              ),
            ),
            const SizedBox(height: 20),

            // Email Field
            _buildFormFieldSection(
              label: localizations.translate('email_address'),
              icon: Icons.email_outlined,
              child: DefaultFormField(
                maxlines: 1,
                controller: emailController,
                type: TextInputType.emailAddress,
                hint: localizations.translate('email_hint'),
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate(
                      'please_enter_email_address',
                    );
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return localizations.translate(
                      'please_enter_valid_email_address',
                    );
                  }
                  return null;
                },
                label: '',
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            _buildFormFieldSection(
              label: localizations.translate('password'),
              icon: Icons.lock_outline,
              child: DefaultFormField(
                maxlines: 1,
                controller: passwordController,
                type: TextInputType.visiblePassword,
                hint: localizations.translate('enter_secure_password'),
                isPassword: true,
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('please_enter_password');
                  } else if (value.length < 6) {
                    return localizations.translate('password_length_error');
                  }
                  return null;
                },
                label: '',
              ),
            ),

            // Password Tips
            const SizedBox(height: 16),
            _buildPasswordTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFieldSection({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.green),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const Spacer(),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.red[400],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildPasswordTips() {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.blue[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              localizations.translate('password_tip'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<CreateAccountCubit, CreateAccountState>(
      builder: (context, state) {
        final isLoading = state is CreateAccountLoading;

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              elevation: isLoading ? 0 : 4,
              disabledBackgroundColor: AppColors.green.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<CreateAccountCubit>().createAccount(
                        firstName: firstNameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        location: locationController.text,
                        businessName: clinicNameController.text.trim(),
                        profileImage:
                            "https://img.freepik.com/premium-vector/3d-simple-user-icon-isolated_169241-7120.jpg",
                        secondName: '',
                      );
                    }
                  },
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
                      const Icon(Icons.person_add_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        localizations.translate('create_account'),
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
      },
    );
  }

  Widget _buildLoginLink() {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: localizations.translate('already_have_account'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: localizations.translate('login_here'),
              style: AppTextStyle.textStyleBoldBlack.copyWith(
                color: AppColors.dark_green,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  navigateTo(context, const LoginView());
                },
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.translate('account_created_success'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.translate('welcome_message'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      navigateAndFinish(dialogContext, const LoginView());
                    },
                    child: Text(
                      localizations.translate('go_to_login'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
