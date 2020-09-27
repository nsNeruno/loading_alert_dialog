# loading_alert_dialog

Customizable AlertDialog that allows running a computation while blocking the app like a normal showDialog without using the approach of using a [Stack](https://api.flutter.dev/flutter/widgets/Stack-class.html)/[Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html) widget.

## Getting Started

This package exposes static methods through one class _**LoadingAlertDialog**_ which are:
* _**showLoadingAlertDialog**_  
    The main method that works as a wrapper to _showDialog_/_showCupertinoDialog_, where it is controller through a _**Future**_, provided through _**computation**_ argument. When the provided Future completes, with a result or an error, then the "Dialog" will be dismissed on it's own, and the method call itself will return the value of the computation Future itself or throws if the Future throws.
* _**setDefaultWidgetBuilder**_  
    By setting a WidgetBuilder here, each call to showLoadingAlertDialog won't require to provide _**builder**_ argument.

### How-to-use example:
```dart
import 'package:loading_alert_dialog/loading_alert_dialog.dart';

LoadingAlertDialog.showLoadingAlertDialog<int>(
  context: context,
  builder: (context,) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24.0,),
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("Please Wait...",),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    ),
    color: Colors.white,
  ),
  computation: Future.delayed(
    Duration(seconds: 3,), () {
      final randomNumber = Random().nextInt(300,);
      return randomNumber;
    },
  ),
).then((number) {
  if (number != null) {
    setState(() {
      _randomNumber = number;
	}
  },
);
```
The builder may returns any Widget eligible to be used as an "AlertDialog". The sample code above shows a simple Card with a Text and CircularProgressIndicator for 3 seconds, then pops out a random number, closing the "AlertDialog", then displaying the popped number into the view.