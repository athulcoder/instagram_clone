import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List _allResult = [];
  List _searchResult = [];
  TextEditingController _searchController = TextEditingController();

  getUserStream() async {
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .orderBy('username')
        .get();

    setState(() {
      _allResult = data.docs;
    });
    searchUser();
  }

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchUser();
  }

  searchUser() {
    setState(() {});
    var showResult = [];

    if (_searchController.text != "") {
      for (var userSnapshot in _allResult) {
        var username = userSnapshot['username'].toString().toLowerCase();
        if (username.contains(_searchController.text.toLowerCase())) {
          showResult.add(userSnapshot);
        }
      }
      setState(() {
        _searchResult = showResult;
      });
    } else {
      setState(() {
        _searchResult = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getUserStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Search username...',
          ),
        ),
        body: _searchController.text.isNotEmpty
            ? _searchResult.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: _searchResult[index]['uid']),
                        )),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage:
                                NetworkImage(_searchResult[index]['avatarUrl']),
                          ),
                          title: Text(_searchResult[index]['username']),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 30,
                          ),
                          Text('No result found')
                        ],
                      ),
                    ),
                  )
            : Center(
                child: Text('POST'),
              ));
  }
}
