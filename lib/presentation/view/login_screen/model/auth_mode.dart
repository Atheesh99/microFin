// import 'dart:convert';

// class ValidationModel {
//   String username;
//   String password;

//   // Required Constructor
//   ValidationModel({
//     required this.username,
//     required this.password,
//   });

//   // Named constructor to create an object from JSON string
//   factory ValidationModel.fromReqBody(String body) {
//     Map<String, dynamic> json = jsonDecode(body);

//     return ValidationModel(
//       username: json['LoginID'],
//       password: json['Password'],
//     );
//   }

//   // Convert object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'password': password,
//     };
//   }

//   // Print attributes
//   void printAttributes() {
//     print("name: ${this.username}\n");
//     print("token: ${this.password}\n");
//   }
// }
