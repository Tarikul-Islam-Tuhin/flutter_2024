import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/git_repos_flutter_entity.dart';
import '../bloc/git_repos_flutter_bloc.dart';

class ListViewScreen extends StatefulWidget {
  final List<GitReposFlutterEntity> repoList;
  const ListViewScreen({super.key, required this.repoList});

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  bool isLoading = false;

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      BlocProvider.of<GitReposFlutterBloc>(context)
          .add(const GitReposScrollEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GitReposFlutterBloc, GitReposFlutterState>(
      listener: (context, state) {
        if (state is LoadingState) {
          isLoading = true;
        }
      },
      child: Expanded(
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount:
                isLoading ? widget.repoList.length + 1 : widget.repoList.length,
            itemBuilder: (context, index) {
              if (index < widget.repoList.length) {
                final user = widget.repoList[index];
                final avatarUrl = user.owner.avatarUrl;
                return Column(
                  key: const Key('Test-Column-Key'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 27.0,
                            backgroundImage: NetworkImage(avatarUrl),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.repoList.length.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Divider()
                  ],
                );
              } else {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ));
              }
            }),
      ),
    );
  }
}
