import 'package:bs23_flutter_task/core/params/params.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/git_repos_flutter_entity.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/repositories/git_repos_flutter_repository.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/domain/usecases/get_git_repos_flutter.dart';
import '../../../../mocks/git_repos_flutter_mock.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGitReposFlutterRepository extends Mock
    implements GitReposFlutterRepository {}

@GenerateMocks([GitReposFlutterRepository])
void main() {
  late GetGitReposFlutter usecase;
  late MockGitReposFlutterRepository mockGitReposFlutterRepository;
  late GitReposFlutterEntity tGitReposFlutterMock;
  late GitReposFlutterEntity tGitReposFlutterMockForUpdatedParams;
  late Params starParams;
  late Params updatedParams;
  setUp(() {
    mockGitReposFlutterRepository = MockGitReposFlutterRepository();
    usecase = GetGitReposFlutter(mockGitReposFlutterRepository);
    tGitReposFlutterMock = gitReposFlutterMock;
    tGitReposFlutterMockForUpdatedParams = gitReposFlutterMockForUpdatedParams;
    starParams = const Params(stars: 'stars');
    updatedParams = const Params(updated: 'updated');
  });

  runTestBasedOnParams(Params params, GitReposFlutterEntity mocks) async {
    List<GitReposFlutterEntity> mockData = [mocks];
    when(mockGitReposFlutterRepository.getReposFlutter(params: params))
        .thenAnswer((_) async => Right(mockData));

    final result = await usecase(params: params);

    expect(result, Right(mockData));
    verify(mockGitReposFlutterRepository.getReposFlutter(params: params));
    verifyNoMoreInteractions(mockGitReposFlutterRepository);
  }

  test('should get git repos flutter for the stars params', () async {
    runTestBasedOnParams(starParams, tGitReposFlutterMock);
  });

  test('should get git repos flutter for the updated params', () async {
    runTestBasedOnParams(updatedParams, tGitReposFlutterMockForUpdatedParams);
  });
}
