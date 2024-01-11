import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs23_flutter_task/core/params/params.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/failure.dart';
import '../../data/datasources/git_repos_flutter_local_data_source.dart';
import '../../data/datasources/git_repos_flutter_remote_data_source.dart';
import '../../data/repositories/git_repos_flutter_repository_impl.dart';
import '../../domain/entities/git_repos_flutter_entity.dart';
import '../../domain/usecases/get_git_repos_flutter.dart';

part 'git_repos_flutter_event.dart';
part 'git_repos_flutter_state.dart';

class GitReposFlutterBloc
    extends Bloc<GitReposFlutterEvent, GitReposFlutterState> {
  _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error';
      case CacheFailure:
        return 'Cache Error';
      default:
        return 'Unexpected error';
    }
  }

  GitReposFlutterBloc() : super(GitReposFlutterInitial()) {
    on<GitReposLoadedEvent>((event, emit) async {
      // emit(GitReposLoading());
      emit(LoadingState());

      GitReposFlutterRepositoryImpl repository = GitReposFlutterRepositoryImpl(
        remoteDataSource: GitReposFlutterRemoteDataSourceImpl(dio: Dio()),
        localDataSource: GitReposFlutterLocalDataSourceImpl(),
        networkInfo: NetworkInfoImpl(InternetConnection()),
      );

      final failureOrRepos = await GetGitReposFlutter(repository).call(
        params: event.params,
      );

      failureOrRepos?.fold((error) {
        emit(Error(message: _mapFailureToMessage(error)));
      }, (data) {
        emit(GitReposLoaded(repos: data));
      });
    });
    on<GitReposFilteredEvent>((event, emit) async {
      emit(GitReposLoading());

      GitReposFlutterLocalDataSourceImpl localData =
          GitReposFlutterLocalDataSourceImpl();
      final getSessionDataPrev = await localData.getSessionData();
      Params params = Params(
          page: getSessionDataPrev.page,
          stars: event.params.stars,
          updated: event.params.updated);
      await localData.setSessionData(params);
      final getSessionDataAfter = await localData.getSessionData();

      emit(GitReposFilterState(params: getSessionDataAfter));
    });
    on<GitReposFilteredEventInitialState>((event, emit) async {
      emit(GitReposLoading());

      GitReposFlutterLocalDataSourceImpl localData =
          GitReposFlutterLocalDataSourceImpl();

      final getSessionData = await localData.getSessionData();

      emit(GitReposFilterState(params: getSessionData));
    });

    on<GitReposScrollEvent>((event, emit) async {
      emit(LoadingState());
      GitReposFlutterLocalDataSourceImpl localData =
          GitReposFlutterLocalDataSourceImpl();

      final getSessionData = await localData.getSessionData();

      int page = getSessionData.page!;
      Params params = Params(
          page: page + 1,
          stars: getSessionData.stars,
          updated: getSessionData.updated);
      await localData.setSessionData(params);

      emit(GitReposFilterState(params: params));
    });
  }
}
