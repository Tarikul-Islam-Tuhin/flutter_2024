import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/pages/details_page.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/widgets/image_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../domain/entities/git_repos_flutter_entity.dart';
import '../bloc/git_repos_flutter_bloc.dart';

class ListViewScreen extends StatefulWidget {
  final List<GitReposFlutterEntity> repoList;
  final String filePath;
  final bool isLoading;
  const ListViewScreen(
      {super.key,
      required this.isLoading,
      required this.repoList,
      required this.filePath});

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

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      BlocProvider.of<GitReposFlutterBloc>(context)
          .add(const GitReposScrollEvent());
    } else {
      BlocProvider.of<GitReposFlutterBloc>(context)
          .add(const GitReposScrollContinuousEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GitReposFlutterBloc, GitReposFlutterState>(
      listener: (context, state) {
        if (state is ShowTimeState) {
          Fluttertoast.showToast(
              msg: "Please wait ${state.timeLeft} minutes before next fetch",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 16.0);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text(
          //         'Please wait ${state.timeLeft} minutes before next fetch')));
        }
      },
      child: Expanded(
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.isLoading
                ? widget.repoList.length + 1
                : widget.repoList.length,
            itemBuilder: (context, index) {
              if (index < widget.repoList.length) {
                final user = widget.repoList[index];
                return InkWell(
                  key: const Key('Test-InkWell-Key'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          filePath: widget.filePath,
                          repo: widget.repoList[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    key: const Key('Test-Column-Key'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            ImageFile(
                              filePath: widget.filePath,
                              userId: '${user.id}',
                              radius: 27.0,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                widget.repoList[index].name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  ),
                );
              } else if (widget.isLoading) {
                return const Center(
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator()));
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
