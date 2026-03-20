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
  final SearchController _searchController = SearchController();
  List<Personaje> _allResults = [];
  List<Personaje> _results = [];
  String _searchQuery = '';
  bool _isLoading = false;

  /// Valores mostrados en el dropdown; la API usa '' o 'All' para todos.
  String _statusFilter = 'All';

  Future<void> _filtra(String status) async {
    setState(() => _isLoading = true);
    final results = await CharactersService().getCharacters(
      status: status.isEmpty ? 'All' : status,
      name: '',
    );
    if (!mounted) return;
    setState(() {
      _allResults = results;
      _applySearch(_searchController.text);
      _isLoading = false;
    });
  }

  void _applySearch(String query) {
    _searchQuery = query.trim().toLowerCase();
    if (_searchQuery.isEmpty) {
      _results = List<Personaje>.from(_allResults);
      return;
    }

    _results = _allResults.where((personaje) {
      return personaje.name.toLowerCase().contains(_searchQuery) ||
          personaje.species.toLowerCase().contains(_searchQuery) ||
          personaje.origin.toLowerCase().contains(_searchQuery) ||
          personaje.location.toLowerCase().contains(_searchQuery) ||
          personaje.id.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _onStatusChanged(String? value) {
    if (value == null) return;
    setState(() => _statusFilter = value);
    final apiStatus = value == 'All' ? '' : value;
    _filtra(apiStatus);
  }

  @override
  void initState() {
    super.initState();
    _filtra('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final favProvider = context.watch<CharactersProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: 1400,
                  constraints: const BoxConstraints(maxWidth: 1400),
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFF0C1712),
                    border: Border.all(
                      color: const Color(0xFF72F000),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF72F000).withValues(alpha: 0.42),
                        blurRadius: 22,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: SearchAnchor(
                            searchController: _searchController,
                            builder:
                                (BuildContext context, SearchController controller) {
                              return SearchBar(
                                controller: controller,
                                backgroundColor: const WidgetStatePropertyAll(
                                  Color(0xFF111D17),
                                ),
                                elevation: const WidgetStatePropertyAll(0),
                                side: const WidgetStatePropertyAll(
                                  BorderSide(
                                    color: Color(0xFF274836),
                                    width: 1.2,
                                  ),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                hintText:
                                    'Busca la genetica loka (e.g. Rick C-137)...',
                                hintStyle: const WidgetStatePropertyAll(
                                  TextStyle(
                                    fontFamily: 'JMH',
                                    color: Color(0xFF667A6F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                textStyle: const WidgetStatePropertyAll(
                                  TextStyle(
                                    fontFamily: 'JMH',
                                    color: Color(0xFFE8F1EC),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                padding:
                                    const WidgetStatePropertyAll<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 0,
                                  ),
                                ),
                                onTap: () {
                                  controller.openView();
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _applySearch(value);
                                  });
                                  controller.openView();
                                },
                                leading: const Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF72F000),
                                  size: 24,
                                ),
                                trailing: <Widget>[
                                  if (controller.text.isNotEmpty)
                                    IconButton(
                                      tooltip: 'Limpiar',
                                      onPressed: () {
                                        controller.clear();
                                        setState(() {
                                          _applySearch('');
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xFF95A89D),
                                        size: 20,
                                      ),
                                    ),
                                  Container(
                                    width: 1.2,
                                    height: 22,
                                    color: const Color(0xFF2A3F33),
                                  ),
                                ],
                              );
                            },
                            suggestionsBuilder:
                                (BuildContext context, SearchController controller) {
                              final query = controller.text.trim().toLowerCase();
                              final suggestions = _allResults
                                  .where((personaje) {
                                    if (query.isEmpty) return true;
                                    return personaje.name
                                            .toLowerCase()
                                            .contains(query) ||
                                        personaje.id.toLowerCase().contains(
                                              query,
                                            );
                                  })
                                  .take(60)
                                  .toList();

                              return List<ListTile>.generate(suggestions.length, (
                                int index,
                              ) {
                                final character = suggestions[index];
                                return ListTile(
                                  tileColor: const Color(0xFF111D17),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text(
                                    character.name,
                                    style: const TextStyle(
                                      fontFamily: 'JMH',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'ID: ${character.id} - ${character.species}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      controller.text = character.name;
                                      _applySearch(character.name);
                                      controller.closeView(character.name);
                                    });
                                  },
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 200,
                          child: _StatusFilterDropdown(
                            value: _statusFilter,
                            onChanged: _onStatusChanged,
                          ),
                        ),
                      ],
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
                                : characterito.status == 'Unknown'
                                ? const Color(0xFFEFE7D1)
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
                                    child: Image.network(
                                      characterito.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        characterito.name,
                                        style: const TextStyle(
                                          fontFamily: 'GoodBrush',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        characterito.location,
                                        style: const TextStyle(
                                          fontFamily: 'JMH',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        characterito.origin,
                                        style: const TextStyle(
                                          fontFamily: 'JMH',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        characterito.species,
                                        style: const TextStyle(
                                          fontFamily: 'JMH',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  color: characterito.status == 'Dead'
                                      ? const Color.fromARGB(255, 149, 6, 49)
                                      : characterito.status == 'Alive'
                                      ? const Color.fromARGB(255, 6, 149, 75)
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
                              onPressed: () =>
                                  favProvider.toggleFavourite(characterito),
                              icon: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.heart_broken_rounded,
                                color: const Color.fromARGB(255, 140, 1, 1),
                              ),
                            ),
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

/// Filtro por estado (Alive / Dead / Unknown / All) al lado del SearchBar.
class _StatusFilterDropdown extends StatelessWidget {
  const _StatusFilterDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  static const _items = <String>['All', 'Alive', 'Dead', 'Unknown'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111D17),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF274836), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF111D17),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF72F000),
          ),
          style: const TextStyle(
            fontFamily: 'JMH',
            color: Color(0xFFE8F1EC),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          hint: const Text(
            'Estado',
            style: TextStyle(
              fontFamily: 'JMH',
              color: Color(0xFF667A6F),
              fontSize: 14,
            ),
          ),
          items: _items.map((s) {
            return DropdownMenuItem<String>(
              value: s,
              child: Text(
                s == 'All' ? 'Todos' : s,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}