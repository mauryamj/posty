import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posty/data/repository/data_call.dart';
import 'package:posty/ui/home/home_page.dart';
import 'package:posty/ui/home/bloc/home_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => DataFormatRepository(),
      child: BlocProvider(
        create: (context) => HomeBloc(context.read<DataFormatRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
