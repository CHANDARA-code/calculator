import 'package:caculator_app/notifier/calculator/calculator_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CalculatorNotifier Tests', () {
    late CalculatorNotifier calculatorNotifier;
    late CalculatorState state;

    setUp(() {
      calculatorNotifier = CalculatorNotifier();
      state = calculatorNotifier.state;
    });

    test('Initial state should be empty expression and empty history', () {
      expect(state.expression, '');
      expect(state.history, []);
      expect(state.error, isNull);
    });

    test('append should add input to expression and reset error', () {
      calculatorNotifier.append('1');
      expect(calculatorNotifier.state.expression, '1');
      expect(calculatorNotifier.state.error, isNull);
      calculatorNotifier.append('+');
      expect(calculatorNotifier.state.expression, '1+');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('clear should clear the expression and reset error', () {
      calculatorNotifier.append('1');
      calculatorNotifier.clear();
      expect(calculatorNotifier.state.expression, '');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('delete should remove last character from expression and reset error', () {
      calculatorNotifier.append('123');
      calculatorNotifier.delete();
      expect(calculatorNotifier.state.expression, '12');
      expect(calculatorNotifier.state.error, isNull);
      calculatorNotifier.delete();
      expect(calculatorNotifier.state.expression, '1');
      expect(calculatorNotifier.state.error, isNull);
      calculatorNotifier.delete();
      expect(calculatorNotifier.state.expression, '');
      expect(calculatorNotifier.state.error, isNull);
      calculatorNotifier.delete(); // Deleting when expression is already empty
      expect(calculatorNotifier.state.expression, '');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('calculate should evaluate the expression correctly', () {
      calculatorNotifier.append('2+3');
      calculatorNotifier.calculate();
      expect(calculatorNotifier.state.expression, '5.0');
      expect(calculatorNotifier.state.history.last, '2+3 = 5.0');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('calculate should handle invalid expression', () {
      calculatorNotifier.append('2++3');
      calculatorNotifier.calculate();
      expect(calculatorNotifier.state.error, 'Invalid expression');
    });

    test('toggleSign should add or remove negative sign', () {
      calculatorNotifier.append('2');
      calculatorNotifier.toggleSign();
      expect(calculatorNotifier.state.expression, '-2');
      expect(calculatorNotifier.state.error, isNull);
      calculatorNotifier.toggleSign();
      expect(calculatorNotifier.state.expression, '2');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addParenthesis should add parenthesis to expression', () {
      calculatorNotifier.addParenthesis('(');
      expect(calculatorNotifier.state.expression, '(');
      expect(calculatorNotifier.state.error, isNull);
      calculatorNotifier.addParenthesis(')');
      expect(calculatorNotifier.state.expression, '()');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addPercentage should convert the expression to percentage', () {
      calculatorNotifier.append('50');
      calculatorNotifier.addPercentage();
      expect(calculatorNotifier.state.expression, '0.5');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addPercentage should handle invalid percentage conversion', () {
      calculatorNotifier.append('abc');
      calculatorNotifier.addPercentage();
      expect(calculatorNotifier.state.error, 'Invalid percentage');
    });

    test('addTrigonometricFunction should add function to expression', () {
      calculatorNotifier.addTrigonometricFunction('sin');
      expect(calculatorNotifier.state.expression, 'sin(');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addSquareRoot should add sqrt to expression', () {
      calculatorNotifier.addSquareRoot();
      expect(calculatorNotifier.state.expression, 'sqrt(');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addPower should add power to expression', () {
      calculatorNotifier.append('2');
      calculatorNotifier.addPower('3');
      expect(calculatorNotifier.state.expression, '2^3');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addConstant should add constant to expression', () {
      calculatorNotifier.addConstant('3.14');
      expect(calculatorNotifier.state.expression, '3.14');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('addLog should add log function to expression', () {
      calculatorNotifier.addLog('log');
      expect(calculatorNotifier.state.expression, 'log(');
      expect(calculatorNotifier.state.error, isNull);
    });

    test('loadHistory should load history from SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('calculator_history', ['1+1=2', '2+2=4']);
      await calculatorNotifier.loadHistory();
      expect(calculatorNotifier.state.history, ['1+1=2', '2+2=4']);
    });

    test('saveHistory should save history to SharedPreferences', () async {
      calculatorNotifier.append('1+1');
      calculatorNotifier.calculate();
      calculatorNotifier.append('2+2');
      calculatorNotifier.calculate();

      final prefs = await SharedPreferences.getInstance();
      final savedHistory = prefs.getStringList('calculator_history');
      expect(savedHistory, ['1+1 = 2.0', '2+2 = 4.0']);
    });
  });
}
