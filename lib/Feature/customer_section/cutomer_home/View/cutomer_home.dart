// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
// import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/book_service_view.dart';
// import 'package:store_mangment/Feature/customer_section/cutomer_home/cubit/customer_home_cubit.dart';
// import 'package:store_mangment/Feature/customer_section/cutomer_home/cubit/customer_home_state.dart';
// import 'package:store_mangment/Feature/notification/view/notification_view.dart';
// import 'package:store_mangment/Feature/resources/colors/colors.dart';

// class CustomerHomeView extends StatelessWidget {
//   const CustomerHomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => CustomerHomeCubit()..initialize(),
//       child: const _CustomerHomeBody(),
//     );
//   }
// }

// class _CustomerHomeBody extends StatefulWidget {
//   const _CustomerHomeBody();

//   @override
//   State<_CustomerHomeBody> createState() => _CustomerHomeBodyState();
// }

// class _CustomerHomeBodyState extends State<_CustomerHomeBody> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<CustomerHomeCubit, CustomerHomeState>(
//       listenWhen: (prev, curr) => prev.lastAction != curr.lastAction,
//       listener: (context, state) {
//         if (state.lastAction.status == ActionStatus.success &&
//             state.lastAction.message != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(
//                     Icons.check_circle_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       state.lastAction.message!,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//               backgroundColor: const Color(0xFF4CAF50),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               margin: const EdgeInsets.all(16),
//               elevation: 8,
//             ),
//           );
//         } else if (state.lastAction.status == ActionStatus.failure &&
//             state.lastAction.message != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(
//                     Icons.error_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       state.lastAction.message!,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//               backgroundColor: const Color(0xFFE53E3E),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               margin: const EdgeInsets.all(16),
//               elevation: 8,
//             ),
//           );
//         }
//       },
//       child: BlocBuilder<CustomerHomeCubit, CustomerHomeState>(
//         builder: (context, state) {
//           if (state.isLoadingUser && state.products.isEmpty) {
//             return Scaffold(
//               body: _ModernBackground(
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(24),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF4CAF50).withOpacity(0.15),
//                               blurRadius: 24,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: const CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Color(0xFF4CAF50),
//                           ),
//                           strokeWidth: 3,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Loading your pet care services...',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF666666),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }

//           return Scaffold(
//             backgroundColor: Colors.transparent,
//             body: _ModernBackground(
//               child: SafeArea(
//                 child: RefreshIndicator(
//                   onRefresh: () async {
//                     context.read<CustomerHomeCubit>().initialize();
//                   },
//                   color: const Color(0xFF4CAF50),
//                   child: CustomScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     slivers: [
//                       // Professional Header
//                       SliverToBoxAdapter(
//                         child: _ProfessionalHeader(
//                           name: state.name,
//                           imageUrl: state.imageUrl,
//                         ),
//                       ),

