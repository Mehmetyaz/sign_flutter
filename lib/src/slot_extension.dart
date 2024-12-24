import 'package:flutter/material.dart';
import 'package:sign_flutter/sign_flutter.dart';
import 'package:sign_flutter/src/slot_widget.dart' as sl;

///
extension NotifierExtension<T> on Signal<T> {
  /// Listen any changes this and [signals] any changes
  MultiSignal combineWith(List<Signal> signals) =>
      MultiSignal(signals..add(this));

  /// Create Yaz Listener Widget that listen your change notifier
  Widget builder(
    Widget Function(T value) builder, {
    Key? key,
    void Function()? onDispose,
    bool notifyOnDebug = true,
  }) => sl.SlotBuilder(
    signal: this,
    builder: builder,
    key: key,
    onDispose: onDispose,
    notifyOnDebug: notifyOnDebug,
  );
}

abstract class SlotState<T extends StatefulWidget> extends State<T>
    implements Slot<void> {
  final List<Signal> _definedSignals = [];

  bool _isDisposed = false;
  bool _isInitialized = false;

  Signal<S> defineSignal<S>(Signal<S> signal) {
    if (_isDisposed) throw Exception('Slot is disposed.');
    if (_isInitialized) throw Exception('Slot is already initialized.');
    _definedSignals.add(signal);
    return signal;
  }

  @override
  void initState() {
    for (var signal in _definedSignals) {
      signal.addSlot(this);
    }
    super.initState();
    _isInitialized = true;
  }

  @override
  void dispose() {
    for (var signal in _definedSignals) {
      signal.removeSlot(this);
    }
    super.dispose();
    _isDisposed = true;
  }
}
