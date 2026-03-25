class WalletResponse {
  final int status;
  final String message;
  final WalletResult result;

  WalletResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      status: json["status"],
      message: json["message"],
      result: WalletResult.fromJson(json["result"]),
    );
  }
}

class WalletResult {
  final UserInfo userInfo;
  final AccountSummary summary;
  final List<TransactionModel> transactions;
  final Pagination pagination;

  WalletResult({
    required this.userInfo,
    required this.summary,
    required this.transactions,
    required this.pagination,
  });

  factory WalletResult.fromJson(Map<String, dynamic> json) {
    return WalletResult(
      userInfo: UserInfo.fromJson(json["user_info"]),
      summary: AccountSummary.fromJson(json["account_summary"]),
      transactions: (json["transactions"] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }
}

class UserInfo {
  final String name;
  final String email;
  final String mobile;

  UserInfo({
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
    );
  }
}

class AccountSummary {
  final int currentBalance;
  final int totalCredit;
  final int totalDebit;

  AccountSummary({
    required this.currentBalance,
    required this.totalCredit,
    required this.totalDebit,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    return AccountSummary(
      currentBalance: json["current_balance"] ?? 0,
      totalCredit: json["total_credit"] ?? 0,
      totalDebit: json["total_debit"] ?? 0,
    );
  }
}

class TransactionModel {
  final String date;
  final String time;
  final String transactionId;
  final String debit;
  final String credit;
  final String status;

  TransactionModel({
    required this.date,
    required this.time,
    required this.transactionId,
    required this.debit,
    required this.credit,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      transactionId: json["transaction_id"] ?? "",
      debit: json["debit"] ?? "",
      credit: json["credit"] ?? "",
      status: json["status"] ?? "",
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;

  Pagination({
    required this.currentPage,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
    );
  }
}