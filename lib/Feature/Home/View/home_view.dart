import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/Home/View/CategoryProductsScreen.dart';
import 'package:store_mangment/Feature/Home/cubit/home_cubit.dart';
import 'package:store_mangment/Feature/admin_booking/view/admin_booking_view.dart';
import 'package:store_mangment/Feature/cuppond/admin)cuppon_view.dart';
import 'package:store_mangment/Feature/notification/view/notification_view.dart';
import 'package:store_mangment/Feature/offers/view/admin_offers.dart'
    show AdminOffers;
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';
import 'package:store_mangment/Feature/service/cubit/service_cubut.dart';
import 'package:store_mangment/Feature/service/cubit/services_state.dart';
import 'package:store_mangment/Feature/service/view/add_services_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadData()),
        BlocProvider(create: (_) => VetServicesCubit()..loadVetServices()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.green),
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  '${localizations.translate('error')}: ${state.message}',
                ),
              );
            } else if (state is HomeLoaded) {
              return Stack(
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFFFFF),
                          const Color(0xFFF4FFF7),
                          AppColors.green.withOpacity(0.02),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                    bottom: 200,
                    left: -50,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.dark_green.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Content
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with greeting
                              _buildHeader(context, localizations),
                              AppSizedBox.sizedH20,

                              // Statistics Cards
                              _buildStatisticsSection(state, localizations),
                              AppSizedBox.sizedH30,

                              // Categories Section
                              _buildCategoriesSection(
                                context,
                                state,
                                localizations,
                              ),
                              AppSizedBox.sizedH30,

                              // Our Services Section (Firebase)
                              _buildOurServicesSection(
                                context,
                                state.customerCount,
                                localizations,
                              ),
                              AppSizedBox.sizedH30,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('welcome_back'),
                  style: AppTextStyle.textStyleBoldBlack.copyWith(
                    fontSize: 24,
                    color: AppColors.dark_green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizations.translate('clinic_name'),
                  style: AppTextStyle.textStyleMediumGray.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.green.withOpacity(0.15),
                    AppColors.green.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {
                  navigateTo(context, NotificationsPage());
                },
                child: const Icon(
                  Icons.notifications_none,
                  color: AppColors.green,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(
    HomeLoaded state,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Appointments card with real count + navigation
            Expanded(child: buildAppointmentsCard(context, localizations)),
            const SizedBox(width: 12),
            // Customers (kept from your state)
            Expanded(
              child: _buildStatCard(
                title: localizations.translate('customers'),
                count: state.customerCount.toString(),
                icon: Icons.person,
                color: const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: buildOffersCard(context, localizations)),
            const SizedBox(width: 12),
            // Customers (kept from your state)
            Expanded(child: buildcuppondCard(context, localizations)),
          ],
        ),
      ],
    );
  }

  Widget buildAppointmentsCard(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('service_bookings')
          .snapshots(),
      builder: (context, snapshot) {
        final total = snapshot.hasData ? snapshot.data!.size : 0;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminBookingsScreen(),
              ),
            );
          },
          child: _buildStatCard(
            title: localizations.translate('appointments'),
            count: total.toString(),
            icon: Icons.calendar_today,
            color: const Color(0xFF2196F3),
          ),
        );
      },
    );
  }

  Widget buildOffersCard(BuildContext context, AppLocalizations localizations) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('offers').snapshots(),
      builder: (context, snapshot) {
        final total = snapshot.hasData ? snapshot.data!.size : 0;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminOffers()),
            );
          },
          child: _buildStatCard(
            title: localizations.translate('offers'),
            count: total.toString(),
            icon: Icons.free_breakfast,
            color: Colors.green,
          ),
        );
      },
    );
  }

  Widget buildcuppondCard(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('coupons').snapshots(),
      builder: (context, snapshot) {
        final total = snapshot.hasData ? snapshot.data!.size : 0;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminCouponScreen(),
              ),
            );
          },
          child: _buildStatCard(
            title: localizations.translate('coupons'),
            count: total.toString(),
            icon: Icons.code,
            color: Colors.green,
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyle.textStyleMediumGray.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    HomeLoaded state,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('service_categories'),
          style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 16),
        ),
        AppSizedBox.sizedH10,
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(
                        categoryName: category["name"] ?? "",
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category["emoji"] ?? "❓",
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          category["name"] ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.textStyleBoldBlack.copyWith(
                            fontSize: 12,
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
      ],
    );
  }

  Widget _buildOurServicesSection(
    BuildContext context,
    int customerCount,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('our_premium_services'),
                  style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  localizations.translate('tap_service_to_edit'),
                  style: AppTextStyle.textStyleMediumGray.copyWith(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                navigateTo(context, const AddVetServicePage());

                if (context.mounted) {
                  context.read<VetServicesCubit>().refresh();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.green, AppColors.green.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      localizations.translate('add_service'),
                      style: AppTextStyle.textStyleBoldBlack.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        AppSizedBox.sizedH15,

        // ✅ FIREBASE SERVICES DISPLAY
        BlocBuilder<VetServicesCubit, VetServicesState>(
          builder: (context, state) {
            if (state is VetServicesLoading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.green),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.translate('loading_services'),
                        style: AppTextStyle.textStyleMediumGray.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is VetServicesError) {
              return _buildErrorState(context, state.message, localizations);
            } else if (state is VetServicesLoaded) {
              final services = state.services;

              if (services.isEmpty) {
                return _buildEmptyState(localizations);
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceCardNew(
                    context: context,
                    service: service,
                    localizations: localizations,
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),

        AppSizedBox.sizedH20,
        _buildClinicInfoCard(customerCount, localizations),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    AppLocalizations localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 48),
          const SizedBox(height: 12),
          Text(
            localizations.translate('failed_to_load_services'),
            style: AppTextStyle.textStyleBoldBlack.copyWith(
              fontSize: 14,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.red.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<VetServicesCubit>().loadVetServices();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.refresh),
            label: Text(localizations.translate('retry')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: AppColors.green.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            localizations.translate('no_services_yet'),
            style: AppTextStyle.textStyleBoldBlack.copyWith(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.translate('start_adding_service'),
            style: AppTextStyle.textStyleMediumGray.copyWith(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCardNew({
    required BuildContext context,
    required Map<String, dynamic> service,
    required AppLocalizations localizations,
  }) {
    final imageUrl = service['imageUrl'] as String?;
    final title = service['name'] ?? localizations.translate('unknown_service');
    final description =
        service['description'] ?? localizations.translate('no_description');
    final price = service['price'] ?? 0.0;
    final color = _getColorFromService(service);

    return GestureDetector(
      onTap: () async {
        navigateTo(context, AddVetServicePage(editService: service));

        if (context.mounted) {
          context.read<VetServicesCubit>().refresh();
        }
      },
      onLongPress: () {
        _showServiceDetailBottomSheet(context, service, color, localizations);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image Section
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  color: color.withOpacity(0.1),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder(color, localizations);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          );
                        },
                      ),
                      // Color overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              color.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      // Icon badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.medical_services,
                            color: color,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: _buildImagePlaceholder(color, localizations),
                ),
              ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.textStyleBoldBlack.copyWith(
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),

                  // Price and Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.2),
                              color.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: AppTextStyle.textStyleBoldBlack.copyWith(
                            fontSize: 12,
                            color: color,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color color, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 48,
            color: color.withOpacity(0.4),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.translate('no_image'),
            style: TextStyle(color: color.withOpacity(0.4), fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showServiceDetailBottomSheet(
    BuildContext context,
    Map<String, dynamic> service,
    Color color,
    AppLocalizations localizations,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) =>
          _buildServiceDetailSheet(service, color, localizations),
    );
  }

  Widget _buildServiceDetailSheet(
    Map<String, dynamic> service,
    Color color,
    AppLocalizations localizations,
  ) {
    final title = service['name'] ?? localizations.translate('unknown_service');
    final description =
        service['description'] ?? localizations.translate('no_description');
    final price = service['price'] ?? 0.0;
    final imageUrl = service['imageUrl'] as String?;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Image
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: color.withOpacity(0.1),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder(color, localizations);
                    },
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildImagePlaceholder(color, localizations),
              ),

            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 8),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${localizations.translate('price')}: \$${price.toStringAsFixed(2)}',
                  style: AppTextStyle.textStyleBoldBlack.copyWith(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                localizations.translate('description'),
                style: AppTextStyle.textStyleBoldBlack.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description,
                style: AppTextStyle.textStyleMediumGray.copyWith(
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.close),
                      label: Text(localizations.translate('close')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        navigateTo(
                          context,
                          AddVetServicePage(editService: service),
                        );
                        context.read<VetServicesCubit>().refresh();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.edit),
                      label: Text(localizations.translate('edit')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicInfoCard(
    int customerCount,
    AppLocalizations localizations,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.green.withOpacity(0.15),
            AppColors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.green.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.dark_green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                localizations.translate('clinic_information'),
                style: AppTextStyle.textStyleBoldBlack.copyWith(
                  fontSize: 14,
                  color: AppColors.dark_green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.group_outlined,
            label: localizations.translate('total_customers'),
            value: customerCount.toString(),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            label: localizations.translate('working_hours'),
            value: localizations.translate('working_hours_value'),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.calendar_month_outlined,
            label: localizations.translate('open_days'),
            value: localizations.translate('open_days_value'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.dark_green),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.textStyleMediumGray.copyWith(fontSize: 12),
          ),
        ),
        Text(
          value,
          style: AppTextStyle.textStyleBoldBlack.copyWith(
            fontSize: 12,
            color: AppColors.dark_green,
          ),
        ),
      ],
    );
  }

  // Helper: Map service name to appropriate color
  Color _getColorFromService(Map<String, dynamic> service) {
    final name = (service['name'] ?? '').toString().toLowerCase();

    if (name.contains('emergency') || name.contains('urgent')) {
      return const Color(0xFFE53935);
    } else if (name.contains('dental') || name.contains('teeth')) {
      return const Color(0xFFFFA726);
    } else if (name.contains('surgery') || name.contains('operation')) {
      return const Color(0xFF7C4DFF);
    } else if (name.contains('groom') ||
        name.contains('bath') ||
        name.contains('clean')) {
      return const Color(0xFF26A69A);
    } else if (name.contains('vaccin') || name.contains('immun')) {
      return const Color(0xFF2196F3);
    } else if (name.contains('checkup') || name.contains('general')) {
      return const Color(0xFF4CAF50);
    }

    return const Color(0xFF4CAF50);
  }
}