//                       // Search Bar
//                       SliverToBoxAdapter(
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: _SearchBar(
//                             controller: _searchController,
//                             onChanged: (value) {
//                               setState(() {
//                                 _searchQuery = value.toLowerCase();
//                               });
//                             },
//                           ),
//                         ),
//                       ),

//                       // Categories
//                       SliverToBoxAdapter(
//                         child: Column(
//                           children: [
//                             _buildSectionHeader(
//                               'Categories',
//                               state.categories.length,
//                             ),
//                             const SizedBox(height: 16),
//                             _CategoriesListView(
//                               isLoading: state.isLoadingCategories,
//                               categories: _filterCategories(state.categories),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Services
//                       SliverToBoxAdapter(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 32),
//                             _buildSectionHeader(
//                               'Services',
//                               state.services.length,
//                             ),
//                             const SizedBox(height: 16),
//                             _ServicesListView(
//                               isLoading: state.isLoadingServices,
//                               services: _filterServices(state.services),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Products
//                       SliverToBoxAdapter(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 32),
//                             _buildSectionHeader(
//                               'Products',
//                               state.products.length,
//                             ),
//                             const SizedBox(height: 16),
//                           ],
//                         ),
//                       ),

//                       SliverPadding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         sliver: _ProductsGridView(
//                           isLoading: state.isLoadingProducts,
//                           products: _filterProducts(state.products),
//                         ),
//                       ),

//                       const SliverToBoxAdapter(child: SizedBox(height: 32)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   List<dynamic> _filterCategories(List<dynamic> categories) {
//     if (_searchQuery.isEmpty) return categories;
//     return categories
//         .where(
//           (category) =>
//               category.name.toString().toLowerCase().contains(_searchQuery),
//         )
//         .toList();
//   }

//   List<dynamic> _filterServices(List<dynamic> services) {
//     if (_searchQuery.isEmpty) return services;
//     return services
//         .where(
//           (service) =>
//               service.name.toString().toLowerCase().contains(_searchQuery),
//         )
//         .toList();
//   }

//   List<dynamic> _filterProducts(List<dynamic> products) {
//     if (_searchQuery.isEmpty) return products;
//     return products
//         .where(
//           (product) =>
//               product.name.toString().toLowerCase().contains(_searchQuery) ||
//               product.description.toString().toLowerCase().contains(
//                 _searchQuery,
//               ),
//         )
//         .toList();
//   }

//   Widget _buildSectionHeader(String title, int count) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w900,
//               color: Color(0xFF1A1A1A),
//               letterSpacing: -0.5,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF4CAF50).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: const Color(0xFF4CAF50).withOpacity(0.2),
//               ),
//             ),
//             child: Text(
//               '$count items',
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF4CAF50),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

// // ============ MODERN BACKGROUND ============
// class _ModernBackground extends StatelessWidget {
//   final Widget child;
//   const _ModernBackground({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFF8FFFE), Color(0xFFF0F9F4), Color(0xFFE8F5E8)],
//           stops: [0.0, 0.5, 1.0],
//         ),
//       ),
//       child: Stack(
//         children: [
//           const Positioned.fill(child: _FloatingShapes()),
//           child,
//         ],
//       ),
//     );
//   }
// }

// class _FloatingShapes extends StatelessWidget {
//   const _FloatingShapes();

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(child: CustomPaint(painter: _ShapesPainter()));
//   }
// }

// class _ShapesPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint1 = Paint()
//       ..color = const Color(0xFF4CAF50).withOpacity(0.05)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

//     final paint2 = Paint()
//       ..color = const Color(0xFF81C784).withOpacity(0.08)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

//     // Floating circles
//     canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.15), 60, paint1);
//     canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.3), 80, paint2);
//     canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 70, paint1);
//     canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.8), 50, paint2);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ============ PROFESSIONAL HEADER ============
// class _ProfessionalHeader extends StatelessWidget {
//   final String name;
//   final String imageUrl;

//   const _ProfessionalHeader({required this.name, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Profile Image
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF4CAF50).withOpacity(0.3),
//                   blurRadius: 16,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(3),
//             child: CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white,
//               child: CircleAvatar(
//                 radius: 27,
//                 backgroundImage: NetworkImage(imageUrl),
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),

//           // Welcome Message
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Welcome back,',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     color: Color(0xFF1A1A1A),
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Ready to care for your pet today?',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF666666),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Notification Button
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F5F5),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: IconButton(
//               onPressed: () {
//                 navigateTo(context, NotificationsPage());
//               },
//               icon: const Icon(
//                 Icons.notifications_outlined,
//                 color: Color(0xFF4CAF50),
//                 size: 24,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============ SEARCH BAR ============
// class _SearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;

//   const _SearchBar({required this.controller, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           hintText: 'Search products, services...',
//           hintStyle: TextStyle(
//             color: Colors.grey[500],
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
//           suffixIcon: controller.text.isNotEmpty
//               ? IconButton(
//                   onPressed: () {
//                     controller.clear();
//                     onChanged('');
//                   },
//                   icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
//                 )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 16,
//           ),
//         ),
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF1A1A1A),
//         ),
//       ),
//     );
//   }
// }

