class BankModel {
  final int id;
  final int userId;
  final String bankName;
  final String? branchName;
  final String accountName;
  final String accountNumber;
  final String ifscCode;
  final String accountType;

  BankModel({
    required this.id,
    required this.userId,
    required this.bankName,
    required this.branchName,
    required this.accountName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountType,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'],
      userId: json['user_id'],
      bankName: json['bank_name'],
      branchName: json['branch_name'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      accountType: json['account_type'],
    );
  }
}