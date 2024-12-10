import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/member_screen/model/get_membership_details_model.dart';
import 'package:microfin/presentation/view/member_screen/model/member_accountdetails_model.dart';
import 'package:microfin/presentation/view/member_screen/view/member_details_final.dart';
import 'package:microfin/presentation/widgets/custom_text_textfield_container.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> loginResponse;
  final MemberShipDetailsModel memberDetails;
  const MemberDetailsScreen({
    super.key,
    required this.loginResponse,
    required this.memberDetails,
  });

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  String closingBalance = '0.00';

  // Controllers for editable fields
  final TextEditingController monthsDueController = TextEditingController();
  final TextEditingController emitController = TextEditingController();
  final TextEditingController amountPaidController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  double totalAmount = 0.0;

  List<MemberAccountDetailsModel> accountDetailsList = [];
  List<Map<String, dynamic>> accountAddedList = [];
  Map<String, dynamic>? selectedAccountDetails;

  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  String? selectedValue;
  List<Map<String, String>> dropdownItems = [];

  String? emi;
  String? monthsDue;
  String? receipts;
  String? interest;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      String membershipID = "70107";
      String receiptDate = "2024-11-08";

      final uri = Uri.parse('http://154.38.175.150:8090/api/mobile/getMemberAccountsForReceipts').replace(queryParameters: {
        'MembershipID': membershipID,
        'ReceiptDate': receiptDate,
      });

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);

        String result = responseJson['result'];

        Map<String, dynamic> resultJson = jsonDecode(result);

        accountDetailsList =
            (resultJson['AccountDetails'] as List).map((e) => MemberAccountDetailsModel.fromJson(e as Map<String, dynamic>)).toList();

        print("response - ${accountDetailsList![0].accountNumber}");

        List<dynamic> accountDetails = resultJson['AccountDetails'];
        setState(() {
          dropdownItems = accountDetails.map<Map<String, String>>((account) {
            return {
              'accountNumber': account['AccountNumber'],
              'sDisplayName': account['SDisplayName'],
              'closingBalance': account['ClosingBalance'],
              'eMI': account['EMI'],
              'monthsDue': account['MonthsDue'],
              'receipts': account['Receipts'],
              'interest': account['Interest'],
            };
          }).toList();
          print("0000000000000000000000000000000000000000");
          print("Account Details: ${accountDetails.toString()}");
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void calculateTotal() {
    // Parse the values from the controllers
    double amountPaid = double.tryParse(amountPaidController.text) ?? 0.0;
    double interest = double.tryParse(interestController.text) ?? 0.0;

    // Calculate total
    setState(() {
      totalAmount = amountPaid + interest;
    });
  }

  // Callback to update closingBalance
  void updateClosingBalance(String newBalance) {
    setState(() {
      closingBalance = newBalance;
      calculateTotal();
    });
  }

  // Callback to update installment details
  void updateInstallmentDetails(Map<String, dynamic> accountDetails) {
    setState(() {
      monthsDueController.text = accountDetails['monthsDue'];
      emitController.text = accountDetails['eMI'];
      amountPaidController.text = accountDetails['receipts'];
      interestController.text = accountDetails['interest'];
    });
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    monthsDueController.dispose();
    emitController.dispose();
    amountPaidController.dispose();
    interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final result = widget.loginResponse['result'];

    final userName = result != null ? result['UserName'] : 'Unknown User';
    // final organizationDetails =
    //     result != null ? result['DisplayName'] : 'No Display Name';
    final memberName = widget.memberDetails.memberName ?? 'Unknown Member';
    final groupNumber = widget.memberDetails.groupNumber ?? "";
    final membershipNumber = widget.memberDetails.membershipNumber ?? "";

    // Format the closing balance with commas
    final formattedBalance = NumberFormat('#,###').format(int.tryParse(closingBalance) ?? 0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // toolbarHeight: mediaQuery.size.height * 7,
          centerTitle: true,
          title: Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
              child: Center(
                child: Text(
                  'Number: $membershipNumber   Name: $memberName  \n                  Group: $groupNumber ',
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
            ),
            // the tab bar with two items

            Container(
              width: double.infinity,
              margin: EdgeInsets.all(screenWidth * 0.02),
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(boxShadow: kElevationToShadow[2], color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Account",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // dropdownButton
                  Container(
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
                      border: Border.all(color: const Color.fromARGB(255, 149, 147, 147), width: 1.0), // Rectangular border
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        key: _dropdownKey,
                        value: selectedValue,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black), // Right-side down arrow
                        decoration: const InputDecoration.collapsed(hintText: ''), // Remove underline
                        items: dropdownItems.map((item) {
                          // Combine accountNumber and sDisplayName for display
                          String displayText = '${item['accountNumber']} - ${item['sDisplayName']}';
                          return DropdownMenuItem<String>(
                            value: item['accountNumber'], // Use accountNumber as the value
                            child: Text(displayText),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                            // Find the selected account and update closingBalance
                            final selectedAccount = dropdownItems.firstWhere(
                              (item) => item['accountNumber'] == newValue,
                            );
                            closingBalance = selectedAccount['closingBalance']!;
                            emi = selectedAccount['eMI'] ?? '0.00';
                            monthsDue = selectedAccount['monthsDue'] ?? '0';
                            receipts = selectedAccount['receipts'] ?? '0.00';
                            interest = selectedAccount['interest'] ?? '0.00';
                            // Send the closing balance to the parent screen

                            setState(() {
                              selectedAccountDetails = selectedAccount;
                            });

                            updateClosingBalance(closingBalance);
                            updateInstallmentDetails(selectedAccount);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      const Text(
                        "Current Balance",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        '\₹' + formattedBalance,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.29,
              margin: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03, bottom: screenWidth * 0.01),
              // margin: EdgeInsets.all(screenWidth * 0.02),
              padding: EdgeInsets.all(screenWidth * 0.01),
              decoration: BoxDecoration(color: Colors.white, boxShadow: kElevationToShadow[1], borderRadius: BorderRadius.circular(5)),
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
                    inputextController: monthsDueController,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    maxLength: 3,
                  ),
                  CustomFieldInsideContainer(
                    labeltext: " EMi",
                    inputextController: emitController,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    maxLength: 7,
                  ),
                  CustomFieldInsideContainer(
                    labeltext: "Amount Paid",
                    inputextController: amountPaidController,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    maxLength: 7,
                    onChanged: (p0) {
                      setState(() {
                        calculateTotal();
                      });
                    },
                  ),
                  CustomFieldInsideContainer(
                    labeltext: "Interest",
                    inputextController: interestController,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    maxLength: 7,
                    onChanged: (p0) {
                      setState(() {
                        calculateTotal();
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.07,
              margin: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03),
              // padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                  boxShadow: kElevationToShadow[1],
                  color: const Color.fromARGB(255, 224, 225, 255),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  const Text(
                    "Total Amount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Spacer(),
                  Text(
                    '₹${totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ),
            Spacer(),

            CustomBottomButtons(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              addbutton: () {
                accountAddedList.add(selectedAccountDetails!);
                print(selectedAccountDetails);

                print(amountPaidController.text);

                amountPaidController.clear();
                print(amountPaidController.text);
                emitController.clear();
                interestController.clear();
                monthsDueController.clear();

                // final dropdownState = _dropdownKey.currentState;

                // dropdownState!.didChange(dropdownState.value);
                // FocusScope.of(context).requestFocus(FocusNode());
                // dropdownState.context.findRenderObject()?.showOnScreen(duration: Duration(milliseconds: 200));
              },
              nextButton: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemberDetailsFinalScreen(
                            accountAddedList: accountAddedList,
                          )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomBottomButtons extends StatelessWidget {
  const CustomBottomButtons({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.addbutton,
    required this.nextButton,
  });

  final double screenWidth;
  final double screenHeight;
  final VoidCallback addbutton;
  final VoidCallback nextButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: screenWidth * 0.2),
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
                  onPressed: addbutton,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: screenHeight * 0.05,
                child: CustomTextButton(
                  buttonText: "NEXT",
                  onPressed: nextButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomDropdown extends StatefulWidget {
//   final Function(String) onBalanceChanged; // Callback function
//   List<MemberAccountDetailsModel>? accountDetailsList;
//   Map<String, dynamic>? selectedAccountDetails;

//   final Function(Map<String, String>) onAccountSelected; // New callback for account details

//   CustomDropdown(
//       {Key? key,
//       required this.onBalanceChanged,
//       required this.onAccountSelected,
//       required this.accountDetailsList,
//       this.selectedAccountDetails})
//       : super(key: key);

//   @override
//   _CustomDropdownState createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0, 1),
//             blurRadius: 2.0,
//           ),
//         ],
//         border: Border.all(color: const Color.fromARGB(255, 149, 147, 147), width: 1.0), // Rectangular border
//         borderRadius: BorderRadius.circular(2.0),
//       ),
//       child: Center(
//         child: DropdownButtonFormField<String>(
//           value: selectedValue,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black), // Right-side down arrow
//           decoration: const InputDecoration.collapsed(hintText: ''), // Remove underline
//           items: dropdownItems.map((item) {
//             // Combine accountNumber and sDisplayName for display
//             String displayText = '${item['accountNumber']} - ${item['sDisplayName']}';
//             return DropdownMenuItem<String>(
//               value: item['accountNumber'], // Use accountNumber as the value
//               child: Text(displayText),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               selectedValue = newValue;
//               // Find the selected account and update closingBalance
//               final selectedAccount = dropdownItems.firstWhere(
//                 (item) => item['accountNumber'] == newValue,
//               );
//               closingBalance = selectedAccount['closingBalance'];
//               emi = selectedAccount['eMI'] ?? '0.00';
//               monthsDue = selectedAccount['monthsDue'] ?? '0';
//               receipts = selectedAccount['receipts'] ?? '0.00';
//               interest = selectedAccount['interest'] ?? '0.00';
//               // Send the closing balance to the parent screen

//               setState(() {
//                 widget.selectedAccountDetails = selectedAccount;
//               });

//               widget.onAccountSelected(selectedAccount);
//               widget.onBalanceChanged(closingBalance ?? '0.00');
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

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
                    top: BorderSide(width: 1.0, color: Colors.black), // Top border
                    bottom: BorderSide(width: 1.0, color: Colors.black), // Top border
                    left: BorderSide(width: 1.0, color: Colors.black), // Left border
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

class TabBarscreen1 extends StatelessWidget {
  const TabBarscreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Text('screenone'),
        )
      ],
    ));
  }
}

class TabBarscreen2 extends StatelessWidget {
  const TabBarscreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Text('screenone'),
        )
      ],
    ));
  }
}
