import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/git_repos_flutter_model.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';

abstract class GitReposFlutterRemoteDataSource {
  Future<List<GitReposFlutterModel>> getReposFlutter({required Params params});
}

class GitReposFlutterRemoteDataSourceImpl
    implements GitReposFlutterRemoteDataSource {
  final Dio dio;

  GitReposFlutterRemoteDataSourceImpl({required this.dio});

  _getUrl(Params params) {
    String url = 'https://api.github.com/search/repositories?q=flutter';
    if (params.stars == 'stars') {
      url += '&sort=stars';
    } else if (params.updated == 'update') {
      url += '&sort=updated';
    }
    url += '&per_page=${params.perPage}';
    return url;
  }

  @override
  Future<List<GitReposFlutterModel>> getReposFlutter(
      {required Params params}) async {
    final response = await dio
        .get(
          _getUrl(params),
        )
        .onError((error, stackTrace) => throw ServerException());

    if (response.statusCode == 200) {
      return convertDynamicListToModelList(response.data['items']);
    } else {
      throw ServerException();
    }
  }
}
