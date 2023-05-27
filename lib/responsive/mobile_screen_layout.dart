import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  late String _avatarUrl;

  void getAvatarFromSever() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _avatarUrl = snap['avatarUrl'];
    });
  }

  @override
  void initState() {
    super.initState();
    getAvatarFromSever();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

// Navigation Menu Function
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        border: Border(top: BorderSide(color: primaryColor, width: .1)),
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                  height: 25,
                  child: _page == 0
                      ? Image.asset(
                          'assets/icons/home(1).png',
                          color: primaryColor,
                        )
                      : Image.asset(
                          'assets/icons/home.png',
                          color: primaryColor,
                        )),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Container(
                  height: 25,
                  child: _page == 1
                      ? Image.asset(
                          'assets/icons/search.png',
                          color: primaryColor,
                        )
                      : Image.asset(
                          'assets/icons/search-interface-symbol.png',
                          color: primaryColor,
                        )),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Container(
                  height: 25,
                  child: _page == 2
                      ? Image.asset(
                          'assets/icons/plus(1).png',
                          color: primaryColor,
                        )
                      : Image.asset(
                          'assets/icons/plus.png',
                          color: primaryColor,
                        )),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Container(
                  height: 25,
                  child: _page == 3
                      ? Image.asset(
                          'assets/icons/like(1).png',
                          color: primaryColor,
                        )
                      : Image.asset(
                          'assets/icons/like.png',
                          color: primaryColor,
                        )),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: _avatarUrl != null
                  ? CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(_avatarUrl),
                    )
                  : Icon(
                      Icons.person,
                      color: _page == 4 ? primaryColor : secondaryColor,
                    ),
              label: '',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
