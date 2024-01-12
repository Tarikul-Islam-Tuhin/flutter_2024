import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/owner_entity.dart';

class GitReposFlutterEntity {
  final int id;
  final String name;
  final String description;
  final OwnerEntity owner;
  final DateTime updatedAt;
  final int stargazersCount;

  GitReposFlutterEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.owner,
      required this.updatedAt,
      required this.stargazersCount});
}
