import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_alert_dialog/loading_alert_dialog.dart';

void main() {
  runApp(
    LoadingAlertDialogExampleApp(),
  );
}

class LoadingAlertDialogExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      color: Colors.blue,
      home: LoadingAlertDialogExample(),
    );
  }
}

class LoadingAlertDialogExample extends StatefulWidget {
  @override
  _LoadingAlertDialogExampleState createState() => _LoadingAlertDialogExampleState();
}

class _LoadingAlertDialogExampleState extends State<LoadingAlertDialogExample> {

  int _randomNumber = 0;

  void _showAlert() {
    LoadingAlertDialog.showLoadingAlertDialog<int>(
      context: context,
      builder: (context,) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Please wait..."),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
        color: Colors.white,
      ),
      computation: Future.delayed(
        Duration(seconds: 3,), () {
          final randomNumber = Random().nextInt(100);
          return randomNumber;
        },
      ),
    ).then((number) {
      if (number != null) {
        setState(() {
          _randomNumber = number;
        });
      }
    },);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Loading Alert Dialog Example"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Text("Random Number: $_randomNumber"),
              ElevatedButton(
                child: Text("Show Alert"),
                onPressed: _showAlert,
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}