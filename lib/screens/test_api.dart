import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TestApiScreen extends StatefulWidget {
  const TestApiScreen({super.key});

  @override
  _TestApiScreenState createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  String _testResult = 'Click buttons to test APIs';
  bool _isTesting = false;

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = 'Testing connection...';
    });

    try {
      bool isConnected = await ApiService.testConnection();
      setState(() {
        _testResult = isConnected
            ? '✅ Connection successful!\nAPI URL: ${ApiService.baseUrl}'
            : '❌ Connection failed!';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _testCategories() async {
    setState(() {
      _isTesting = true;
      _testResult = 'Testing categories API...';
    });

    try {
      final categories = await ApiService.getCategories();
      setState(() {
        _testResult =
            '✅ Categories loaded!\nFound ${categories.length} categories';
        for (var cat in categories) {
          _testResult += '\n• ${cat['name']}';
        }
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Categories Error: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _testRegister() async {
    setState(() {
      _isTesting = true;
      _testResult = 'Testing register API...';
    });

    try {
      final result = await ApiService.registerUser(
        'testuser${DateTime.now().millisecondsSinceEpoch}',
        'test${DateTime.now().millisecondsSinceEpoch}@example.com',
        'test123',
      );

      setState(() {
        _testResult =
            '✅ Registration successful!\nUser ID: ${result['user_id']}';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Registration Error: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Testing')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Base URL:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(ApiService.baseUrl),
            SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _testResult,
                    style: TextStyle(
                      fontSize: 16,
                      color: _testResult.contains('✅')
                          ? Colors.green
                          : _testResult.contains('❌')
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            if (_isTesting)
              Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _testConnection,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Test Connection'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _testCategories,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Test Categories API'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _testRegister,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Test Register API'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
