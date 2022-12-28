class TripRoute {
  final int id;
  final int userid;
  final String routelocationname;
  final String date;

  TripRoute(
      {required this.id,
      required this.userid,
      required this.routelocationname,
      required this.date});

  factory TripRoute.fromJson(Map<String, dynamic> json) => TripRoute(
        id: json['_id'],
        userid: json['routeUserId'],
        routelocationname: json['routeLocations'],
        date: json['routeDate'],
      );
}
