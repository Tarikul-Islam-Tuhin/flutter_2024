import 'package:equatable/equatable.dart';

class Params extends Equatable {
  final String? stars;
  final String? updated;
  final int? perPage;
  const Params({this.stars, this.updated, this.perPage});
  @override
  List<Object?> get props => [stars, updated, perPage];
}
