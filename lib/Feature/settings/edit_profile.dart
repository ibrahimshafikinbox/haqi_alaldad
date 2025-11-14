// import 'dart:convert';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:store_mangment/Feature/resources/colors/colors.dart';
// import 'package:store_mangment/Feature/resources/styles/app_sized_box.dart';
// import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

// class EditProfileView extends StatefulWidget {
//   const EditProfileView({super.key});

//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }

// class _EditProfileViewState extends State<EditProfileView> {
//   final uid = FirebaseAuth.instance.currentUser?.uid;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = true;
//   bool _isSaving = false;

//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController secondNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController genderController = TextEditingController();
//   final TextEditingController businessNameController = TextEditingController();

//   bool allowNotification = false;
//   String? selectedGender;
//   String? profileImageUrl;
//   File? newImage;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     setState(() => _isLoading = true);
//     try {
//       if (uid != null) {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(uid)
//             .get();
//         final data = doc.data();
//         if (data != null) {
//           firstNameController.text = data['firstName'] ?? '';
//           secondNameController.text = data['secondName'] ?? '';
//           emailController.text = data['email'] ?? '';
//           phoneController.text = data['phone_number'] ?? '';
//           addressController.text = data['address'] ?? '';
//           genderController.text = data['gender'] ?? '';
//           businessNameController.text = data['businessName'] ?? '';
//           allowNotification = data['allow_notification'] ?? false;
//           profileImageUrl = data['profileImage'];

