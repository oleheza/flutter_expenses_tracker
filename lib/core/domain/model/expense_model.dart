class ExpenseModel {
  static const fieldUserId = 'user_id';
  static const fieldName = 'name';
  static const fieldTimestamp = 'timestamp';
  static const fieldAmount = 'amount';

  final String? id;
  final String userId;
  final String name;
  final double amount;
  final int timestamp;

  ExpenseModel({
    this.id,
    required this.userId,
    required this.name,
    required this.timestamp,
    required this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          amount == other.amount &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(id, userId, name, amount, timestamp);

  @override
  String toString() {
    return 'ExpenseModel{id: $id, userId: $userId, name: $name, amount: $amount, timestamp: $timestamp}';
  }

  ExpenseModel.fromMap(String id, Map<String, dynamic> map)
      : this(
          id: id,
          userId: map[fieldUserId],
          name: map[fieldName],
          timestamp: map[fieldTimestamp],
          amount: map[fieldAmount],
        );

  Map<String, dynamic> asMap() {
    return {
      ExpenseModel.fieldUserId: userId,
      ExpenseModel.fieldName: name,
      ExpenseModel.fieldTimestamp: timestamp,
      ExpenseModel.fieldAmount: amount,
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? amount,
    int? timestamp,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
      amount: amount ?? this.amount,
    );
  }
}
