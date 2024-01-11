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

  @override
  Future<Either<Failure, List<GitReposFlutterEntity>>>? getReposFlutter(
      {required Params params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteData =
            await remoteDataSource.getReposFlutter(params: params);

        localDataSource.cacheRepos(remoteData);
        localDataSource.setSessionData(params);

        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server Exception'));
      }
    } else {
      try {
        final localRepos = await localDataSource.getCachedRepos();
        return Right(localRepos!);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'Epmty DB'));
      }
    }
  }
}
