// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:store_mangment/Feature/admin_booking/view/booking_detail_view.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
// import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
// import '../cubit/admin_bookings_cubit.dart';
// import '../cubit/admin_bookings_state.dart';

// class AdminBookingsScreen extends StatelessWidget {
//   const AdminBookingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => AdminBookingsCubit(
//         bookingRepository: BookingRepository(),
//         notificationsRepository: NotificationsRepository(),
//       )..listenAllBookings(),
//       child: const _AdminBookingsView(),
//     );
//   }
// }

// class _AdminBookingsView extends StatefulWidget {
//   const _AdminBookingsView();

//   @override
//   State<_AdminBookingsView> createState() => _AdminBookingsViewState();
// }

// class _AdminBookingsViewState extends State<_AdminBookingsView> {
//   final _searchController = TextEditingController();
//   String _statusFilter = 'all';

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String v, BuildContext context) {
//     context.read<AdminBookingsCubit>().applyQuery(v);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Column(
//         children: [
//           _buildCustomHeader(),
//           _buildSearchBar(context),
//           _buildStatusChips(context),
//           Expanded(
//             child: BlocConsumer<AdminBookingsCubit, AdminBookingsState>(
//               listener: (context, state) {
//                 if (state is AdminBookingsError) {
//                   Fluttertoast.showToast(
//                     msg: state.message,
//                     backgroundColor: Colors.red,
//                   );
//                 } else if (state is AdminBookingUpdated) {
//                   Fluttertoast.showToast(
//                     msg: state.message,
//                     backgroundColor: Colors.green,
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 if (state is AdminBookingsLoading ||
//                     state is AdminBookingsInitial) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is AdminBookingsError) {
//                   return Center(child: Text(state.message));
//                 }
//                 if (state is AdminBookingsLoaded) {
//                   final items = state.filtered;
//                   if (items.isEmpty) {
//                     return const Center(child: Text('No bookings found.'));
//                   }
//                   return ListView.separated(
//                     padding: const EdgeInsets.all(12),
//                     itemBuilder: (context, index) {
//                       final b = items[index];
//                       return _BookingTile(
//                         booking: b,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   BookingDetailsScreen(bookingId: b.id!),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemCount: items.length,
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomHeader() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade600, Colors.blue.shade800],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade400.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Booking Management',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'View & manage all bookings',
//                           style: TextStyle(color: Colors.white70, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (v) => _onSearchChanged(v, context),
//         decoration: InputDecoration(
//           hintText: 'Search by name, phone, service...',
//           prefixIcon: const Icon(Icons.search, color: Colors.grey),
//           suffixIcon: _searchController.text.isNotEmpty
//               ? IconButton(
//                   icon: const Icon(Icons.clear),
//                   onPressed: () {
//                     _searchController.clear();
//                     _onSearchChanged('', context);
//                   },
//                 )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: Colors.grey, width: 1),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChips(BuildContext context) {
//     final options = ['all', 'pending', 'approved', 'declined', 'cancelled'];
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: options.map((s) {
//             final selected = _statusFilter == s;
//             return Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: FilterChip(
//                 label: Text(
//                   s.capitalize(),
//                   style: TextStyle(
//                     color: selected ? Colors.white : Colors.grey.shade700,
//                     fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//                 selected: selected,
//                 onSelected: (val) {
//                   if (!val) return;
//                   setState(() => _statusFilter = s);
//                   context.read<AdminBookingsCubit>().applyStatusFilter(s);
//                 },
//                 backgroundColor: Colors.white,
//                 selectedColor: Colors.blue.shade600,
//                 side: BorderSide(
//                   color: selected ? Colors.blue.shade600 : Colors.grey.shade300,
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

// class _BookingTile extends StatelessWidget {
//   final BookingModel booking;
//   final VoidCallback onTap;
//   const _BookingTile({required this.booking, required this.onTap});

//   Color _statusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Colors.green;
//       case 'declined':
//         return Colors.red;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.grey;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _statusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Icons.check_circle;
//       case 'declined':
//         return Icons.cancel;
//       case 'pending':
//         return Icons.schedule;
//       case 'cancelled':
//         return Icons.block;
//       default:
//         return Icons.info;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateStr =
//         '${booking.bookingDate.year}-${booking.bookingDate.month.toString().padLeft(2, '0')}-${booking.bookingDate.day.toString().padLeft(2, '0')} ${booking.bookingTime}';

//     return Card(
//       elevation: 2,
//       shadowColor: Colors.blue.withOpacity(0.2),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.event,
//                       color: Colors.blue.shade600,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           booking.serviceName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           booking.customerName,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade600,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _statusColor(booking.status).withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: _statusColor(booking.status).withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           _statusIcon(booking.status),
//                           color: _statusColor(booking.status),
//                           size: 14,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           booking.status.capitalize(),
//                           style: TextStyle(
//                             color: _statusColor(booking.status),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Icon(Icons.phone, size: 14, color: Colors.grey.shade500),
//                   const SizedBox(width: 6),
//                   Text(
//                     booking.customerPhone,
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                   const SizedBox(width: 16),
//                   Icon(
//                     Icons.calendar_month,
//                     size: 14,
//                     color: Colors.grey.shade500,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     dateStr,
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/admin_booking/view/booking_detail_view.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
import '../cubit/admin_bookings_cubit.dart';
import '../cubit/admin_bookings_state.dart';

class AdminBookingsScreen extends StatelessWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBookingsCubit(
        bookingRepository: BookingRepository(),
        notificationsRepository: NotificationsRepository(),
      )..listenAllBookings(),
      child: const _AdminBookingsView(),
    );
  }
}

