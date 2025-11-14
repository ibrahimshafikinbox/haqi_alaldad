// settings_state.dart
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> userData;

  SettingsLoaded(this.userData);
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}
