// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:store_mangment/Core/Widget/app_button.dart';
// // import 'package:store_mangment/Core/Widget/app_form_field.dart';
// // import 'package:store_mangment/Feature/resources/colors/colors.dart';
// // import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
// // import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';
// // import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

// // const Color kCardBackground = Color(0xFFF3F4F6);

// // class AddNewTaskView extends StatefulWidget {
// //   const AddNewTaskView({super.key});

// //   @override
// //   State<AddNewTaskView> createState() => _AddNewTaskViewState();
// // }

// // class _AddNewTaskViewState extends State<AddNewTaskView> {
// //   final _formKey = GlobalKey<FormState>();

// //   final TextEditingController petNameController = TextEditingController();
// //   final TextEditingController petOwnerController = TextEditingController();
// //   final TextEditingController serviceChargeController = TextEditingController();
// //   final TextEditingController serviceTypeController = TextEditingController();
// //   final TextEditingController paymentStatusController = TextEditingController();
// //   final TextEditingController serviceStatusController = TextEditingController();
// //   final TextEditingController petTypeController = TextEditingController();

// //   bool isLoading = false;

// //   void _showSnack(String message, {bool success = false}) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         behavior: SnackBarBehavior.floating,
// //         backgroundColor: success
// //             ? Colors.green.shade600
// //             : Theme.of(context).colorScheme.error,
// //       ),
// //     );
// //   }

// //   Future<void> createService() async {
// //     if (_formKey.currentState!.validate()) {
// //       setState(() => isLoading = true);

// //       try {
// //         await FirebaseFirestore.instance.collection('clinic_services').add({
// //           'pet_name': petNameController.text.trim(),
// //           'pet_owner': petOwnerController.text.trim(),
// //           'pet_type': petTypeController.text.trim(),
// //           'service_charge': double.tryParse(serviceChargeController.text) ?? 0,
// //           'service_type': serviceTypeController.text.trim(),
// //           'payment_status': paymentStatusController.text.trim(),
// //           'service_status': serviceStatusController.text.trim(),
// //           'created_at': Timestamp.now(),
// //         });

// //         _showSnack('Service recorded successfully', success: true);

// //         _formKey.currentState!.reset();
// //         petNameController.clear();
// //         petOwnerController.clear();
// //         serviceChargeController.clear();
// //         serviceTypeController.clear();
// //         paymentStatusController.clear();
// //         serviceStatusController.clear();
// //         petTypeController.clear();
// //       } catch (e) {
// //         _showSnack('Failed to record service: $e');
// //       }

// //       setState(() => isLoading = false);
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     petNameController.dispose();
// //     petOwnerController.dispose();
// //     serviceChargeController.dispose();
// //     serviceTypeController.dispose();
// //     paymentStatusController.dispose();
// //     serviceStatusController.dispose();
// //     petTypeController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);

// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       appBar: AppBar(
// //         leading: IconButton(
// //           icon: Icon(Icons.navigate_before, color: AppColors.black, size: 32),
// //           onPressed: () => Navigator.pop(context),
// //           tooltip: 'Back',
// //         ),
// //         elevation: 0.8,
// //         title: const Text(
// //           'New Service Record',
// //           style: AppTextStyle.textStyleBoldBlack,
// //         ),
// //         centerTitle: false,
// //         backgroundColor: AppColors.white,
// //       ),

// //       bottomNavigationBar: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
// //           child: AnimatedSwitcher(
// //             duration: const Duration(milliseconds: 200),
// //             child: isLoading
// //                 ? const Center(
// //                     key: ValueKey('loading'),
// //                     child: SizedBox(
// //                       height: 46,
// //                       child: CircularProgressIndicator(),
// //                     ),
// //                   )
// //                 : SizedBox(
// //                     key: const ValueKey('button'),
// //                     height: 52,
// //                     width: double.infinity,
// //                     child: DefaultButton(
// //                       function: createService,
// //                       text: "Save Service",
// //                       textColor: AppColors.white,
// //                       bottonColor: AppColors.dark_green,
// //                     ),
// //                   ),
// //           ),
// //         ),
// //       ),

// //       body: Stack(
// //         children: [
// //           SafeArea(
// //             child: Center(
// //               child: ConstrainedBox(
// //                 constraints: const BoxConstraints(maxWidth: 720),
// //                 child: SingleChildScrollView(
// //                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
// //                   child: Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           "Record a new service by filling the fields below:",
// //                           style: AppTextStyle.textStyleBoldBlack.copyWith(
// //                             fontSize: 18,
// //                           ),
// //                         ),
// //                         AppSizedBox.sizedH25,

