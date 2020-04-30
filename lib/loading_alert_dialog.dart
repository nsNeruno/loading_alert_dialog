library loading_alert_dialog;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// Signature for callback that indicates the computation has completed and the
/// dialog should pop with a result.
///
typedef DialogPopCallback<T> = void Function(T result);

///
/// Signature for callback that indicates an error happened and the dialog
/// should pop with nothing, and fires an additional callback with optional
/// error object.
///
typedef ErrorPopCallback = void Function(dynamic err);

///
/// Displays a platform aware dialog that either calls [showCupertinoDialog]
/// or [showDialog] depending on current [Platform], and runs indefinitely,
/// while showing a [Widget].
///
/// Takes a [BuildContext] as primary requirements for common dialog showing
/// methods.
///
/// During the [computation], the [DialogPopCallback] and [ErrorPopCallback] are
/// provided to control when to pop the dialog and what should be popped from
/// the dialog. Calling [DialogPopCallback] will pop the dialog and send the
/// result back to be processed within [onPop] callback if provided, while
/// calling [ErrorPopCallback] will pop the dialog, send nothing, and fire
/// additional callback to handle optional error object within [onError]
/// callback.
///
/// Calling [ErrorPopCallback] also triggers [onPop] callback with a null
/// value if provided.
///
/// Omitting the [computation] parameter will cause the displayed dialog to
/// run indefinitely.
///
/// If [isPlatformAware] is not true, then [showDialog] will be used on iOS
/// platform.
///
/// [builder] may be omitted if a default [WidgetBuilder] was provided via
/// [setDefaultLoadingWidget] method
///
void showLoadingDialog<T>({
  @required BuildContext context,
  WidgetBuilder builder,
  void Function( DialogPopCallback<T> pop, ErrorPopCallback error, ) computation,
  void Function(T result) onPop,
  void Function(dynamic error) onError,
  bool isPlatformAware = true,
}) {
  // A control flag that prevents multiple call to Navigator.pop
  bool hasPopped = false;

  // Handles Dialog result
  final Function dialogCallback = (T result) {
    if (onPop != null) {
      onPop(result);
    }
  };

  if (Platform.isIOS && isPlatformAware == true) {
    showCupertinoDialog<T>(
      context: context,
      builder: builder ?? _defaultLoadingWidgetBuilder,
    ).then(dialogCallback);
  } else {
    showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: builder ?? _defaultLoadingWidgetBuilder,
    ).then(dialogCallback);
  }

  if (computation != null) {
    // Checking hasPopped flag ensures only one Navigator.pop event
    final Function pop = (T result) {
      if (hasPopped) { return; }
      Navigator.of(context).pop(result);
      hasPopped = true;
    };

    final Function error = (err) {
      if (hasPopped) { return; }
      Navigator.of(context).pop();
      hasPopped = true;
      if (onError != null) {
        onError(err);
      }
    };

    computation(pop, error);
  }
}

///
/// To safely omit builder argument, this value needs to be set via
/// [setDefaultLoadingWidget] method
///
WidgetBuilder _defaultLoadingWidgetBuilder;

///
/// Helper getter to make sure there was a default builder
///
bool get hasDefaultLoadingWidget => _defaultLoadingWidgetBuilder != null;

///
/// Sets the default loading widget to be used
///
void setDefaultLoadingWidget({@required WidgetBuilder builder,}) {
  _defaultLoadingWidgetBuilder = builder;
}