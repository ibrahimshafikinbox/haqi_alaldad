// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
// import '../cubit/admin_bookings_cubit.dart';
// import '../cubit/admin_bookings_state.dart';

// class BookingDetailsScreen extends StatefulWidget {
//   final String bookingId;
//   const BookingDetailsScreen({super.key, required this.bookingId});

//   @override
//   State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
// }

// class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
//   BookingModel? _booking;
//   bool _loading = true;
//   final _noteController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadBooking();
//   }

//   Future<void> _loadBooking() async {
//     try {
//       final repo = BookingRepository();
//       final b = await repo.getBookingById(widget.bookingId);
//       setState(() {
//         _booking = b;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       Fluttertoast.showToast(
//         msg: 'Failed to load booking',
//         backgroundColor: Colors.red,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _noteController.dispose();
//     super.dispose();
//   }

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
//     final adminCubit = context.read<AdminBookingsCubit>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _booking == null
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
//                   const SizedBox(height: 16),
//                   const Text('Booking not found'),
//                 ],
//               ),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildCustomHeader(),
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         _buildStatusCard(),
//                         const SizedBox(height: 16),
//                         _buildCustomerSection(),
//                         const SizedBox(height: 16),
//                         _buildServiceSection(),
//                         const SizedBox(height: 16),
//                         _buildBookingSection(),
//                         const SizedBox(height: 16),
//                         if (_booking!.notes.isNotEmpty) ...[
//                           _buildNotesSection(),
//                           const SizedBox(height: 16),
//                         ],
//                         _buildAdminNoteSection(),
//                         const SizedBox(height: 16),
//                         _buildActionButtons(adminCubit),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
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
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Booking Details',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Complete information & actions',
//                       style: TextStyle(color: Colors.white70, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             _statusColor(_booking!.status).withOpacity(0.1),
//             _statusColor(_booking!.status).withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _statusColor(_booking!.status).withOpacity(0.3),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: _statusColor(_booking!.status).withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               _statusIcon(_booking!.status),
//               color: _statusColor(_booking!.status),
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Current Status',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//                 Text(
//                   _booking!.status.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: _statusColor(_booking!.status),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomerSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.person, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text(
//                   'Customer Information',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildInfoItem(
//               icon: Icons.person_outline,
//               label: 'Name',
//               value: _booking!.customerName,
//             ),
//             const SizedBox(height: 12),
//             _buildInfoItem(
//               icon: Icons.phone,
//               label: 'Phone',
//               value: _booking!.customerPhone,
//             ),
//             const SizedBox(height: 12),
//             _buildInfoItem(
//               icon: Icons.location_on_outlined,
//               label: 'Location',
//               value: _booking!.location,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.shopping_bag, color: Colors.green),
//                 SizedBox(width: 8),
//                 Text(
//                   'Service Information',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildInfoItem(
//               icon: Icons.apartment_outlined,
//               label: 'Service',
//               value: _booking!.serviceName,
//             ),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.attach_money, color: Colors.green.shade600),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Price',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         Text(
//                           '\$${_booking!.servicePrice.toStringAsFixed(2)}',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBookingSection() {
//     final dateStr =
//         '${_booking!.bookingDate.year}-${_booking!.bookingDate.month.toString().padLeft(2, '0')}-${_booking!.bookingDate.day.toString().padLeft(2, '0')}';

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.orange),
//                 SizedBox(width: 8),
//                 Text(
//                   'Booking Details',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildInfoItem(
//                     icon: Icons.calendar_month_outlined,
//                     label: 'Date',
//                     value: dateStr,
//                     isCompact: true,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildInfoItem(
//                     icon: Icons.access_time,
//                     label: 'Time',
//                     value: _booking!.bookingTime,
//                     isCompact: true,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNotesSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.amber.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.amber.shade200),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.note, color: Colors.amber.shade600),
//               const SizedBox(width: 8),
//               const Text(
//                 'Customer Notes',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             _booking!.notes,
//             style: const TextStyle(fontSize: 13, height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdminNoteSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.edit_note, color: Colors.indigo),
//               const SizedBox(width: 8),
//               const Text(
//                 'Admin Note (Optional)',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _noteController,
//             decoration: InputDecoration(
//               hintText: 'Add a note for the customer...',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.indigo, width: 2),
//               ),
//               filled: true,
//               fillColor: Colors.grey.shade50,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             maxLines: 3,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(AdminBookingsCubit adminCubit) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () async {
//               await adminCubit.updateStatus(
//                 bookingId: _booking!.id!,
//                 newStatus: 'approved',
//                 adminNote: _noteController.text.trim(),
//               );
//               if (mounted) Navigator.pop(context);
//             },
//             icon: const Icon(Icons.check_circle, size: 20),
//             label: const Text('Approve Booking'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () async {
//               await adminCubit.updateStatus(
//                 bookingId: _booking!.id!,
//                 newStatus: 'declined',
//                 adminNote: _noteController.text.trim(),
//               );
//               if (mounted) Navigator.pop(context);
//             },
//             icon: const Icon(Icons.cancel, size: 20),
//             label: const Text('Decline Booking'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     bool isCompact = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 16, color: Colors.grey),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: isCompact ? 13 : 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mangment/Feature/customer_section/book_service/book_modek.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import '../cubit/admin_bookings_cubit.dart';
import '../cubit/admin_bookings_state.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  BookingModel? _booking;
  bool _loading = true;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    try {
      final repo = BookingRepository();
      final b = await repo.getBookingById(widget.bookingId);
      setState(() {
        _booking = b;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate('failed_to_load_booking'),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
    final adminCubit = context.read<AdminBookingsCubit>();
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _booking == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(localizations.translate('booking_not_found')),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildCustomHeader(localizations),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatusCard(localizations),
                        const SizedBox(height: 16),
                        _buildCustomerSection(localizations),
                        const SizedBox(height: 16),
                        _buildServiceSection(localizations),
                        const SizedBox(height: 16),
                        _buildBookingSection(localizations),
                        const SizedBox(height: 16),
                        if (_booking!.notes.isNotEmpty) ...[
                          _buildNotesSection(localizations),
                          const SizedBox(height: 16),
                        ],
                        _buildAdminNoteSection(localizations),
                        const SizedBox(height: 16),
                        _buildActionButtons(adminCubit, localizations),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCustomHeader(AppLocalizations localizations) {
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
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('booking_details'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localizations.translate('complete_information_actions'),
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
        ),
      ),
    );
  }

  Widget _buildStatusCard(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _statusColor(_booking!.status).withOpacity(0.1),
            _statusColor(_booking!.status).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor(_booking!.status).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _statusColor(_booking!.status).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _statusIcon(_booking!.status),
              color: _statusColor(_booking!.status),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('current_status'),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  localizations.translate(_booking!.status.toLowerCase()),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _statusColor(_booking!.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  localizations.translate('customer_information'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              icon: Icons.person_outline,
              label: localizations.translate('name'),
              value: _booking!.customerName,
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.phone,
              label: localizations.translate('phone'),
              value: _booking!.customerPhone,
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.location_on_outlined,
              label: localizations.translate('location'),
              value: _booking!.location,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  localizations.translate('service_information'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              icon: Icons.apartment_outlined,
              label: localizations.translate('service'),
              value: _booking!.serviceName,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.translate('price'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '\$${_booking!.servicePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSection(AppLocalizations localizations) {
    final dateStr =
        '${_booking!.bookingDate.year}-${_booking!.bookingDate.month.toString().padLeft(2, '0')}-${_booking!.bookingDate.day.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  localizations.translate('booking_details'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.calendar_month_outlined,
                    label: localizations.translate('date'),
                    value: dateStr,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.access_time,
                    label: localizations.translate('time'),
                    value: _booking!.bookingTime,
                    isCompact: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: Colors.amber.shade600),
              const SizedBox(width: 8),
              Text(
                localizations.translate('customer_notes'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _booking!.notes,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminNoteSection(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: Colors.indigo),
              const SizedBox(width: 8),
              Text(
                localizations.translate('admin_note_optional'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: localizations.translate('add_note_for_customer'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.indigo, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    AdminBookingsCubit adminCubit,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await adminCubit.updateStatus(
                bookingId: _booking!.id!,
                newStatus: 'approved',
                adminNote: _noteController.text.trim(),
              );
              if (mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.check_circle, size: 20),
            label: Text(localizations.translate('approve_booking')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await adminCubit.updateStatus(
                bookingId: _booking!.id!,
                newStatus: 'declined',
                adminNote: _noteController.text.trim(),
              );
              if (mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel, size: 20),
            label: Text(localizations.translate('decline_booking')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isCompact = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 13 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
