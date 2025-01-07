import 'package:flutter/material.dart';

void main() {
  runApp(PentagonalPayoffApp());
}

class PentagonalPayoffApp extends StatelessWidget {
  const PentagonalPayoffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pentagonal Payoff Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PentagonalPayoffScreen(),
    );
  }
}

class PentagonalPayoffScreen extends StatefulWidget {
  const PentagonalPayoffScreen({super.key});

  @override
  PentagonalPayoffScreenState createState() => PentagonalPayoffScreenState();
}

class PentagonalPayoffScreenState extends State<PentagonalPayoffScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  num? _value;
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pentagonal Payoff Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Enter a number to calculate its payoff based on the Pentagonal Number Theorem:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Text("Enter your number: "),
                    border: OutlineInputBorder(),
                  ),
                  initialValue: "5",
                  onSaved: (input) => _value = num.tryParse(input ?? ""),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calculatePayoff,
                  child: Text('Calculate Payoff'),
                ),
                SizedBox(height: 16),
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculatePayoff() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Check if the value is valid
      if (_value == null || _value! < 0) {
        setState(() {
          result = "Please enter a valid non-negative integer.";
        });
        return;
      }

      // Calculate the payoff
      final payoff = calculatePentagonalPayoff(_value!.toInt());

      // Update the result
      setState(() {
        result = "The payoff for n = ${_value!.toInt()} is $payoff.";
      });
    }
  }

  int calculatePentagonalPayoff(int n) {
    if (n == 0) return 1; // Base case: payoff for n = 0 is 1

    int result = 0;
    int k = 1;

    while (true) {
      // Generalized pentagonal numbers
      int pentagonal1 = k * (3 * k - 1) ~/ 2;
      int pentagonal2 = k * (3 * k + 1) ~/ 2;

      if (pentagonal1 > n && pentagonal2 > n) break;

      // Alternate signs
      int sign = (k % 2 == 0) ? -1 : 1;

      if (pentagonal1 <= n) {
        result += sign * calculatePentagonalPayoff(n - pentagonal1);
      }
      if (pentagonal2 <= n) {
        result += sign * calculatePentagonalPayoff(n - pentagonal2);
      }

      k++;
    }

    return result;
  }
}
