import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Core/Helper/cache_helper.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Widget/app_button.dart';
import 'package:store_mangment/Core/Widget/app_form_field.dart';
import 'package:store_mangment/Feature/Change_password/change_password_view.dart';
import 'package:store_mangment/Feature/Create_account/View/create_acc_view.dart';
import 'package:store_mangment/Feature/Login/cubit/login_cubit.dart';
import 'package:store_mangment/Feature/Login/cubit/login_state.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';
import 'package:store_mangment/main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isRegisterMode = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    String? uid = CachePrfHelper.getUid();
    debugPrint("🐾 UID: $uid");
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Fluttertoast.showToast(
                msg: localizations.translate('welcome_toast'),
                backgroundColor: AppColors.green,
              );
              navigateAndFinish(
                context,
                RoleBasedScreen(uid: CachePrfHelper.getUid()),
              );
            } else if (state is LoginError) {
              Fluttertoast.showToast(
                msg: localizations.translate('check_credentials'),
                backgroundColor: AppColors.red,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: [
                    // Soft gradient background
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFF4FFF7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Subtle decorative circles
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

                    // Content
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            children: [
                              // Logo and title section
                              Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Image.asset(
                                    "assets/img/logo.png",
                                    height: 250,
                                  ),
                                  AppSizedBox.sizedH10,
                                  Text(
                                    localizations.translate(
                                      'welcome_to_clinic',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.textStyleBoldBlack
                                        .copyWith(
                                          fontSize: 20,
                                          color: AppColors.dark_green,
                                        ),
                                  ),
                                  AppSizedBox.sizedH5,
                                  Text(
                                    localizations.translate(
                                      'compassionate_care',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.textStyleMediumGray,
                                  ),
                                ],
                              ),

                              AppSizedBox.sizedH20,

                              // Card with form
                              Card(
                                elevation: 8,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 22,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          localizations.translate('email'),
                                          style:
                                              AppTextStyle.textStyleBoldBlack,
                                        ),
                                        AppSizedBox.sizedH5,
                                        DefaultFormField(
                                          controller: emailController,
                                          type: TextInputType.emailAddress,
                                          hint: localizations.translate(
                                            'email_hint',
                                          ),
                                          onValidate: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return localizations.translate(
                                                'please_enter_email',
                                              );
                                            } else if (!RegExp(
                                              r'^[^@]+@[^@]+\.[^@]+',
                                            ).hasMatch(value)) {
                                              return localizations.translate(
                                                'please_enter_valid_email_address',
                                              );
                                            }
                                            return null;
                                          },
                                          label: '',
                                          maxlines: 1,
                                        ),
                                        AppSizedBox.sizedH15,
                                        Text(
                                          localizations.translate('password'),
                                          style:
                                              AppTextStyle.textStyleBoldBlack,
                                        ),
                                        AppSizedBox.sizedH5,
                                        passwordFormField(
                                          controller: passwordController,
                                          type: TextInputType.visiblePassword,
                                          label: "",
                                          hint: localizations.translate(
                                            'password_hint',
                                          ),
                                          suffix: LoginCubit.get(
                                            context,
                                          ).suffix,
                                          isPassword: LoginCubit.get(
                                            context,
                                          ).isPassword,
                                          prefix: Icons.lock_outline,
                                          suffixPressed: () {
                                            LoginCubit.get(
                                              context,
                                            ).changePasswordVisibility();
                                          },
                                          onValidate: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return localizations.translate(
                                                'please_enter_password',
                                              );
                                            }
                                            return null;
                                          },
                                        ),
                                        AppSizedBox.sizedH20,
                                        ConditionalBuilder(
                                          condition: state is! LoginLoading,
                                          builder: (context) => DefaultButton(
                                            function: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<LoginCubit>()
                                                    .loginUser(
                                                      email:
                                                          emailController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    );
                                              }
                                            },
                                            text: isRegisterMode
                                                ? localizations.translate(
                                                    'register',
                                                  )
                                                : localizations.translate(
                                                    'login',
                                                  ),
                                            textColor: AppColors.white,
                                            bottonColor: AppColors.green,
                                          ),
                                          fallback: (context) => const Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                        AppSizedBox.sizedH10,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: Text(
                                                localizations.translate('or'),
                                                style: AppTextStyle
                                                    .textStyleMediumGray
                                                    .copyWith(fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppSizedBox.sizedH10,
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              navigateTo(
                                                context,
                                                const ForgotPassView(),
                                              );
                                            },
                                            child: Text(
                                              localizations.translate(
                                                'forgot_your_password',
                                              ),
                                              style: AppTextStyle
                                                  .textStyleMediumGray,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              navigateAndFinish(
                                                context,
                                                const CreateAccountView(),
                                              );
                                            },
                                            child: Text(
                                              localizations.translate(
                                                'create_new_account',
                                              ),
                                              style: AppTextStyle
                                                  .textStyleMediumGray
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Footer
                              Text(
                                localizations.translate('footer_text'),
                                textAlign: TextAlign.center,
                                style: AppTextStyle.textStyleMediumGray,
                              ),

                              // Extra bottom padding to avoid being too tight on small screens
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
