# loading_alert_dialog

Customizable AlertDialog that allows running a computation while blocking the app like a normal showDialog without using the approach of using a [Stack](https://api.flutter.dev/flutter/widgets/Stack-class.html)/[Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html) widget.

## Getting Started

This package only exposes one method, *__showLoadingDialog__* with similar implementation of normal *__showDialog__* or *__showCupertinoDialog__*.

### How-to-use example:
```dart
showLoadingDialog<int>(
  context: context,
  builder: (context) => Card(
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
  computation: (pop, err) {
    Future.delayed(
      Duration(seconds: 3,), () {
        final randomNumber = Random().nextInt(100);
        pop(randomNumber);
      },
    );
  },
  onPop: (number) {
    if (number != null) {
      setState(() {
        _randomNumber = number;
      });
    }
  },
);
```
The builder may returns any Widget eligible to be used as an "AlertDialog". The sample code above shows a simple Card with a Text and CircularProgressIndicator for 3 seconds, then pops out a random number, closing the "AlertDialog", then displaying the popped number into the view.

## Cheatsheet
* __pop__ closes the "AlertDialog" and pops and returns a specific type value.
* __err__ closes the "AlertDialog" and pops NOTHING and returns an optional, any kind of value, indicating there is an error.
* Omitting the __computation__ parameter or not calling any of __pop__ or __err__ will cause the "AlertDialog" to be shown indefinitely.

## Full Example Code
```dart
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
    showLoadingDialog<int>(
      context: context,
      builder: (context) => Card(
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
      computation: (pop, err) {
        Future.delayed(
          Duration(seconds: 3,), () {
            final randomNumber = Random().nextInt(100);
            pop(randomNumber);
          },
        );
      },
      onPop: (number) {
        if (number != null) {
          setState(() {
            _randomNumber = number;
          });
        }
      },
    );
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
              RaisedButton(
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
```
