import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/data/repositories/sigin_api.dart';
import 'package:microfin/presentation/view/member_screen/view/member_details_first.dart';
import 'package:microfin/presentation/view/member_screen/view/member_number_screen.dart';

import 'package:microfin/presentation/widgets/custom_text_textform_login.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthAPI _authAPI = AuthAPI();

  bool _isLoading = false;

//////Login ////
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the login function
        bool isLoginSuccessful = await _authAPI.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
        print(_usernameController.text);
        print(_passwordController.text);

        if (isLoginSuccessful) {
          // Navigate to the next screen if login is successful
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MemberNumber()),
          );
        }
      } catch (e) {
        // Show an error message on failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: appbarColor,
        elevation: 0,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.logout,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // do something
        //     },
        //   )
        // ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 241, 241, 241),
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: mediaQuery.size.width * 0.6,
                  // width: mediaQuery.size.width * 0.5,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(5),
                    //     topRight: Radius.circular(5)),
                  ),
                  // margin: const EdgeInsets.only(left: 120, top: 20),
                  child: ClipRect(
                    child: Image.asset(
                      'assets/image/icon/icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.06,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWithTextFormField(
                            labeltext: "Login",
                            // inputext: "example@gmamil.com",
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field cannot be empty";
                              }
                              if (value.length < 3) {
                                return "Must be at least 3 characters long";
                              }
                              if (value.length > 8) {
                                return "Cannot exceed 8 characters";
                              }

                              // Check for alphabetic only
                              if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return null; // valid alphabetic input
                              }

                              // Check for numeric only
                              if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return null; // valid numeric input
                              }

                              // Check for alphanumeric (letters and numbers)
                              if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                                return null; // valid alphanumeric input
                              }

                              return "Input must be alphabetic, numeric, or alphanumeric.";
                            },
                          ),
                          SizedBox(
                            height: mediaQuery.size.height * 0.03,
                          ),
                          CustomTextWithTextFormField(
                            labeltext: "Password",
                            // inputext: "********",
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password cannot be empty";
                              }
                              if (value.length < 4) {
                                return "Password must be at least 4 characters long";
                              }
                              if (value.length > 7) {
                                return "Password cannot exceed 7 characters";
                              }
                              if (value.contains(' ')) {
                                return "Password cannot contain spaces";
                              }

                              // Check for alphabetic only (letters)
                              if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return null; // valid alphabetic input
                              }

                              // Check for numeric only (numbers)
                              if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return null; // valid numeric input
                              }

                              // Check for alphanumeric (letters and numbers)
                              if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                                return null; // valid alphanumeric input
                              }

                              return "Password must be alphabetic, numeric, or alphanumeric.";
                            },
                          ),
                          SizedBox(
                            height: mediaQuery.size.height * 0.04,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : CustomTextButton(
                                  buttonText: "Login",
                                  onPressed: _login,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