// //                         // قسم بيانات الحيوان الأليف
// //                         _SectionCard(
// //                           title: 'Patient Information',
// //                           icon: Icons.pets,
// //                           child: Column(
// //                             children: [
// //                               DefaultFormField(
// //                                 controller: petNameController,
// //                                 type: TextInputType.text,
// //                                 hint: 'e.g. Fluffy',
// //                                 onSubmit: (_) =>
// //                                     FocusScope.of(context).nextFocus(),
// //                                 onValidate: (value) =>
// //                                     value == null || value.isEmpty
// //                                     ? 'Enter pet name'
// //                                     : null,
// //                                 label: 'Pet Name',
// //                                 maxlines: 1,
// //                               ),
// //                               AppSizedBox.sizedH15,
// //                               SelectorFormField(
// //                                 controller: petTypeController,
// //                                 label: 'Pet Type',
// //                                 hint: 'Select pet type',
// //                                 onValidate: (value) =>
// //                                     value == null || value.isEmpty
// //                                     ? 'Select pet type'
// //                                     : null,
// //                                 options: const ['Dog', 'Cat'],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         AppSizedBox.sizedH15,

// //                         // قسم بيانات المالك
// //                         _SectionCard(
// //                           title: 'Owner Information',
// //                           icon: Icons.person_outline,
// //                           child: DefaultFormField(
// //                             controller: petOwnerController,
// //                             type: TextInputType.text,
// //                             hint: 'e.g. Ahmed Ali',
// //                             onSubmit: (_) => FocusScope.of(context).nextFocus(),
// //                             onValidate: (value) =>
// //                                 value == null || value.isEmpty
// //                                 ? 'Enter owner name'
// //                                 : null,
// //                             label: 'Owner Name',
// //                             maxlines: 1,
// //                           ),
// //                         ),
// //                         AppSizedBox.sizedH15,

// //                         // قسم تفاصيل الخدمة
// //                         _SectionCard(
// //                           title: 'Service Details',
// //                           icon: Icons.medical_services_outlined,
// //                           child: Column(
// //                             children: [
// //                               SelectorFormField(
// //                                 controller: serviceTypeController,
// //                                 label: 'Service Type',
// //                                 hint: 'Select service',
// //                                 onValidate: (value) =>
// //                                     value == null || value.isEmpty
// //                                     ? 'Select service type'
// //                                     : null,
// //                                 options: const [
// //                                   'General Checkup',
// //                                   'Vaccination',
// //                                   'Surgery',
// //                                   'Dental Cleaning',
// //                                   'Grooming',
// //                                   'Microchipping',
// //                                   'Blood Test',
// //                                   'X-Ray',
// //                                   'Emergency Care',
// //                                   'Wound Care',
// //                                 ],
// //                               ),
// //                               AppSizedBox.sizedH15,
// //                               DefaultFormField(
// //                                 controller: serviceChargeController,
// //                                 type: TextInputType.number,
// //                                 hint: 'e.g. 250.00',
// //                                 onSubmit: (_) =>
// //                                     FocusScope.of(context).nextFocus(),
// //                                 onValidate: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return 'Enter service charge';
// //                                   }
// //                                   final charge = double.tryParse(value);
// //                                   if (charge == null || charge <= 0) {
// //                                     return 'Enter valid charge';
// //                                   }
// //                                   return null;
// //                                 },
// //                                 label: 'Service Charge',
// //                                 maxlines: 1,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         AppSizedBox.sizedH15,

// //                         // قسم الحالة والدفع
// //                         _SectionCard(
// //                           title: 'Status',
// //                           icon: Icons.assignment_outlined,
// //                           child: Column(
// //                             children: [
// //                               SelectorFormField(
// //                                 controller: serviceStatusController,
// //                                 label: 'Service Status',
// //                                 hint: 'Select service status',
// //                                 onValidate: (value) =>
// //                                     value == null || value.isEmpty
// //                                     ? 'Select service status'
// //                                     : null,
// //                                 options: const [
// //                                   'Completed',
// //                                   'In Progress',
// //                                   'Pending',
// //                                   'Cancelled',
// //                                 ],
// //                               ),
// //                               AppSizedBox.sizedH15,
// //                               SelectorFormField(
// //                                 controller: paymentStatusController,
// //                                 label: 'Payment Status',
// //                                 hint: 'Select payment status',
// //                                 onValidate: (value) =>
// //                                     value == null || value.isEmpty
// //                                     ? 'Select payment status'
// //                                     : null,
// //                                 options: const [
// //                                   'Paid',
// //                                   'Pending',
// //                                   'Partially Paid',
// //                                   'Unpaid',
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         AppSizedBox.sizedH15,

