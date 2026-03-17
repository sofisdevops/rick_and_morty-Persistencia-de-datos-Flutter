import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rickandmortyapi.dart';
import '../provider/favourites_characters.dart';
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
  void initState() {
    super.initState();
    _filtra('');
  }

  Widget build(BuildContext context) {
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
            //boton de filtro
            Stack(
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
                          "FILTRA POR: Estado ",
                          style: TextStyle(
                            fontFamily: 'Shlop',
                            color: Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      items: <String>['All', 'Alive', 'Dead', 'Unknown'].map((
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
                      onChanged: (String? newValue) {
                        _filtra(newValue ?? "");
                      },
                    ),
                  ),
                ),
              ],
            ),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, //columnas
                          mainAxisSpacing: 5, //espacio y
                          crossAxisSpacing: 2, //espacio x
                          childAspectRatio: 0.65,
                        ),

                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final characterito = _results[index];
                      final isFav = favProvider.favourites.any(
                        (t) => t.id == characterito.id,
                      );
        
                      return Stack(
                        
                        children: [
                          
                          Card(
                            margin: const EdgeInsets.all(15),
                            color: characterito.status == 'Dead'
                            ? const Color.fromARGB(255, 252, 217, 217) 
                            : characterito.status == 'Unknown' ?  const Color(0xFFEFE7D1)
                            : const Color.fromARGB(255, 209, 228, 239),
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(characterito.image,fit: BoxFit.cover,),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8,),
                                      Text(
                                        characterito.name,
                                        style: const TextStyle(
                                          fontFamily: 'GoodBrush',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8,),
                                      Text(
                                        characterito.location,
                                        style: const TextStyle(
                                          fontFamily: 'JMH',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8,),
                                      Text(
                                        characterito.origin,
                                        style: const TextStyle(
                                          fontFamily: 'JMH',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8,),
                                      Text(
                                        characterito.species,
                                        style: const TextStyle(
                                          fontFamily: 'JMH',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  color: characterito.status == 'Dead' 
                                  ? const Color.fromARGB(255, 149, 6, 49) 
                                  : characterito.status == 'Alive' ?
                                   const Color.fromARGB(255, 6, 149, 75) 
                                      : const Color.fromARGB(255, 6, 97, 149),

                                  child: Text(
                                    characterito.status,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 249, 247, 228),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: 'JMH',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Container(
                            margin: const EdgeInsets.only(left: 250),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 193, 7),
                              border: Border.all(
                                color: Colors.amber,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () => favProvider.toggleFavourite(characterito) , 
                              icon: Icon(
                                isFav ? Icons.favorite
                                : Icons.heart_broken_rounded,
                                color: const Color.fromARGB(255, 140, 1, 1) ,)) ,
                          ),
                        
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
      ],
    ),
  );
}
