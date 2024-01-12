import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/utils/parse_date_time.dart';
import '../../domain/entities/git_repos_flutter_entity.dart';

class DetailsPage extends StatelessWidget {
  final String filePath;
  final GitReposFlutterEntity repo;
  const DetailsPage({super.key, required this.filePath, required this.repo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: CircleAvatar(
                radius: 100.0,
                backgroundImage: FileImage(File(filePath)),
                backgroundColor: Colors.transparent,
              ),
            ),
            repoInfoCard('Name', repo.name),
            repoInfoCard('Repository description', repo.description),
            repoInfoCard('Last Updated', formatDate(repo.updatedAt)),
          ]),
        ),
      ),
    );
  }

  Widget repoInfoCard(String title, String content) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}
