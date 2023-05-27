import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';

class BottomSheetFunction {
  BottomSheetFunction();
  Widget homePostMore({required var snap}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                circleButton(
                    icon: Icon(Icons.bookmark_border_rounded),
                    onTap: () {},
                    label: "save"),
                circleButton(
                    icon: Icon(Icons.qr_code_2_rounded),
                    onTap: () {},
                    label: "QR code")
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: .5,
              color: primaryColor,
            ),
            options(Icon(Icons.send), "Share", function: () {}),
            options(Icon(Icons.star_border), "Add to Favorites",
                function: () {}),
            const Divider(
              thickness: .1,
              color: primaryColor,
            ),
            options(Icon(Icons.hide_image), "Hide", function: () {}),
            options(Icon(Icons.info), "Why you're seeing this post",
                function: () {}),
            options(Icon(Icons.person_remove_rounded), "Unfollow",
                function: () {}),
            options(snap['profileImage'], "About this Account",
                isAvatar: true, function: () {}),
            options(
                Icon(
                  Icons.report,
                  color: Colors.red,
                ),
                "Report",
                function: () {}),
          ],
        ),
      ),
    );
  }

  Widget circleButton(
      {required Widget icon,
      required void Function() onTap,
      required String label}) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: primaryColor)),
        child: icon,
      ),
    );
  }

  Widget options(var icon, String label,
      {isAvatar = false, required void Function() function}) {
    return InkWell(
      onTap: function,
      child: ListTile(
        leading: isAvatar
            ? CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(icon),
              )
            : icon,
        title: TextUtils().normal15(label, primaryColor),
      ),
    );
  }
}
