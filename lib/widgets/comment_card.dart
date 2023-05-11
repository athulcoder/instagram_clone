import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(widget.snap['userProfile']),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  widget.snap['username'],
                  style: TextStyle(
                      fontSize: 11,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                )
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              widget.snap['commentText'],
              style: TextStyle(fontSize: 11),
            ),
            SizedBox(
              height: 6,
            ),
            InkWell(
              child: Container(
                child: Text(
                  'Reply',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            )
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite_outline,
            color: Colors.grey,
            size: 15,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
