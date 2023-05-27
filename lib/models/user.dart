class User {
  final String email;
  final String uid;
  final String avatarUrl;
  final String username;
  final String bio;
  final String name;
  final List followers;
  final List following;
  final List posts;

  const User(
      {required this.email,
      required this.uid,
      required this.avatarUrl,
      required this.name,
      required this.followers,
      required this.following,
      required this.username,
      required this.posts,
      required this.bio});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "avatarUrl": avatarUrl,
        "bio": bio,
        'fullname': name,
        "followers": followers,
        "following": following,
        "posts": posts
      };
}
