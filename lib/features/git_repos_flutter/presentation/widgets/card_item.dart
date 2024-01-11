import 'package:flutter/material.dart';

import '../../domain/entities/git_repos_flutter_entity.dart';

class ListViewScreen extends StatelessWidget {
  final List<GitReposFlutterEntity> repoList;
  const ListViewScreen({super.key, required this.repoList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: repoList.length,
        itemBuilder: (context, index) {
          final user = repoList[index];
          final avatarUrl = user.owner.avatarUrl;
          // startDownloading(
          //     repoListData!.items[index].owner.avatarUrl, index);
          // _downloadFile(repoListData!.items[index].owner.avatarUrl);
          // downloadImage(repoListData!.items[index].owner.avatarUrl);
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Column(children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 27.0,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  color: const Color.fromARGB(255, 188, 185, 185),
                  height: 0.9,
                ),
              ]));
        });
  }
}
