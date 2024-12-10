class MemberAccountDetailsModel {
  final String? rowID;
  final String? membershipID;
  final String? membAccMasterID;
  final String? memAccDetailID;
  final String? accountNumber;
  final String? receipts;
  final String? interest;
  final String? closingBalance;
  final String? eMI;
  final String? eMIPaidUpto;
  final String? lastTransaction;
  final String? monthsDue;
  final String? dayMonth;
  final String? rateOfInt;
  final String? schemeID;
  final String? sDisplayName;
  final String? intPerDay;
  final String? intChargedForDays;
  final String? accountGroupID;

  MemberAccountDetailsModel({
    this.rowID,
    this.membershipID,
    this.membAccMasterID,
    this.memAccDetailID,
    this.accountNumber,
    this.receipts,
    this.interest,
    this.closingBalance,
    this.eMI,
    this.eMIPaidUpto,
    this.lastTransaction,
    this.monthsDue,
    this.dayMonth,
    this.rateOfInt,
    this.schemeID,
    this.sDisplayName,
    this.intPerDay,
    this.intChargedForDays,
    this.accountGroupID,
  });

  MemberAccountDetailsModel.fromJson(Map<String, dynamic> json)
      : rowID = json['RowID'] as String?,
        membershipID = json['MembershipID'] as String?,
        membAccMasterID = json['MembAccMasterID'] as String?,
        memAccDetailID = json['MemAccDetailID'] as String?,
        accountNumber = json['AccountNumber'] as String?,
        receipts = json['Receipts'] as String?,
        interest = json['Interest'] as String?,
        closingBalance = json['ClosingBalance'] as String?,
        eMI = json['EMI'] as String?,
        eMIPaidUpto = json['EMIPaidUpto'] as String?,
        lastTransaction = json['LastTransaction'] as String?,
        monthsDue = json['MonthsDue'] as String?,
        dayMonth = json['DayMonth'] as String?,
        rateOfInt = json['RateOfInt'] as String?,
        schemeID = json['SchemeID'] as String?,
        sDisplayName = json['SDisplayName'] as String?,
        intPerDay = json['IntPerDay'] as String?,
        intChargedForDays = json['IntChargedForDays'] as String?,
        accountGroupID = json['AccountGroupID'] as String?;

  Map<String, dynamic> toJson() => {
        'RowID': rowID,
        'MembershipID': membershipID,
        'MembAccMasterID': membAccMasterID,
        'MemAccDetailID': memAccDetailID,
        'AccountNumber': accountNumber,
        'Receipts': receipts,
        'Interest': interest,
        'ClosingBalance': closingBalance,
        'EMI': eMI,
        'EMIPaidUpto': eMIPaidUpto,
        'LastTransaction': lastTransaction,
        'MonthsDue': monthsDue,
        'DayMonth': dayMonth,
        'RateOfInt': rateOfInt,
        'SchemeID': schemeID,
        'SDisplayName': sDisplayName,
        'IntPerDay': intPerDay,
        'IntChargedForDays': intChargedForDays,
        'AccountGroupID': accountGroupID
      };
}
