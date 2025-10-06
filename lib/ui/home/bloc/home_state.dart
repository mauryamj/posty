part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<DataFormat> posts;
  HomeLoaded({required this.posts});
}

class HomeDetailClicked extends HomeState {}

class PostLoaded extends HomeState {
  final DataFormat post;
  PostLoaded(this.post);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

