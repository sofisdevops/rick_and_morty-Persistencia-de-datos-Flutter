class Characters {
  final String id;
  final String name;
  final String status;
  final String image;
  final String origin;
  final String location;

  Characters({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
    required this.origin,
    required this.location,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'status': status,
    'image': image,
    'origin': origin,
    'location': location,
  };

  factory Characters.fromMap(Map<String, dynamic> map) => Characters(
    id: map['id'],
    name: map['name'],
    status: map['status'],
    image: map['image'],
    origin: map['origin'],
    location: map['location'],
  );
}
