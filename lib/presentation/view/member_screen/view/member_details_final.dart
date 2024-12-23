import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/member_screen/model/get_membership_details_model.dart';
import 'package:microfin/presentation/widgets/custom_popup.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberDetailsFinalScreen extends StatefulWidget {
  const MemberDetailsFinalScreen(
      {super.key,
      required this.accountAddedList,
      required this.memberDetails,
      required this.loginResponse});

  final List<Map<String, dynamic>> accountAddedList;
  final MemberShipDetailsModel memberDetails;
  final Map<String, dynamic> loginResponse;

  @override
  State<MemberDetailsFinalScreen> createState() =>
      _MemberDetailsFinalScreenState();
}

class _MemberDetailsFinalScreenState extends State<MemberDetailsFinalScreen> {
  @override
  Widget build(BuildContext context) {
    final result = widget.loginResponse['result'];
    // final userName = result != null ? result['UserName'] : 'Unknown User';
    final memberName = widget.memberDetails.memberName ?? 'Unknown Member';
    final groupNumber = widget.memberDetails.groupNumber ?? "";
    final membershipNumber = widget.memberDetails.membershipNumber ?? "";
    final organizationDetails =
        result != null ? result['DisplayName'] : 'No Display Name';

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

    // Total amount formatte
    String getFormattedTotalAmount() {
      // Create a formatter instance
      final formatter = NumberFormat("#,##0");

      // Calculate total and format it
      return "₹ ${formatter.format(calculateTotalAmount())}";
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
        title: Text(
          organizationDetails,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 17, color: Colors.white),
        ),
        backgroundColor: appbarColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.6),
              child: Column(
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
                    child: Center(
                      child: Text(
                        '     Number: $membershipNumber   Name: $memberName  \n                     Group: $groupNumber ',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(screenWidth * 0.02),
                    padding: EdgeInsets.all(screenWidth * 0.04),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        Text(
                          getFormattedTotalAmount(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.accountAddedList.length,
                    itemBuilder: (context, index) {
                      var item = widget.accountAddedList[index];

                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(screenWidth * 0.02),
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[1],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            CustomRowWithIconWidget(
                              interest: item['interest'],
                              screenWidth: screenWidth,
                              name: item['sDisplayName'],
                              amount: item['receipts'].toString(),
                              screenHeight: screenHeight,
                              onDelete: () =>
                                  showDeleteConfirmation(context, index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomButtons(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
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
    required this.name,
    required this.amount,
    required this.screenHeight,
    this.onDelete,
    required this.interest,
  });

  final double screenWidth;
  final double screenHeight;
  final String name;
  final String amount;
  final String? interest;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0");

    // Format interest
    String formattedInterest = interest != null
        ? formatter.format(double.tryParse(interest!)?.truncate() ?? 0)
        : '0';

    // Format amount
    String formattedAmount = amount != null
        ? formatter.format(double.tryParse(amount!)?.truncate() ?? 0)
        : '0';
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete,
            size: 19,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    // double.tryParse(amount)?.truncate().toString() ?? '0',
                    formattedAmount,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                ],
              ),
              interest != null &&
                      double.tryParse(interest!)?.truncate().toString() != '0'
                  ? Row(
                      children: [
                        const Text(
                          "Interest",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          // interest!,
                          // double.tryParse(interest!)?.truncate().toString() ??
                          //     '0',
                          formattedInterest,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        )
      ],
    );
  }
}
