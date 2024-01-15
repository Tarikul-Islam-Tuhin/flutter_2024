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
  final bool isLoading;
  const GitReposLoaded(
      {required this.repos, required this.filePath, required this.isLoading});
  @override
  List<Object> get props => [repos, isLoading];
}

class Error extends GitReposFlutterState {
  final String message;
  const Error({required this.message});
}

final class GitReposNavigateToDetailsPage extends GitReposActionState {}

final class GitReposFilterState extends GitReposActionState {
  final Params params;
  final List<GitReposFlutterEntity>? repos;
  GitReposFilterState({required this.params, this.repos});
  @override
  List<Object> get props => [params];
}

class ShowTimeState extends GitReposActionState {
  final int timeLeft;
  ShowTimeState({required this.timeLeft});
  @override
  List<Object> get props => [];
}

class FilterByStarOrUpdateState extends GitReposActionState {
  final Params params;
  FilterByStarOrUpdateState({required this.params});
  @override
  List<Object> get props => [params];
}
