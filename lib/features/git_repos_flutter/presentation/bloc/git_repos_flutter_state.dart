part of 'git_repos_flutter_bloc.dart';

abstract class GitReposFlutterState extends Equatable {
  const GitReposFlutterState();

  @override
  List<Object> get props => [];
}

abstract class GitReposActionState extends GitReposFlutterState {}

class GitReposFlutterInitial extends GitReposFlutterState {}

class GitReposLoading extends GitReposFlutterState {}

class GitReposLoaded extends GitReposFlutterState {
  final List<GitReposFlutterEntity> repos;
  final String filePath;
  const GitReposLoaded({required this.repos, required this.filePath});
  @override
  List<Object> get props => [repos];
}

class Error extends GitReposFlutterState {
  final String message;
  const Error({required this.message});
}

final class GitReposNavigateToDetailsPage extends GitReposActionState {}

final class GitReposFilterState extends GitReposActionState {
  final Params params;
  GitReposFilterState({required this.params});
  @override
  List<Object> get props => [params];
}

class LoadingState extends GitReposActionState {
  LoadingState();
}

class ShowTimeState extends GitReposActionState {
  final int timeLeft;
  ShowTimeState({required this.timeLeft});
  @override
  List<Object> get props => [DateTime.now().toString()];
}
