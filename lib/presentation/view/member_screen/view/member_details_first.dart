import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/member_screen/model/get_membership_details_model.dart';
import 'package:microfin/presentation/view/member_screen/model/member_accountdetails_model.dart';
import 'package:microfin/presentation/view/member_screen/model/other_account_model.dart';
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
  final TextEditingController otherAccountamountController =
      TextEditingController();
  String formattedTotal = "0";

  List<MemberAccountDetailsModel> accountDetailsList = [];
  List<OtherAccountModel> otherAccountList = [];
  List<Map<String, dynamic>> accountAddedList = [];
  Map<String, dynamic>? selectedAccountDetails;

  bool isOtherAccount = false;

  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dropdownKey2 = GlobalKey<FormFieldState>();
  String? selectedValue;
  String? selectedDropValue;
  List<Map<String, String>> accountDropdownItems = [];
  List<Map<String, String>> otherAccountDropdownItems = [];

  String? emi;
  String? monthsDue;
  String? receipts;
  String? interest;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
    fetchOtherAccountData();
  }

  String responseText = "Fetching data...";

  // Other Account screen api call
  Future<void> fetchOtherAccountData() async {
    const String apiUrl =
        "http://154.38.175.150:8090/api/accountHead/getGLAccounts";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      log('Api calling of OtherAccount TabScreen2');

      Map<String, dynamic> responseJson = jsonDecode(response.body);

      log("API response status -1: ${response.statusCode}");
      log("API response body  -1: ${response.body.toString()}");

      var result = responseJson['result'];
      print(
          "response of Accountnumber - ${result['AccountHeads'][0]['DisplayName']}");

      otherAccountList = (result['AccountHeads'] as List)
          .map((e) => OtherAccountModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // print("count -- " + otherAccountList.length.toString());

      List<dynamic> accountHeads = result['AccountHeads'];
      setState(() {
        otherAccountDropdownItems =
            accountHeads.map<Map<String, String>>((account) {
          return {
            'DisplayName': account['DisplayName'],
          };
        }).toList();
      });
      if (response.statusCode == 200) {
        setState(() {
          responseText = json.decode(response.body)['title'];
        });

        print("------1------" + responseText);
      } else {
        setState(() {
          responseText = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        responseText = "Failed to fetch data. Error: $e";
      });
    }
  }

// Account screen api calling
  Future<void> fetchDropdownData() async {
    try {
      String membershipID = "70107";
      String receiptDate = "2024-11-08";

      final uri = Uri.parse(
              'http://154.38.175.150:8090/api/mobile/getMemberAccountsForReceipts')
          .replace(queryParameters: {
        'MembershipID': membershipID,
        'ReceiptDate': receiptDate,
      });

      var response = await http.get(uri);
      log('Api calling of Account TabScreen');
      log("API response status: ${response.statusCode}");
      log("API response body: ${response.body.toString()}");
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);

        String result = responseJson['result'];

        Map<String, dynamic> resultJson = jsonDecode(result);

        accountDetailsList = (resultJson['AccountDetails'] as List)
            .map((e) =>
                MemberAccountDetailsModel.fromJson(e as Map<String, dynamic>))
            .toList();

        List<dynamic> accountDetails = resultJson['AccountDetails'];
        setState(() {
          accountDropdownItems =
              accountDetails.map<Map<String, String>>((account) {
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

    double totalAmount = amountPaid + interest;
    // Calculate total
    setState(() {
      formattedTotal = NumberFormat("#,##0").format(totalAmount);
    });
  }

  // Callback to update closingBalance
  void updateClosingBalance(String newBalance) {
    setState(() {
      closingBalance = newBalance;
    });
  }

  // Callback to update installment details
  void updateInstallmentDetails(Map<String, dynamic> accountDetails) {
    setState(() {
      monthsDueController.text = accountDetails['monthsDue'];
      emitController.text = accountDetails['eMI'];
      amountPaidController.text = accountDetails['receipts'];
      interestController.text = accountDetails['interest'];
      calculateTotal();
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
    String formattedBalance =
        NumberFormat('#,###').format(int.tryParse(closingBalance) ?? 0);

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
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          backgroundColor: appbarColor,
          elevation: 0,
          leading: PopupMenuButton<String>(
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
                  '     Number: $membershipNumber   Name: $memberName  \n                    Group: $groupNumber ',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
            ),
            // the tab bar with two items

            SizedBox(
              height: 50,
              child: AppBar(
                bottom: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.black,
                  indicatorWeight: 2.5,
                  tabs: const [
                    Tab(text: 'Accounts'),
                    Tab(text: 'Other Accounts'),
                  ],
                ),
              ),
            ),
            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            // dropdownButton
                            Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    color: const Color.fromARGB(
                                        255, 149, 147, 147),
                                    width: 1.0), // Rectangular border
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  key: _dropdownKey,
                                  value: selectedValue,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors
                                          .black), // Right-side down arrow
                                  decoration: const InputDecoration.collapsed(
                                      hintText: ''), // Remove underline
                                  items: accountDropdownItems.map((item) {
                                    // Combine accountNumber and sDisplayName for display
                                    String displayText =
                                        '${item['accountNumber']} - ${item['sDisplayName']}';
                                    return DropdownMenuItem<String>(
                                      value: item[
                                          'accountNumber'], // Use accountNumber as the value
                                      child: Text(displayText),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedValue = newValue;
                                      // Find the selected account and update closingBalance
                                      final selectedAccount =
                                          accountDropdownItems.firstWhere(
                                        (item) =>
                                            item['accountNumber'] == newValue,
                                      );
                                      closingBalance =
                                          selectedAccount['closingBalance']!;
                                      emi = selectedAccount['eMI'] ?? '0.00';
                                      monthsDue =
                                          selectedAccount['monthsDue'] ?? '0';
                                      receipts =
                                          selectedAccount['receipts'] ?? '0.00';
                                      interest =
                                          selectedAccount['interest'] ?? '0.00';
                                      // Send the closing balance to the parent screen

                                      isOtherAccount = false;

                                      setState(() {
                                        selectedAccountDetails =
                                            selectedAccount;
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
                                  '₹$formattedBalance',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                        margin: EdgeInsets.only(
                            left: screenWidth * 0.02,
                            right: screenWidth * 0.02),
                        // padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[1],
                            color: const Color.fromARGB(255, 224, 225, 255),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Spacer(),
                            Text(
                              '₹$formattedTotal',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // second tab bar viiew widget
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(screenWidth * 0.02),
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                            boxShadow: kElevationToShadow[1],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Other Accounts",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            // other account dropdown
                            Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                    color: const Color.fromARGB(
                                        255, 149, 147, 147),
                                    width: 1.0), // Rectangular border
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  key: _dropdownKey2,
                                  value: selectedDropValue,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors
                                          .black), // Right-side down arrow
                                  decoration: const InputDecoration.collapsed(
                                      hintText: ''), // Remove underline
                                  items: otherAccountDropdownItems.map((item) {
                                    // Combine accountNumber and sDisplayName for display
                                    String displayText =
                                        '${item['DisplayName']}';
                                    return DropdownMenuItem<String>(
                                      value: item[
                                          'DisplayName'], // Use accountNumber as the value
                                      child: Text(displayText),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDropValue = newValue;
                                      // Find the selected account and update closingBalance
                                      final selectedAccount =
                                          otherAccountDropdownItems.firstWhere(
                                        (item) =>
                                            item['DisplayName'] == newValue,
                                      );

                                      // print(selectedAccount.displayName);

                                      isOtherAccount = true;

                                      setState(() {
                                        selectedAccountDetails =
                                            selectedAccount;
                                      });

                                      // updateClosingBalance(closingBalance);
                                      // updateInstallmentDetails(selectedAccount);
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              children: [
                                const Text(
                                  "Amount",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: screenHeight * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1),
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      // textAlign: TextAlign.end,
                                      keyboardType: TextInputType.number,
                                      maxLength: 7,
                                      controller: otherAccountamountController,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                        counterText: "",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Spacer(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            CustomBottomButtons(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              addbutton: () {
                if (isOtherAccount) {
                  if (selectedAccountDetails != null &&
                      otherAccountamountController.text.isNotEmpty) {
                    setState(() {
                      accountAddedList.add({
                        'sDisplayName': selectedAccountDetails!['DisplayName'],
                        'eMI': double.tryParse(
                                otherAccountamountController.text) ??
                            0.0,
                      });

                      // Clear the form after adding
                      selectedDropValue = null;
                      selectedAccountDetails = null;
                      otherAccountamountController.clear();
                    });
                  }
                } else {
                  accountAddedList.add(selectedAccountDetails!);
                }

                amountPaidController.clear();
                emitController.clear();
                interestController.clear();
                monthsDueController.clear();
                setState(() {
                  formattedTotal = '0';
                });
                print("Add to account list");
                log(accountAddedList.toString());
              },
              nextButton: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MemberDetailsFinalScreen(
                      accountAddedList: accountAddedList,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomBottomButtons extends StatefulWidget {
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
  State<CustomBottomButtons> createState() => _CustomBottomButtonsState();
}

class _CustomBottomButtonsState extends State<CustomBottomButtons> {
  bool _isNextButtonEnabled = false;

  void _handleAddButton() {
    widget.addbutton(); // Call the provided "ADD" button callback
    setState(() {
      _isNextButtonEnabled = true; // Enable the NEXT button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.screenWidth * 0.0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(widget.screenWidth * 0.01),
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
              width: widget.screenWidth * 0.012,
            ),
            Expanded(
              child: SizedBox(
                height: widget.screenHeight * 0.05,
                child: CustomTextButton(
                  buttonText: "ADD",
                  onPressed: _handleAddButton,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: widget.screenHeight * 0.05,
                child: CustomTextButton(
                  buttonText: "NEXT",
                  onPressed: _isNextButtonEnabled ? widget.nextButton : null,
                  buttonColor: _isNextButtonEnabled ? appbarColor : Colors.grey,
                ),
              ),
            ),
          ],
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
