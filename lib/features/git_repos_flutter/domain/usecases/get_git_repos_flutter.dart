import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/git_repos_flutter_entity.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/repositories/git_repos_flutter_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';

class GetGitReposFlutter {
  final GitReposFlutterRepository repository;

  GetGitReposFlutter(this.repository);

  Future<Either<Failure, List<GitReposFlutterEntity>>?> call(
      {required Params params}) async {
    return await repository.getReposFlutter(params: params);
  }
}
