import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_post_list.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfilePost extends StatefulWidget {
  final uid;
  const ProfilePost({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  late var postDetails;
  bool isLoading = false;
  bool _showPreview = false;
  late OverlayEntry entry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Posts")
            .where("uid", isEqualTo: widget.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 0, mainAxisSpacing: 0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot snap = snapshot.data!.docs[index];
                return GestureDetector(
                  onLongPressStart: (details) {
                    OverlayState state = Overlay.of(context);
                    entry = OverlayEntry(builder: (context) {
                      return Center(
                        child: Container(
                          width: double.infinity,
                          height: 500,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: mobileSearchColor),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 12, right: 12, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    color: mobileSearchColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25))),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage:
                                          NetworkImage(snap['profileImage']),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    DefaultTextStyle(
                                      style: TextStyle(
                                          fontSize: 14, color: primaryColor),
                                      child: Text(snap['username']),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snap['postUrl']))),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                color: mobileSearchColor,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite_outline_rounded),
                                      Icon(Icons.comment_rounded),
                                      Icon(Icons.send),
                                      Icon(Icons.more_vert),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      );
                    });
                    state.insert(entry);
                  },
                  onLongPressEnd: ((details) {
                    entry.remove();
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(snap['postUrl']))),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePostList(
                        uid: snap['uid'],
                        startIndex: index,
                      ),
                    ));
                  },
                );
              });
        });
  }
}
