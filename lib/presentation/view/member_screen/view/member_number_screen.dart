import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:microfin/core/constants/colour.dart';
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
        title: Text(
          userName,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
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
            membershipNumberController: _membershipNumberController,
            getMembershipDetails: () async {
              FocusScope.of(context).unfocus();
              membershipFechedDetails = await getMembershipDetails();

              log("fetched values -- ${membershipFechedDetails!.displayName}");
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MemberDetailsScreen(
                      memberDetails: membershipFechedDetails!,
                      loginResponse: widget.loginResponse),
                ),
              );
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
    );
  }

  Future<MemberShipDetailsModel?> getMembershipDetails() async {
    String membershipNumber = _membershipNumberController.text.trim();

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
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return null;
    }
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
              height: widget.screenHeight * 0.05,
              child: CustomTextButton(
                  buttonText: "RESET", onPressed: widget.resetButton),
            ),
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
  CustomMiddleMemberDetails(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      this.memberName,
      this.fatherName,
      this.dateofJoin,
      this.groupnumber});

  final double screenWidth;
  final double screenHeight;
  String? memberName;
  String? fatherName;
  String? groupnumber;
  String? dateofJoin;

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
  CustomheaderWidgetMemberShipNumber({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.getMembershipDetails,
    required this.membershipNumberController,
  });

  final double screenWidth;
  final double screenHeight;
  final VoidCallback getMembershipDetails;
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
          ],
        ),
      ],
    );
  }
}
