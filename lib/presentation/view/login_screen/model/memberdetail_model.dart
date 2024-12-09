class AccountDetail {
  final String accountNumber;

  AccountDetail({required this.accountNumber});

  factory AccountDetail.fromJson(Map<String, dynamic> json) {
    return AccountDetail(
      accountNumber: json['AccountNumber'],
    );
  }
}

class Result {
  final List<AccountDetail> accountDetails;

  Result({required this.accountDetails});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      accountDetails: (json['AccountDetails'] as List)
          .map((item) => AccountDetail.fromJson(item))
          .toList(),
    );
  }
}

class ResponseModel {
  final Result? result;

  ResponseModel({this.result});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }
}

class MemberAccountsRequestModel {
  final String membershipID;
  final String receiptDate;

  MemberAccountsRequestModel({
    required this.membershipID,
    required this.receiptDate,
  });

  Map<String, String> toQueryParameters() {
    return {
      'MembershipID': membershipID,
      'ReceiptDate': receiptDate,
    };
  }
}
