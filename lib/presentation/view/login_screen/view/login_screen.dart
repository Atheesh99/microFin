import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/data/repositories/api.dart';
import 'package:microfin/data/repositories/sigin_api.dart';
import 'package:microfin/presentation/view/member_screen/view/member_number_screen.dart';
import 'package:http/http.dart' as http;
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

// Function to convert a string to SHA-256 hash
  // String convertToSha256(String input) {
  //   var bytes = utf8.encode(input); // Convert string to bytes
  //   var digest = sha256.convert(bytes); // Get the SHA-256 hash
  //   return digest.toString();
  // }
  String convertToSha256(String input) {
    var newvalue = "$input${BaseAPI.hashcode}";
    if (input.isEmpty) {
      throw ArgumentError("Input string cannot be empty.");
    }

    // Convert the input string to a UTF8 encoded list of bytes
    List<int> bytes = utf8.encode(newvalue);

// Perform the SHA256 hash operation
    Digest sha256Result = sha256.convert(bytes);

    // Convert the hash bytes to a hexadecimal string
    return sha256Result.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Convert the username and password to SHA-256
    var hashedUsername = convertToSha256(username);
    var hashedPassword = convertToSha256(password);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get the username and password from controllers

      print("SHA-256 Hashed Username: $hashedUsername");
      print("SHA-256 Hashed Password: $hashedPassword");

      // API endpoint URL
      const String url =
          'http://154.38.175.150:8090/api/users/validateMobileUser';

      // Prepare the request body
      final Map<String, String> requestBody = {
        "LoginID": hashedUsername.toUpperCase(),
        "Password": hashedPassword.toUpperCase(),
      };

      try {
        // Send POST request
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json', // Specify content type as JSON
          },
          body: jsonEncode(requestBody), // Encode the request body to JSON
        );

        // Check the response status
        if (response.statusCode == 200) {
          // Decode the response JSON if needed
          final responseData = jsonDecode(response.body);
          print("Login successful: $responseData");

          // Navigate to the next screen if login is successful
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MemberNumber()),
          );
        } else {
          // Show an error message if the login failed
          print(
              "Login failed: ${response.statusCode} - ${response.reasonPhrase}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        // Handle exceptions (e.g., network error)
        print("An error occurred: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      } finally {
        // Hide the loading indicator once the operation is complete
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
