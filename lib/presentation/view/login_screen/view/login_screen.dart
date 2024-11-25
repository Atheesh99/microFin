import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/member_screen/view/member_number_screen.dart';
import 'package:microfin/presentation/widgets/custom_text_textform_login.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextWithTextFormField(
                            labeltext: "Login", inputext: "example@gmamil.com"),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        const CustomTextWithTextFormField(
                            labeltext: "Password", inputext: "********"),
                        SizedBox(
                          height: mediaQuery.size.height * 0.04,
                        ),
                        CustomTextButton(
                          buttonText: "Login",
                          onPressed: () {
                            // Navigate to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MemberNumber()),
                            );
                          },
                        )
                      ],
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
