import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/loginScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../responsive/responsive_layout_screen.dart';

var Spacer = SizedBox(
  height: 10,
);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _avatar;
  bool _isLoading = false;
  bool _textEnabled = true;
  String defaultAvatarUrl =
      'https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _avatar = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
      _textEnabled = false;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        fullname: _fullnameController.text,
        file: _avatar ?? await defaultProfile());

    setState(() {
      _isLoading = false;
      _textEnabled = true;
    });
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout()),
      ));
    }
  }

  void navigatorToLogin() {
    Navigator.of(context).pop();
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
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 54,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  _avatar != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_avatar!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(defaultAvatarUrl),
                        ),
                  Positioned(
                      bottom: -10,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                        ),
                        onPressed: selectImage,
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    textInputBox(
                      placeholder: 'Email',
                      controller: _emailController,
                      type: TextInputType.emailAddress,
                    ),
                    Spacer,
                    textInputBox(
                      placeholder: 'Full Name',
                      controller: _fullnameController,
                      type: TextInputType.text,
                    ),
                    Spacer,
                    textInputBox(
                      placeholder: 'Username',
                      controller: _usernameController,
                      type: TextInputType.text,
                    ),
                    Spacer,
                    textInputBox(
                        placeholder: 'Password',
                        controller: _passwordController,
                        type: TextInputType.text,
                        isPass: true),
                    Spacer,
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: _isLoading
                    ? Container(
                        width: double.infinity,
                        height: 35,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : InkWell(
                        onTap: signUpUser,
                        child: Container(
                          child: Center(
                            child: Text('Sign up'),
                          ),
                          width: double.infinity,
                          height: 35,
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: navigatorToLogin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    Container(
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  CupertinoTextField textInputBox({
    required String placeholder,
    required TextEditingController controller,
    required TextInputType type,
    bool isPass = false,
  }) {
    return CupertinoTextField(
      enabled: _textEnabled,
      controller: controller,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 47, 46, 46),
        borderRadius: BorderRadius.circular(6),
      ),
      placeholder: placeholder,
      style: TextStyle(color: primaryColor, fontSize: 16),
      padding: EdgeInsets.all(12),
      keyboardType: type,
    );
  }
}
