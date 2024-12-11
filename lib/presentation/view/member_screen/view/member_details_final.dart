import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/widgets/custom_popup.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberDetailsFinalScreen extends StatelessWidget {
  MemberDetailsFinalScreen({super.key, required this.accountAddedList});

  final List<Map<String, dynamic>> accountAddedList;

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
              )),
          Container(
              width: double.infinity,
              margin: EdgeInsets.all(screenWidth * 0.02),
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                  boxShadow: kElevationToShadow[1],
                  color: const Color.fromARGB(255, 241, 231, 231),
                  borderRadius: BorderRadius.circular(5)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    "0.00",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ],
              )),

          Expanded(
            child: ListView.builder(
              itemCount: accountAddedList.length,
              itemBuilder: (context, index) {
                var item = accountAddedList[index];
                return Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(screenWidth * 0.02),
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                        boxShadow: kElevationToShadow[1],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        CustomRowWithIconWidget(
                          screenWidth: screenWidth,
                          isIcon: true,
                          name: item['sDisplayName'],
                          amount: item['eMI'],
                          screenHeight: screenHeight,
                        ),
                      ],
                    ));
              },
            ),
          ),
          // Container(
          //     width: double.infinity,
          //     margin: EdgeInsets.all(screenWidth * 0.02),
          //     padding: EdgeInsets.all(screenWidth * 0.03),
          //     decoration: BoxDecoration(
          //         boxShadow: kElevationToShadow[1],
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(5)),
          //     child: Column(
          //       children: [
          //         CustomRowWithIconWidget(
          //           screenWidth: screenWidth,
          //           isIcon: true,
          //           name: "Member Loan",
          //           amount: "0.00",
          //           screenHeight: screenHeight,
          //         ),
          //         // CustomRowWithIconWidget(
          //         //   screenWidth: screenWidth,
          //         //   isIcon: false,
          //         //   name: "Amount",
          //         //   amount: "0.00",
          //         //   screenHeight: screenHeight,
          //         // ),
          //         CustomRowWithIconWidget(
          //           screenWidth: screenWidth,
          //           isIcon: false,
          //           name: "Interest",
          //           amount: "0.00",
          //           screenHeight: screenHeight,
          //         ),
          //       ],
          //     )),

          Container(
            width: double.infinity,
            margin: EdgeInsets.all(screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
                boxShadow: kElevationToShadow[1],
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                CustomRowWithIconWidget(
                  screenWidth: screenWidth,
                  isIcon: true,
                  name: "Penalty",
                  amount: "0.00",
                  screenHeight: screenHeight,
                ),
                CustomRowWithIconWidget(
                  screenWidth: screenWidth,
                  isIcon: true,
                  name: "Passbook",
                  amount: "0.00",
                  screenHeight: screenHeight,
                ),
                CustomRowWithIconWidget(
                  screenWidth: screenWidth,
                  isIcon: true,
                  name: "Calender",
                  amount: "0.00",
                  screenHeight: screenHeight,
                ),
              ],
            ),
          ),

          const Spacer(),
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
                buttonText: "OTHER ACCOUNTS",
                onPressed: () {
                  //////////////////////////////
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomPopup(
                        title: 'Popup Title',
                        saveButtonText: 'Save',
                        onCancelPressed: () {
                          Navigator.of(context).pop(); // Close popup on cancel
                        },
                        onUpdatePressed: () {
                          // Handle save/update logic here
                          Navigator.of(context).pop(); // Close popup on update
                        },
                        children: const [
                          Text('Content goes here'),
                        ],
                      );
                    },
                  );
                  /////////////////////
                },
              ),
            ),
          ),
          // SizedBox(
          //   width: screenWidth * 0.012,
          // ),
          Expanded(
            child: SizedBox(
              height: screenHeight * 0.05,
              child: CustomTextButton(
                buttonText: "FINISH",
                onPressed: () {
                  // Navigate to the next screen

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomPopup(
                        title: 'Popup Title',
                        saveButtonText: 'Save',
                        onCancelPressed: () {
                          Navigator.of(context).pop(); // Close popup on cancel
                        },
                        onUpdatePressed: () {
                          // Handle save/update logic here
                          Navigator.of(context).pop(); // Close popup on update
                        },
                        children: const [
                          Text('Content goes here'),
                        ],
                      );
                    },
                  );

                  ///////////////////////////
                },
              ),
            ),
          )
        ],
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
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 2.0,
          ),
        ], // Rectangular border
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Center(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ), // Right-side down arrow
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        ),
        SizedBox(
          width: screenWidth * 0.02,
        )
      ],
    );
  }
}
