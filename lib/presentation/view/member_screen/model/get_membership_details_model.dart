class MemberShipDetailsModel {
  final int? currentStatus;
  final int? membershipID;
  final int? membershipNumber;
  final String? memberName;
  final String? memberNameLang;
  final String? displayName;
  final String? headOfFamily;
  final String? groupNumber;
  final String? membershipDate;
  final String? memberType;

  MemberShipDetailsModel({
    this.currentStatus,
    this.membershipID,
    this.membershipNumber,
    this.memberName,
    this.memberNameLang,
    this.displayName,
    this.headOfFamily,
    this.groupNumber,
    this.membershipDate,
    this.memberType,
  });

  MemberShipDetailsModel.fromJson(Map<String, dynamic> json)
      : currentStatus = json['CurrentStatus'] as int?,
        membershipID = json['MembershipID'] as int?,
        membershipNumber = json['MembershipNumber'] as int?,
        memberName = json['MemberName'] as String?,
        memberNameLang = json['MemberNameLang'] as String?,
        displayName = json['DisplayName'] as String?,
        headOfFamily = json['HeadOfFamily'] as String?,
        groupNumber = json['GroupNumber'] as String?,
        membershipDate = json['MembershipDate'] as String?,
        memberType = json['MemberType'] as String?;

  Map<String, dynamic> toJson() => {
        'CurrentStatus': currentStatus,
        'MembershipID': membershipID,
        'MembershipNumber': membershipNumber,
        'MemberName': memberName,
        'MemberNameLang': memberNameLang,
        'DisplayName': displayName,
        'HeadOfFamily': headOfFamily,
        'GroupNumber': groupNumber,
        'MembershipDate': membershipDate,
        'MemberType': memberType
      };
}
