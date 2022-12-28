class LocationType {
  final int id;
  final String name;

  LocationType({required this.id, required this.name});

  factory LocationType.fromJson(Map<String, dynamic> json) =>
      LocationType(id: json['_id'], name: json['typeName']);
}
