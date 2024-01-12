import 'dart:convert';
import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/git_repos_flutter_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/download_path.dart';
import '../../../../core/params/params.dart';

abstract class GitReposFlutterLocalDataSource {
  Future<void>? cacheRepos(List<GitReposFlutterModel>? repoToCache);
  Future<List<GitReposFlutterModel>>? getCachedRepos();
  Future<void>? setSessionData(Params params);
  Future<Params>? getSessionData();
  Future<void>? setNext30minutes();
  Future<int>? getStoredTimeDifferenceInMinutes();
}

class GitReposFlutterLocalDataSourceImpl
    implements GitReposFlutterLocalDataSource {
  GitReposFlutterLocalDataSourceImpl();

  @override
  Future<List<GitReposFlutterModel>>? getCachedRepos() {
    final reposBox = Hive.box(hiveReposBox);

    if (reposBox.keys.isNotEmpty) {
      List<GitReposFlutterModel> gitReposList =
          reposBox.values.toList().map((dynamic json) {
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

    if (repoToCache != null) {
      Dio dio = Dio();
      for (int i = 0; i < repoToCache.length; i++) {
        // ignoring duplicates
        if (!repos.containsKey((repoToCache[i].id).toString())) {
          await repos.put(repoToCache[i].id, repoToCache[i].toJson());
          final path = await getImagePath(repoToCache[i].id.toString());
          await dio
              .download(repoToCache[i].owner.avatarUrl, path)
              .onError((error, stackTrace) => throw CacheException());
        }
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Params> getSessionData() async {
    final sessionBox = Hive.box(hiveSessionBox);
    if (sessionBox.keys.isNotEmpty) {
      final hiveSession = await sessionBox.get('sessionData');
      final sessionStars = hiveSession['stars'];
      final sessionUpdated = hiveSession['updated'];
      final sessionPage = hiveSession['perPage'];
      return Future.value(Params(
          stars: sessionStars, updated: sessionUpdated, page: sessionPage));
    } else {
      const params = Params(stars: '', updated: '', page: 1);
      await setSessionData(params);
      return Future.value(params);
    }
  }

  @override
  Future<void>? setSessionData(Params params) async {
    final sessionBox = Hive.box(hiveSessionBox);
    await sessionBox.clear();
    Map query = {};
    if (params.updated == 'updated') {
      query['updated'] = 'updated';
    } else {
      query['updated'] = '';
    }
    if (params.stars == 'stars') {
      query['stars'] = 'stars';
    } else {
      query['stars'] = '';
    }
    if (params.page != null) {
      query['perPage'] = params.page;
    } else {
      query['perPage'] = 1;
    }
    await sessionBox.put('sessionData', Map.from(query));
  }

  @override
  Future<int>? getStoredTimeDifferenceInMinutes() async {
    final timeIntervalBox = Hive.box(hiveTimeIntervalBox);
    if (timeIntervalBox.keys.isEmpty) {
      return Future.value(0);
    }
    final storedTimeString = await timeIntervalBox.get('storedTimeString');
    final storedTime = DateTime.parse(storedTimeString);
    final now = DateTime.now();
    final difference = storedTime.difference(now).inMinutes;
    return Future.value(difference);
  }

  @override
  Future<void>? setNext30minutes() async {
    final timeIntervalBox = Hive.box(hiveTimeIntervalBox);
    final now = DateTime.now();
    final next30Minutes = now.add(const Duration(minutes: 30));
    await timeIntervalBox.put(
        'storedTimeString', next30Minutes.toIso8601String());
  }
}
