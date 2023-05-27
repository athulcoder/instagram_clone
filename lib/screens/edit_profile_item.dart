import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/utils/utils.dart';

class EditItem extends StatefulWidget {
  final String field;
  final String value;
  final String uid;
  const EditItem(
      {super.key, required this.uid, required this.field, required this.value});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  bool isSaving = false;
  TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    if (widget.value != "") {
      _itemController.text = widget.value;
    }
    super.initState();
  }

  void saveChange(String itemChanged) async {
    setState(() {
      isSaving = true;
    });
    if (itemChanged != '') {
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.uid)
            .update({widget.field.toLowerCase(): itemChanged});
        showSnackBar('Updated!', context);
        Navigator.of(context).pop();
      } catch (e) {
        showSnackBar(e.toString(), context);
      }
    }
    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(widget.field),
        actions: [
          TextButton(
              onPressed: () {
                saveChange(_itemController.text);
              },
              child: isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),
                    )
                  : TextUtils().normal16("Save", blueColor))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                controller: _itemController,
                style: TextStyle(fontSize: 18, letterSpacing: 1),
                decoration: InputDecoration(
                    hintText: 'Add ' + widget.field.toLowerCase(),
                    contentPadding: EdgeInsets.only(left: 5),
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: blueColor)))),
          ],
        ),
      ),
    );
  }
}
