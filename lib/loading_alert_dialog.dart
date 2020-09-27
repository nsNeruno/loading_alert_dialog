import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class LoadingAlertDialog {

  ///
  /// Currently, this plugin is intended to run only on Mobile Apps (Android/iOS)
  ///
  static const UNSUPPORTED_PLATFORM = "UNSUPPORTED_PLATFORM";

  ///
  /// --Defaults to null--
  ///
  /// This property will be accessed within [showLoadingAlertDialog]
  /// implementation when [computation] argument is not provided.
  ///
  static WidgetBuilder _defaultWidgetBuilder;

  ///
  /// By assigning a Default [WidgetBuilder] here, each call to
  /// [showLoadingAlertDialog] won't require [computation] argument to be
  /// provided.
  ///
  /// Null argument is ignored.
  ///
  static void setDefaultWidgetBuilder(WidgetBuilder builder,) {
    if (builder != null) {
      _defaultWidgetBuilder = builder;
    }
  }

  ///
  /// Wrapper for a call to [showDialog] on Android or [showCupertinoDialog] on
  /// iOS, controlled by the [computation] argument, which is a [Future].
  ///
  /// This method's workflow are described below:
  /// 1. Shows the Dialog
  /// 2. Runs the computation
  /// 2. When the computation finishes, close the Dialog
  ///
  /// This method returns a distinct [Future] instance which completes with the
  /// result/error from the original provided [Future] from the [computation]
  /// argument.
  ///
  /// If [builder] argument is null, the Dialog defaults to result from
  /// [_defaultWidgetBuilder] return value, or an empty [Container] if both are
  /// not provided.
  ///
  static Future<T> showLoadingAlertDialog<T>({
    @required BuildContext context,
    @required Future<T> computation,
    WidgetBuilder builder,
  }) {
    final Completer<T> completer = Completer<T>();

    final WidgetBuilder builderWrapper = (context) {
      computation.then((value) {
        if (Navigator.of(context,).canPop()) {
          Navigator.of(context,).pop();
        }
        if (Platform.isIOS) {
          Future.delayed( Duration(milliseconds: 50,), () {
            completer.complete(value,);
          },);
        } else {
          completer.complete(value,);
        }
      },).catchError((e,) {
        if (Navigator.of(context,).canPop()) {
          Navigator.of(context,).pop();
        }
        if (Platform.isIOS) {
          Future.delayed( Duration(milliseconds: 50,), () {
            completer.completeError(e,);
          },);
        } else {
          completer.completeError(e,);
        }
      },);
      return WillPopScope(
        onWillPop: () async => false,
        child: Builder(
          builder: (context) => builder?.call(context,) ?? _defaultWidgetBuilder?.call(context,) ?? Container(),
        ),
      );
    };

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return Builder(
            builder: builderWrapper,
          );
        },
      );
    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: builderWrapper,
      );
    } else {
      completer.completeError(UnsupportedError(UNSUPPORTED_PLATFORM,),);
    }

    return completer.future;
  }
}