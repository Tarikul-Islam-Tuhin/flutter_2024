import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/bloc_providers/bloc_providers.dart';
import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('sessionBox');
  await Hive.openBox('reposBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AllBlocProviders.getAllBlocProviders],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Git Repos Flutter',
        theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black87,
            )),
        home: const HomePage(),
      ),
    );
  }
}
