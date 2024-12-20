class OtherAccountModel {
  final String? accountHeadID;
  final String? displayName;
  final String? accountGroupID;

  OtherAccountModel({
    this.accountHeadID,
    this.displayName,
    this.accountGroupID,
  });

  OtherAccountModel.fromJson(Map<String, dynamic> json)
      : accountHeadID = json['AccountHeadID'] as String?,
        displayName = json['DisplayName'] as String?,
        accountGroupID = json['AccountGroupID'] as String?;

  Map<String, dynamic> toJson() => {
        'AccountHeadID': accountHeadID,
        'DisplayName': displayName,
        'AccountGroupID': accountGroupID
      };
}
