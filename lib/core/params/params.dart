import 'package:equatable/equatable.dart';

class Params extends Equatable {
  final String? stars;
  final String? updated;
  final int? page;
  const Params({this.stars, this.updated, this.page});
  @override
  List<Object?> get props => [stars, updated, page];
}