//           selectedGender = (data['gender'] as String?)?.isNotEmpty == true
//               ? data['gender']
//               : null;
//         }
//       }
//     } catch (_) {
//       // You could show a snackbar if desired
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<String?> uploadImageToImgBB(File imageFile) async {
//     final apiKey = "fd92c702916d503b106bac9858b8856c";
//     final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");
//     final bytes = await imageFile.readAsBytes();
//     final base64Image = base64Encode(bytes);

//     final response = await http.post(url, body: {"image": base64Image});

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['data']['url'];
//     } else {
//       return null;
//     }
//   }

//   Future<void> pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Update Profile Picture',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _PickOption(
//                         icon: Icons.camera_alt_outlined,
//                         label: 'Camera',
//                         onTap: () async {
//                           final picked = await ImagePicker().pickImage(
//                             source: ImageSource.camera,
//                             imageQuality: 75,
//                           );
//                           if (picked != null) {
//                             setState(() => newImage = File(picked.path));
//                           }
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _PickOption(
//                         icon: Icons.photo_library_outlined,
//                         label: 'Gallery',
//                         onTap: () async {
//                           final picked = await ImagePicker().pickImage(
//                             source: ImageSource.gallery,
//                             imageQuality: 75,
//                           );
//                           if (picked != null) {
//                             setState(() => newImage = File(picked.path));
//                           }
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 if (newImage != null || profileImageUrl != null)
//                   TextButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         newImage = null;
//                         profileImageUrl = null;
//                       });
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(
//                       Icons.delete_outline,
//                       color: Colors.redAccent,
//                     ),
//                     label: const Text(
//                       'Remove current photo',
//                       style: TextStyle(color: Colors.redAccent),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> updateUserData() async {
//     if (!_formKey.currentState!.validate()) return;
//     FocusScope.of(context).unfocus();

//     setState(() => _isSaving = true);
//     try {
//       // Upload image if a new one was selected
//       if (newImage != null) {
//         final imageUrl = await uploadImageToImgBB(newImage!);
//         if (imageUrl != null) {
//           profileImageUrl = imageUrl;
//         }
//       }

//       if (uid != null) {
//         await FirebaseFirestore.instance.collection('users').doc(uid).update({
//           'firstName': firstNameController.text.trim(),
//           'secondName': secondNameController.text.trim(),
//           'email': emailController.text.trim(),
//           'phone_number': phoneController.text.trim(),
//           'address': addressController.text.trim(),
//           'gender': (selectedGender ?? genderController.text).trim(),
//           'businessName': businessNameController.text.trim(),
//           'allow_notification': allowNotification,
//           'profileImage': profileImageUrl,
//         });

//         if (mounted) Navigator.pop(context);
//       }
//     } catch (_) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to save changes. Please try again.'),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }

//   InputDecoration _inputDecoration({
//     required String label,
//     String? hint,
//     IconData? icon,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       hintText: hint,
//       prefixIcon: icon != null ? Icon(icon, color: AppColors.dark_green) : null,
//       filled: true,
//       fillColor: Colors.grey[50],
//       contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColors.dark_green, width: 1.5),
//       ),
//     );
//   }

//   String? _requiredValidator(String? v) {
//     if (v == null || v.trim().isEmpty) return 'This field is required';
//     return null;
//   }

//   String? _emailValidator(String? v) {
//     if (v == null || v.trim().isEmpty) return 'Email is required';
//     final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,7}$');
//     if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
//     return null;
//   }

//   String? _phoneValidator(String? v) {
//     if (v == null || v.trim().isEmpty) return 'Phone number is required';
//     final digits = v.replaceAll(RegExp(r'\D'), '');
//     if (digits.length < 8 || digits.length > 15)
//       return 'Enter a valid phone number';
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final green = AppColors.dark_green;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           "Edit Profile",
//           style: AppTextStyle.textStyleBoldBlack,
//         ),
//         backgroundColor: AppColors.white,
//         elevation: 0.5,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.navigate_before_outlined,
//             size: 28,
//             color: AppColors.black,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SafeArea(
//               child: Stack(
//                 children: [
//                   SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           // ✨ Enhanced Profile Picture Card
//                           _buildProfileCard(green),
//                           const SizedBox(height: 18),

//                           // Form Fields Card
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: const Color(0xFFEAEAEA),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: TextFormField(
//                                         controller: firstNameController,
//                                         textInputAction: TextInputAction.next,
//                                         decoration: _inputDecoration(
//                                           label: "First Name",
//                                           icon: Icons.person_outline,
//                                         ),
//                                         validator: _requiredValidator,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: TextFormField(
//                                         controller: secondNameController,
//                                         textInputAction: TextInputAction.next,
//                                         decoration: _inputDecoration(
//                                           label: "Second Name",
//                                           icon: Icons.badge_outlined,
//                                         ),
//                                         validator: _requiredValidator,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 TextFormField(
//                                   controller: emailController,
//                                   keyboardType: TextInputType.emailAddress,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: _inputDecoration(
//                                     label: "Email",
//                                     icon: Icons.email_outlined,
//                                   ),
//                                   validator: _emailValidator,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 TextFormField(
//                                   controller: phoneController,
//                                   keyboardType: TextInputType.phone,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: _inputDecoration(
//                                     label: "Phone Number",
//                                     icon: Icons.phone_outlined,
//                                   ),
//                                   validator: _phoneValidator,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 TextFormField(
//                                   controller: addressController,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: _inputDecoration(
//                                     label: "Address",
//                                     icon: Icons.location_on_outlined,
//                                   ),
//                                   validator: _requiredValidator,
//                                 ),
//                                 const SizedBox(height: 12),

//                                 // Gender dropdown
//                                 DropdownButtonFormField<String>(
//                                   value: selectedGender,
//                                   decoration: _inputDecoration(
//                                     label: "Gender",
//                                     icon: Icons.wc,
//                                   ),
//                                   items: const [
//                                     DropdownMenuItem(
//                                       value: 'Male',
//                                       child: Text('Male'),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: 'Female',
//                                       child: Text('Female'),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: 'Other',
//                                       child: Text('Other'),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: 'Prefer not to say',
//                                       child: Text('Prefer not to say'),
//                                     ),
//                                   ],
//                                   onChanged: (val) {
//                                     setState(() {
//                                       selectedGender = val;
//                                       genderController.text = val ?? '';
//                                     });
//                                   },
//                                   validator: (v) => (v == null || v.isEmpty)
//                                       ? 'Please select your gender'
//                                       : null,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 TextFormField(
//                                   controller: businessNameController,
//                                   textInputAction: TextInputAction.done,
//                                   decoration: _inputDecoration(
//                                     label: "Business Name",
//                                     icon: Icons.storefront_outlined,
//                                   ),
//                                   validator: _requiredValidator,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 SwitchListTile(
//                                   value: allowNotification,
//                                   onChanged: (val) =>
//                                       setState(() => allowNotification = val),
//                                   title: const Text("Allow Notifications"),
//                                   activeColor: green,
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 6,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Sticky Save Button
//                   Positioned(
//                     left: 16,
//                     right: 16,
//                     bottom: 16,
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isSaving ? null : updateUserData,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: green,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: _isSaving
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text(
//                                 "Save Changes",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   /// ✨ Clean Profile Card with White Background and Border
//   Widget _buildProfileCard(Color green) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//         child: Column(
//           children: [
//             // Profile Avatar Section
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 // Avatar Container
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: green.withOpacity(0.15),
//                       width: 3,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: Container(
//                       width: 120,
//                       height: 120,
//                       color: Colors.grey[100],
//                       child: Image(
//                         image: newImage != null
//                             ? FileImage(newImage!) as ImageProvider
//                             : (profileImageUrl != null
//                                   ? NetworkImage(profileImageUrl!)
//                                   : const AssetImage(
//                                       "assets/default_avatar.png",
//                                     )),
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: Colors.grey[200],
//                             child: Icon(
//                               Icons.person_4,
//                               color: Colors.grey[400],
//                               size: 50,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Edit button
//                 Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: pickImage,
//                     borderRadius: BorderRadius.circular(24),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: green,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: green.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.camera_alt,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // User Name
//             Text(
//               '${firstNameController.text} ${secondNameController.text}'
//                       .trim()
//                       .isEmpty
//                   ? 'Your Name'
//                   : '${firstNameController.text} ${secondNameController.text}',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 8),

//             // Email
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.email_outlined, color: Colors.grey[600], size: 16),
//                 const SizedBox(width: 6),
//                 Text(
//                   emailController.text.isEmpty
//                       ? 'email@example.com'
//                       : emailController.text,
//                   style: TextStyle(color: Colors.grey[700], fontSize: 13),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     secondNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     genderController.dispose();
//     businessNameController.dispose();
//     super.dispose();
//   }
// }

// class _PickOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _PickOption({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.grey[100],
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             children: [
//               Icon(icon, color: AppColors.dark_green, size: 24),
//               const SizedBox(height: 8),
//               Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();

  bool allowNotification = false;
  String? selectedGender;
  String? profileImageUrl;
  File? newImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    setState(() => _isLoading = true);
    try {
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final data = doc.data();
        if (data != null) {
          firstNameController.text = data['firstName'] ?? '';
          secondNameController.text = data['secondName'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone_number'] ?? '';
          addressController.text = data['address'] ?? '';
          genderController.text = data['gender'] ?? '';
          businessNameController.text = data['businessName'] ?? '';
          allowNotification = data['allow_notification'] ?? false;
          profileImageUrl = data['profileImage'];

          selectedGender = (data['gender'] as String?)?.isNotEmpty == true
              ? data['gender']
              : null;
        }
      }
    } catch (_) {
      // You could show a snackbar if desired
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> uploadImageToImgBB(File imageFile) async {
    final apiKey = "fd92c702916d503b106bac9858b8856c";
    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(url, body: {"image": base64Image});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['url'];
    } else {
      return null;
    }
  }

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  ).translate("update_profile_picture"),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _PickOption(
                        icon: Icons.camera_alt_outlined,
                        label: AppLocalizations.of(context).translate("camera"),
                        onTap: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            imageQuality: 75,
                          );
                          if (picked != null) {
                            setState(() => newImage = File(picked.path));
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickOption(
                        icon: Icons.photo_library_outlined,
                        label: AppLocalizations.of(
                          context,
                        ).translate("gallery"),
                        onTap: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 75,
                          );
                          if (picked != null) {
                            setState(() => newImage = File(picked.path));
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (newImage != null || profileImageUrl != null)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        newImage = null;
                        profileImageUrl = null;
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      AppLocalizations.of(
                        context,
                      ).translate("remove_current_photo"),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateUserData() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSaving = true);
    try {
      // Upload image if a new one was selected
      if (newImage != null) {
        final imageUrl = await uploadImageToImgBB(newImage!);
        if (imageUrl != null) {
          profileImageUrl = imageUrl;
        }
      }

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'firstName': firstNameController.text.trim(),
          'secondName': secondNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone_number': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'gender': (selectedGender ?? genderController.text).trim(),
          'businessName': businessNameController.text.trim(),
          'allow_notification': allowNotification,
          'profileImage': profileImageUrl,
        });

        if (mounted) Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate("failed_to_save"),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.dark_green) : null,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.dark_green, width: 1.5),
      ),
    );
  }

  String? _requiredValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppLocalizations.of(context).translate("field_required");
    }
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppLocalizations.of(context).translate("email_required");
    }
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,7}$');
    if (!regex.hasMatch(v.trim())) {
      return AppLocalizations.of(context).translate("enter_valid_email");
    }
    return null;
  }

  String? _phoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppLocalizations.of(context).translate("phone_required");
    }
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 15) {
      return AppLocalizations.of(context).translate("enter_valid_phone");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final green = AppColors.dark_green;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("edit_profile"),
          style: AppTextStyle.textStyleBoldBlack,
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before_outlined,
            size: 28,
            color: AppColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // ✨ Enhanced Profile Picture Card
                          _buildProfileCard(green),
                          const SizedBox(height: 18),

                          // Form Fields Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFEAEAEA),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: firstNameController,
                                        textInputAction: TextInputAction.next,
                                        decoration: _inputDecoration(
                                          label: AppLocalizations.of(
                                            context,
                                          ).translate("first_name"),
                                          icon: Icons.person_outline,
                                        ),
                                        validator: _requiredValidator,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: secondNameController,
                                        textInputAction: TextInputAction.next,
                                        decoration: _inputDecoration(
                                          label: AppLocalizations.of(
                                            context,
                                          ).translate("second_name"),
                                          icon: Icons.badge_outlined,
                                        ),
                                        validator: _requiredValidator,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate("email"),
                                    icon: Icons.email_outlined,
                                  ),
                                  validator: _emailValidator,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate("phone_number"),
                                    icon: Icons.phone_outlined,
                                  ),
                                  validator: _phoneValidator,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: addressController,
                                  textInputAction: TextInputAction.next,
                                  decoration: _inputDecoration(
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate("address"),
                                    icon: Icons.location_on_outlined,
                                  ),
                                  validator: _requiredValidator,
                                ),
                                const SizedBox(height: 12),

                                // Gender dropdown
                                DropdownButtonFormField<String>(
                                  value: selectedGender,
                                  decoration: _inputDecoration(
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate("gender"),
                                    icon: Icons.wc,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Male',
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).translate("male"),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Female',
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).translate("female"),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Other',
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).translate("other"),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Prefer not to say',
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).translate("prefer_not_to_say"),
                                      ),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      selectedGender = val;
                                      genderController.text = val ?? '';
                                    });
                                  },
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? AppLocalizations.of(
                                          context,
                                        ).translate("select_gender")
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: businessNameController,
                                  textInputAction: TextInputAction.done,
                                  decoration: _inputDecoration(
                                    label: AppLocalizations.of(
                                      context,
                                    ).translate("business_name"),
                                    icon: Icons.storefront_outlined,
                                  ),
                                  validator: _requiredValidator,
                                ),
                                const SizedBox(height: 8),
                                SwitchListTile(
                                  value: allowNotification,
                                  onChanged: (val) =>
                                      setState(() => allowNotification = val),
                                  title: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate("allow_notifications"),
                                  ),
                                  activeColor: green,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // Sticky Save Button
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : updateUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(
                                  context,
                                ).translate("save_changes"),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// ✨ Clean Profile Card with White Background and Border
  Widget _buildProfileCard(Color green) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            // Profile Avatar Section
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Avatar Container
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: green.withOpacity(0.15),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[100],
                      child: Image(
                        image: newImage != null
                            ? FileImage(newImage!) as ImageProvider
                            : (profileImageUrl != null
                                  ? NetworkImage(profileImageUrl!)
                                  : const AssetImage(
                                      "assets/default_avatar.png",
                                    )),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person_4,
                              color: Colors.grey[400],
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Edit button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: pickImage,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              '${firstNameController.text} ${secondNameController.text}'
                      .trim()
                      .isEmpty
                  ? AppLocalizations.of(context).translate("your_name")
                  : '${firstNameController.text} ${secondNameController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_outlined, color: Colors.grey[600], size: 16),
                const SizedBox(width: 6),
                Text(
                  emailController.text.isEmpty
                      ? AppLocalizations.of(context).translate("email_example")
                      : emailController.text,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    genderController.dispose();
    businessNameController.dispose();
    super.dispose();
  }
}

class _PickOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.dark_green, size: 24),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
