import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

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
                height: 20,
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
                child: InkWell(
                  onTap: () {},
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
                onTap: () {},
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
