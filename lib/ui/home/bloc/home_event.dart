part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class CardClicked extends HomeEvent {
  final int postId;
  CardClicked(this.postId);
}

class DetailScreenCloseClicked extends HomeEvent {}
class FetchPost extends HomeEvent {
  final int postId;
  FetchPost(this.postId);

  List<Object> get props => [postId];
}

class StartCentralTimer extends HomeEvent{}

class UpdatePostVisibility extends HomeEvent {
  final int postId;
  final bool isVisible;

  UpdatePostVisibility(this.postId, this.isVisible);
}

class TickEvent extends HomeEvent {}