// // ============ CATEGORIES ============
// class _CategoriesListView extends StatelessWidget {
//   final bool isLoading;
//   final List<dynamic> categories;

//   const _CategoriesListView({
//     required this.isLoading,
//     required this.categories,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return SizedBox(
//         height: 140,
//         child: ListView.separated(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           scrollDirection: Axis.horizontal,
//           itemCount: 4,
//           separatorBuilder: (_, __) => const SizedBox(width: 16),
//           itemBuilder: (context, index) => Container(),
//         ),
//       );
//     }

//     if (categories.isEmpty) {
//       return const _EmptyState(message: 'No categories found');
//     }

//     return SizedBox(
//       height: 140,
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return _CategoryCard(category: category);
//         },
//       ),
//     );
//   }
// }

// class _CategoryCard extends StatelessWidget {
//   final dynamic category;

//   const _CategoryCard({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: 140,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       category.emoji ?? '🐾',
//                       style: const TextStyle(fontSize: 40),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       category.name,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============ SERVICES ============
// class _ServicesListView extends StatelessWidget {
//   final bool isLoading;
//   final List<dynamic> services;

//   const _ServicesListView({required this.isLoading, required this.services});

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return SizedBox(
//         height: 160,
//         child: ListView.separated(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           scrollDirection: Axis.horizontal,
//           itemCount: 4,
//           separatorBuilder: (_, __) => const SizedBox(width: 16),
//           itemBuilder: (context, index) => Container(),
//         ),
//       );
//     }

//     if (services.isEmpty) {
//       return const _EmptyState(message: 'No services found');
//     }

//     return SizedBox(
//       height: 160,
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         scrollDirection: Axis.horizontal,
//         itemCount: services.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),
//         itemBuilder: (context, index) {
//           final service = services[index];
//           return _ServiceCard(service: service);
//         },
//       ),
//     );
//   }
// }

// class _ServiceCard extends StatelessWidget {
//   final dynamic service;

//   const _ServiceCard({required this.service});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ServiceBookingScreen(service: service),
//           ),
//         );
//       },
//       child: Container(
//         width: 150,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//                       image: DecorationImage(
//                         image: NetworkImage(service.imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF4CAF50),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         'IQD ${service.price?.toInt() ?? 0}',
//                         style: const TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       service.name,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } // ============ PRODUCTS GRID ============

// class _ProductsGridView extends StatelessWidget {
//   final bool isLoading;
//   final List<dynamic> products;

//   const _ProductsGridView({required this.isLoading, required this.products});

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return SliverGrid(
//         delegate: SliverChildBuilderDelegate(
//           (context, index) => Container(),
//           childCount: 6,
//         ),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 0.75,
//         ),
//       );
//     }

//     if (products.isEmpty) {
//       return const SliverToBoxAdapter(
//         child: _EmptyState(message: 'No products found'),
//       );
//     }

//     return SliverGrid(
//       delegate: SliverChildBuilderDelegate((context, index) {
//         final product = products[index];
//         return _ProductCard(product: product);
//       }, childCount: products.length),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.75,
//       ),
//     );
//   }
// }

// class _ProductCard extends StatelessWidget {
//   final dynamic product;

//   const _ProductCard({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.read<CartCubit>().addToCart(
//           id: product.id,
//           name: product.name,
//           image: product.imageUrl,
//           description: product.description ?? '',
//           price: product.price ?? 0,
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${product.name} added to cart'),
//             backgroundColor: const Color(0xFF4CAF50),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 3,
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//                       image: DecorationImage(
//                         image: NetworkImage(product.imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF4CAF50),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF4CAF50).withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         'IQD ${product.price?.toInt() ?? 0}',
//                         style: const TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Product Details
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.name,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           // إضافة المنتج للسلة عند الضغط على الزر
//                           context.read<CartCubit>().addToCart(
//                             id: product.id,
//                             name: product.name,
//                             image: product.imageUrl,
//                             description: product.description ?? '',
//                             price: product.price ?? 0,
//                           );

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('${product.name} added to cart'),
//                               backgroundColor: const Color(0xFF4CAF50),
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               margin: const EdgeInsets.all(16),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.add_shopping_cart, size: 16),
//                         label: const Text(
//                           'Add to Cart',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4CAF50),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============ EMPTY STATE ============
// class _EmptyState extends StatelessWidget {
//   final String message;

//   const _EmptyState({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_mangment/Core/Helper/naviagtion_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_service_view.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/cubit/customer_home_cubit.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/cubit/customer_home_state.dart';
import 'package:store_mangment/Feature/customer_section/product_datails/details_view.dart';
import 'package:store_mangment/Feature/notification/view/notification_view.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/scanner/qr_scanner_screen.dart';

class CustomerHomeView extends StatelessWidget {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerHomeCubit()..initialize(),
      child: const _CustomerHomeBody(),
    );
  }
}

