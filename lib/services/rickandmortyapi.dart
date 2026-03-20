import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/characters.dart';

class CharactersService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<List<Personaje>> getCharacters({String status = '',String name =''}) async {
    String statusFilter = (status == 'All') ? '' : status;
    final url = Uri.parse('$_baseUrl?status=$statusFilter&name=$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final results = data['results'];
        if (results is! List) {
          return <Personaje>[];
        }

        return results.map<Personaje>((dynamic raw) {
          final item = raw as Map<String, dynamic>;
          final originMap = item['origin'];
          final locationMap = item['location'];
          final originName = originMap is Map<String, dynamic>
              ? (originMap['name'] as String?) ?? 'Unknown'
              : 'Unknown';
          final locationName = locationMap is Map<String, dynamic>
              ? (locationMap['name'] as String?) ?? 'Unknown'
              : 'Unknown';

          return Personaje(
            id: '${item['id'] ?? ''}',
            name: (item['name'] as String?) ?? 'Desconocido',
            status: (item['status'] as String?) ?? 'Unknown',
            species: (item['species'] as String?) ?? 'Unknown',
            image: (item['image'] as String?) ??
                'https://via.placeholder.com/150',
            origin: originName,
            location: locationName,
          );
        }).toList();
      } else {
        throw 'Error en la respuesta del servidor: ${response.statusCode}';
      }
    } catch (e) {
      throw 'No se pudo conectar con la el portal API : $e';
    }
  }
}