// //                         Row(
// //                           children: [
// //                             Icon(
// //                               Icons.info_outline,
// //                               color: theme.colorScheme.primary,
// //                               size: 18,
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Expanded(
// //                               child: Text(
// //                                 'Ensure all service details are correct before saving.',
// //                                 style: theme.textTheme.bodySmall?.copyWith(
// //                                   color: Colors.grey[700],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         AppSizedBox.sizedH40,
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),

// //           if (isLoading)
// //             Positioned.fill(
// //               child: IgnorePointer(
// //                 ignoring: true,
// //                 child: AnimatedContainer(
// //                   duration: const Duration(milliseconds: 200),
// //                   color: Colors.black.withOpacity(0.04),
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SectionCard extends StatelessWidget {
// //   final String title;
// //   final IconData icon;
// //   final Widget child;

// //   const _SectionCard({
// //     required this.title,
// //     required this.icon,
// //     required this.child,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);

// //     return Card(
// //       color: kCardBackground,
// //       elevation: 0,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(16),
// //         side: BorderSide(color: Colors.grey.shade300),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 16,
// //                   backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
// //                   child: Icon(icon, size: 18, color: theme.colorScheme.primary),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   title,
// //                   style: theme.textTheme.titleMedium?.copyWith(
// //                     fontWeight: FontWeight.w700,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             child,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // lib/Feature/orders/view/add_order_view.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:store_mangment/Feature/Orders/cubit/order_cubit.dart';
// import 'package:store_mangment/Feature/Orders/cubit/order_state.dart';
// import 'package:store_mangment/Feature/resources/colors/colors.dart';

// class AddOrderView extends StatefulWidget {
//   const AddOrderView({super.key});

//   @override
//   State<AddOrderView> createState() => _AddOrderViewState();
// }

// class _AddOrderViewState extends State<AddOrderView> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController petNameCtrl = TextEditingController();
//   final TextEditingController petOwnerCtrl = TextEditingController();
//   final TextEditingController petTypeCtrl = TextEditingController();
//   final TextEditingController serviceTypeCtrl = TextEditingController();
//   final TextEditingController serviceChargeCtrl = TextEditingController();
//   final TextEditingController paymentStatusCtrl = TextEditingController();
//   final TextEditingController serviceStatusCtrl = TextEditingController();

//   String _orderType = 'vet';

//   final List<String> petTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];
//   final List<String> serviceTypes = [
//     'General Checkup',
//     'Vaccination',
//     'Surgery',
//     'Dental',
//     'Grooming',
//     'Blood Test',
//     'X-Ray',
//     'Emergency',
//   ];
//   final List<String> paymentStatuses = [
//     'Paid',
//     'Pending',
//     'Partially Paid',
//     'Unpaid',
//   ];
//   final List<String> serviceStatuses = [
//     'Pending',
//     'In Progress',
//     'Completed',
//     'Cancelled',
//   ];

//   @override
//   void dispose() {
//     petNameCtrl.dispose();
//     petOwnerCtrl.dispose();
//     petTypeCtrl.dispose();
//     serviceTypeCtrl.dispose();
//     serviceChargeCtrl.dispose();
//     paymentStatusCtrl.dispose();
//     serviceStatusCtrl.dispose();
//     super.dispose();
//   }

//   void _showSnack(String msg, {bool success = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'New Order',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: BlocListener<OrderCubit, OrderState>(
//         listener: (context, state) {
//           if (state is OrderCreated) {
//             _showSnack(
//               'Order created successfully (ID: ${state.orderId})',
//               success: true,
//             );
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.pop(context);
//             });
//           } else if (state is OrderActionError) {
//             _showSnack(state.message);
//           } else if (state is OrderConverted) {
//             _showSnack(
//               'Market order converted to vet order successfully',
//               success: true,
//             );
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.pop(context);
//             });
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _SectionTitle("patient information"),
//                 const SizedBox(height: 16),
//                 _CustomFormField(
//                   controller: petNameCtrl,
//                   label: 'Pet Name',
//                   hint: 'Enter pet name',
//                   icon: Icons.pets,
//                   validator: (v) =>
//                       v == null || v.isEmpty ? 'Pet name is required' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 _CustomDropdownField(
//                   label: 'Pet Type',
//                   hint: 'Select pet type',
//                   icon: Icons.category,
//                   value: petTypeCtrl.text.isEmpty ? null : petTypeCtrl.text,
//                   items: petTypes,
//                   onChanged: (value) {
//                     petTypeCtrl.text = value;
//                     setState(() {});
//                   },
//                   validator: (v) =>
//                       v == null || v.isEmpty ? 'Pet type is required' : null,
//                 ),
//                 const SizedBox(height: 32),
//                 // Owner Information Section
//                 _SectionTitle('Owner Information'),
//                 const SizedBox(height: 16),
//                 _CustomFormField(
//                   controller: petOwnerCtrl,
//                   label: 'Owner Name',
//                   hint: 'Enter owner name',
//                   icon: Icons.person,
//                   validator: (v) =>
//                       v == null || v.isEmpty ? 'Owner name is required' : null,
//                 ),
//                 const SizedBox(height: 32),
//                 // Service Details Section
//                 _SectionTitle('Service Details'),
//                 const SizedBox(height: 16),
//                 _CustomDropdownField(
//                   label: 'Service Type',
//                   hint: 'Select service',
//                   icon: Icons.medical_services,
//                   value: serviceTypeCtrl.text.isEmpty
//                       ? null
//                       : serviceTypeCtrl.text,
//                   items: serviceTypes,
//                   onChanged: (value) {
//                     serviceTypeCtrl.text = value;
//                     setState(() {});
//                   },
//                   validator: (v) => v == null || v.isEmpty
//                       ? 'Service type is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 16),
//                 _CustomFormField(
//                   controller: serviceChargeCtrl,
//                   label: 'Service Charge',
//                   hint: 'Enter amount in IQD',
//                   icon: Icons.attach_money,
//                   keyboardType: TextInputType.number,
//                   validator: (v) {
//                     if (v == null || v.isEmpty) {
//                       return 'Service charge is required';
//                     }
//                     final amount = double.tryParse(v);
//                     if (amount == null || amount <= 0) {
//                       return 'Enter a valid amount';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32),
//                 // Status Section
//                 _SectionTitle('Status'),
//                 const SizedBox(height: 16),
//                 _CustomDropdownField(
//                   label: 'Service Status',
//                   hint: 'Select status',
//                   icon: Icons.assignment,
//                   value: serviceStatusCtrl.text.isEmpty
//                       ? null
//                       : serviceStatusCtrl.text,
//                   items: serviceStatuses,
//                   onChanged: (value) {
//                     serviceStatusCtrl.text = value;
//                     setState(() {});
//                   },
//                   validator: (v) => v == null || v.isEmpty
//                       ? 'Service status is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 16),
//                 _CustomDropdownField(
//                   label: 'Payment Status',
//                   hint: 'Select payment status',
//                   icon: Icons.payment,
//                   value: paymentStatusCtrl.text.isEmpty
//                       ? null
//                       : paymentStatusCtrl.text,
//                   items: paymentStatuses,
//                   onChanged: (value) {
//                     paymentStatusCtrl.text = value;
//                     setState(() {});
//                   },
//                   validator: (v) => v == null || v.isEmpty
//                       ? 'Payment status is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 32),
//                 // Submit Button
//                 BlocBuilder<OrderCubit, OrderState>(
//                   builder: (context, state) {
//                     final isLoading = state is OrderCreating;
//                     return SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: isLoading
//                           ? Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     AppColors.dark_green,
//                                     AppColors.dark_green.withOpacity(0.8),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: const Center(
//                                 child: SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation(
//                                       Colors.white,
//                                     ),
//                                     strokeWidth: 2.5,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   context.read<OrderCubit>().createOrder(
//                                     petName: petNameCtrl.text.trim(),
//                                     petOwner: petOwnerCtrl.text.trim(),
//                                     petType: petTypeCtrl.text.trim(),
//                                     serviceType: serviceTypeCtrl.text.trim(),
//                                     serviceCharge: double.parse(
//                                       serviceChargeCtrl.text.trim(),
//                                     ),
//                                     paymentStatus: paymentStatusCtrl.text
//                                         .trim(),
//                                     serviceStatus: serviceStatusCtrl.text
//                                         .trim(),
//                                     orderType: _orderType,
//                                   );
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.dark_green,
//                                 elevation: 8,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Save Order',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;

//   const _SectionTitle(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w800,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Container(
//           width: 40,
//           height: 3,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.dark_green,
//                 AppColors.dark_green.withOpacity(0.4),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _CustomFormField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final IconData icon;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;

//   const _CustomFormField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     required this.icon,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       decoration: InputDecoration(
//         label: Text(label),
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey.shade400),
//         prefixIcon: Icon(icon, color: AppColors.dark_green),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: AppColors.dark_green, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.red, width: 1.5),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.red, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//       ),
//       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//     );
//   }
// }

