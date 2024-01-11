import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/widgets/list_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/params/params.dart';
import '../bloc/git_repos_flutter_bloc.dart';

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
                    current is GitReposFilterState,
                builder: (context, state) {
                  if (state is GitReposFilterState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<GitReposFlutterBloc>(context).add(
                              const GitReposFilteredEvent(
                                params: Params(updated: '', stars: 'stars'),
                              ),
                            );
                          },
                          child: Text(
                            'Stars',
                            style: TextStyle(
                              fontSize: 18,
                              color: state.params.stars == 'stars'
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<GitReposFlutterBloc>(context).add(
                                  const GitReposFilteredEvent(
                                      params: Params(
                                          updated: 'updated', stars: '')));
                            },
                            child: Text(
                              'Latest',
                              style: TextStyle(
                                fontSize: 18,
                                color: state.params.updated == 'updated'
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                            ))
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
                              updated: state.params.updated)));
                }
              },
              builder: (context, state) {
                if (state is GitReposLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GitReposLoaded) {
                  return ListViewScreen(repoList: state.repos);
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
