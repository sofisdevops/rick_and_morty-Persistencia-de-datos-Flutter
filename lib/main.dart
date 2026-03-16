import 'package:flutter/material.dart';
import 'screens/screenEsplore.dart';
import 'provider/favourites_characters.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CharactersProvider()),
    ],
    child: const RickAPI(),
    ),
  );
}

class RickAPI extends StatelessWidget {
  const RickAPI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Rick And Morty API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 42, 5),
      ),
      home: const ScreenExplore(),
    );
  }
}