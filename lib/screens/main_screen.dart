import 'package:flutter/material.dart';
import 'package:rickapi/screens/home_screen.dart';
import 'package:rickapi/screens/screenEsplore.dart';
import 'package:rickapi/screens/my_favourites.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de pantallas para navegar
  // El orden debe coincidir con los índices del BottomNavigationBar.
  // 0: Search/Explore, 1: Home, 2: Favoritos.
  final List<Widget> _pages = [
    const ScreenExplore(),
    const HomeScreen(),
    const MyFavourites(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 24, 77, 52),
            height: 2.0,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 35, 37),
        title: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mi Multiverso Squad",
                      style: TextStyle(
                        fontFamily: 'Shlop',
                        color: Color(0xFF4ade80),
                        fontSize: 80,
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
                    Row(
                      children: [
                        Text(
                          "ESCÁNER ACTIVO:  ",
                          style: TextStyle(
                            fontFamily: 'JMH',
                            color: Color(0xFF44c674),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        TweenAnimationBuilder<double>(
                          key: ValueKey(_currentIndex),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 3),
                          builder: (context, value, child) {
                            return Container(
                              width: 200,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFF121611),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF392255),
                                  width: 2,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 200 * value,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      137,
                                      184,
                                      71,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    // EFECTO DE BRILLO NEÓN
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          255,
                                          137,
                                          184,
                                          71,
                                        ).withValues(),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 30),
                        Text(
                          "PORTAL CARGADO EN: " 
                              '${_currentIndex == 0
                                  ? "Explorar"
                                  : _currentIndex == 1
                                      ? "Home"
                                      : _currentIndex == 2
                                          ? "Favoritos"
                                          : "Desconocido"}',
                          style: TextStyle(
                            fontFamily: 'JMH',
                            color: Color(0xFF9e70d1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(222, 43, 51, 79),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 17, 105, 48),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 17, 105, 48),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Squad_V2.0.4",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
              ],
            ),
            Row(children: [
                
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(
        // Mantener el estado de las pantallas aunque se cambie de screen
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
          left: 60,
          right: 60,
        ), // Agrega espacio alrededor
        child: Container(
          // 1. Establecemos un alto personalizado
          height: 90,
          decoration: BoxDecoration(
            // 2. Color de fondo oscuro
            color: const Color(0xFF2C353F),
            // 3. Borde verde brillante
            border: Border.all(
              color: const Color(0xFFB4FF00), // Verde lima
              width: 3.0, // Grosor del borde
            ),
            // 4. Bordes redondeados para que parezca una píldora
            borderRadius: BorderRadius.circular(45),
            // 5. Sombra suave opcional
            boxShadow: [
              BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors
                .transparent, // Fondo transparente para ver el del Container
            elevation: 0, // Eliminamos la sombra predeterminada
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.blueAccent, size: 35),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.bolt_outlined,
                  color: const Color.fromARGB(255, 236, 247, 144),
                  size: 45,
                ),
                label: "home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.blueAccent,
                  size: 35,
                ),
                label: "favorite",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
