class MembershipFetchModel {
  final String officeID;
  final String membershipID;
  final String defaultLanguage;

  MembershipFetchModel({
    required this.officeID,
    required this.membershipID,
    required this.defaultLanguage,
  });

  // Convert the model object to JSON format for request
  Map<String, dynamic> toJson() {
    return {
      'OfficeID': officeID,
      'MembershipID': membershipID,
      'DefaultLanguage': defaultLanguage,
    };
  }

  // Create a model object from JSON (response parsing)
  factory MembershipFetchModel.fromJson(Map<String, dynamic> json) {
    return MembershipFetchModel(
      officeID: json['OfficeID'] ?? '',
      membershipID: json['MembershipID'] ?? '',
      defaultLanguage: json['DefaultLanguage'] ?? '',
    );
  }
}
