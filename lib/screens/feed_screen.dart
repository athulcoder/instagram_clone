import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
              height: 32,
            ),
            SizedBox(
              width: 6,
            ),
            Icon(Icons.keyboard_arrow_down_rounded)
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Container(
                  height: 25,
                  child: Image.asset(
                    'assets/icons/messenger.png',
                    color: primaryColor,
                  ))),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Posts")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                PostCard(snap: snapshot.data!.docs[index].data()),
          );
        },
      ),
    );
  }
}
