import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String label;
  final Color textColor;
  const FollowButton(
      {super.key,
      required this.backgroundColor,
      required this.borderColor,
      required this.label,
      required this.textColor,
      this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
          width: 164,
          height: 37,
        ),
      ),
    );
  }
}
