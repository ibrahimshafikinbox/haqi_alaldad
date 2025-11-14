import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_state.dart';

class ServiceBookingScreen extends StatefulWidget {
  final dynamic service;

  const ServiceBookingScreen({Key? key, required this.service})
    : super(key: key);

  @override
  _ServiceBookingScreenState createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Map<String, String> _fieldErrors = {};

  String get _currentUid {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'anonymous';
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C5CE7),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3436),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _fieldErrors.remove('date');
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C5CE7),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3436),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _fieldErrors.remove('time');
      });
    }
  }

  void _submitBooking() {
    setState(() {
      _fieldErrors.clear();
    });

    final formValid = _formKey.currentState!.validate();
    bool dtValid = true;

    if (_selectedDate == null) {
      _fieldErrors['date'] = AppLocalizations.of(
        context,
      ).translate('please_select_a_date');
      dtValid = false;
    }
    if (_selectedTime == null) {
      _fieldErrors['time'] = AppLocalizations.of(
        context,
      ).translate('please_select_a_time');
      dtValid = false;
    }

    if (!formValid || !dtValid) {
      setState(() {});
      return;
    }

    context.read<BookingCubit>().createBooking(
      service: widget.service,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      bookingDate: _selectedDate!,
      bookingTime: _selectedTime!,
      notes: _notesController.text.trim(),
      userId: _currentUid,
      location: _locationController.text.trim(),
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: const Color(0xFFE74C3C),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocListener<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              Fluttertoast.showToast(
                msg:
                    state.message ??
                    AppLocalizations.of(
                      context,
                    ).translate('booked_successfully'),
                backgroundColor: const Color(0xFF00B894),
                textColor: Colors.white,
              );
              Navigator.of(context).pop();
            } else if (state is BookingError) {
              _showErrorMessage(state.message);
            } else if (state is BookingValidationError) {
              setState(() {
                _fieldErrors = state.fieldErrors;
              });
            }
          },
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 30),
                            _buildPersonalInfoSection(),
                            const SizedBox(height: 35),
                            _buildDateTimeSection(),
                            const SizedBox(height: 35),
                            _buildLocationSection(),
                            const SizedBox(height: 35),
                            _buildNotesSection(),
                            const SizedBox(height: 40),
                            _buildSubmitButton(),
                            const SizedBox(height: 30),
                          ],
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

  Widget _buildSliverAppBar() {
    final imageUrl = (widget.service?.imageUrl as String?) ?? '';
    final name =
        (widget.service?.name as String?) ??
        AppLocalizations.of(context).translate('service');
    final price = (widget.service?.price as num?)?.toInt() ?? 0;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF6C5CE7),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'IQD $price',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          AppLocalizations.of(context).translate('book_your_service'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        _buildSectionTitle(
          AppLocalizations.of(context).translate('personal_information'),
          Icons.person,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _nameController,
          label: AppLocalizations.of(context).translate('full_name'),
          icon: Icons.account_circle,
          errorText: _fieldErrors['name'],
          validator: (value) {
            if (value?.trim().isEmpty ?? true)
              return AppLocalizations.of(
                context,
              ).translate('please_enter_your_name');
            if (value!.trim().length < 2)
              return AppLocalizations.of(
                context,
              ).translate('name_is_too_short');
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _phoneController,
          label: AppLocalizations.of(context).translate('phone_number'),
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          errorText: _fieldErrors['phone'],
          validator: (value) {
            final v = value?.trim() ?? '';
            if (v.isEmpty)
              return AppLocalizations.of(
                context,
              ).translate('please_enter_your_phone_number');
            final reg = RegExp(r'^[0-9+\-\s]{7,}$');
            if (!reg.hasMatch(v))
              return AppLocalizations.of(
                context,
              ).translate('enter_a_valid_phone_number');
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    final dateError = _fieldErrors['date'];
    final timeError = _fieldErrors['time'];

    return Column(
      children: [
        _buildSectionTitle(
          AppLocalizations.of(context).translate('date_and_time'),
          Icons.schedule,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildPickerCard(
                label: AppLocalizations.of(context).translate('select_date'),
                value: _selectedDate != null
                    ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                    : AppLocalizations.of(context).translate('no_date_chosen'),
                icon: Icons.event,
                onTap: _selectDate,
                errorText: dateError,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildPickerCard(
                label: AppLocalizations.of(context).translate('select_time'),
                value: _selectedTime != null
                    ? _selectedTime!.format(context)
                    : AppLocalizations.of(context).translate('no_time_chosen'),
                icon: Icons.access_time,
                onTap: _selectTime,
                errorText: timeError,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          AppLocalizations.of(context).translate('location'),
          Icons.location_on,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _locationController,
          label: AppLocalizations.of(
            context,
          ).translate('enter_your_address_or_location'),
          icon: Icons.location_pin,
          errorText: _fieldErrors['location'],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppLocalizations.of(
                context,
              ).translate('please_enter_your_location');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          AppLocalizations.of(context).translate('additional_notes'),
          Icons.notes,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: _cardDecoration(),
          child: TextFormField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(
                context,
              ).translate('any_special_requests_or_details'),
              prefixIcon: const Icon(Icons.edit_note, color: Color(0xFF6C5CE7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final isLoading =
            state is BookingLoading || state is BookingFormValidating;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _submitBooking,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                isLoading
                    ? AppLocalizations.of(context).translate('submitting')
                    : AppLocalizations.of(context).translate('confirm_booking'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
              elevation: 8,
            ),
          ),
        );
      },
    );
  }

  // Helpers

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6C5CE7)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final showError = (errorText != null && errorText.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: _cardDecoration(
            borderColor: showError ? const Color(0xFFE74C3C) : null,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(icon, color: const Color(0xFF6C5CE7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12),
            ),
          ),
      ],
    );
  }

  BoxDecoration _cardDecoration({Color? borderColor}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor ?? Colors.transparent, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildPickerCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: _cardDecoration(
              borderColor: hasError ? const Color(0xFFE74C3C) : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF6C5CE7)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2D3436),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFB2BEC3)),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12),
            ),
          ),
      ],
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
// import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_state.dart';

