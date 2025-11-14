import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Feature/Create_account/cubit/create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CreateAccountCubit() : super(CreateAccountInitial());

  Future<void> createAccount({
    required String firstName,
    required String secondName,
    required String email,
    bool? is_admin = false,
    required String password,
    required String location,
    required String profileImage,
    String? businessName,
  }) async {
    emit(CreateAccountLoading());
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'firstName': firstName,
        'secondName': secondName,
        'email': email,
        'is_admin': is_admin ?? false,
        'address': location,
        'businessName': businessName ?? '',
        'profileImage': profileImage,
        'createdAt': FieldValue.serverTimestamp(),
        "allow_notification": false,
        "gender": "",
        "phone_number": "",
      });

      emit(CreateAccountSuccess());
    } catch (error) {
      emit(CreateAccountFailure(error.toString()));
    }
  }
}
