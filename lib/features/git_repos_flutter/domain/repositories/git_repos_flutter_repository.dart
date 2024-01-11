import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/git_repos_flutter_entity.dart';

abstract class GitReposFlutterRepository {
  Future<Either<Failure, List<GitReposFlutterEntity>>>? getReposFlutter(
      {required Params params});
}