// class _CustomDropdownField extends StatelessWidget {
//   final String label;
//   final String hint;
//   final IconData icon;
//   final String? value;
//   final List<String> items;
//   final Function(String) onChanged;
//   final String? Function(String?)? validator;

//   const _CustomDropdownField({
//     required this.label,
//     required this.hint,
//     required this.icon,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       hint: Text(hint),
//       validator: validator,
//       isExpanded: true,
//       decoration: InputDecoration(
//         label: Text(label),
//         prefixIcon: Icon(icon, color: AppColors.dark_green),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: AppColors.dark_green, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.red, width: 1.5),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//       ),
//       items: items
//           .map(
//             (item) => DropdownMenuItem(
//               value: item,
//               child: Text(
//                 item,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//       onChanged: (value) {
//         if (value != null) {
//           onChanged(value);
//         }
//       },
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//     );
//   }
// }

// class _OrderTypeButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _OrderTypeButton({
//     required this.label,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? LinearGradient(
//                   colors: [
//                     AppColors.dark_green,
//                     AppColors.dark_green.withOpacity(0.8),
//                   ],
//                 )
//               : null,
//           color: isSelected ? null : Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: isSelected
//               ? null
//               : Border.all(color: Colors.grey.shade300, width: 1.5),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: AppColors.dark_green.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : AppColors.dark_green,
//               size: 32,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: isSelected ? Colors.white : Colors.grey.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/Orders/cubit/order_cubit.dart';
import 'package:store_mangment/Feature/Orders/cubit/order_state.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';

