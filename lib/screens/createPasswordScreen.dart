import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email;
  final String fullname;
  final String username;
  final Uint8List profilePic;
  const CreatePasswordScreen(
      {super.key,
      required this.email,
      required this.fullname,
      required this.profilePic,
      required this.username});

  @override
  State<CreatePasswordScreen> createState() => CreatePasswordScreenState();
}

class CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _firstPassword = TextEditingController();
  final TextEditingController _secondPassword = TextEditingController();
  Uint8List? _avatar;
  bool _isLoading = false;
  bool _textEnabled = true;

  void signUpUser() async {
    if (_firstPassword.text == _secondPassword.text) {
      String password = _firstPassword.text;
      setState(() {
        _isLoading = true;
        _textEnabled = false;
      });
      String res = await AuthMethods().signupUser(
          email: widget.email,
          password: password,
          username: widget.username,
          name: widget.fullname,
          file: widget.profilePic);

      setState(() {
        _isLoading = false;
        _textEnabled = true;
      });
      if (res != "success") {
        showSnackBar(res, context);
      } else {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      }
    } else {
      showSnackBar("Password doesn't match !", context);
    }
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
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                        isPass: true,
                        textEditingController: _firstPassword,
                        hintText: 'Password',
                        textInputType: TextInputType.name),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                        isPass: true,
                        textEditingController: _secondPassword,
                        hintText: 'Confirm Password',
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    _isLoading
                        ? Container(
                            width: double.infinity,
                            height: 35,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : InkWell(
                            onTap: signUpUser,
                            child: Container(
                              child: Center(
                                child:
                                    TextUtils().bold14('Sign up', primaryColor),
                              ),
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: blueColor,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Have an Account"),
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
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