class _AdminBookingsView extends StatefulWidget {
  const _AdminBookingsView();

  @override
  State<_AdminBookingsView> createState() => _AdminBookingsViewState();
}

class _AdminBookingsViewState extends State<_AdminBookingsView> {
  final _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v, BuildContext context) {
    context.read<AdminBookingsCubit>().applyQuery(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildCustomHeader(),
          _buildSearchBar(context),
          _buildStatusChips(context),
          Expanded(
            child: BlocConsumer<AdminBookingsCubit, AdminBookingsState>(
              listener: (context, state) {
                if (state is AdminBookingsError) {
                  Fluttertoast.showToast(
                    msg: state.message,
                    backgroundColor: Colors.red,
                  );
                } else if (state is AdminBookingUpdated) {
                  Fluttertoast.showToast(
                    msg: state.message,
                    backgroundColor: Colors.green,
                  );
                }
              },
              builder: (context, state) {
                if (state is AdminBookingsLoading ||
                    state is AdminBookingsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminBookingsError) {
                  return Center(child: Text(state.message));
                }
                if (state is AdminBookingsLoaded) {
                  final items = state.filtered;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).translate('no_bookings_found'),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final b = items[index];
                      return _BookingTile(
                        booking: b,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookingDetailsScreen(bookingId: b.id!),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: items.length,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade400.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('booking_management'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('view_manage_bookings'),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => _onSearchChanged(v, context),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(
            context,
          ).translate('search_placeholder'),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('', context);
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChips(BuildContext context) {
    final options = ['all', 'pending', 'approved', 'declined', 'cancelled'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((s) {
            final selected = _statusFilter == s;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  AppLocalizations.of(context).translate('status_$s'),
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade700,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: selected,
                onSelected: (val) {
                  if (!val) return;
                  setState(() => _statusFilter = s);
                  context.read<AdminBookingsCubit>().applyStatusFilter(s);
                },
                backgroundColor: Colors.white,
                selectedColor: Colors.blue.shade600,
                side: BorderSide(
                  color: selected ? Colors.blue.shade600 : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  const _BookingTile({required this.booking, required this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      case 'pending':
        return Icons.schedule;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${booking.bookingDate.year}-${booking.bookingDate.month.toString().padLeft(2, '0')}-${booking.bookingDate.day.toString().padLeft(2, '0')} ${booking.bookingTime}';

    return Card(
      elevation: 2,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.event,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          booking.customerName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(booking.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _statusColor(booking.status).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _statusIcon(booking.status),
                          color: _statusColor(booking.status),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.status.capitalize(),
                          style: TextStyle(
                            color: _statusColor(booking.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    booking.customerPhone,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_month,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
