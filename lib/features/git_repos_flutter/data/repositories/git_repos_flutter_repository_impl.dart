import 'package:bs23_flutter_task/features/git_repos_flutter/data/datasources/git_repos_flutter_local_data_source.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/git_repos_flutter_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../domain/repositories/git_repos_flutter_repository.dart';
import '../datasources/git_repos_flutter_remote_data_source.dart';

class GitReposFlutterRepositoryImpl implements GitReposFlutterRepository {
  final GitReposFlutterRemoteDataSourceImpl remoteDataSource;
  final GitReposFlutterLocalDataSourceImpl localDataSource;
  final NetworkInfo networkInfo;

  GitReposFlutterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  List<GitReposFlutterEntity>? _sortCachedRepos(
      List<GitReposFlutterEntity>? cachedRepo, Params params) {
    if (cachedRepo == null) return null;

    if (params.stars == 'stars') {
      cachedRepo.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
    } else if (params.updated == 'updated') {
      cachedRepo.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return cachedRepo;
  }

  @override
  Future<Either<Failure, List<GitReposFlutterEntity>>>? getReposFlutter(
      {required Params params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteData =
            await remoteDataSource.getReposFlutter(params: params);

        await localDataSource.cacheRepos(remoteData);
        await localDataSource.setSessionData(params);
        await localDataSource.setNext30minutes();

        final updatedRemoteData = await localDataSource.getCachedRepos();
        final sortedData = _sortCachedRepos(updatedRemoteData, params);
        return Right(sortedData!);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server Exception'));
      }
    } else {
      try {
        final localRepos = await localDataSource.getCachedRepos();
        final sortedData = _sortCachedRepos(localRepos, params);
        if (sortedData == null) {
          return Left(CacheFailure(errorMessage: 'Epmty DB'));
        }
        return Right(sortedData);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'Epmty DB'));
      }
    }
  }
}
