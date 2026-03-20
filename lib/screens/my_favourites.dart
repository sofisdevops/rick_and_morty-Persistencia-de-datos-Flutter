import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favourites_characters.dart';

class MyFavourites extends StatelessWidget {
  const MyFavourites({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharactersProvider>();
    final favs = provider.favourites;

    return Scaffold(
      body: Column(
        children: [
          favs.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 200),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 23, 119, 57),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4ade80),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons
                                .search_off_rounded, // Un icono que indique "vacío"
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No se han detectado entidades en la dimensión 200",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Shlop',
                            color: Color(0xFF4ade80),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 8.0,
                                color: Color.fromARGB(255, 67, 155, 30),
                                offset: Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "¡Ve a la sección de personajes y elige a tus favoritos!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 23, 119, 57),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${favs.length} " +
                                  "Entidades detectadas en la dimensión  200",
                              style: TextStyle(
                                fontFamily: 'Shlop',
                                color: Color(0xFF4ade80),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Color.fromARGB(255, 67, 155, 30),
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favs.length,
                          itemBuilder: (context, index) {
                            final personaje = favs[index];
                            return Card(
                              elevation: 8,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 159,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 23, 28, 37),
                                  border: Border(
                                    left: BorderSide(
                                      color: personaje.status == "Alive"
                                          ? Color.fromARGB(255, 34, 197, 94)
                                          : Color.fromARGB(255, 66, 27, 107),
                                      width: 8,
                                    ),
                                    right: BorderSide(
                                      color: personaje.status == "Alive"
                                          ? Color.fromARGB(255, 34, 197, 94)
                                          : Color.fromARGB(255, 66, 27, 107),
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: personaje.status == "Alive"
                                          ? Color.fromARGB(255, 34, 197, 94)
                                          : Color.fromARGB(255, 66, 27, 107),
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: personaje.status == "Alive"
                                          ? Color.fromARGB(255, 34, 197, 94)
                                          : Color.fromARGB(255, 66, 27, 107),
                                      width: 1,
                                    ),
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    SizedBox(width: 30),
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(60),
                                        border: Border.all(
                                          color: Color(0xFF97ce4c),
                                          width: 4,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                              255,
                                              70,
                                              120,
                                              70,
                                            ),
                                            blurRadius: 2,
                                            spreadRadius: 4,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.network(
                                          personaje.image,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          personaje.name,
                                          style: TextStyle(
                                            fontFamily: 'GoodBrush',
                                            color: personaje.status == "Dead"
                                                ? Color(0xFF8d939e)
                                                : Color(0xFF4ade80),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                color:
                                                    personaje.status == "Dead"
                                                    ? Color(0xFF8d939e)
                                                    : Color(0xFF4ade80),
                                                offset: Offset(5.0, 5.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          personaje.species,
                                          style: TextStyle(
                                            fontFamily: 'JMH',
                                            color: Color(0xFFC084FC),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                color: Color.fromARGB(
                                                  255,
                                                  67,
                                                  155,
                                                  30,
                                                ),
                                                offset: Offset(5.0, 5.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 470),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          personaje.location,
                                          style: TextStyle(
                                            fontFamily: 'JMH',
                                            color: Color(0xFF676d7b),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          personaje.origin,
                                          style: TextStyle(
                                            fontFamily: 'JMH',
                                            color: personaje.status == "Alive"
                                                ? Color(0xFFcfd4d9)
                                                : Color(0xFF676d7b),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 200,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF10131b),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: personaje.status == 'Alive'
                                              ? const Color.fromARGB(
                                                  255,
                                                  20,
                                                  54,
                                                  40,
                                                )
                                              : const Color.fromARGB(
                                                  255,
                                                  102,
                                                  10,
                                                  10,
                                                ),
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10),
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              color: personaje.status == "Alive"
                                                  ? Color(0xFF4ade80)
                                                  : Color(0xFFef4444),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 10.0,
                                                  color:
                                                      personaje.status ==
                                                          "Alive"
                                                      ? Color(0xFF4ade80)
                                                      : Color(0xFFef4444),
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Status: " + personaje.status,
                                            style: TextStyle(
                                              fontFamily: 'JMH',
                                              color: personaje.status == "Alive"
                                                  ? Color(0xFF4ade80)
                                                  : Color(0xFFd63e3f),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 50),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          provider.toggleFavourite(personaje),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
