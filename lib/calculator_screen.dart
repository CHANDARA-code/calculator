import 'package:auto_size_text/auto_size_text.dart';
import 'package:caculator_app/calculator_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final size = MediaQuery.of(context).size;

    // Calculate padding based on both width and height for better responsiveness
    final buttonPadding = (size.width + size.height) / 200; // Reduced padding for a snug fit

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            DisplayArea(size: size),
            Expanded(
              flex: 2,
              child: isLandscape
                  ? buildLandscapeLayout(context, buttonPadding)
                  : buildPortraitLayout(context, buttonPadding),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLandscapeLayout(BuildContext context, double padding) {
    const buttonTitles = [
      "",
      "Rad",
      "√",
      "C",
      "()",
      "%",
      "÷",
      "sin",
      "cos",
      "tan",
      "7",
      "8",
      "9",
      "×",
      "ln",
      "log",
      "1/x",
      "4",
      "5",
      "6",
      "-",
      "e^x",
      "x^2",
      "x^y",
      "1",
      "2",
      "3",
      "+",
      "|x|",
      "π",
      "e",
      "+/-",
      "0",
      ".",
      "=",
      "",
    ];

    return ResponsiveGridList(
      desiredItemWidth: 80, // Adjusted item width
      minSpacing: 5, // Adjusted minimum spacing
      children: buttonTitles.map((title) {
        return Padding(
          padding: EdgeInsets.all(padding),
          child: CalculatorButton(title: title),
        );
      }).toList(),
    );
  }

  Widget buildPortraitLayout(BuildContext context, double padding) {
    const buttonTitles = [
      'C',
      '(',
      ')',
      '%',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '+/-',
      '0',
      '.',
      '='
    ];

    return ResponsiveGridList(
      desiredItemWidth: 80, // Adjusted item width
      minSpacing: 5, // Adjusted minimum spacing
      children: buttonTitles.map((title) {
        return Padding(
          padding: EdgeInsets.all(padding),
          child: CalculatorButton(title: title),
        );
      }).toList(),
    );
  }
}

class DisplayArea extends ConsumerWidget {
  final Size size;

  const DisplayArea({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expression = ref.watch(calculatorProvider);
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.bottomRight,
        child: AutoSizeText(
          expression.isEmpty ? '0' : expression,
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          maxLines: 1,
          maxFontSize: 36,
          minFontSize: 20,
        ),
      ),
    );
  }
}

class CalculatorButton extends ConsumerWidget {
  final String title;

  const CalculatorButton({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);

    return ElevatedButton(
      onPressed: () {
        switch (title) {
          case 'C':
            calculator.clear();
            break;
          case '+':
          case '-':
          case '×':
          case '÷':
          case '.':
          case '(':
          case ')':
            calculator.append(title);
            break;
          case '=':
            calculator.calculate();
            break;
          case '+/-':
            calculator.toggleSign();
            break;
          case '%':
            calculator.addPercentage();
            break;
          case '√':
            calculator.addSquareRoot();
            break;
          case 'sin':
          case 'cos':
          case 'tan':
            calculator.addTrigonometricFunction(title);
            break;
          case 'ln':
          case 'log':
            calculator.addLog(title);
            break;
          case 'π':
            calculator.addConstant('3.141592653589793');
            break;
          case 'e':
            calculator.addConstant('2.718281828459045');
            break;
          default:
            calculator.append(title);
            break;
        }
      },
      child: Text(title),
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: CalculatorScreen(),
      ),
    ),
  );
}
