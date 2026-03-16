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
    id: map['id'],
    name: map['name'],
    status: map['status'],
    species: map['species'],
    image: map['image'],
    origin: map['origin'],
    location: map['location'],
  );
}
