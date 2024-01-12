import 'package:path_provider/path_provider.dart';

Future<String> getImagePath(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/$fileName";
}

Future<String> getFilePath() async {
  final dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/";
}
