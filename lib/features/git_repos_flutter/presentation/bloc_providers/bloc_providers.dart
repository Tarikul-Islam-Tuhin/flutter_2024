import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/bloc/git_repos_flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllBlocProviders {
  static List getAllBlocProviders = [
    BlocProvider(create: (context) => GitReposFlutterBloc()),
  ];
}
