class Personaje {
  final String id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String origin;
  final String location;

  Personaje({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.origin,
    required this.location,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'image':image,
    'origin': origin,
    'location': location,
  };

  factory Personaje.fromMap(Map<String, dynamic> map) => Personaje(
        id: '${map['id'] ?? ''}',
        name: (map['name'] as String?) ?? 'Desconocido',
        status: (map['status'] as String?) ?? 'Unknown',
        species: (map['species'] as String?) ?? 'Unknown',
        image: (map['image'] as String?) ?? 'https://via.placeholder.com/150',
        origin: (map['origin'] as String?) ?? 'Unknown',
        location: (map['location'] as String?) ?? 'Unknown',
      );
}
