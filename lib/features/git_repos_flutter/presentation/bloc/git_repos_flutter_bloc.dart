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
import '../../data/models/git_repos_flutter_model.dart';
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
  String filePath = '';
  List<GitReposFlutterEntity> reposInBloc = [];

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

  List<GitReposFlutterModel>? _sortCachedRepos(
      List<GitReposFlutterModel>? cachedRepo, Params params) {
    if (cachedRepo == null) return null;

    if (params.stars == 'stars') {
      cachedRepo.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
    } else if (params.updated == 'updated') {
      cachedRepo.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return cachedRepo;
  }

  Future<List<GitReposFlutterModel>?> _getCachedSortedRepos(
      Params params) async {
    final cachedRepo = await repository.localDataSource.getCachedRepos();
    final sortedRepo = _sortCachedRepos(cachedRepo, params);
    reposInBloc = sortedRepo!;
    return sortedRepo;
  }

  GitReposFlutterBloc() : super(GitReposFlutterInitial()) {
    on<GitReposLoadedEvent>((event, emit) async {
      emit(GitReposLoaded(
          repos: reposInBloc, filePath: filePath, isLoading: true));
      final storedTimeInMin =
          await repository.localDataSource.getStoredTimeDifferenceInMinutes();
      final bool hasNetWork = await repository.networkInfo.isConnected!;
      if (hasNetWork) {
        if (storedTimeInMin! > 0) {
          emit(ShowTimeState(timeLeft: storedTimeInMin));
          final sortedRepo = await _getCachedSortedRepos(event.params);
          emit(GitReposLoaded(
              repos: sortedRepo!, filePath: filePath, isLoading: false));
          return;
        }
      }
      final failureOrRepos = await GetGitReposFlutter(repository).call(
        params: event.params,
      );
      failureOrRepos?.fold((error) {
        emit(Error(message: _mapFailureToMessage(error)));
      }, (data) {
        reposInBloc = data;
        emit(GitReposLoaded(repos: data, filePath: filePath, isLoading: false));
      });
    });

    on<GitReposFilteredEvent>((event, emit) async {
      final sessionData = await localData.getSessionData();
      Params params = Params(
          page: sessionData.page,
          stars: event.params.stars,
          updated: event.params.updated);
      await localData.setSessionData(params);
      emit(FilterByStarOrUpdateState(params: params));
      final sortedRepo = await _getCachedSortedRepos(params);
      emit(GitReposLoaded(repos: sortedRepo!, filePath: filePath));
    });

    on<GitReposFilteredEventInitialState>((event, emit) async {
      filePath = await getFilePath();
      emit(GitReposLoading());
      final getSessionData = await localData.getSessionData();
      if (getSessionData.page != 1) {
        emit(FilterByStarOrUpdateState(params: getSessionData));
        final sortedRepo = await _getCachedSortedRepos(getSessionData);
        emit(GitReposLoaded(repos: sortedRepo!, filePath: filePath));
      } else {
        emit(GitReposFilterState(params: getSessionData));
        emit(FilterByStarOrUpdateState(params: getSessionData));
      }
    });

    on<GitReposScrollEvent>((event, emit) async {
      final bool hasNetWork = await networkInfo.isConnected;
      if (hasNetWork) {
        final getSessionData = await localData.getSessionData();
        final storedTimeInMin =
            await repository.localDataSource.getStoredTimeDifferenceInMinutes();
        Params params = Params(
            page: getSessionData.page!,
            stars: getSessionData.stars,
            updated: getSessionData.updated);
        if (storedTimeInMin! <= 0) {
          int page = getSessionData.page!;
          params = Params(
              page: page + 1,
              stars: getSessionData.stars,
              updated: getSessionData.updated);
          await localData.setSessionData(params);
        }
        emit(GitReposFilterState(params: params, repos: reposInBloc));
      }
    });

    on<GitReposScrollContinuousEvent>((event, emit) async {
      emit(GitReposLoaded(
          repos: reposInBloc, filePath: filePath, isLoading: true));
    });
  }
}
