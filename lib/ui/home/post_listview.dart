import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posty/ui/home/bloc/home_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostListview extends StatefulWidget {
  final int postId;
  final String? title;
  final int remainingDuration;
  const PostListview({
    super.key,
    required this.postId,
    this.title,
    required this.remainingDuration,
  });

  @override
  State<PostListview> createState() => _PostListviewState();
}

class _PostListviewState extends State<PostListview> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    final isvisted = bloc.visitedId.contains(widget.postId);
    final colorScheme = Theme.of(context).colorScheme;
    return VisibilityDetector(
      key: Key("post-${widget.postId}"),
      onVisibilityChanged: (info) {
        final visibleFraction = info.visibleFraction;
        if (visibleFraction > 0.3) {
          context.read<HomeBloc>().add(
            UpdatePostVisibility(widget.postId, true),
          );
        } else {
          (info) {
            if (!mounted) return; 
            final visibleFraction = info.visibleFraction;
            if (visibleFraction > 0.3) {
              context.read<HomeBloc>().add(
                UpdatePostVisibility(widget.postId, true),
              );
            } else {
              context.read<HomeBloc>().add(
                UpdatePostVisibility(widget.postId, false),
              );
            }
          };
        }
      },
      child: Card(
        margin: EdgeInsets.all(5),
        elevation: 3,
        color: isvisted ? Colors.white70 : colorScheme.primaryContainer,
        child: InkWell(
          onTap: () {
            context.read<HomeBloc>().add(CardClicked(widget.postId));
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.postId}", style: TextStyle(fontSize: 15)),
                Text("${widget.title}", style: TextStyle(fontSize: 20)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 32,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorScheme.surfaceContainerLow,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, 
                          spreadRadius: 2, 
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "${widget.remainingDuration} ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
