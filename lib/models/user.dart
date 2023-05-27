class User {
  final String email;
  final String uid;
  final String avatarUrl;
  final String username;
  final String bio;
  final String fullname;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.uid,
      required this.avatarUrl,
      required this.fullname,
      required this.followers,
      required this.following,
      required this.username,
      required this.bio});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "avatarUrl": avatarUrl,
        "bio": bio,
        'fullname': fullname,
        "followers": followers,
        "following": following,
      };
}
