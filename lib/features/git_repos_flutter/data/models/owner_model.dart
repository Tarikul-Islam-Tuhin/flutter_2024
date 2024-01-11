import 'package:bs23_flutter_task/features/git_repos_flutter/domain/entities/owner_entity.dart';

class OwnerModel extends OwnerEntity {
  OwnerModel({required int id, required String avatarUrl})
      : super(avatarUrl: avatarUrl, id: id);

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(id: json["id"], avatarUrl: json['avatar_url']);
  }

  Map<String, dynamic> toJson() => {"id": id, "avatar_url": avatarUrl};
}
