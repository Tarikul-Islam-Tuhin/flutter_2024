import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/widgets/list_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/params/params.dart';
import '../bloc/git_repos_flutter_bloc.dart';
import '../widgets/sort_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GitReposFlutterBloc>(context)
        .add(const GitReposFilteredEventInitialState());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.black,
              height: size.height * 0.08,
              width: double.maxFinite,
              child: BlocBuilder<GitReposFlutterBloc, GitReposFlutterState>(
                buildWhen: (previous, current) =>
                    current is FilterByStarOrUpdateState,
                builder: (context, state) {
                  if (state is FilterByStarOrUpdateState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SortButton(
                          label: 'Stars',
                          sortType: 'stars',
                          blocSortState: state.params.stars!,
                        ),
                        SortButton(
                          label: 'Latest',
                          sortType: 'updated',
                          blocSortState: state.params.updated!,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            BlocConsumer<GitReposFlutterBloc, GitReposFlutterState>(
              buildWhen: (previous, current) => current is! GitReposActionState,
              listenWhen: (previous, current) => current is GitReposActionState,
              listener: (context, state) {
                if (state is GitReposFilterState) {
                  BlocProvider.of<GitReposFlutterBloc>(context).add(
                    GitReposLoadedEvent(
                      params: Params(
                          page: state.params.page,
                          stars: state.params.stars,
                          updated: state.params.updated),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GitReposLoading) {
                  return const SizedBox(
                    height: 50,
                    width: 50,
                    child: AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  );
                } else if (state is GitReposLoaded) {
                  return ListViewScreen(
                    repoList: state.repos,
                    filePath: state.filePath,
                    isLoading: state.isLoading,
                  );
                } else if (state is Error) {
                  return Text(state.message);
                } else {
                  return const Text('Nothing Found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
