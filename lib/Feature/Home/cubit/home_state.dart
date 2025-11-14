// home_state.dart
part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, String>> categories;
  final int customerCount;

  HomeLoaded({required this.categories, required this.customerCount});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
