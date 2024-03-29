import 'package:flutter/material.dart';
import '../../../../core/utils/parse_date_time.dart';
import '../../domain/entities/git_repos_flutter_entity.dart';
import '../widgets/image_file.dart';

class DetailsPage extends StatefulWidget {
  final String filePath;
  final GitReposFlutterEntity repo;
  const DetailsPage({super.key, required this.filePath, required this.repo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: ImageFile(
                filePath: widget.filePath,
                userId: widget.repo.id.toString(),
                radius: 100.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            repoInfoCard('Name', widget.repo.name),
            repoInfoCard('Repository description', widget.repo.description),
            repoInfoCard('Stars', widget.repo.stargazersCount.toString()),
            repoInfoCard('Last Updated', formatDate(widget.repo.updatedAt)),
          ]),
        ),
      ),
    );
  }

  Widget repoInfoCard(String title, String content) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
      ),
    );
  }
}
