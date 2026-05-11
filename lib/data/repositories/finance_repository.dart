import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/finance_transaction.dart';

class FinanceRepository {
  FinanceRepository._();

  static final instance = FinanceRepository._();

  static const _collectionPath = 'transactions';
  final _localController =
      StreamController<List<FinanceTransaction>>.broadcast();
  final _localTransactions = <FinanceTransaction>[];

  CollectionReference<Map<String, dynamic>>? get _transactions {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseFirestore.instance.collection(_collectionPath);
  }

  String? get _userId =>
      Firebase.apps.isEmpty ? null : FirebaseAuth.instance.currentUser?.uid;

  bool get isFirebaseReady => _transactions != null;

  Stream<List<FinanceTransaction>> watchTransactions({
    int limit = 20,
    String status = FinanceTransactionStatus.completed,
  }) {
    final collection = _transactions;
    final uid = _userId;
    if (collection == null || uid == null) {
      return _watchLocalTransactions(limit, status);
    }

    return collection.where('userId', isEqualTo: uid).snapshots().map((
      snapshot,
    ) {
      final transactions =
          snapshot.docs
              .map(FinanceTransaction.fromFirestore)
              .where((transaction) => transaction.status == status)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return transactions.take(limit).toList(growable: false);
    });
  }

  Stream<int> watchCompletedBalanceCents() {
    return watchTransactions(limit: 1000).map(_balanceOf);
  }

  String? _lastError;
  String? get lastError => _lastError;

  Future<void> addTransaction(FinanceTransaction transaction) async {
    final collection = _transactions;
    final uid = _userId;
    if (collection == null || uid == null) {
      _localTransactions.insert(
        0,
        FinanceTransaction(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          userId: uid,
          title: transaction.title,
          subtitle: transaction.subtitle,
          amountCents: transaction.amountCents,
          iconKey: transaction.iconKey,
          paymentMethod: transaction.paymentMethod,
          createdAt: transaction.createdAt,
          paidAt: transaction.paidAt,
          qrPayload: transaction.qrPayload,
          status: transaction.status,
        ),
      );
      _localController.add(List.unmodifiable(_localTransactions));
      return;
    }

    try {
      if (transaction.status == FinanceTransactionStatus.completed &&
          transaction.amountCents < 0) {
        await _ensureEnoughBalance(transaction.amountCents.abs());
      }

      await collection.add(
        FinanceTransaction(
          id: transaction.id,
          userId: uid,
          title: transaction.title,
          subtitle: transaction.subtitle,
          amountCents: transaction.amountCents,
          iconKey: transaction.iconKey,
          paymentMethod: transaction.paymentMethod,
          createdAt: transaction.createdAt,
          paidAt: transaction.paidAt,
          qrPayload: transaction.qrPayload,
          status: transaction.status,
        ).toFirestore(),
      );
      _lastError = null;
    } on FirebaseException catch (error) {
      _lastError = '${error.code}: ${error.message ?? error.plugin}';
      rethrow;
    }
  }

  Future<void> completePendingTransaction(
    FinanceTransaction transaction, {
    required String paymentMethod,
    required String qrPayload,
  }) async {
    final collection = _transactions;
    if (collection == null) return;

    final paidAt = DateTime.now();
    await _ensureEnoughBalance(transaction.amountCents.abs());
    await collection.doc(transaction.id).update({
      'status': FinanceTransactionStatus.completed,
      'paymentMethod': paymentMethod,
      'paidAt': Timestamp.fromDate(paidAt),
      'qrPayload': qrPayload,
      'createdAt': Timestamp.fromDate(paidAt),
    });
  }

  Future<void> _ensureEnoughBalance(int amountCents) async {
    final balance = _balanceOf(await watchTransactions(limit: 1000).first);
    if (balance - amountCents < 0) {
      throw StateError('Дансны үлдэгдэл хүрэлцэхгүй байна');
    }
  }

  int _balanceOf(List<FinanceTransaction> transactions) {
    return transactions.fold<int>(
      0,
      (total, transaction) => total + transaction.amountCents,
    );
  }

  Stream<List<FinanceTransaction>> _watchLocalTransactions(
    int limit,
    String status,
  ) async* {
    yield _limitedLocalTransactions(limit, status);
    yield* _localController.stream.map(
      (_) => _limitedLocalTransactions(limit, status),
    );
  }

  List<FinanceTransaction> _limitedLocalTransactions(int limit, String status) {
    final sorted = List<FinanceTransaction>.from(_localTransactions)
      ..removeWhere((transaction) => transaction.status != status)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList(growable: false);
  }
}
