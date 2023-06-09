import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/signupScreen_1.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/responsive_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout()),
      ));
    } else {
      showSnackBar(res, context);
    }
  }

  void navigatorToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CreateAccountScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
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
                width: MediaQuery.of(context).size.width,
                height: 100,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: primaryColor,
                      height: 56,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                        textEditingController: _emailController,
                        hintText: 'Email',
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                        isPass: true,
                        textEditingController: _passwordController,
                        hintText: 'Password',
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 20,
                    ),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : InkWell(
                            onTap: loginUser,
                            child: Container(
                              child: Center(
                                child:
                                    TextUtils().bold14('Log In', primaryColor),
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
                  onTap: navigatorToSignUp,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Don't have an account?"),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      Container(
                        child: const Text(
                          "Sign up",
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
