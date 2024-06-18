import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, String>((ref) {
  return CalculatorNotifier();
});

class CalculatorNotifier extends StateNotifier<String> {
  CalculatorNotifier() : super('');

  void append(String input) {
    state += input;
  }

  void clear() {
    state = '';
  }

  void delete() {
    if (state.isNotEmpty) {
      state = state.substring(0, state.length - 1);
    }
  }

  void calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(state.replaceAll('÷', '/').replaceAll('×', '*'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      state = eval.toString();
    } catch (e) {
      state = 'Error';
    }
  }

  void toggleSign() {
    if (state.isNotEmpty && state[0] == '-') {
      state = state.substring(1);
    } else {
      state = '-$state';
    }
  }

  void addParenthesis(String parenthesis) {
    state += parenthesis;
  }

  void addPercentage() {
    try {
      double value = double.parse(state) / 100;
      state = value.toString();
    } catch (e) {
      state = 'Error';
    }
  }

  void addTrigonometricFunction(String function) {
    state += function + '(';
  }

  void addSquareRoot() {
    state += 'sqrt(';
  }

  void addPower(String power) {
    state += '^$power';
  }

  void addConstant(String constant) {
    state += constant;
  }

  void addLog(String logFunction) {
    state += logFunction + '(';
  }
}
