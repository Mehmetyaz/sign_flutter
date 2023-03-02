import 'package:flutter/material.dart';
import 'package:sign_flutter/sign_flutter.dart';

///
extension NotifierExtension<T> on Signal<T> {
  /// Listen any changes this and [signals] any changes
  MultiSignal combineWith(List<Signal> signals) =>
      MultiSignal(signals..add(this));

  /// Create Yaz Listener Widget that listen your change notifier
  Widget builder(Widget Function(T value) builder,
          {Key? key, void Function()? onDispose, bool notifyOnDebug = true}) =>
      SlotWidget(
        signal: this,
        builder: builder,
        key: key,
        onDispose: onDispose,
        notifyOnDebug: notifyOnDebug,
      );
}
