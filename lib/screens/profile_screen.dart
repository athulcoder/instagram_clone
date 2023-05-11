import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followersNum = 0;
  int followingNum = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      // get post length

      var postSnap = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLength = postSnap.docs.length;

      followersNum = userSnap.data()!['followers'].length;
      followingNum = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(userData['avatarUrl'])),
                          TextButton(
                              onPressed: () {},
                              child: buildStateCoulmn(postLength, 'Posts')),
                          TextButton(
                              onPressed: () {},
                              child:
                                  buildStateCoulmn(followersNum, 'Followers')),
                          TextButton(
                              onPressed: () {},
                              child:
                                  buildStateCoulmn(followingNum, 'Following'))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['username'],
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(userData['bio'])
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? FollowButton(
                                  backgroundColor:
                                      Color.fromARGB(255, 39, 38, 38),
                                  borderColor: Colors.grey,
                                  label: 'Edit Profile',
                                  textColor: primaryColor,
                                  function: () {},
                                )
                              : isFollowing
                                  ? FollowButton(
                                      backgroundColor:
                                          Color.fromARGB(255, 39, 38, 38),
                                      borderColor: Colors.grey,
                                      label: 'Following',
                                      textColor: primaryColor,
                                      function: () {},
                                    )
                                  : FollowButton(
                                      backgroundColor: blueColor,
                                      borderColor: Colors.grey,
                                      label: 'Follow',
                                      textColor: primaryColor,
                                      function: () {},
                                    ),
                          FollowButton(
                            backgroundColor: Color.fromARGB(255, 39, 38, 38),
                            borderColor: Colors.grey,
                            label: 'Share Profile',
                            textColor: primaryColor,
                            function: () {},
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 39, 38, 38),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.person_add_outlined,
                                  size: 15,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  thickness: .2,
                  color: primaryColor,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("Posts")
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 0.1,
                              mainAxisSpacing: 0.1,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStateCoulmn(int number, String label) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: const TextStyle(
              fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold),
        ),
        Text(
          label.toString(),
          style: const TextStyle(fontSize: 11, color: primaryColor),
        )
      ],
    );
  }
}
