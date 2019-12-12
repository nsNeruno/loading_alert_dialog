library loading_alert_dialog;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef KeyedWidgetBuilder = Widget Function(BuildContext context, Key key);
typedef DialogPopCallback<T> = void Function(T result);
typedef ErrorPopCallback = void Function(dynamic err);

GlobalKey _loadingKey = GlobalKey();

Widget _buildWidget(BuildContext context, KeyedWidgetBuilder builder) {
  final widget = builder(context, _loadingKey);
  assert(widget.key == _loadingKey);
  return widget;
}

void showLoadingDialog<T>({
  @required BuildContext context,
  @required KeyedWidgetBuilder builder,
  void Function( DialogPopCallback<T> pop, ErrorPopCallback error, ) computation,
  void Function(T result) onPop,
  void Function(dynamic error) onError,
  bool isPlatformAware = true,
}) {
  bool hasPopped = false;

  final Function dialogCallback = (T result) {
    if (onPop != null) {
      onPop(result);
    }
  };

  if (Platform.isIOS && isPlatformAware == true) {
    showCupertinoDialog<T>(
      context: context,
      builder: (context) => _buildWidget(context, builder),
    ).then(dialogCallback);
  } else {
    showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (context) => _buildWidget(context, builder),
    ).then(dialogCallback);
  }

  if (computation != null) {
    final Function pop = (T result) {
      if (hasPopped) { return; }
      Navigator.of(_loadingKey.currentContext).pop(result);
      hasPopped = true;
    };

    final Function error = (err) {
      if (hasPopped) { return; }
      Navigator.of(_loadingKey.currentContext).pop();
      hasPopped = true;
      if (onError != null) {
        onError(err);
      }
    };

    computation(pop, error);
  }
}