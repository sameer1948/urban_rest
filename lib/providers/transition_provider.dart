// lib/providers/transition_provider.dart

import 'package:flutter/material.dart';
import 'package:urban_rest/database/service/transitionService.dart';
import 'package:urban_rest/model/transition.dart';

class TransitionProvider with ChangeNotifier {
  final Transitionservice _transitioService = Transitionservice();
  Transition? _activeTransition;

  Transition? get activeTransition => _activeTransition;
  String get activeStyle => _activeTransition?.style ?? 'fade';

  Future<void> load() async {
    final transitions = await _transitioService.getAllTransitions();
    _activeTransition = transitions.firstWhere(
      (transition) => transition.isActive == Transition.VALUE_YES,
    );
    notifyListeners();
  }

  Future<void> update(Transition transition) async {
    await _transitioService.updateTransition(transition);
    _activeTransition = transition;
    notifyListeners();
  }
}
