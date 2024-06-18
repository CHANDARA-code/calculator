import 'package:caculator_app/services/storage/history_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';


final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier()..loadHistory();
});

class CalculatorState {
  final String expression;
  final List<String> history;
  final String? error;

  CalculatorState({required this.expression, required this.history, this.error});

  CalculatorState copyWith({String? expression, List<String>? history, String? error}) {
    return CalculatorState(
      expression: expression ?? this.expression,
      history: history ?? this.history,
      error: error,
    );
  }
}

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(CalculatorState(expression: '', history: []));

  void append(String input) {
    state = state.copyWith(expression: state.expression + input, error: null);
  }

  void clear() {
    state = state.copyWith(expression: '', error: null);
  }

  void delete() {
    if (state.expression.isNotEmpty) {
      state = state.copyWith(expression: state.expression.substring(0, state.expression.length - 1));
    }
  }

  void calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(state.expression.replaceAll('÷', '/').replaceAll('×', '*'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      String result = eval.toString();
      state = state.copyWith(
        expression: result,
        history: List.from(state.history)..add(state.expression + ' = ' + result),
        error: null,
      );
      _saveHistory();
    } catch (e) {
      state = state.copyWith(error: 'Invalid expression');
    }
  }

  void toggleSign() {
    if (state.expression.isNotEmpty && state.expression[0] == '-') {
      state = state.copyWith(expression: state.expression.substring(1));
    } else {
      state = state.copyWith(expression: '-${state.expression}');
    }
  }

  void addParenthesis(String parenthesis) {
    state = state.copyWith(expression: state.expression + parenthesis);
  }

  void addPercentage() {
    try {
      double value = double.parse(state.expression) / 100;
      state = state.copyWith(expression: value.toString());
    } catch (e) {
      state = state.copyWith(error: 'Invalid percentage');
    }
  }

  void addTrigonometricFunction(String function) {
    state = state.copyWith(expression: state.expression + function + '(');
  }

  void addSquareRoot() {
    state = state.copyWith(expression: state.expression + 'sqrt(');
  }

  void addPower(String power) {
    state = state.copyWith(expression: state.expression + '^$power');
  }

  void addConstant(String constant) {
    state = state.copyWith(expression: state.expression + constant);
  }

  void addLog(String logFunction) {
    state = state.copyWith(expression: state.expression + logFunction + '(');
  }

  Future<void> loadHistory() async {
    var historyStorage = HistoryStorage();
    var history = await historyStorage.read();
    final List<String>? loadedHistory = history?['history']?.cast<String>();
    if (loadedHistory != null) {
      state = state.copyWith(history: loadedHistory);
    }
  }

  Future<void> _saveHistory() async {
    var historyStorage = HistoryStorage();
    await historyStorage.write({'history': state.history});
  }
}
