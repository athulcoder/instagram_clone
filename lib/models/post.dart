class Post {
  final String caption;
  final String uid;
  final String profileImage;
  final String username;
  final String postId;
  final likes;
  final datePublished;
  final String postUrl;

  const Post(
      {required this.caption,
      required this.uid,
      required this.profileImage,
      required this.likes,
      required this.postId,
      required this.username,
      required this.datePublished,
      required this.postUrl});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profileImage": profileImage,
        "postId": postId,
        "likes": likes,
        "caption": caption,
        "datePublished": datePublished,
        "postUrl": postUrl
      };
}
