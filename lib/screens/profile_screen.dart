import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final TextUtils _textUtils = TextUtils();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline),
                const SizedBox(
                  width: 5,
                ),
                _textUtils.bold18('Josepyh12', Colors.white),
                const SizedBox(
                  width: 5,
                ),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
            Row(
              children: [
                Icon(Icons.add_box_outlined),
                const SizedBox(
                  width: 15,
                ),
                Icon(Icons.menu)
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1683464623235-d165004a9e75?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _textUtils.normal16('Joseph Jogn', Colors.white)
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              _textUtils.bold16('12', Colors.white),
                              const SizedBox(height: 4),
                              _textUtils.normal15('Posts', Colors.white)
                            ],
                          ),
                          Column(
                            children: [
                              _textUtils.bold16('123', Colors.white),
                              const SizedBox(height: 4),
                              _textUtils.normal15('Followers', Colors.white)
                            ],
                          ),
                          Column(
                            children: [
                              _textUtils.bold16('1230', Colors.white),
                              const SizedBox(height: 4),
                              _textUtils.normal15('Following', Colors.white)
                            ],
                          )
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
                      flex: 8,
                      child: Container(
                        child: Center(
                            child: _textUtils.bold16(
                                'Edit profile', Colors.white)),
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        child: Center(child: Icon(Icons.keyboard_arrow_down)),
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5))),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
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
                            size: 40,
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
            )
          ],
        ),
      ),
    );
  }

  Widget favouriteStoriesWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      ),
    );
  }
}
