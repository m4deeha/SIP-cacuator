import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groww - SIP Calculator',
      theme: ThemeData(
        fontFamily: 'Subter',
        primarySwatch: Colors.blue,
      ),
      home: InvestmentScreen(),
    );
  }
}

class InvestmentScreen extends StatefulWidget {
  @override
  _InvestmentScreenState createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  double _monthlyInvestment = 1000;
  double _rateOfReturn = 12;
  double _investmentPeriod = 10;

  double _maturityValue = 0;

  Future<void> _calculateSIP() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/calculate-sip'), 
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'monthlyInvestment': _monthlyInvestment,
        'rateOfReturn': _rateOfReturn,
        'investmentPeriod': _investmentPeriod,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _maturityValue = double.parse(data['maturityValue']);
      });
    } else {
      throw Exception('Failed to calculate SIP');
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateSIP(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIP Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Investment : ₹${_monthlyInvestment.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Slider(
                      value: _monthlyInvestment,
                      min: 500,
                      max: 6000,
                      divisions: 40,
                      label: _monthlyInvestment.toStringAsFixed(2),
                      onChanged: (value) {
                        setState(() {
                          _monthlyInvestment = value;
                        });
                        _calculateSIP();
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Expected Return Rate (p.a): ${_rateOfReturn.toStringAsFixed(2)}%',
                      style: TextStyle(fontSize: 18),
                    ),
                    Slider(
                      value: _rateOfReturn,
                      min: 1,
                      max: 30,
                      divisions: 30,
                      label: _rateOfReturn.toStringAsFixed(2),
                      onChanged: (value) {
                        setState(() {
                          _rateOfReturn = value;
                        });
                        _calculateSIP();
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Time Period : ${_investmentPeriod.toStringAsFixed(0)}Yr',
                      style: TextStyle(fontSize: 18),
                    ),
                    Slider(
                      value: _investmentPeriod,
                      min: 1,
                      max: 40,
                      divisions: 40,
                      label: _investmentPeriod.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() {
                          _investmentPeriod = value;
                        });
                        _calculateSIP();
                      },
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Invested Amount: ₹${_monthlyInvestment.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Est. Returns: ₹${(_maturityValue - _monthlyInvestment * 12 * _investmentPeriod).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Total Value: ₹${_maturityValue.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator(
                        value: _maturityValue / 1000000,
                        strokeWidth: 16,  // Thicker line
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    SizedBox(height: 84),  
                    ElevatedButton(
                      onPressed: () {
                      },
                      child: Text('Invest Now'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, 
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
