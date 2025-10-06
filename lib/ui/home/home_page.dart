import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posty/ui/home/bloc/home_bloc.dart';
import 'package:posty/ui/home/detailed_screen.dart';
import 'package:posty/ui/home/post_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<HomeBloc>().add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posty")),
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostListview(
                  postId: post.id,
                  title: post.title,
                  remainingDuration: post.remainingDuration,
                );
              },
            );
          } else if (state is PostLoaded) {
            return DetailedScreen(post: state.post);
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox(child: Text("default data"));
        },
      ),
    );
  }
}
