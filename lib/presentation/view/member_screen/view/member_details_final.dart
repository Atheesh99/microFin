import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/widgets/custom_popup.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberDetailsFinalScreen extends StatefulWidget {
  const MemberDetailsFinalScreen({super.key, required this.accountAddedList});

  final List<Map<String, dynamic>> accountAddedList;

  @override
  State<MemberDetailsFinalScreen> createState() =>
      _MemberDetailsFinalScreenState();
}

class _MemberDetailsFinalScreenState extends State<MemberDetailsFinalScreen> {
  @override
  Widget build(BuildContext context) {
    double calculateTotalAmount() {
      double total = 0.0;

      // Add amounts from accountAddedList
      for (var item in widget.accountAddedList) {
        total += double.tryParse(item['receipts'].toString()) ?? 0.0;
        total += double.tryParse(item['interest'].toString()) ?? 0.0;
      }

      // Add static amounts
      total += 0.0; // Penalty
      total += 0.0; // Member fee

      return total;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void showDeleteConfirmation(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.accountAddedList.removeAt(index);
                });
                // Remove the item
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: mediaQuery.size.height * 7,
        centerTitle: true,
        title: const Text("Name of the Organization"),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: appbarColor,
        elevation: 0,
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
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                Text(
                  calculateTotalAmount().toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.accountAddedList.length,
            itemBuilder: (context, index) {
              var item = widget.accountAddedList[index];

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
                      amount: item['receipts'].toString(),
                      screenHeight: screenHeight,
                      onDelete: () => showDeleteConfirmation(context, index),
                    ),
                    CustomRowWithIconWidget(
                      screenWidth: screenWidth,
                      isIcon: false,
                      name: "Interest",
                      amount: item['interest'].toString(),
                      screenHeight: screenHeight,
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[1],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
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
                  name: "Member fee",
                  amount: "0.00",
                  screenHeight: screenHeight,
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomBottomButtons(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
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
                buttonText: "BACK",
                onPressed: () {
                  /////////////////////////////
                  Navigator.of(context).pop();
                  /////////////////////
                },
              ),
            ),
          ),
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

class CustomRowWithIconWidget extends StatelessWidget {
  const CustomRowWithIconWidget({
    super.key,
    required this.screenWidth,
    required this.isIcon,
    required this.name,
    required this.amount,
    required this.screenHeight,
    this.onDelete,
  });

  final double screenWidth;
  final double screenHeight;
  final bool isIcon;
  final String name;
  final String amount;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isIcon
            ? IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 19,
                ),
              )
            : SizedBox(
                width: screenWidth * 0.11,
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
