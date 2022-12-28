class Location {
  final int id;
  final int locationtypeid;
  final int locationdistrictid;
  final String name;
  final List<String> imageurls;
  final String defination;
  final String coordinate;
  final double avaragerating;

  Location({
    required this.id,
    required this.locationtypeid,
    required this.locationdistrictid,
    required this.name,
    required this.imageurls,
    required this.defination,
    required this.coordinate,
    required this.avaragerating,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['_id'],
        locationtypeid: json['locationTypeId'],
        locationdistrictid: json['locationDistrictId'],
        name: json['locationName'],
        imageurls: List<String>.from(json['locationImageUrl']),
        defination: json['locationDefination'],
        coordinate: json['locationCoordinate'],
        avaragerating: (json['locationAvarageRating']).toDouble(),
      );
}
