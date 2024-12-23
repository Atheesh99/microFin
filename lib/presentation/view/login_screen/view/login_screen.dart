import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/data/repositories/api.dart';
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
  // final AuthAPI _authAPI = AuthAPI();

  bool _isLoading = false;

//////Login ////

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
    return sha256Result.bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
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
      const String url = 'http://154.38.175.150:8090/api/users/validateMobileUser';

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
            MaterialPageRoute(
              builder: (context) => MemberNumber(
                loginResponse: responseData,
              ),
            ),
          );
        } else {
          // Show an error message if the login failed
          print("Login failed: ${response.statusCode} - ${response.reasonPhrase}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Center(child: Text('Invalid User Name or Password'))),
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
        titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: appbarColor,
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Do you want to close the APP',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {});
                          SystemNavigator.pop();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.white),
              ))
        ],
        elevation: 0,
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
                // SizedBox(
                //   height: mediaQuery.size.height * 0.01,
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWithTextFormField(
                            labeltext: "Login",
                            maxLength: 10,
                            obscure: false,
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter User Name";
                              }
                            },
                          ),
                          SizedBox(
                            height: mediaQuery.size.height * 0.03,
                          ),
                          CustomTextWithTextFormField(
                            maxLength: 10,
                            obscure: true,
                            labeltext: "Password",
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: mediaQuery.size.height * 0.04,
                          ),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : CustomTextButton(
                                  buttonText: "Login",
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      _login();
                                    }
                                  },
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
