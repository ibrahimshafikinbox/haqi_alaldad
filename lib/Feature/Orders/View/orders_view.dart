// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:store_mangment/Feature/Orders/View/add_order_view.dart';
// import 'package:store_mangment/Feature/Orders/cubit/order_cubit.dart';
// import 'package:store_mangment/Feature/Orders/cubit/order_state.dart';
// import 'package:store_mangment/Feature/resources/colors/colors.dart';
// import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

// class OrdersView extends StatefulWidget {
//   const OrdersView({super.key});

//   @override
//   State<OrdersView> createState() => _OrdersViewState();
// }

// class _OrdersViewState extends State<OrdersView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   String _searchQuery = '';
//   String _selectedFilter = 'All';

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     )..forward();
//     context.read<OrderCubit>().subscribeToOrders();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   List<dynamic> _filterOrders(List<dynamic> orders) {
//     var filtered = orders;

//     // Filter by status
//     if (_selectedFilter != 'All') {
//       filtered = filtered
//           .where((o) => o.serviceStatus == _selectedFilter)
//           .toList();
//     }

//     // Filter by search query
//     if (_searchQuery.isNotEmpty) {
//       filtered = filtered
//           .where(
//             (o) =>
//                 o.petName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                 o.petOwner.toLowerCase().contains(_searchQuery.toLowerCase()),
//           )
//           .toList();
//     }

//     return filtered;
//   }

//   int _getCompletedCount(List<dynamic> orders) {
//     return orders.where((o) => o.serviceStatus == 'Completed').length;
//   }

//   int _getPendingCount(List<dynamic> orders) {
//     return orders.where((o) => o.serviceStatus == 'Pending').length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Orders", style: AppTextStyle.textStyleBoldBlack20),
//         backgroundColor: const Color(0xFFF8F9FA),
//       ),