class _CustomerHomeBody extends StatefulWidget {
  const _CustomerHomeBody();

  @override
  State<_CustomerHomeBody> createState() => _CustomerHomeBodyState();
}

class _CustomerHomeBodyState extends State<_CustomerHomeBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerHomeCubit, CustomerHomeState>(
      listenWhen: (prev, curr) => prev.lastAction != curr.lastAction,
      listener: (context, state) {
        if (state.lastAction.status == ActionStatus.success &&
            state.lastAction.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.lastAction.message!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              elevation: 8,
            ),
          );
        } else if (state.lastAction.status == ActionStatus.failure &&
            state.lastAction.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.lastAction.message!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFE53E3E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              elevation: 8,
            ),
          );
        }
      },
      child: BlocBuilder<CustomerHomeCubit, CustomerHomeState>(
        builder: (context, state) {
          if (state.isLoadingUser && state.products.isEmpty) {
            return Scaffold(
              body: _ModernBackground(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).translate('loading_pet_care_services'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: _ModernBackground(
              child: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CustomerHomeCubit>().initialize();
                  },
                  color: const Color(0xFF4CAF50),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Professional Header
                      SliverToBoxAdapter(
                        child: _ProfessionalHeader(
                          name: state.name,
                          imageUrl: state.imageUrl,
                        ),
                      ),

                      // Search Bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: _SearchBar(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ),

                      // Categories
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            _buildSectionHeader(
                              AppLocalizations.of(
                                context,
                              ).translate('categories'),
                              state.categories.length,
                            ),
                            const SizedBox(height: 16),
                            _CategoriesListView(
                              isLoading: state.isLoadingCategories,
                              categories: _filterCategories(state.categories),
                            ),
                          ],
                        ),
                      ),

                      // Services
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            _buildSectionHeader(
                              AppLocalizations.of(
                                context,
                              ).translate('services'),
                              state.services.length,
                            ),
                            const SizedBox(height: 16),
                            _ServicesListView(
                              isLoading: state.isLoadingServices,
                              services: _filterServices(state.services),
                            ),
                          ],
                        ),
                      ),

                      // Products
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            _buildSectionHeader(
                              AppLocalizations.of(
                                context,
                              ).translate('products'),
                              state.products.length,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: _ProductsGridView(
                          isLoading: state.isLoadingProducts,
                          products: _filterProducts(state.products),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _filterCategories(List<dynamic> categories) {
    if (_searchQuery.isEmpty) return categories;
    return categories
        .where(
          (category) =>
              category.name.toString().toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  List<dynamic> _filterServices(List<dynamic> services) {
    if (_searchQuery.isEmpty) return services;
    return services
        .where(
          (service) =>
              service.name.toString().toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  List<dynamic> _filterProducts(List<dynamic> products) {
    if (_searchQuery.isEmpty) return products;
    return products
        .where(
          (product) =>
              product.name.toString().toLowerCase().contains(_searchQuery) ||
              product.description.toString().toLowerCase().contains(
                _searchQuery,
              ),
        )
        .toList();
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.2),
              ),
            ),
            child: Text(
              '$count ${AppLocalizations.of(context).translate('items_count')}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ============ MODERN BACKGROUND ============
class _ModernBackground extends StatelessWidget {
  final Widget child;
  const _ModernBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FFFE), Color(0xFFF0F9F4), Color(0xFFE8F5E8)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _FloatingShapes()),
          child,
        ],
      ),
    );
  }
}