// class ServiceBookingScreen extends StatefulWidget {
//   final dynamic service;

//   const ServiceBookingScreen({Key? key, required this.service})
//     : super(key: key);

//   @override
//   _ServiceBookingScreenState createState() => _ServiceBookingScreenState();
// }

// class _ServiceBookingScreenState extends State<ServiceBookingScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _notesController = TextEditingController();
//   final _locationController = TextEditingController();

//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;

//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   Map<String, String> _fieldErrors = {};

//   String get _currentUid {
//     final user = FirebaseAuth.instance.currentUser;
//     return user?.uid ?? 'anonymous';
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
//     );

//     _fadeController.forward();
//     _scaleController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     _notesController.dispose();
//     _locationController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 1)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF6C5CE7),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Color(0xFF2D3436),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _fieldErrors.remove('date');
//       });
//     }
//   }

//   Future<void> _selectTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF6C5CE7),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Color(0xFF2D3436),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//         _fieldErrors.remove('time');
//       });
//     }
//   }

//   void _submitBooking() {
//     setState(() {
//       _fieldErrors.clear();
//     });

//     final formValid = _formKey.currentState!.validate();
//     bool dtValid = true;

//     if (_selectedDate == null) {
//       _fieldErrors['date'] = 'Please select a date';
//       dtValid = false;
//     }
//     if (_selectedTime == null) {
//       _fieldErrors['time'] = 'Please select a time';
//       dtValid = false;
//     }

//     if (!formValid || !dtValid) {
//       setState(() {});
//       return;
//     }

//     context.read<BookingCubit>().createBooking(
//       service: widget.service,
//       customerName: _nameController.text.trim(),
//       customerPhone: _phoneController.text.trim(),
//       bookingDate: _selectedDate!,
//       bookingTime: _selectedTime!,
//       notes: _notesController.text.trim(),
//       userId: _currentUid,
//       location: _locationController.text.trim(),
//     );
//   }

