// File: api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:microfin/presentation/view/member_screen/model/member_accountdetails_model.dart';

class ApiService {
  static const String _baseUrl = 'http://154.38.175.150:8090/api/mobile';

  Future<List<MemberAccountDetailsModel>> fetchMemberAccounts(
      String membershipID, String receiptDate) async {
    final uri = Uri.parse('$_baseUrl/getMemberAccountsForReceipts')
        .replace(queryParameters: {
      'MembershipID': membershipID,
      'ReceiptDate': receiptDate,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      final String result = responseJson['result'];
      final Map<String, dynamic> resultJson = jsonDecode(result);

      return (resultJson['AccountDetails'] as List)
          .map((e) =>
              MemberAccountDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch accounts: ${response.reasonPhrase}');
    }
  }
}
