import 'package:flutter/material.dart';
import 'package:sign/sign.dart';

/// Listen changes and rebuilt if necessary
class GlobalSlotWidget<V, T extends GlobalSignal<V>> extends StatefulWidget {
  /// Listen changes and rebuilt if necessary
  const GlobalSlotWidget(
      {Key? key,
      required this.signal,
      required this.builder,
      this.notifyOnDebug = true,
      this.onDispose})
      : super(key: key);

  ///
  final T signal;

  /// Called on widget dispose
  final void Function()? onDispose;

  ///
  final bool notifyOnDebug;

  ///
  /// Listen changes and rebuilt if necessary
  final Widget Function(V value) builder;

  @override
  GlobalSlotState<V, T> createState() => GlobalSlotState();
}

///
class GlobalSlotState<V, T extends GlobalSignal<V>>
    extends State<GlobalSlotWidget<V, T>> implements GlobalSlot<V, T> {
  @mustCallSuper
  @override
  void initState() {
    _listen();
    super.initState();
  }

  @mustCallSuper
  @override
  void dispose() {
    _remove();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GlobalSlotWidget<V, T> oldWidget) {
    _remove();
    _listen();
    super.didUpdateWidget(oldWidget);
  }

  void _listen() {
    widget.signal.addSlot(this);
  }

  void _remove() {
    widget.signal.removeSlot(this);
  }

  @override
  void reassemble() {
    super.reassemble();
    _listen();
  }

  @override
  Widget build(BuildContext context) => widget.builder(widget.signal.value);

  @override
  void onValue(V value) {
    if (mounted) setState(() {});
  }
}
