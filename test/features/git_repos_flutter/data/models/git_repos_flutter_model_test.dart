import 'dart:convert';
import 'dart:io';
import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/git_repos_flutter_model.dart';
import '../../../../mocks/git_repos_flutter_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final jsonFile =
      File('test/mocks/git_repos_flutter_mock.json').readAsStringSync();

  test('fromJson test', () async {
    //arrange
    final Map<String, dynamic> jsonMap = json.decode(jsonFile);
    //act
    final result = GitReposFlutterModel.fromJson(jsonMap);
    //assert
    expect(result, isA<GitReposFlutterModel>());
  });

  test('toJson test', () async {
    //arrange
    final result = gitReposFlutterModelMock.toJson();

    final expectedMap = {
      "id": 31792824,
      "name": "flutter",
      "owner": {
        "id": 14101776,
        "avatar_url": "https://avatars.githubusercontent.com/u/14101776?v=4"
      },
      "updated_at": "2024-01-11T03:26:31.000Z",
      "description":
          "Flutter makes it easy and fast to build beautiful apps for mobile and beyond"
    };
    expect(result, equals(expectedMap));
  });
}
