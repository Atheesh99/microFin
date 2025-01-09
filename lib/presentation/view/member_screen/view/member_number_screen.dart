import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
import 'package:microfin/presentation/view/login_screen/view/login_screen.dart';
import 'package:microfin/presentation/view/member_screen/model/get_membership_details_model.dart';
import 'package:microfin/presentation/view/member_screen/model/membership_fetch_model.dart';
import 'package:microfin/presentation/view/member_screen/view/member_details_first.dart';
import 'package:microfin/presentation/widgets/textbutton.dart';

class MemberNumber extends StatefulWidget {
  final Map<String, dynamic> loginResponse;
  const MemberNumber({super.key, required this.loginResponse});

  @override
  State<MemberNumber> createState() => _MemberNumberState();
}

class _MemberNumberState extends State<MemberNumber> {
  final TextEditingController _membershipNumberController =
      TextEditingController();
  String? memberName;
  String? fatherName;
  String? groupnumber;
  String? dateofJoin;
  String? membershipNumber;
  Map<String, dynamic>? memberResponse;

  MemberShipDetailsModel? membershipFechedDetails;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final result = widget.loginResponse['result'];

    final userName = result != null ? result['UserName'] : 'Unknown User';
    final organizationDetails =
        result != null ? result['DisplayName'] : 'No Display Name';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        // toolbarHeight: mediaQuery.size.height * 0.05,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: appbarColor,
        elevation: 0, centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          userName,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        ),

        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
              icon: const Icon(Icons.logout, color: Colors.white))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
              ), //BoxDecoration
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 45,
                    child: Text("M"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "MicroFin",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash Summary'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
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
              child: Center(
                child: Text(
                  organizationDetails,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
            ),
            CustomheaderWidgetMemberShipNumber(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Enter Membership Number';
              //   }
              //   return null;
              // },
              membershipNumberController: _membershipNumberController,
              getMembershipDetails: () async {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  log("fetched values -- ");
                  membershipFechedDetails = await getMembershipDetails();

                  log("fetched values -- ${membershipFechedDetails!.displayName}");
                }
              },
            ),
            CustomMiddleMemberDetails(
              memberName: memberName,
              dateofJoin: dateofJoin,
              fatherName: fatherName,
              groupnumber: groupnumber,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const Spacer(),
            CustomBottomButtons(
              nextButton: () {
                if (membershipFechedDetails == null) {
                  _showErrorDialog(" Enter Membership Number.");
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MemberDetailsScreen(
                          memberDetails: membershipFechedDetails!,
                          loginResponse: widget.loginResponse),
                    ),
                  );
                }
              },
              resetButton: () {
                setState(() {
                  memberName = "";
                  fatherName = "";
                  groupnumber = "";
                  groupnumber = "";
                  dateofJoin = "";
                  _membershipNumberController.clear();
                });
              },
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              loginResponse: widget.loginResponse,
            ),
          ],
        ),
      ),
    );
  }

  Future<MemberShipDetailsModel?> getMembershipDetails() async {
    String membershipNumber = _membershipNumberController.text.trim();

    // Validate membership number
    if (membershipNumber.isEmpty) {
      _showErrorDialog("Membership Number is required.");
      return null; // Stop execution if validation fails
    }

    // Create the request object (model)
    final membershipData = MembershipFetchModel(
      officeID: '3',
      membershipID: membershipNumber,
      defaultLanguage: '1',
    );

    // Define headers
    var headers = {'Content-Type': 'application/json'};

    try {
      // Make the POST request
      var response = await http.post(
        Uri.parse(
            'http://154.38.175.150:8090/api/members/getMembershipDetails'),
        headers: headers,
        body: json.encode(membershipData.toJson()),
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        final responseData = jsonDecode(response.body);

        // Extract `result` and parse it into a model
        var result = responseData['result'];

        MemberShipDetailsModel memberResult =
            MemberShipDetailsModel.fromJson(result);

        setState(() {
          memberName = memberResult.memberName;
          fatherName = memberResult.headOfFamily;
          groupnumber = memberResult.groupNumber;
          dateofJoin = memberResult.membershipDate;
        });
        return memberResult;
      } else {
        // Handle unsuccessful responses
        print('Error: ${response.reasonPhrase}');
        _showErrorDialog(
            "Failed to fetch membership details. Please try again.");
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      _showErrorDialog("Member details not found Or Incorrect Member Details.");
      return null;
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                memberName = "";
                fatherName = "";
                groupnumber = "";
                groupnumber = "";
                dateofJoin = "";
                _membershipNumberController.clear();
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class CustomBottomButtons extends StatefulWidget {
  const CustomBottomButtons({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.loginResponse,
    required this.resetButton,
    required this.nextButton,
  });

  final double screenWidth;
  final double screenHeight;
  final VoidCallback resetButton;
  final VoidCallback nextButton;

  final Map<String, dynamic> loginResponse;

  @override
  State<CustomBottomButtons> createState() => _CustomBottomButtonsState();
}

class _CustomBottomButtonsState extends State<CustomBottomButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(widget.screenWidth * 0.02),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: widget.screenHeight * 0.05,
              child: CustomTextButton(
                  buttonText: "RESET", onPressed: widget.resetButton),
            ),
          ),
          const SizedBox(
            width: .7,
          ),
          Expanded(
            child: SizedBox(
              height: widget.screenHeight * 0.05,
              child: CustomTextButton(
                  buttonText: "NEXT", onPressed: widget.nextButton),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMiddleMemberDetails extends StatelessWidget {
  const CustomMiddleMemberDetails(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      this.memberName,
      this.fatherName,
      this.dateofJoin,
      this.groupnumber});

  final double screenWidth;
  final double screenHeight;
  final String? memberName;
  final String? fatherName;
  final String? groupnumber;
  final String? dateofJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.33,
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
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
            inputext: memberName ?? "",
          ),
          CustomField(
            labeltext: "Father/Husband",
            inputext: fatherName ?? "",
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          CustomField(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            labeltext: "Group Number",
            inputext: groupnumber ?? "",
          ),
          CustomField(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            labeltext: "Date of Joining",
            inputext: dateofJoin ?? "",
          ),
        ],
      ),
    );
  }
}

