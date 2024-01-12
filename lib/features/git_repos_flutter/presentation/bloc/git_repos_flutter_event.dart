part of 'git_repos_flutter_bloc.dart';

abstract class GitReposFlutterEvent extends Equatable {
  const GitReposFlutterEvent();

  @override
  List<Object> get props => [];
}

class GitReposLoadedEvent extends GitReposFlutterEvent {
  final Params params;
  const GitReposLoadedEvent({required this.params});
}

class GitReposFilteredEvent extends GitReposFlutterEvent {
  final Params params;
  const GitReposFilteredEvent({required this.params});
}

class GitReposFilteredEventInitialState extends GitReposFlutterEvent {
  const GitReposFilteredEventInitialState();
}

class GitReposScrollEvent extends GitReposFlutterEvent {
  const GitReposScrollEvent();
}

class GitReposContinuousScrollEvent extends GitReposFlutterEvent {
  const GitReposContinuousScrollEvent();
}
