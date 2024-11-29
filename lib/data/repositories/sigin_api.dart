import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:microfin/data/repositories/api.dart';

class AuthAPI extends BaseAPI {
  Future<void> login(String usernameValue, String passwordValue) async {
    // Convert the password to SHA-256 hash
    var username = convertToSha256(usernameValue);
    var password = convertToSha256(passwordValue);
    print("SHA-256 Hashed Username: $username");
    print("SHA-256 Hashed Password: $password");

    // API endpoint URL
    const String url =
        'http://154.38.175.150:8090/api/users/validateMobileUser';

    // Prepare the request body
    final Map<String, String> requestBody = {
      "LoginID": username.toUpperCase(),
      "Password": password.toUpperCase(),
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Specify content type
        },
        body: jsonEncode(requestBody), // Encode request body
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Decode response JSON if needed
        final responseData = jsonDecode(response.body);
        print("Login successful: $responseData");
      } else {
        print(
            "Login failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      // Handle exceptions
      print("An error occurred: $e");
    }

    // Define headers
    // var headers = {
    //   'Content-Type': 'application/json',
    // };

    // // Create the request
    // var request = await http.Request(
    //   'POST',
    //   Uri.parse('http://154.38.175.150:8090/api/users/validateMobileUser'),
    // );

    // // Add the body
    // request.body = json.encode({
    //   "LoginID": username.toUpperCase(),
    //   "Password": password.toUpperCase(),
    // });

    // // Add headers
    // request.headers.addAll(headers);

    // try {
    //   // Send the request
    //   http.StreamedResponse response = await request.send();

    //   // Handle the response
    //   if (response.statusCode == 200) {
    //     // Parse the response
    //     String responseBody = await response.stream.bytesToString();

    //     var jsonResponse = json.decode(responseBody);

    //     // Check if the user exists in the response
    //     if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
    //       print("Login successful. User exists in the API response.");

    //       print(jsonResponse['success'].toString());

    //       return true;
    //     } else {
    //       throw Exception(
    //           jsonResponse['message'] ?? 'Invalid login credentials.');
    //     }
    //   } else {
    //     String errorDetails = await response.stream.bytesToString();
    //     throw Exception('Error during login: $errorDetails');
    //   }
    // } catch (e) {
    //   print("Error during login: $e");
    //   rethrow;
    // }
  }

  String convertToSha256(String input) {
    var newvalue = "$input${BaseAPI.hashcode}";
    if (input.isEmpty) {
      throw ArgumentError("Input string cannot be empty.");
    }

    // Convert the input string to a UTF8 encoded list of bytes
    List<int> bytes = utf8.encode(newvalue);

// Perform the SHA256 hash operation
    Digest sha256Result = sha256.convert(bytes);

    // Convert the hash bytes to a hexadecimal string
    return sha256Result.bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }
}