class CustomheaderWidgetMemberShipNumber extends StatefulWidget {
  const CustomheaderWidgetMemberShipNumber({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.getMembershipDetails,
    required this.membershipNumberController,
    this.validator,
  });

  final double screenWidth;
  final double screenHeight;
  final VoidCallback getMembershipDetails;
  final FormFieldValidator<String>? validator;

  final TextEditingController membershipNumberController;

  @override
  State<CustomheaderWidgetMemberShipNumber> createState() =>
      _CustomheaderWidgetMemberShipNumberState();
}

class _CustomheaderWidgetMemberShipNumberState
    extends State<CustomheaderWidgetMemberShipNumber> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 180,
      width: double.infinity,
      margin: EdgeInsets.all(widget.screenWidth * 0.02),
      padding: EdgeInsets.all(widget.screenWidth * 0.03),
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
                  height: widget.screenHeight * 0.05,
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
                    controller: widget.membershipNumberController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    validator: widget.validator,
                    maxLength: 6,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        counterText: '',
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
                        errorBorder: InputBorder.none,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                width: widget.screenWidth * 0.05,
              ),
              Expanded(
                child: SizedBox(
                  height: widget.screenHeight * 0.045,
                  child: CustomTextButton(
                    buttonText: 'Fetch',
                    onPressed: widget.getMembershipDetails,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Expanded(
              child: Container(
                height: screenHeight * 0.05,
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
                child: Container(
                  height: screenHeight * 0.05,
                  padding: const EdgeInsets.only(left: 4, top: 12),
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
                  child: Text(
                    inputext,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
