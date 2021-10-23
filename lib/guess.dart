import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart'; // or flutter_spinbox.dart for both
import 'package:guess_age/data.dart';
import 'package:http/http.dart' as http;

class guess extends StatefulWidget {
  const guess({Key? key}) : super(key: key);

  @override
  _guessState createState() => _guessState();
}

class _guessState extends State<guess> {
  var _input1;
  var _input2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GUESS TEACHER'S AGE"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // ไล่เฉดจากมุมบนซ้ายไปมุมล่างขวาของ Container
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // ไล่เฉดจากสีแดงไปสีน้ำเงิน
            colors: [
              Colors.lightBlueAccent.shade200,
              Colors.blue.shade200,
              Colors.cyanAccent,
              //Colors.pinkAccent.shade100,
              //Colors.purpleAccent.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "อายุอาจารย์",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ],
              ),
              Padding(
                child: SpinBox(
                  value: 0,
                  max: 100,
                  min: 0,
                  decoration: InputDecoration(labelText: 'Year'),
                  onChanged: (value) => _input1 = value as int,
                ),
                padding: const EdgeInsets.all(16),
              ),
              Padding(
                child: SpinBox(
                  value: 0,
                  max: 11,
                  min: 0,
                  decoration: InputDecoration(labelText: 'Month'),
                  onChanged: (value) => _input2 = value as int,
                ),
                padding: const EdgeInsets.all(16),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                  child: Text(
                    'ทาย',
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  onPressed: () {
                    _test(_input1, _input2);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _test(var year,var month) async {
    var url = Uri.parse("https://cpsu-test-api.herokuapp.com/login");
    var response = await http.post(url, body: {
      'year': year,
      'month' : month
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);
      String status = jsonBody['status'];
      String? message = jsonBody['message'];
      List<dynamic> data = jsonBody['data'];

      print('STATUS: $status');
      print('MESSAGE: $message');
      print('data: $data');

      var getData = data.map((element) => datad(
        text: element['text'],
        value: element['value']
      )).toList();

      if (data == false) {
        _showMaterialDialog('ERROR', 'Invalid PIN. Please try again.');
      } else {
        _showMaterialDialog('ERROR', 'Invalid PIN. Please try again.');
      }
    }
  }


  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