class _FloatingShapes extends StatelessWidget {
  const _FloatingShapes();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _ShapesPainter()));
  }
}

class _ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final paint2 = Paint()
      ..color = const Color(0xFF81C784).withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // Floating circles
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.15), 60, paint1);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.3), 80, paint2);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 70, paint1);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.8), 50, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============ PROFESSIONAL HEADER ============
class _ProfessionalHeader extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _ProfessionalHeader({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Welcome Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate('welcome_back'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).translate('ready_to_care'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),

          // Notification Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {
                navigateTo(context, NotificationsPage());
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(
            context,
          ).translate('search_products_services'),
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر مسح النص
              if (controller.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                tooltip: AppLocalizations.of(context).translate('scan_qr_code'),
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

// // ============ SEARCH BAR ============
// class _SearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;

//   const _SearchBar({required this.controller, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           hintText: AppLocalizations.of(
//             context,
//           ).translate('search_products_services'),
//           hintStyle: TextStyle(
//             color: Colors.grey[500],
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
//           suffixIcon: controller.text.isNotEmpty
//               ? IconButton(
//                   onPressed: () {
//                     controller.clear();
//                     onChanged('');
//                   },
//                   icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
//                 )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 16,
//           ),
//         ),
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF1A1A1A),
//         ),
//       ),
//     );
//   }
// }

// ============ CATEGORIES ============
class _CategoriesListView extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> categories;

  const _CategoriesListView({
    required this.isLoading,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 140,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) => Container(),
        ),
      );
    }

    if (categories.isEmpty) {
      return _EmptyState(
        message: AppLocalizations.of(context).translate('no_categories_found'),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(category: category);
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.emoji ?? '🐾',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ SERVICES ============
class _ServicesListView extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> services;

  const _ServicesListView({required this.isLoading, required this.services});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 160,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) => Container(),
        ),
      );
    }

    if (services.isEmpty) {
      return _EmptyState(
        message: AppLocalizations.of(context).translate('no_services_found'),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final service = services[index];
          return _ServiceCard(service: service);
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final dynamic service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceBookingScreen(service: service),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(service.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'IQD ${service.price?.toInt() ?? 0}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ PRODUCTS GRID ============
class _ProductsGridView extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> products;

  const _ProductsGridView({required this.isLoading, required this.products});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Container(),
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
      );
    }

    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: _EmptyState(
          message: AppLocalizations.of(context).translate('no_products_found'),
        ),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = products[index];
        return _ProductCard(product: product);
      }, childCount: products.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // الانتقال إلى صفحة تفاصيل المنتج
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsView(
              imageUrl: product.imageUrl,
              name: product.name,
              price: product.price?.toInt().toString() ?? '0',
              description: product.description ?? '',
              productId: product.id, // إضافة معرف المنتج
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'IQD ${product.price?.toInt() ?? 0}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // إضافة المنتج للسلة مباشرة من البطاقة
                          context.read<CartCubit>().addToCart(
                            id: product.id,
                            name: product.name,
                            image: product.imageUrl,
                            description: product.description ?? '',
                            price: product.price ?? 0,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} ${AppLocalizations.of(context).translate('added_to_cart')}',
                              ),
                              backgroundColor: const Color(0xFF4CAF50),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: Text(
                          AppLocalizations.of(context).translate('add_to_cart'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ EMPTY STATE ============
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
