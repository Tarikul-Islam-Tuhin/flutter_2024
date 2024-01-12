import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/git_repos_flutter_model.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/data/models/owner_model.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/git_repos_flutter_entity.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/owner_entity.dart';

final gitReposFlutterMock = GitReposFlutterEntity(
    id: 1,
    name: 'test_name',
    description: 'test_description',
    owner: owner,
    updatedAt: DateTime(2024, 2, 1),
    stargazersCount: 1);

final owner = OwnerEntity(
    id: 12, avatarUrl: 'https://avatars.githubusercontent.com/u/14101776?v=4');

final gitReposFlutterMockForUpdatedParams = GitReposFlutterEntity(
    id: 2,
    name: 'test_update',
    description: 'test_updated',
    owner: ownerUpdate,
    updatedAt: DateTime(2024, 2, 1),
    stargazersCount: 1);

final ownerUpdate = OwnerEntity(
    id: 13, avatarUrl: 'https://avatars.githubusercontent.com/u/71636191?v=4');

final gitReposFlutterModelMock = GitReposFlutterModel(
    id: 31792824,
    name: "flutter",
    owner: ownerModelMock,
    updatedAt: DateTime.parse("2024-01-11T03:26:31Z"),
    stargazersCount: 1,
    description:
        "Flutter makes it easy and fast to build beautiful apps for mobile and beyond");

final ownerModelMock = OwnerModel(
    id: 14101776,
    avatarUrl: "https://avatars.githubusercontent.com/u/14101776?v=4");
