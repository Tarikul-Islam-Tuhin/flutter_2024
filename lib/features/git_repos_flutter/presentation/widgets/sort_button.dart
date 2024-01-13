import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/params/params.dart';
import '../bloc/git_repos_flutter_bloc.dart';

class SortButton extends StatelessWidget {
  final String label;
  final String sortType;
  final String blocSortState;

  const SortButton({
    Key? key,
    required this.label,
    required this.sortType,
    required this.blocSortState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        BlocProvider.of<GitReposFlutterBloc>(context).add(
          GitReposFilteredEvent(
            params: Params(
              updated: sortType == 'updated' ? 'updated' : '',
              stars: sortType == 'stars' ? 'stars' : '',
            ),
          ),
        );
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          color: blocSortState == sortType ? Colors.blue : Colors.white,
        ),
      ),
    );
  }
}
