import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceTransaction {
  final String id;
  final String? userId;
  final String title;
  final String subtitle;
  final int amountCents;
  final String iconKey;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? qrPayload;
  final String status;

  const FinanceTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amountCents,
    required this.iconKey,
    required this.createdAt,
    this.userId,
    this.paymentMethod,
    this.paidAt,
    this.qrPayload,
    this.status = FinanceTransactionStatus.completed,
  });

  bool get isIncome => amountCents >= 0;
  bool get isPending => status == FinanceTransactionStatus.pending;

  String get amountText {
    final sign = isIncome ? '+' : '-';
    final value = amountCents.abs() / 100;
    return '$sign \$ ${value.toStringAsFixed(2)}';
  }

  Map<String, Object?> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'amountCents': amountCents,
      'iconKey': iconKey,
      'userId': userId,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'paidAt': paidAt == null ? null : Timestamp.fromDate(paidAt!),
      'qrPayload': qrPayload,
      'status': status,
    };
  }

  factory FinanceTransaction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final createdAt = data['createdAt'];
    final paidAt = data['paidAt'];
    return FinanceTransaction(
      id: doc.id,
      userId: data['userId'] as String?,
      title: data['title'] as String? ?? 'Transaction',
      subtitle: data['subtitle'] as String? ?? '',
      amountCents: (data['amountCents'] as num?)?.toInt() ?? 0,
      iconKey: data['iconKey'] as String? ?? 'avatar',
      paymentMethod: data['paymentMethod'] as String?,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      paidAt: paidAt is Timestamp ? paidAt.toDate() : null,
      qrPayload: data['qrPayload'] as String?,
      status: data['status'] as String? ?? FinanceTransactionStatus.completed,
    );
  }
}

class FinanceTransactionStatus {
  const FinanceTransactionStatus._();

  static const completed = 'completed';
  static const pending = 'pending';
}
