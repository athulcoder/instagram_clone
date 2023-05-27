import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/createPasswordScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/utils/utils.dart';

class CreateProfileScreen extends StatefulWidget {
  final String email;
  final String fullname;
  final String username;

  const CreateProfileScreen(
      {super.key,
      required this.email,
      required this.fullname,
      required this.username});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  Uint8List? _avatar;
  String defaultAvatarUrl =
      'https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg';

  void _showNextPage() async {
    if (_avatar == null) {
      _avatar = await defaultProfile();
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CreatePasswordScreen(
        fullname: widget.fullname,
        email: widget.email,
        username: widget.username,
        profilePic: _avatar!,
      );
    }));
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _avatar = im;
    });
  }

  Future<Uint8List> defaultProfile() async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(defaultAvatarUrl))
            .load(defaultAvatarUrl))
        .buffer
        .asUint8List();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 50,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        _avatar != null
                            ? CircleAvatar(
                                radius: 120,
                                backgroundImage: MemoryImage(_avatar!),
                              )
                            : CircleAvatar(
                                radius: 120,
                                backgroundImage: NetworkImage(defaultAvatarUrl),
                              ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: selectImage,
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Icon(Icons.add_a_photo),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: blueColor,
                                ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: GestureDetector(
                    onTap: () {},
                    child: InkWell(
                      onTap: _showNextPage,
                      child: Container(
                        child: Center(
                          child: TextUtils().bold14('Next', primaryColor),
                        ),
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: blueColor,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
