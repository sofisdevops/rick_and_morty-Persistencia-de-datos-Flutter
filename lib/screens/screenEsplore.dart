import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favourites_characters.dart';
import '../services/rickandmortyapi.dart';
import '../models/characters.dart';

class ScreenExplore extends StatefulWidget {
  const ScreenExplore({super.key});
  @override
  State<ScreenExplore> createState() => _ScreenExploreState();
}

class _ScreenExploreState extends State<ScreenExplore> {
  List<Personaje> _results = [];
  bool _isLoading = false;

  void _filtra(String status) async {
    setState(() => _isLoading = true);
    final results = await CharactersService().getCharacters(status: status);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el proveedor para saber qué canciones son favoritas
    final favProvider = context.watch<CharactersProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 149, 174),
        elevation: 0,
        title: Row(
          children: [
            Padding(padding: EdgeInsetsGeometry.only(left: 20)),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -10,
                  top: 10,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 202, 3),
                      border: Border.all(
                        color: const Color.fromARGB(255, 213, 147, 4),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 152, 4, 149),
                    border: Border.all(
                      color: const Color.fromARGB(255, 103, 6, 138),
                      width: 2.5,
                    ),
                  ),
                  child: const Text(
                    "RickAPI",
                    style: TextStyle(
                      fontFamily: 'Shlop',
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black,
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, //columnas
                  mainAxisSpacing: 5, //espacio y
                  crossAxisSpacing: 5, //espacio x
                  childAspectRatio: 1.2,
                ),

                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final characterito = _results[index];
                  final isFav = favProvider.favourites.any(
                    (t) => t.id == characterito.id,
                  );

                  return Card(
                    color: const Color(0xFFEFE7D1),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      children: [
                        Expanded(child: Container(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            characterito.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color(0xFF00B2FF),
                          child: const Text(
                            "Descripcion futura skdjaldj",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ]
        ),
      ),
    );
  }
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment
          .spaceBetween, // Empuja el texto a la izquierda y botón a la derecha
      crossAxisAlignment:
          CrossAxisAlignment.center, // Alinea el botón con la base del texto
      children: [
        // LADO IZQUIERDO: Títulos
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "MY GALACTIC",
                style: TextStyle(
                  fontFamily: 'Shlop',
                  fontSize: 100,
                  color: Color(0xFFB4FF00),
                  height: 0.9,
                ),
              ),
              const Text(
                "COLLECTION",
                style: TextStyle(
                  fontFamily: 'Shlop',
                  fontSize: 100,
                  color: Color.fromARGB(255, 5, 149, 174),
                  height: 0.9,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "Wubba Lubba dub-dub",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        _buildFilterButton(),
      ],
    ),
  );
}

Widget _buildFilterButton() {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        top: 4,
        left: 4,
        child: Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      Container(
        width: 200,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFB4FF00),
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: const Color(0xFFB4FF00),
            isExpanded: true,
            hint: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "FILTRA POR: ",
                style: TextStyle(
                  fontFamily: 'Shlop',
                  color: Colors.black,
                  fontSize: 40,
                ),
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            items: <String>['Estado', 'Especie', 'Locacion', 'Origen'].map((
              String value,
            ) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Shlop',
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    ],
  );
}
