import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/characters.dart';
import '../provider/favourites_characters.dart';
import '../services/rickandmortyapi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeData {
  final List<Personaje> alive;
  final List<Personaje> dead;

  const _HomeData(this.alive, this.dead);
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<_HomeData> _homeFuture;
  Personaje? _featuredCharacter;

  @override
  void initState() {
    super.initState();
    _homeFuture = _loadData();
  }

  Future<_HomeData> _loadData() async {
    final alive = await CharactersService().getCharacters(status: 'Alive');
    final dead = await CharactersService().getCharacters(status: 'Dead');
    final merged = [...alive, ...dead];

    if (merged.isNotEmpty) {
      _featuredCharacter = merged.first;
    }

    return _HomeData(alive, dead);
  }

  void _nextCharacter(_HomeData data) {
    final merged = [...data.alive, ...data.dead];
    if (merged.isEmpty) {
      return;
    }

    if (merged.length == 1) {
      setState(() {
        _featuredCharacter = merged.first;
      });
      return;
    }

    setState(() {
      final currentId = _featuredCharacter?.id;
      final currentIndex = merged.indexWhere((p) => p.id == currentId);
      final nextIndex = (currentIndex < 0 || currentIndex + 1 >= merged.length)
          ? 0
          : currentIndex + 1;
      _featuredCharacter = merged[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<CharactersProvider>().favourites;

    return Scaffold(
      body: FutureBuilder<_HomeData>(
        future: _homeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error al cargar el Home: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final aliveCount = data.alive.length;
          final deadCount = data.dead.length;
          final merged = [...data.alive, ...data.dead];
          final featured = _featuredCharacter ?? (merged.isNotEmpty ? merged.first : null);

          if (_featuredCharacter == null && featured != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _featuredCharacter != null) {
                return;
              }
              setState(() {
                _featuredCharacter = featured;
              });
            });
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF020A06),
                  Color(0xFF07150F),
                  Color(0xFF03120B),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          title: 'VIVOS',
                          value: aliveCount.toString(),
                          color: const Color(0xFFB4FF00),
                          icon: Icons.favorite,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatsCard(
                          title: 'MUERTOS',
                          value: deadCount.toString(),
                          color: const Color(0xFFFF5A58),
                          icon: Icons.dangerous_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatsCard(
                          title: 'FAVORITOS',
                          value: favs.length.toString(),
                          color: const Color(0xFFC084FC),
                          icon: Icons.star,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (featured != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildFeaturedCard(
                            featured,
                            onNext: () => _nextCharacter(data),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildNewsCard(
                            featured: featured,
                            aliveCount: aliveCount,
                            deadCount: deadCount,
                            favsCount: favs.length,
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF19372A),
                          width: 1.2,
                        ),
                        color: const Color(0xFF0A1510),
                      ),
                      child: Text(
                        'No hay personajes disponibles para mostrar la carta y las noticias.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'JMH',
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 340,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1F3B2A), width: 1.3),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF05140D),
            Color(0xFF041009),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4FF00).withValues(),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'ACCESS GRANTED',
                    style: TextStyle(
                      fontFamily: 'JMH',
                      color: Color(0xFFB4FF00),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'MI HOME DEL',
                  style: TextStyle(
                    fontFamily: 'Shlop',
                    fontSize: 56,
                    color: Colors.white,
                    height: 0.9,
                  ),
                ),
                const Text(
                  'MULTIVERSO',
                  style: TextStyle(
                    fontFamily: 'Shlop',
                    fontSize: 56,
                    color: Color(0xFFB4FF00),
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Explora personajes, monitorea tus estadísticas y descubre nuevos perfiles del multiverso.',
                  style: TextStyle(
                    fontFamily: 'JMH',
                    color: Colors.white.withValues(),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _heroActionButton(
                      label: 'Rick-API',
                      filled: true,
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
              width: 390,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroActionButton({required String label, required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFB4FF00) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB4FF00).withValues(),
          width: 1.4,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.black : const Color(0xFFC7F59A),
          fontFamily: 'JMH',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF19372A), width: 1.2),
        color: const Color(0xFF0A1510),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(),
                  fontFamily: 'JMH',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const Spacer(),
              Icon(icon, color: Colors.white.withValues(), size: 34),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Shlop',
              color: color,
              fontSize: 44,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Personaje p, {required VoidCallback onNext}) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF19372A), width: 1.2),
        color: const Color(0xFF0A1510),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              p.image,
              width: 160,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERSONAJE AL AZAR',
                  style: TextStyle(
                    color: Colors.white.withValues(),
                    fontFamily: 'JMH',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Shlop',
                    color: Colors.white,
                    fontSize: 42,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(p.status, const Color(0xFFB4FF00)),
                    _chip(p.species, const Color(0xFF8BE9FD)),
                    _chip('ORIGEN: ${p.origin}', const Color(0xFFC084FC)),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Ver Expediente Completo',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'JMH',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onNext,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2A4F3A),
                          ),
                        ),
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues()),
        color: color.withValues(),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontFamily: 'JMH',
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    required Personaje featured,
    required int aliveCount,
    required int deadCount,
    required int favsCount,
  }) {
    return Container(
      height: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF19372A), width: 1.2),
        color: const Color(0xFF0A1510),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOTICIAS RÁPIDAS',
            style: TextStyle(
              fontFamily: 'JMH',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          _newsLine('Brecha detectada en dimensión ${featured.id}.'),
          _newsLine(
            'Estado global: $aliveCount vivos / $deadCount muertos.',
          ),
          _newsLine('Favoritos guardados por ti: $favsCount.'),
          _newsLine('Último perfil analizado: ${featured.name}.'),
          const Spacer(),
          Text(
            'Wubba Lubba dub-dub',
            style: TextStyle(
              color: Colors.white.withValues(),
              fontFamily: 'JMH',
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF101E17),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(),
            fontFamily: 'JMH',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

