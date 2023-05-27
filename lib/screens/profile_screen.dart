import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:instagram_clone/widgets/profile_post.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final TextUtils _textUtils = TextUtils();

  int followers = 0;
  int following = 0;
  int post = 0;
  late TabController _tabController;
  ScrollController scrollController = ScrollController();
  late DocumentSnapshot userData;
  bool isLoading = false;
  int userState = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getUserStream();

    super.initState();
  }

  getUserStream() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .get();
    userData = data;
    post = userData['posts'].length;
    followers = userData['followers'].length;
    following = userData['following'].length;

//  Checking whether the  user profile is self profile, for own profile userState becomes 0, which means Edit Profile

    if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        userState = 0;
      });
    }
    // else , checking whether the user is followed by the current user,
    else {
      if (userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid)) {
        // if current user follows the user ,then  userState becomes 1, which mean following
        setState(() {
          userState = 1;
        });
      } else {
        // if current user not follows the user then useState becomes 2 , means Follow
        setState(() {
          userState = 2;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_sharp),
                      const SizedBox(
                        width: 5,
                      ),
                      _textUtils.bold18(userData['username'], Colors.white),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        child: Image.asset(
                          'assets/icons/add.png',
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 22,
                        child: Image.asset(
                          'assets/icons/menu.png',
                          color: primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 44,
                                  backgroundImage:
                                      NetworkImage(userData['avatarUrl']),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                _textUtils.bold16(
                                    userData['name'], Colors.white),
                                userData['bio'] == null
                                    ? SizedBox(
                                        height: 18,
                                      )
                                    : TextUtils()
                                        .normal15(userData['bio'], primaryColor)
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  profileBoxButtons(post, 'Posts'),
                                  profileBoxButtons(followers, 'Followers'),
                                  profileBoxButtons(following, 'Following'),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: userState == 0
                                  ? FollowButton(
                                      function: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                snap: userData,
                                              ),
                                            ))
                                            .whenComplete(
                                                () => getUserStream());
                                      },
                                      backgroundColor: mobileSearchColor,
                                      borderColor: Colors.transparent,
                                      label: "Edit Profile",
                                      textColor: primaryColor)
                                  : userState == 2
                                      ? FollowButton(
                                          function: () async {
                                            setState(() {
                                              userState = 1;
                                              followers++;
                                            });
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid']);
                                          },
                                          backgroundColor: blueColor,
                                          borderColor: Colors.transparent,
                                          label: "Follow",
                                          textColor: primaryColor)
                                      : FollowButton(
                                          function: () async {
                                            setState(() {
                                              userState = 2;
                                              followers--;
                                            });
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid']);
                                          },
                                          backgroundColor: mobileSearchColor,
                                          borderColor: Colors.transparent,
                                          label: "Following",
                                          textColor: primaryColor)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              flex: 5,
                              child: userState == 0
                                  ? FollowButton(
                                      backgroundColor: mobileSearchColor,
                                      borderColor: Colors.transparent,
                                      label: "Share Profile",
                                      textColor: primaryColor)
                                  : FollowButton(
                                      backgroundColor: mobileSearchColor,
                                      borderColor: Colors.transparent,
                                      label: "Message",
                                      textColor: primaryColor))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Column(children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.add,
                                    size: 45,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(
                                          side: BorderSide(
                                        color: Colors.white,
                                      )),
                                      padding: EdgeInsets.all(5),
                                      primary: Colors.transparent),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _textUtils.normal13('New', Colors.white)
                              ]),
                            ),
                            for (int i = 0; i < 7; i++) favouriteStoriesWidget()
                          ],
                        ),
                      ),
                    ),
                    TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 0.8,
                      indicatorPadding: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      controller: _tabController,
                      tabs: [
                        Icon(Icons.grid_on_outlined),
                        Icon(Icons.person_pin_circle_outlined)
                      ],
                    ),
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: [
                        post > 0
                            ? ProfilePost(uid: widget.uid)
                            : Center(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 70,
                                        weight: 1,
                                      ),
                                      Text(
                                        "No Post yet",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ]),
                              ),
                        GridView.count(
                          controller: scrollController,
                          crossAxisCount: 3,
                          children: [
                            for (int i = 0; i < 123; i++)
                              Container(
                                margin: EdgeInsets.only(right: 3, top: 3),
                                child: Image.network(
                                  "https://images.unsplash.com/photo-1683817411951-2134066fa3bb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=688&q=80",
                                  fit: BoxFit.cover,
                                ),
                              )
                          ],
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
  }

  Widget favouriteStoriesWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      ),
    );
  }

  //  Followers ,Following , Posts
  Widget profileBoxButtons(int number, String label) {
    return Column(
      children: [
        _textUtils.bold16(number.toString(), Colors.white),
        const SizedBox(height: 4),
        _textUtils.normal15(label, Colors.white)
      ],
    );
  }
}
