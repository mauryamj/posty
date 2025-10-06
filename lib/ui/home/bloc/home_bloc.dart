import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:posty/data/model/dataformat.dart';
import 'package:posty/data/repository/data_call.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DataFormatRepository repository;
  final Set<int> visitedId = {};
  Timer? _centralTicker;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<CardClicked>(cardClicked);
    on<DetailScreenCloseClicked>(detailScreenCloseClicked);
    on<FetchPost>(fetchPost);
    on<TickEvent>(onTick);
    on<UpdatePostVisibility>(updatePostVisibility);
  }

  
  FutureOr<void> homeInitialEvent(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final fetchedPostsList = await repository.getPosts();

      
      emit(HomeLoaded(posts: fetchedPostsList));

      
      _centralTicker?.cancel();

      
      _centralTicker = Timer.periodic(const Duration(seconds: 1), (_) {
        add(TickEvent());
      });
    } catch (e) {
      emit(HomeError("Failed to load posts: $e"));
    }
  }

  
  FutureOr<void> cardClicked(CardClicked event, Emitter<HomeState> emit) {
    visitedId.add(event.postId);

    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(isPaused: true); 
        }
        return post;
      }).toList();
      emit(HomeLoaded(posts: updatedPosts));
    }

    add(FetchPost(event.postId)); 
  }

  
  FutureOr<void> detailScreenCloseClicked(
    DetailScreenCloseClicked event,
    Emitter<HomeState> emit,
  ) async {
    if (state is PostLoaded) {
      final currentPost = (state as PostLoaded).post;
      if (state is PostLoaded) {
        
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          final updatedPosts = currentState.posts.map((post) {
            if (post.id == currentPost.id) {
              return post.copyWith(isPaused: false);
            }
            return post;
          }).toList();
          emit(HomeLoaded(posts: updatedPosts));
        }
      }
    }

    
    final fetchedPostsList = await repository.getPosts();
    emit(HomeLoaded(posts: fetchedPostsList));
  }

  
  FutureOr<void> fetchPost(FetchPost event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final post = await repository.getPostById(event.postId);
      emit(PostLoaded(post));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  
  FutureOr<void> onTick(TickEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final updatedPosts = currentState.posts.map((post) {
        if (post.isVisible && !post.isPaused && post.remainingDuration > 0) {
          return post.copyWith(remainingDuration: post.remainingDuration - 1);
        }
        return post;
      }).toList();

      emit(HomeLoaded(posts: updatedPosts));
    }
  }

  
  FutureOr<void> updatePostVisibility(
    UpdatePostVisibility event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(isVisible: event.isVisible);
        }
        return post;
      }).toList();

      emit(HomeLoaded(posts: updatedPosts));
    }
  }

  
  @override
  Future<void> close() {
    _centralTicker?.cancel();
    return super.close();
  }

  
  FutureOr<void> startCentralTimer(
    StartCentralTimer event,
    Emitter<HomeState> emit,
  ) {}
}
