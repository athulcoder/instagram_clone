import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentNo = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Posts")
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentNo = snapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap['profileImage'])),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  widget.snap['username'],
                  style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                const SizedBox(
                  width: 3,
                ),
                const Icon(
                  Icons.verified,
                  color: Colors.blueAccent,
                  size: 15,
                )
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(microseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 230, 113, 113),
                      size: 120,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          // Like Comment section

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes']);
                        },
                        icon: widget.snap['likes'].contains(user.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              )),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            snap: widget.snap,
                          ),
                        ));
                      },
                      icon: Icon(Icons.comment)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border))
            ],
          ),

          // Description and number of likes

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Positioned(
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(text: ' '),
                          TextSpan(text: widget.snap['caption'])
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  // Number of comments and date published
                  DefaultTextStyle(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    child: Text(
                      'View all ${commentNo} comments',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Text(
                  //           'fy_joyal',
                  //           style: TextStyle(
                  //               color: primaryColor,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 15),
                  //         ),
                  //         SizedBox(
                  //           width: 6,
                  //         ),
                  //         Text('❤️😍💌')
                  //       ],
                  //     ),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: Icon(Icons.favorite),
                  //       color: Colors.red,
                  //       iconSize: 14,
                  //     )
                  //   ],
                  // ),

                  Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 10),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
