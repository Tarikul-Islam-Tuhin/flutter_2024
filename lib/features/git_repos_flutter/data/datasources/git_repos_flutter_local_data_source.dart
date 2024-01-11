import 'dart:convert';
import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/git_repos_flutter_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';

abstract class GitReposFlutterLocalDataSource {
  Future<void>? cacheRepos(List<GitReposFlutterModel>? repoToCache);
  Future<List<GitReposFlutterModel>>? getCachedRepos();
  Future<void>? setSessionData(Params params);
  Future<Params>? getSessionData();
}

const hiveSessionBox = 'sessionBox';
const hiveReposBox = 'reposBox';

class GitReposFlutterLocalDataSourceImpl
    implements GitReposFlutterLocalDataSource {
  GitReposFlutterLocalDataSourceImpl();

  @override
  Future<List<GitReposFlutterModel>>? getCachedRepos() {
    final repos = Hive.box(hiveReposBox);

    if (repos.keys.isNotEmpty) {
      List<GitReposFlutterModel> gitReposList =
          repos.values.toList().map((dynamic json) {
        return GitReposFlutterModel.fromJson(jsonDecode(jsonEncode(json)));
      }).toList();

      return Future.value(gitReposList);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cacheRepos(List<GitReposFlutterModel>? repoToCache) async {
    final repos = Hive.box(hiveReposBox);
    await repos.clear();
    if (repoToCache != null) {
      for (int i = 0; i < repoToCache.length; i++) {
        await repos.put(repoToCache[i].id, repoToCache[i].toJson());
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Params> getSessionData() async {
    final sessionBox = Hive.box(hiveSessionBox);
    if (sessionBox.keys.isNotEmpty) {
      final hiveSession = sessionBox.get('sessionData');
      final sessionStars = hiveSession['stars'];
      final sessionUpdated = hiveSession['updated'];
      final sessionPerPage = hiveSession['perPage'];
      return Future.value(Params(
          stars: sessionStars,
          updated: sessionUpdated,
          perPage: sessionPerPage));
    } else {
      const params = Params(stars: 'stars', updated: '', perPage: 10);
      await setSessionData(params);
      return Future.value(params);
    }
  }

  @override
  Future<void>? setSessionData(Params params) async {
    final sessionBox = Hive.box(hiveSessionBox);
    await sessionBox.clear();
    if (params.perPage != null) {
      await sessionBox.put('sessionData', {
        'perPage': params.perPage,
        'updated': params.updated,
        'stars': params.stars
      });
    } else {
      throw CacheException();
    }
  }
}
