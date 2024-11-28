// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:microfin/presentation/view/member_screen/model/membership_fetch_model.dart';

// class MembershipNumberService {
//   // Method to send MembershipNumber data via HTTP POST
//   Future<void> sendMembershipNumber(MembershipNum membershipNumber) async {
//     final url = Uri.parse(
//         'https://your-api-endpoint.com/submit'); // Replace with your actual API endpoint

//     // Prepare the body data by converting the MembershipNumber object to JSON
//     final body = json.encode(membershipNumber.toJson());

//     try {
//       // Send the HTTP POST request
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         print('Success: Data sent successfully');
//       } else {
//         print(
//             'Error: Failed to send data, Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: Failed to send data. Exception: $e');
//     }
//   }
// }
