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
// Common API response model
class ApiResponse<T> {
  final int statusCode;
  final String? exception;
  final String userMessage;
  final T? result;
  final dynamic additionalResult;
  final int exceptionCode;
  final String? error;

  ApiResponse({
    required this.statusCode,
    this.exception,
    required this.userMessage,
    this.result,
    this.additionalResult,
    required this.exceptionCode,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'],
      exception: json['exception'],
      userMessage: json['userMessage'],
      result: json['result'] != null ? fromJsonT(json['result']) : null,
      additionalResult: json['additionalResult'],
      exceptionCode: json['exceptionCode'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'statusCode': statusCode,
      'exception': exception,
      'userMessage': userMessage,
      'result': result != null ? toJsonT(result!) : null,
      'additionalResult': additionalResult,
      'exceptionCode': exceptionCode,
      'error': error,
    };
  }
}

// LoginModel for the `result` field
class LoginModel {
  final int userID;
  final String userName;
  final String collectionDate;
  final int officeID;
  final String displayName;

  LoginModel({
    required this.userID,
    required this.userName,
    required this.collectionDate,
    required this.officeID,
    required this.displayName,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      userID: json['UserID'],
      userName: json['UserName'],
      collectionDate: json['CollectionDate'],
      officeID: json['OfficeID'],
      displayName: json['DisplayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'UserName': userName,
      'CollectionDate': collectionDate,
      'OfficeID': officeID,
      'DisplayName': displayName,
    };
  }
}