//       backgroundColor: const Color(0xFFF8F9FA),
//       body: BlocBuilder<OrderCubit, OrderState>(
//         builder: (context, state) {
//           return CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       TextField(
//                         onChanged: (value) {
//                           setState(() => _searchQuery = value);
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Search by pet name or owner...',
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 14,
//                           ),
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: Colors.grey.shade400,
//                           ),
//                           suffixIcon: _searchQuery.isNotEmpty
//                               ? GestureDetector(
//                                   onTap: () {
//                                     setState(() => _searchQuery = '');
//                                   },
//                                   child: Icon(
//                                     Icons.clear,
//                                     color: Colors.grey.shade400,
//                                   ),
//                                 )
//                               : null,
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide(
//                               color: AppColors.dark_green,
//                               width: 2,
//                             ),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 14,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       // Filter Chips
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             _FilterChip(
//                               label: 'All',
//                               isSelected: _selectedFilter == 'All',
//                               onTap: () {
//                                 setState(() => _selectedFilter = 'All');
//                               },
//                             ),
//                             _FilterChip(
//                               label: 'Pending',
//                               isSelected: _selectedFilter == 'Pending',
//                               onTap: () {
//                                 setState(() => _selectedFilter = 'Pending');
//                               },
//                             ),
//                             _FilterChip(
//                               label: 'In Progress',
//                               isSelected: _selectedFilter == 'In Progress',
//                               onTap: () {
//                                 setState(() => _selectedFilter = 'In Progress');
//                               },
//                             ),
//                             _FilterChip(
//                               label: 'Completed',
//                               isSelected: _selectedFilter == 'Completed',
//                               onTap: () {
//                                 setState(() => _selectedFilter = 'Completed');
//                               },
//                             ),
//                             _FilterChip(
//                               label: 'Cancelled',
//                               isSelected: _selectedFilter == 'Cancelled',
//                               onTap: () {
//                                 setState(() => _selectedFilter = 'Cancelled');
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Orders List
//               if (state is OrdersLoading)
//                 SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation(Colors.green),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Loading orders...',
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               else if (state is OrdersError)
//                 SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.error_outline,
//                           size: 64,
//                           color: Colors.red.shade300,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Error loading orders',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           state.message,
//                           style: TextStyle(
//                             color: Colors.grey.shade500,
//                             fontSize: 14,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               else if (state is OrdersLoaded)
//                 if (_filterOrders(state.orders).isEmpty)
//                   SliverFillRemaining(
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.inbox_outlined,
//                             size: 80,
//                             color: Colors.grey.shade300,
//                           ),
//                           const SizedBox(height: 24),
//                           Text(
//                             _searchQuery.isEmpty
//                                 ? 'No orders yet'
//                                 : 'No orders found',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             _searchQuery.isEmpty
//                                 ? 'Create your first clinical order'
//                                 : 'Try adjusting your search',
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else
//                   SliverPadding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     sliver: SliverList(
//                       delegate: SliverChildBuilderDelegate((context, index) {
//                         final orders = _filterOrders(state.orders);
//                         final order = orders[index];
//                         return FadeTransition(
//                           opacity: Tween<double>(begin: 0, end: 1).animate(
//                             CurvedAnimation(
//                               parent: _animationController,
//                               curve: Interval(
//                                 (index * 0.1).clamp(0.0, 1.0),
//                                 1.0,
//                               ),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: _OrderCard(
//                               order: order,
//                               onDelete: () => _confirmDelete(context, order.id),
//                             ),
//                           ),
//                         );
//                       }, childCount: _filterOrders(state.orders).length),
//                     ),
//                   ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColors.white,
//         onPressed: () => Navigator.of(
//           context,
//         ).push(MaterialPageRoute(builder: (_) => const AddOrderView())),
//         icon: const Icon(Icons.add_rounded),
//         label: const Text('New Order'),
//         elevation: 2,
//       ),
//     );
//   }

//   void _confirmDelete(BuildContext ctx, String id) {
//     showDialog(
//       context: ctx,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete Order?'),
//         content: const Text(
//           'This order will be permanently deleted and cannot be recovered.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               ctx.read<OrderCubit>().deleteOrder(id);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Order deleted successfully'),
//                   backgroundColor: Colors.green.shade600,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             },
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String count;
//   final String label;
//   final IconData icon;
//   final Color color;

//   const _StatCard({
//     required this.count,
//     required this.label,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             count,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w900,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _FilterChip({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             gradient: isSelected
//                 ? LinearGradient(
//                     colors: [
//                       AppColors.dark_green,
//                       AppColors.dark_green.withOpacity(0.8),
//                     ],
//                   )
//                 : null,
//             color: isSelected ? null : Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             border: isSelected ? null : Border.all(color: Colors.grey.shade300),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: AppColors.dark_green.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: isSelected ? Colors.white : Colors.grey.shade700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _OrderCard extends StatefulWidget {
//   final dynamic order;
//   final VoidCallback onDelete;

//   const _OrderCard({required this.order, required this.onDelete});

//   @override
//   State<_OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<_OrderCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orderType = widget.order.orderType == 'vet' ? 'Vet' : 'Market';
//     final orderTypeColor = widget.order.orderType == 'vet'
//         ? Colors.blue
//         : Colors.orange;
//     final statusColor = _getStatusColor(widget.order.serviceStatus);
//     final paymentColor = _getPaymentColor(widget.order.paymentStatus);

//     return GestureDetector(
//       onTap: () {
//         setState(() => _isExpanded = !_isExpanded);
//         if (_isExpanded) {
//           _controller.forward();
//         } else {
//           _controller.reverse();
//         }
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(_isExpanded ? 0.15 : 0.08),
//               blurRadius: _isExpanded ? 16 : 8,
//               offset: Offset(0, _isExpanded ? 8 : 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               orderTypeColor.withOpacity(0.8),
//                               orderTypeColor,
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           widget.order.orderType == 'vet'
//                               ? Icons.local_hospital
//                               : Icons.store,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.order.petName,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${widget.order.serviceType} • $orderType Order',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey.shade600,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       RotationTransition(
//                         turns: Tween<double>(
//                           begin: 0,
//                           end: 0.5,
//                         ).animate(_controller),
//                         child: Icon(
//                           Icons.expand_more,
//                           color: Colors.grey.shade400,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Owner',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey.shade500,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               widget.order.petOwner,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Charge',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey.shade500,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${widget.order.serviceCharge.toStringAsFixed(2)} IQD',
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _StatusBadge(
//                           label: 'Service',
//                           value: widget.order.serviceStatus,
//                           color: statusColor,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: _StatusBadge(
//                           label: 'Payment',
//                           value: widget.order.paymentStatus,
//                           color: paymentColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (_isExpanded) ...[
//               Divider(color: Colors.grey.shade200),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _DetailRow('Pet Type', widget.order.petType),
//                     const SizedBox(height: 12),
//                     _DetailRow('Service Type', widget.order.serviceType),
//                     const SizedBox(height: 12),
//                     _DetailRow(
//                       'Created',
//                       DateFormat(
//                         'MMM dd, yyyy • HH:mm',
//                       ).format(widget.order.createdAt),
//                     ),
//                     if (widget.order.convertedFromMarket) ...[
//                       const SizedBox(height: 12),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.green.shade200),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.check_circle,
//                               color: Colors.green.shade600,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Converted from market order',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.green.shade700,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: widget.onDelete,
//                             icon: const Icon(Icons.delete_outline),
//                             label: const Text('Delete'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.red,
//                               side: const BorderSide(color: Colors.red),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'in progress':
//         return Colors.blue;
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   Color _getPaymentColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'paid':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'partially paid':
//         return Colors.amber;
//       case 'unpaid':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// class _StatusBadge extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const _StatusBadge({
//     required this.label,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             color: Colors.grey.shade500,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   final String label;
//   final String value;

//   const _DetailRow(this.label, this.value);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/Orders/View/add_order_view.dart';
import 'package:store_mangment/Feature/Orders/cubit/order_cubit.dart';
import 'package:store_mangment/Feature/Orders/cubit/order_state.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    context.read<OrderCubit>().subscribeToOrders();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<dynamic> _filterOrders(List<dynamic> orders) {
    var filtered = orders;

    // Filter by status
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((o) => o.serviceStatus == _selectedFilter)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (o) =>
                o.petName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                o.petOwner.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }

  int _getCompletedCount(List<dynamic> orders) {
    return orders.where((o) => o.serviceStatus == 'Completed').length;
  }

  int _getPendingCount(List<dynamic> orders) {
    return orders.where((o) => o.serviceStatus == 'Pending').length;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.translate('orders'),
          style: AppTextStyle.textStyleBoldBlack20,
        ),
        backgroundColor: const Color(0xFFF8F9FA),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Search Field
                      TextField(
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                        decoration: InputDecoration(
                          hintText: loc.translate('search_by_pet_owner'),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() => _searchQuery = '');
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.dark_green,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: loc.translate('all'),
                              isSelected: _selectedFilter == 'All',
                              onTap: () {
                                setState(() => _selectedFilter = 'All');
                              },
                            ),
                            _FilterChip(
                              label: loc.translate('pending'),
                              isSelected: _selectedFilter == 'Pending',
                              onTap: () {
                                setState(() => _selectedFilter = 'Pending');
                              },
                            ),
                            _FilterChip(
                              label: loc.translate('in_progress'),
                              isSelected: _selectedFilter == 'In Progress',
                              onTap: () {
                                setState(() => _selectedFilter = 'In Progress');
                              },
                            ),
                            _FilterChip(
                              label: loc.translate('completed'),
                              isSelected: _selectedFilter == 'Completed',
                              onTap: () {
                                setState(() => _selectedFilter = 'Completed');
                              },
                            ),
                            _FilterChip(
                              label: loc.translate('cancelled'),
                              isSelected: _selectedFilter == 'Cancelled',
                              onTap: () {
                                setState(() => _selectedFilter = 'Cancelled');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Orders List
              if (state is OrdersLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.green),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.translate('loading_orders'),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is OrdersError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.translate('error_loading_orders'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is OrdersLoaded)
                if (_filterOrders(state.orders).isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _searchQuery.isEmpty
                                ? loc.translate('no_orders_yet')
                                : loc.translate('no_orders_found'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isEmpty
                                ? loc.translate('create_first_order')
                                : loc.translate('try_adjusting_search'),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final orders = _filterOrders(state.orders);
                        final order = orders[index];
                        return FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                (index * 0.1).clamp(0.0, 1.0),
                                1.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OrderCard(
                              order: order,
                              onDelete: () => _confirmDelete(context, order.id),
                            ),
                          ),
                        );
                      }, childCount: _filterOrders(state.orders).length),
                    ),
                  ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.white,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddOrderView())),
        icon: const Icon(Icons.add_rounded),
        label: Text(loc.translate('new_order')),
        elevation: 2,
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, String id) {
    final loc = AppLocalizations.of(ctx);

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(loc.translate('delete_order')),
        content: Text(loc.translate('delete_order_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ctx.read<OrderCubit>().deleteOrder(id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.translate('order_deleted_successfully')),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text(
              loc.translate('delete'),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.dark_green,
                      AppColors.dark_green.withOpacity(0.8),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.dark_green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final dynamic order;
  final VoidCallback onDelete;

  const _OrderCard({required this.order, required this.onDelete});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final orderType = widget.order.orderType == 'vet'
        ? loc.translate('vet')
        : loc.translate('market');
    final orderTypeColor = widget.order.orderType == 'vet'
        ? Colors.blue
        : Colors.orange;
    final statusColor = _getStatusColor(widget.order.serviceStatus);
    final paymentColor = _getPaymentColor(widget.order.paymentStatus);

    return GestureDetector(
      onTap: () {
        setState(() => _isExpanded = !_isExpanded);
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isExpanded ? 0.15 : 0.08),
              blurRadius: _isExpanded ? 16 : 8,
              offset: Offset(0, _isExpanded ? 8 : 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              orderTypeColor.withOpacity(0.8),
                              orderTypeColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.order.orderType == 'vet'
                              ? Icons.local_hospital
                              : Icons.store,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.petName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.order.serviceType} • $orderType ${loc.translate('orders').toLowerCase()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RotationTransition(
                        turns: Tween<double>(
                          begin: 0,
                          end: 0.5,
                        ).animate(_controller),
                        child: Icon(
                          Icons.expand_more,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate('owner'),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.order.petOwner,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate('charge'),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.order.serviceCharge.toStringAsFixed(2)} ${loc.translate('iqd')}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusBadge(
                          label: loc.translate('service'),
                          value: _translateStatus(
                            widget.order.serviceStatus,
                            loc,
                          ),
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatusBadge(
                          label: loc.translate('payment'),
                          value: _translatePaymentStatus(
                            widget.order.paymentStatus,
                            loc,
                          ),
                          color: paymentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              Divider(color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(loc.translate('pet_type'), widget.order.petType),
                    const SizedBox(height: 12),
                    _DetailRow(
                      loc.translate('service_type'),
                      widget.order.serviceType,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      loc.translate('created'),
                      DateFormat().format(widget.order.createdAt),
                    ),
                    if (widget.order.convertedFromMarket) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                loc.translate('converted_from_market'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.onDelete,
                            icon: const Icon(Icons.delete_outline),
                            label: Text(loc.translate('delete')),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _translateStatus(String status, AppLocalizations loc) {
    final key = status.toLowerCase().replaceAll(' ', '_');
    return loc.translate(key);
  }

  String _translatePaymentStatus(String status, AppLocalizations loc) {
    final key = status.toLowerCase().replaceAll(' ', '_');
    return loc.translate(key);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'partially paid':
        return Colors.amber;
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
