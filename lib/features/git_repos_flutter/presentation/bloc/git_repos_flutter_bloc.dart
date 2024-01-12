import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs23_flutter_task/core/params/params.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/utils/download_path.dart';
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
  // DI
  final repository = GitReposFlutterRepositoryImpl(
    remoteDataSource: GitReposFlutterRemoteDataSourceImpl(dio: Dio()),
    localDataSource: GitReposFlutterLocalDataSourceImpl(),
    networkInfo: NetworkInfoImpl(InternetConnection()),
  );

  // local data
  final localData = GitReposFlutterLocalDataSourceImpl();
  final networkInfo = NetworkInfoImpl(InternetConnection());
  final String filePath = '';

  // local function
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
      final filePath = await getFilePath();
      final storedTimeInMin =
          await repository.localDataSource.getStoredTimeDifferenceInMinutes();

      final bool hasNetWork = await repository.networkInfo.isConnected!;
      if (hasNetWork) {
        if (storedTimeInMin! > 0) {
          emit(ShowTimeState(timeLeft: storedTimeInMin));
          final cachedRepo = await repository.localDataSource.getCachedRepos();
          emit(GitReposLoaded(repos: cachedRepo!, filePath: filePath));

          return;
        }
      }

      final failureOrRepos = await GetGitReposFlutter(repository).call(
        params: event.params,
      );

      failureOrRepos?.fold((error) {
        emit(Error(message: _mapFailureToMessage(error)));
      }, (data) {
        emit(GitReposLoaded(repos: data, filePath: filePath));
      });
    });

    on<GitReposFilteredEvent>((event, emit) async {
      final filePath = await getFilePath();
      final getSessionDataPrev = await localData.getSessionData();
      Params params = Params(
          page: getSessionDataPrev.page,
          stars: event.params.stars,
          updated: event.params.updated);
      await localData.setSessionData(params);

      emit(FilterByStarOrUpdateState(params: params));
      final cachedRepo = await repository.localDataSource.getCachedRepos();
      if (params.stars == 'stars') {
        cachedRepo
            ?.sort((a, b) => a.stargazersCount.compareTo(b.stargazersCount));
      } else if (params.updated == 'updated') {
        cachedRepo?.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
      }
      emit(GitReposLoaded(repos: cachedRepo!, filePath: filePath));
    });

    on<GitReposFilteredEventInitialState>((event, emit) async {
      emit(GitReposLoading());

      final getSessionData = await localData.getSessionData();
      emit(FilterByStarOrUpdateState(params: getSessionData));

      emit(GitReposFilterState(params: getSessionData));
    });

    on<GitReposScrollEvent>((event, emit) async {
      final bool hasNetWork = await networkInfo.isConnected;
      if (hasNetWork) {
        final getSessionData = await localData.getSessionData();

        int page = getSessionData.page!;
        Params params = Params(
            page: page + 1,
            stars: getSessionData.stars,
            updated: getSessionData.updated);
        await localData.setSessionData(params);

        emit(GitReposFilterState(params: params));
      }
    });
  }
}
