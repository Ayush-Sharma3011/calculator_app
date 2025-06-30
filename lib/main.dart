// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {

  Hive.initFlutter();
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  String _result = '';
  String _selectedOperation = '+';
  final List<String> _history = [];

  void _calculate() {
    double? num1 = double.tryParse(_num1Controller.text.trim());
    double? num2 = double.tryParse(_num2Controller.text.trim());

    if (num1 == null || num2 == null) {
      setState(() {
        _result = '❌ Please enter valid numbers';
      });
      return;
    }

    double res;
    String resultText;

    switch (_selectedOperation) {
      case '+':
        res = num1 + num2;
        break;
      case '-':
        res = num1 - num2;
        break;
      case '×':
        res = num1 * num2;
        break;
      case '÷':
        if (num2 == 0) {
          setState(() {
            _result = '❌ Cannot divide by zero';
          });
          return;
        }
        res = num1 / num2;
        break;
      default:
        res = 0;
    }

    resultText = '$num1 $_selectedOperation $num2 = ${res.toStringAsFixed(2)}';

    setState(() {
      _result = '✅ $resultText';
      _history.insert(0, resultText);
    });
  }

  void _clearAll() {
    setState(() {
      _num1Controller.clear();
      _num2Controller.clear();
      _result = '';
      _history.clear();
    });
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white70,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '💻 Simple Calculator',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Enter first number', _num1Controller),
                    const SizedBox(height: 15),
                    _buildInputField('Enter second number', _num2Controller),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      value: _selectedOperation,
                      items: ['+', '-', '×', '÷'].map((op) {
                        return DropdownMenuItem<String>(
                          value: op,
                          child: Text(op, style: TextStyle(fontSize: 18)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOperation = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _calculate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Calculate',
                              style: TextStyle(fontSize: 18,
                              color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: _clearAll,
                          icon: const Icon(Icons.clear_all),
                          tooltip: "Clear All",
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_history.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📝 History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ListView.builder(
                              itemCount: _history.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  leading: Icon(Icons.calculate_outlined,
                                      color: Colors.deepPurpleAccent),
                                  title: Text(_history[index]),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