//   void _showErrorMessage(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: const Color(0xFFE74C3C),
//       textColor: Colors.white,
//       fontSize: 16,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: BlocListener<BookingCubit, BookingState>(
//           listener: (context, state) {
//             if (state is BookingSuccess) {
//               Fluttertoast.showToast(
//                 msg: state.message ?? 'Booked successfully',
//                 backgroundColor: const Color(0xFF00B894),
//                 textColor: Colors.white,
//               );
//               Navigator.of(context).pop(); // pop the booking screen
//             } else if (state is BookingError) {
//               _showErrorMessage(state.message);
//             } else if (state is BookingValidationError) {
//               setState(() {
//                 _fieldErrors = state.fieldErrors;
//               });
//             }
//           },
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: CustomScrollView(
//                 slivers: [
//                   _buildSliverAppBar(),
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.all(25),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildHeader(),
//                             const SizedBox(height: 30),
//                             _buildPersonalInfoSection(),
//                             const SizedBox(height: 35),
//                             _buildDateTimeSection(),
//                             const SizedBox(height: 35),
//                             _buildLocationSection(),
//                             const SizedBox(height: 35),
//                             _buildNotesSection(),
//                             const SizedBox(height: 40),
//                             _buildSubmitButton(),
//                             const SizedBox(height: 30),
//                           ],
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

//   Widget _buildSliverAppBar() {
//     final imageUrl = (widget.service?.imageUrl as String?) ?? '';
//     final name = (widget.service?.name as String?) ?? 'Service';
//     final price = (widget.service?.price as num?)?.toInt() ?? 0;

//     return SliverAppBar(
//       expandedHeight: 300,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: const Color(0xFF6C5CE7),
//                     child: const Icon(
//                       Icons.image_not_supported,
//                       size: 80,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 25,
//               right: 25,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           offset: Offset(0, 2),
//                           blurRadius: 4,
//                           color: Colors.black26,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 15,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'IQD $price',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
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

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
//             ),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: const Icon(
//             Icons.calendar_today,
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//         const SizedBox(width: 15),
//         const Text(
//           'Book Your Service',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF2D3436),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPersonalInfoSection() {
//     return Column(
//       children: [
//         _buildSectionTitle('Personal Information', Icons.person),
//         const SizedBox(height: 20),
//         _buildTextField(
//           controller: _nameController,
//           label: 'Full Name',
//           icon: Icons.account_circle,
//           errorText: _fieldErrors['name'],
//           validator: (value) {
//             if (value?.trim().isEmpty ?? true) return 'Please enter your name';
//             if (value!.trim().length < 2) return 'Name is too short';
//             return null;
//           },
//         ),
//         const SizedBox(height: 20),
//         _buildTextField(
//           controller: _phoneController,
//           label: 'Phone Number',
//           icon: Icons.phone,
//           keyboardType: TextInputType.phone,
//           errorText: _fieldErrors['phone'],
//           validator: (value) {
//             final v = value?.trim() ?? '';
//             if (v.isEmpty) return 'Please enter your phone number';
//             final reg = RegExp(r'^[0-9+\-\s]{7,}$');
//             if (!reg.hasMatch(v)) return 'Enter a valid phone number';
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDateTimeSection() {
//     final dateError = _fieldErrors['date'];
//     final timeError = _fieldErrors['time'];

//     return Column(
//       children: [
//         _buildSectionTitle('Date & Time', Icons.schedule),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             Expanded(
//               child: _buildPickerCard(
//                 label: 'Select Date',
//                 value: _selectedDate != null
//                     ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
//                     : 'No date chosen',
//                 icon: Icons.event,
//                 onTap: _selectDate,
//                 errorText: dateError,
//               ),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: _buildPickerCard(
//                 label: 'Select Time',
//                 value: _selectedTime != null
//                     ? _selectedTime!.format(context)
//                     : 'No time chosen',
//                 icon: Icons.access_time,
//                 onTap: _selectTime,
//                 errorText: timeError,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Location', Icons.location_on),
//         const SizedBox(height: 12),
//         _buildTextField(
//           controller: _locationController,
//           label: 'Enter your address or location',
//           icon: Icons.location_pin,
//           errorText: _fieldErrors['location'],
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Please enter your location';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildNotesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Additional Notes', Icons.notes),
//         const SizedBox(height: 12),
//         Container(
//           decoration: _cardDecoration(),
//           child: TextFormField(
//             controller: _notesController,
//             maxLines: 4,
//             decoration: const InputDecoration(
//               hintText: 'Any special requests or details...',
//               prefixIcon: Icon(Icons.edit_note, color: Color(0xFF6C5CE7)),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return BlocBuilder<BookingCubit, BookingState>(
//       builder: (context, state) {
//         final isLoading =
//             state is BookingLoading || state is BookingFormValidating;
//         return SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: isLoading ? null : _submitBooking,
//             icon: isLoading
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Icon(Icons.check_circle_outline),
//             label: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 14.0),
//               child: Text(
//                 isLoading ? 'Submitting...' : 'Confirm Booking',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF6C5CE7),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
//               elevation: 8,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Helpers

//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFF6C5CE7).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: const Color(0xFF6C5CE7)),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF2D3436),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? errorText,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     final showError = (errorText != null && errorText.isNotEmpty);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: _cardDecoration(
//             borderColor: showError ? const Color(0xFFE74C3C) : null,
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             validator: validator,
//             decoration: InputDecoration(
//               hintText: label,
//               prefixIcon: Icon(icon, color: const Color(0xFF6C5CE7)),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         if (showError)
//           Padding(
//             padding: const EdgeInsets.only(top: 6, left: 8),
//             child: Text(
//               errorText!,
//               style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   BoxDecoration _cardDecoration({Color? borderColor}) {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: borderColor ?? Colors.transparent, width: 1.2),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 12,
//           offset: const Offset(0, 6),
//         ),
//       ],
//     );
//   }

//   Widget _buildPickerCard({
//     required String label,
//     required String value,
//     required IconData icon,
//     required VoidCallback onTap,
//     String? errorText,
//   }) {
//     final hasError = errorText != null && errorText.isNotEmpty;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             decoration: _cardDecoration(
//               borderColor: hasError ? const Color(0xFFE74C3C) : null,
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6C5CE7).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: const Color(0xFF6C5CE7)),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         label,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF636E72),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         value,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Color(0xFF2D3436),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right, color: Color(0xFFB2BEC3)),
//               ],
//             ),
//           ),
//         ),
//         if (hasError)
//           Padding(
//             padding: const EdgeInsets.only(top: 6, left: 8),
//             child: Text(
//               errorText!,
//               style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }
// }
