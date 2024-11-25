import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/member_screen/view/member_details_final.dart';
import 'package:microfin/presentation/widgets/custom_text_textfield_container.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberDetailsScreen extends StatelessWidget {
  const MemberDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // toolbarHeight: mediaQuery.size.height * 7,
        centerTitle: true,
        title: const Text("Name of the Organization"),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: appbarColor,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected value
              print(value); // Example action when menu item is selected
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              // Add more menu items if needed
            ],
          ),
        ],
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
                "Member details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomDropdown(),
                SizedBox(height: screenHeight * 0.02),
                const Row(
                  children: [
                    Text(
                      "Current Balance",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      "0.00",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: screenHeight * 0.29,
            margin: EdgeInsets.only(
                left: screenWidth * 0.03,
                right: screenWidth * 0.03,
                bottom: screenWidth * 0.01),
            // margin: EdgeInsets.all(screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.01),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[1],
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Installment details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                CustomFieldInsideContainer(
                  labeltext: "Months/Days Due",
                  inputext: "",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  maxLength: 3,
                ),
                CustomFieldInsideContainer(
                  labeltext: "Month Installment",
                  inputext: "",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  maxLength: 7,
                ),
                CustomFieldInsideContainer(
                  labeltext: "Amount Paid",
                  inputext: "",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  maxLength: 7,
                ),
                CustomFieldInsideContainer(
                  labeltext: "Interest",
                  inputext: "",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  maxLength: 7,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: screenHeight * 0.07,
            margin: EdgeInsets.only(
                left: screenWidth * 0.03, right: screenWidth * 0.03),
            // padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
                boxShadow: kElevationToShadow[1],
                color: const Color.fromARGB(255, 224, 225, 255),
                borderRadius: BorderRadius.circular(5)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "0.00",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.062),
          CustomBottomButtons(
              screenWidth: screenWidth, screenHeight: screenHeight)
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
    return Padding(
      padding: EdgeInsets.only(top: screenWidth * 0.3),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(screenWidth * 0.01),
        // padding: EdgeInsets.symmetric(
        //   vertical: screenHeight * 0.01,
        //   horizontal: screenWidth * 0.04,
        // ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.012,
            ),
            Expanded(
              child: SizedBox(
                height: screenHeight * 0.05,
                child: CustomTextButton(
                  buttonText: "ADD",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MemberDetailsFinalScreen()),
                    );
                    // Navigate to the next screen
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 2.0,
          ),
        ],
        border: Border.all(
            color: const Color.fromARGB(255, 149, 147, 147),
            width: 1.0), // Rectangular border
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Center(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.black), // Right-side down arrow
          decoration:
              const InputDecoration.collapsed(hintText: ''), // Remove underline
          items:
              <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
        ),
      ),
    );
  }
}

class CustomRowWithIconWidget extends StatelessWidget {
  const CustomRowWithIconWidget({
    super.key,
    required this.screenWidth,
    required this.isIcon,
    required this.name,
    required this.amount,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;
  final bool isIcon;
  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isIcon
            ? Container(
                width: screenWidth * 0.03,
                height: screenHeight * 0.012,
                margin: EdgeInsets.only(right: screenWidth * 0.04),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1.0, color: Colors.black), // Top border
                    bottom: BorderSide(
                        width: 1.0, color: Colors.black), // Top border
                    left: BorderSide(
                        width: 1.0, color: Colors.black), // Left border
                  ),
                ),
              )
            : SizedBox(
                width: screenWidth * 0.07,
              ),
        Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
        const Spacer(),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        SizedBox(
          width: screenWidth * 0.02,
        )
      ],
    );
  }
}
