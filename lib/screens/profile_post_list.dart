import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProfilePostList extends StatefulWidget {
  final int startIndex;
  final uid;
  ProfilePostList({super.key, required this.uid, required this.startIndex});

  @override
  State<ProfilePostList> createState() => _ProfilePostListState();
}

class _ProfilePostListState extends State<ProfilePostList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextUtils().bold16('Posts', primaryColor),
        ),
        body: StreamBuilder(
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

            return ScrollablePositionedList.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data!.docs[index];
                  return PostCard(snap: snap);
                },
                initialScrollIndex: widget.startIndex);
          },
        ));
  }
}
