import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Core/Helper/cache_helper.dart';
import 'package:store_mangment/Feature/Login/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static LoginCubit get(context) => BlocProvider.of(context);

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      // Firebase login with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save UID to SharedPreferences
      String? uid = userCredential.user?.uid;
      if (uid != null) {
        await CachePrfHelper.saveUid(uid);
        print('🚀🚀🚀 UID saved: $uid');
      }
      emit(LoginSuccess(userCredential.user!.uid));
    } catch (error) {
      print('🚀🚀🚀 can not save uid : $error');

      emit(LoginError(error.toString()));
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    await CachePrfHelper.removeUid(); // Clear UID on logout
    // emit(LogoutSuccess());
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.delete(); // Delete the user account
        await CachePrfHelper.removeUid(); // Clear UID on account deletion
        // emit(AccountDeletionSuccess());
      } catch (error) {
        // emit(AccountDeletionError(error.toString()));
      }
    } else {
      // emit(AccountDeletionError("No user is currently logged in."));
    }
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswwordState());
  }
}