class AddOrderView extends StatefulWidget {
  const AddOrderView({super.key});

  @override
  State<AddOrderView> createState() => _AddOrderViewState();
}

class _AddOrderViewState extends State<AddOrderView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController petNameCtrl = TextEditingController();
  final TextEditingController petOwnerCtrl = TextEditingController();
  final TextEditingController petTypeCtrl = TextEditingController();
  final TextEditingController serviceTypeCtrl = TextEditingController();
  final TextEditingController serviceChargeCtrl = TextEditingController();
  final TextEditingController paymentStatusCtrl = TextEditingController();
  final TextEditingController serviceStatusCtrl = TextEditingController();

  String _orderType = 'vet';

  @override
  void dispose() {
    petNameCtrl.dispose();
    petOwnerCtrl.dispose();
    petTypeCtrl.dispose();
    serviceTypeCtrl.dispose();
    serviceChargeCtrl.dispose();
    paymentStatusCtrl.dispose();
    serviceStatusCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    // Lists with translations
    final petTypes = [
      loc.translate('dog'),
      loc.translate('cat'),
      loc.translate('bird'),
      loc.translate('rabbit'),
      loc.translate('other'),
    ];

    final serviceTypes = [
      loc.translate('general_checkup'),
      loc.translate('vaccination'),
      loc.translate('surgery'),
      loc.translate('dental'),
      loc.translate('grooming'),
      loc.translate('blood_test'),
      loc.translate('x_ray'),
      loc.translate('emergency'),
    ];

    final paymentStatuses = [
      loc.translate('paid'),
      loc.translate('pending'),
      loc.translate('partially_paid'),
      loc.translate('unpaid'),
    ];

    final serviceStatuses = [
      loc.translate('pending'),
      loc.translate('in_progress'),
      loc.translate('completed'),
      loc.translate('cancelled'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.translate('new_order'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            _showSnack(
              loc
                  .translate('order_created_successfully')
                  .replaceAll('{id}', state.orderId),
              success: true,
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          } else if (state is OrderActionError) {
            _showSnack(state.message);
          } else if (state is OrderConverted) {
            _showSnack(loc.translate('market_order_converted'), success: true);
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Information Section
                _SectionTitle(loc.translate('patient_information')),
                const SizedBox(height: 16),
                _CustomFormField(
                  controller: petNameCtrl,
                  label: loc.translate('pet_name'),
                  hint: loc.translate('enter_pet_name'),
                  icon: Icons.pets,
                  validator: (v) => v == null || v.isEmpty
                      ? loc.translate('pet_name_required')
                      : null,
                ),
                const SizedBox(height: 16),
                _CustomDropdownField(
                  label: loc.translate('pet_type'),
                  hint: loc.translate('select_pet_type'),
                  icon: Icons.category,
                  value: petTypeCtrl.text.isEmpty ? null : petTypeCtrl.text,
                  items: petTypes,
                  onChanged: (value) {
                    petTypeCtrl.text = value;
                    setState(() {});
                  },
                  validator: (v) => v == null || v.isEmpty
                      ? loc.translate('pet_type_required')
                      : null,
                ),
                const SizedBox(height: 32),

                // Owner Information Section
                _SectionTitle(loc.translate('owner_information')),
                const SizedBox(height: 16),
                _CustomFormField(
                  controller: petOwnerCtrl,
                  label: loc.translate('owner_name'),
                  hint: loc.translate('enter_owner_name'),
                  icon: Icons.person,
                  validator: (v) => v == null || v.isEmpty
                      ? loc.translate('owner_name_required')
                      : null,
                ),
                const SizedBox(height: 32),

                // Service Details Section
                _SectionTitle(loc.translate('service_details')),
                const SizedBox(height: 16),
                _CustomDropdownField(
                  label: loc.translate('service_type'),
                  hint: loc.translate('select_service'),
                  icon: Icons.medical_services,
                  value: serviceTypeCtrl.text.isEmpty
                      ? null
                      : serviceTypeCtrl.text,
                  items: serviceTypes,
                  onChanged: (value) {
                    serviceTypeCtrl.text = value;
                    setState(() {});
                  },
                  validator: (v) => v == null || v.isEmpty
                      ? loc.translate('service_type_required')
                      : null,
                ),
                const SizedBox(height: 16),
                _CustomFormField(
                  controller: serviceChargeCtrl,
                  label: loc.translate('service_charge'),
                  hint: loc.translate('enter_amount_iqd'),
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return loc.translate('service_charge_required');
                    }
                    final amount = double.tryParse(v);
                    if (amount == null || amount <= 0) {
                      return loc.translate('enter_valid_amount');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Status Section
                _SectionTitle(loc.translate('status')),
                const SizedBox(height: 16),
                _CustomDropdownField(
                  label: loc.translate('service_status'),
                  hint: loc.translate('select_status'),
                  icon: Icons.assignment,
                  value: serviceStatusCtrl.text.isEmpty
                      ? null
                      : serviceStatusCtrl.text,
                  items: serviceStatuses,
                  onChanged: (value) {
                    serviceStatusCtrl.text = value;
                    setState(() {});
                  },
                  validator: (v) => v == null || v.isEmpty
                      ? loc.translate('service_status_required')
                      : null,
                ),
                const SizedBox(height: 16),
                _CustomDropdownField(
                  label: loc.translate('payment_status'),
                  hint: loc.translate('select_payment_status'),
                  icon: Icons.payment,
                  value: paymentStatusCtrl.text.isEmpty
                      ? null
                      : paymentStatusCtrl.text,
                  items: paymentStatuses,
                  onChanged: (value) {
                    paymentStatusCtrl.text = value;
                    setState(() {});
                  },
                  validator: (v) => v == null || v.isEmpty
                      ? loc.translate('payment_status_required')
                      : null,
                ),
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    final isLoading = state is OrderCreating;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: isLoading
                          ? Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.dark_green,
                                    AppColors.dark_green.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<OrderCubit>().createOrder(
                                    petName: petNameCtrl.text.trim(),
                                    petOwner: petOwnerCtrl.text.trim(),
                                    petType: petTypeCtrl.text.trim(),
                                    serviceType: serviceTypeCtrl.text.trim(),
                                    serviceCharge: double.parse(
                                      serviceChargeCtrl.text.trim(),
                                    ),
                                    paymentStatus: paymentStatusCtrl.text
                                        .trim(),
                                    serviceStatus: serviceStatusCtrl.text
                                        .trim(),
                                    orderType: _orderType,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.dark_green,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                loc.translate('save_order'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.dark_green,
                AppColors.dark_green.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool isArabic;
  final String? Function(String?)? validator;

  const _CustomFormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isArabic = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: AppColors.dark_green),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.dark_green, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

class _CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final bool isArabic;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const _CustomDropdownField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    this.isArabic = false,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      validator: validator,
      isExpanded: true,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(icon, color: AppColors.dark_green),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.dark_green, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
    );
  }
}
