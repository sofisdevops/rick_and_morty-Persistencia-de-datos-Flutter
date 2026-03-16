import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/characters.dart';

class CharactersService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<List<Personaje>> getCharacters({String status = ''}) async {
    String statusFilter = (status == 'all') ? '' : status;
    final url = Uri.parse('$_baseUrl?status=$statusFilter');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['results'];
        return results.map((item) {
          return Personaje(
            id: item['id'].toString(),
            name: item['name'] ?? 'Desconocido',
            status: item['status'] ?? 'Unknown',
            species: item['species'] ?? 'Unknown',
            image: item['image'] ?? 'https://via.placeholder.com/150',
            origin: item['origin']['name'],
            location: item['location']['name'],
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
