import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/member_screen/view/member_details_first.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberNumber extends StatelessWidget {
  const MemberNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        // toolbarHeight: mediaQuery.size.height * 0.05,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: appbarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 25,
          ),
          onPressed: (() {
            Navigator.of(context).pop();
          }),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.09,
            // margin: EdgeInsets.all(screenWidth * 0.02),
            // padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[1],
              color: const Color.fromARGB(255, 224, 225, 255),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                "Organisation Details",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ),
          CustomheaderWidgetMemberShipNumber(
              screenWidth: screenWidth, screenHeight: screenHeight),
          CustomMiddleMemberDetails(
              screenWidth: screenWidth, screenHeight: screenHeight),
          SizedBox(
            height: screenHeight * 0.25,
          ),
          CustomBottomButtons(
              screenWidth: screenWidth, screenHeight: screenHeight),
        ],
      ),
    );
  }
}

class CustomBottomButtons extends StatelessWidget {
  const CustomBottomButtons({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(screenWidth * 0.02),
      // padding: EdgeInsets.symmetric(
      //   vertical: screenHeight * 0.01,
      //   horizontal: screenWidth * 0.04,
      // ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: screenHeight * 0.05,
              child: CustomTextButton(
                buttonText: "RESET",
                onPressed: () {
                  // Navigate to the next screen
                },
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: screenHeight * 0.05,
              child: CustomTextButton(
                buttonText: "NEXT",
                onPressed: () {
                  // Navigate to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MemberDetailsScreen()),
                  );
                },
              ),
            ),
          ),
          // SizedBox(
          //   width: screenWidth * 0.001,
          // ),
        ],
      ),
    );
  }
}

class CustomMiddleMemberDetails extends StatelessWidget {
  const CustomMiddleMemberDetails({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.33,
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Member details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          CustomField(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            labeltext: "Member Name",
            inputext: "",
          ),
          CustomField(
            labeltext: "Father/Husband",
            inputext: "",
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          CustomField(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            labeltext: "Group Number",
            inputext: "",
          ),
          CustomField(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            labeltext: "Date of Joining",
            inputext: "",
          ),
        ],
      ),
    );
  }
}

class CustomheaderWidgetMemberShipNumber extends StatelessWidget {
  const CustomheaderWidgetMemberShipNumber({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 180,
      width: double.infinity,
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Membership Number",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: screenHeight * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 1),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.05,
              ),
              Expanded(
                child: SizedBox(
                  height: screenHeight * 0.045,
                  child: CustomTextButton(
                    buttonText: "Fetch",
                    onPressed: () {},
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    this.icon,
    required this.labeltext,
    required this.inputext,
    required this.screenWidth,
    required this.screenHeight,
  });
  final String labeltext;
  final String inputext;
  final IconData? icon;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.009,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: screenHeight * 0.16,
              child: Text(
                labeltext,
                style: TextStyle(
                    fontSize: screenWidth * 0.037, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.45,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 1),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 12),
                  child: Text(inputext),
                )
                // TextFormField(
                //   initialValue: inputext,
                //   textAlign: TextAlign.start,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(5),
                //       borderSide: const BorderSide(
                //         color: Colors.black,
                //         width: 1.0,
                //       ),
                //     ),
                //     suffixIcon: Icon(icon),
                //     contentPadding: const EdgeInsets.symmetric(
                //       vertical: 12, // Adjust this for vertical padding
                //       horizontal: 15, // Adjust this for horizontal padding
                //     ),
                //   ),
                //   style: TextStyle(
                //     fontSize: screenWidth * 0.03, // Adjust the text size
                //   ),
                // ),
                ),
          ],
        ),
      ],
    );
  }
}
