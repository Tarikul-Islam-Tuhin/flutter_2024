import 'dart:convert';

import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/owner_model.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/git_repos_flutter_entity.dart';

GitReposFlutterModel gitReposFlutterModelFromJson(String str) =>
    GitReposFlutterModel.fromJson(json.decode(str));

List<GitReposFlutterModel> convertDynamicListToModelList(
    List<dynamic> dynamicList) {
  return dynamicList
      .map((json) => GitReposFlutterModel.fromJson(json))
      .toList();
}

List<GitReposFlutterModel> gitReposFlutterModelsFromJsonList(String str) =>
    (json.decode(str) as List<dynamic>)
        .map((json) => GitReposFlutterModel.fromJson(json))
        .toList();

String gitReposFlutterModelToJson(GitReposFlutterModel data) =>
    json.encode(data.toJson());

class GitReposFlutterModel extends GitReposFlutterEntity {
  GitReposFlutterModel(
      {required int id,
      required String name,
      required String description,
      required OwnerModel owner,
      required DateTime updatedAt,
      required int stargazersCount})
      : super(
            owner: owner,
            id: id,
            description: description,
            updatedAt: updatedAt,
            name: name,
            stargazersCount: stargazersCount);

  factory GitReposFlutterModel.fromJson(Map<String, dynamic> json) {
    return GitReposFlutterModel(
      id: json["id"],
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      owner: OwnerModel.fromJson(json["owner"]),
      updatedAt: DateTime.parse(
        json["updated_at"] ?? DateTime.now(),
      ),
      stargazersCount: json["stargazers_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "owner": (owner as OwnerModel).toJson(),
        "description": description,
        "updated_at": updatedAt.toIso8601String(),
        "stargazers_count": stargazersCount
      };
}
