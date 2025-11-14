// settings_cubit.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Feature/settings/cubit/setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void getUserData() async {
    emit(SettingsLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        emit(SettingsLoaded(doc.data()!));
      } else {
        emit(SettingsError('User data not found.'));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
