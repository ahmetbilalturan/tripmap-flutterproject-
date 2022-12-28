class District {
  final int districtid;
  final String districtname;
  final String districtimageurl;
  final int districtlocationcount;
  final double districtavaragerating;

  const District({
    required this.districtid,
    required this.districtname,
    required this.districtimageurl,
    required this.districtlocationcount,
    required this.districtavaragerating,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        districtid: json["_id"],
        districtname: json['districtName'],
        districtimageurl: json['districtImageUrl'],
        districtlocationcount: json['districtLocationCount'],
        districtavaragerating: (json['districtAvarageRating']).toDouble(),
      );
}
