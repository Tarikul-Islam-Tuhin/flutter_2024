import 'package:bs23_flutter_task/core/params/params.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/bloc/git_repos_flutter_bloc.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/bloc_providers/bloc_providers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('sessionBox');
  await Hive.openBox('reposBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AllBlocProviders.getAllBlocProviders],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Git Repos Flutter',
        theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black87,
            )),
        home: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GitReposFlutterBloc>(context)
        .add(const GitReposFilteredEventInitialState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GitReposFlutterBloc, GitReposFlutterState>(
        buildWhen: (previous, current) => current is! GitReposActionState,
        listenWhen: (previous, current) => current is GitReposActionState,
        listener: (context, state) {
          if (state is GitReposFilterState) {
            BlocProvider.of<GitReposFlutterBloc>(context).add(
                GitReposLoadedEvent(
                    params: Params(
                        perPage: state.params.perPage,
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
            return Column(
              children: [
                Text(state.params.perPage.toString()),
                Text(state.params.stars.toString()),
                Text(state.params.updated.toString()),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GitReposFlutterBloc>(context).add(
                          const GitReposFilteredEvent(
                              params: Params(
                                  perPage: 4, updated: 'updated', stars: '')));
                    },
                    child: const Text('Updated')),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GitReposFlutterBloc>(context).add(
                          const GitReposFilteredEvent(
                              params: Params(
                                  perPage: 4, updated: '', stars: 'stars')));
                    },
                    child: const Text('Stars')),
                Text(state.repos.toString()),
              ],
            );
          } else if (state is Error) {
            return Text(state.message);
          } else {
            return const Text('Nothing Found');
          }
        },
      ),
    );
  }
}
