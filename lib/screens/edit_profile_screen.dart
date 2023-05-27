import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/screens/edit_profile_item.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';

import '../utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  final snap;
  const EditProfileScreen({super.key, required this.snap});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Uint8List _avatar;

  late DocumentSnapshot snap;
  bool isLoading = false;
  bool isSaving = false;
  bool isUrlPic = true;

  void finalSaveData() async {
    try {
      if (_avatar != null) {
        setState(() {
          isSaving = true;
        });
        String url = await StorageMethods()
            .uploadImageToStorage("profilePic", _avatar, false);

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.snap['uid'])
            .update({'avatarUrl': url});

        showSnackBar("Profile successfully updated", context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      showSnackBar("Profile successfully updated", context);
      Navigator.of(context).pop();

      setState(() {
        isSaving = false;
      });
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _avatar = im;
      isUrlPic = false;
    });
  }

  void refreshPage() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.snap['uid'])
        .get();

    setState(() {
      snap = data;
      isLoading = false;
    });
  }

  void showEditPage(field, value, uid) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditItem(uid: uid, field: field, value: value);
    })).whenComplete(() => refreshPage());
  }

  @override
  void initState() {
    refreshPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Edit Profile"),
        actions: [
          TextButton(
              onPressed: finalSaveData,
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 6, top: 8),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: primaryColor, width: 2)),
                          child: isUrlPic
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      NetworkImage(snap.get('avatarUrl')),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage: MemoryImage(_avatar),
                                ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: selectImage,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: blueColor),
                                child: Center(
                                    child: Icon(Icons.camera_alt_rounded)),
                              ),
                            ))
                      ]),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  editFieldWidget(
                      label: "Name",
                      value: snap.get('name'),
                      function: () {
                        showEditPage("Name", snap.get('name'), snap.get('uid'));
                      }),
                  editFieldWidget(
                      label: "Username",
                      value: widget.snap['username'],
                      function: () {
                        showEditPage("Username", snap.get('username'),
                            widget.snap['uid']);
                      }),
                  editFieldWidget(
                      label: "Bio",
                      value: snap.get('bio'),
                      function: () {
                        showEditPage(
                            "Bio", snap.get('bio'), widget.snap['uid']);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextUtils().normal16("Personal Information", primaryColor),
                  const SizedBox(
                    height: 8,
                  ),
                  editFieldWidget(
                      label: "Email Address",
                      value: snap.get('email'),
                      function: () {},
                      width: .2)
                ]),
              ),
            ),
    );
  }

  Widget editFieldWidget({
    required String label,
    required String value,
    double width = 1,
    required void Function() function,
  }) {
    return InkWell(
      onTap: function,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: primaryColor, width: width))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: mobileSearchColor),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              )
            ]),
      ),
    );
  }
}
