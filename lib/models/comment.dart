class Comment {
  final int id;
  final int userID;
  final int locationID;
  final double rating;
  final String content;

  const Comment({
    required this.id,
    required this.userID,
    required this.locationID,
    required this.rating,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['_id'],
        userID: json['commentUserId'],
        locationID: json['commentLocationId'],
        rating: (json['commentRating']).toDouble(),
        content: json['commentContent'],
      );
}
