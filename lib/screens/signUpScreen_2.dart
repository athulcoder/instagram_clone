import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/createProfileScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/text_utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class CreateUsernameScreen extends StatefulWidget {
  final String email;
  final String fullname;
  const CreateUsernameScreen(
      {super.key, required this.fullname, required this.email});

  @override
  State<CreateUsernameScreen> createState() => _CreateUsernameScreenState();
}

class _CreateUsernameScreenState extends State<CreateUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  void _showNextPage() {
    if (_usernameController.text.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateProfileScreen(
          fullname: widget.fullname,
          email: widget.email,
          username: _usernameController.text,
        ),
      ));
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
                        isPass: false,
                        textEditingController: _usernameController,
                        hintText: 'Username',
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 20,
                    ),
                    false
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : InkWell(
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
