import 'package:flutter/foundation.dart';

class CreditService {
  // In a real app, this would interact with a database to update
  // a user's or family's training credit balance.
  // For now, this is a mock service.

  // We can imagine a data structure like this:
  final Map<String, int> _creditsByChildId = {
    'child1': 8, // Starting with 8 credits
  };

  Future<int> getCreditsForChild(String childId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _creditsByChildId[childId] ?? 0;
  }

  Future<void> addCredits(String childId, int amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final currentCredits = _creditsByChildId[childId] ?? 0;
    _creditsByChildId[childId] = currentCredits + amount;

    // The 'kDebugMode' check ensures this only runs in debug builds.
    if (kDebugMode) {
      print('Added $amount credits to child $childId. New balance: ${_creditsByChildId[childId]}');
    }
  }

  Future<void> deductCredit(String childId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final currentCredits = _creditsByChildId[childId] ?? 0;
    if (currentCredits > 0) {
      _creditsByChildId[childId] = currentCredits - 1;
    }
    if (kDebugMode) {
      print('Deducted 1 credit from child $childId. New balance: ${_creditsByChildId[childId]}');
    }
  }
}
