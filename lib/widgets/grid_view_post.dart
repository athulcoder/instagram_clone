import 'package:flutter/material.dart';

class GridViewPosts extends StatefulWidget {
  const GridViewPosts({super.key});

  @override
  State<GridViewPosts> createState() => _GridViewPostsState();
}

class _GridViewPostsState extends State<GridViewPosts> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.camera_alt_outlined),
                ),
                Tab(
                  icon: Icon(Icons.video_camera_back),
                ),
                Tab(
                  icon: Icon(Icons.linked_camera),
                )
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Container(
                  child: Center(child: Text('POST')),
                ),
                Container(
                  child: Center(child: Text('Reel')),
                ),
                Container(
                  child: Center(child: Text('TAG')),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
