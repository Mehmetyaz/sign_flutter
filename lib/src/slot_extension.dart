import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final Set<Signal> _definedSignals = {};

  bool _isDisposed = false;
  bool _isInitialized = false;

  S defineSignal<S extends Signal>(S signal) {
    if (_isDisposed) throw Exception('Slot is disposed.');
    if (_definedSignals.add(signal) && _isInitialized) {
      signal.addSlot(this);
    }
    return signal;
  }

  @override
  void onValue(void value) {
    if (!_isInitialized || _isDisposed || !mounted) return;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && mounted) setState(() {});
      });
    } else {
      setState(() {});
    }
  }

  ComputedSignal<S> computed<S>(Iterable<Signal> signals, S Function() fn) {
    final deps = signals.toList();
    if (deps.isEmpty) {
      throw ArgumentError.value(signals, 'signals', 'must not be empty');
    }
    return defineSignal(deps.first.computed(fn, also: deps.skip(1)));
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
      if (signal is ComputedSignal) signal.dispose();
    }
    super.dispose();
    _isDisposed = true;
  }
}
