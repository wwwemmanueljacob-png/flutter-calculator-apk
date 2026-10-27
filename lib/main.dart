
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  double? firstNumber;
  String? operator;
  bool startNewNumber = true;

  void press(String value) {
    setState(() {
      if (value == 'AC') {
        display = '0';
        firstNumber = null;
        operator = null;
        startNewNumber = true;
      } else if (value == 'DEL') {
        if (!startNewNumber && display.isNotEmpty) {
          display = display.length > 1
              ? display.substring(0, display.length - 1)
              : '0';
        }
      } else if (value == '.') {
        if (startNewNumber) {
          display = '0.';
          startNewNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
      } else if ('0123456789'.contains(value)) {
        if (startNewNumber || display == '0') {
          display = value;
          startNewNumber = false;
        } else {
          display += value;
        }
      } else if ('+-×÷'.contains(value)) {
        firstNumber = double.tryParse(display);
        operator = value;
        startNewNumber = true;
      } else if (value == '=') {
        final secondNumber = double.tryParse(display);
        if (firstNumber != null &&
            secondNumber != null &&
            operator != null) {
          double result;

          switch (operator) {
            case '+':
              result = firstNumber! + secondNumber;
              break;
            case '-':
              result = firstNumber! - secondNumber;
              break;
            case '×':
              result = firstNumber! * secondNumber;
              break;
            case '÷':
              if (secondNumber == 0) {
                display = 'Cannot divide by zero';
                firstNumber = null;
                operator = null;
                startNewNumber = true;
                return;
              }
              result = firstNumber! / secondNumber;
              break;
            default:
              return;
          }

          display = result % 1 == 0
              ? result.toInt().toString()
              : result.toString();
          firstNumber = null;
          operator = null;
          startNewNumber = true;
        }
      }
    });
  }

  Widget calculatorButton(String label) {
    final isOperator = '+-×÷='.contains(label) && label.length == 1;
    final isUtility = label == 'AC' || label == 'DEL';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isOperator
                  ? Colors.orange
                  : isUtility
                      ? Colors.blueGrey
                      : const Color(0xFF252A34),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () => press(label),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calculator'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(children: [
                    calculatorButton('AC'),
                    calculatorButton('DEL'),
                    calculatorButton('÷'),
                    calculatorButton('×'),
                  ]),
                  Row(children: [
                    calculatorButton('7'),
                    calculatorButton('8'),
                    calculatorButton('9'),
                    calculatorButton('-'),
                  ]),
                  Row(children: [
                    calculatorButton('4'),
                    calculatorButton('5'),
                    calculatorButton('6'),
                    calculatorButton('+'),
                  ]),
                  Row(children: [
                    calculatorButton('1'),
                    calculatorButton('2'),
                    calculatorButton('3'),
                    calculatorButton('='),
                  ]),
                  Row(children: [
                    calculatorButton('0'),
                    calculatorButton('.'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
