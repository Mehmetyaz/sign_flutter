library yaz_state;

import 'package:flutter/material.dart';
import 'package:sign/sign.dart';

/// Listen changes and rebuilt if necessary
class SlotWidget<V> extends StatefulWidget {
  /// Listen changes and rebuilt if necessary
  const SlotWidget(
      {Key? key,
      required this.signal,
      required this.builder,
      this.notifyOnDebug = true,
      this.onDispose})
      : super(key: key);

  ///
  final Signal<V> signal;

  /// Called on widget dispose
  final void Function()? onDispose;

  ///
  final bool notifyOnDebug;

  ///
  /// Listen changes and rebuilt if necessary
  final Widget Function(V value) builder;

  @override
  SlotState<V> createState() => SlotState();
}

///
class SlotState<T> extends State<SlotWidget> implements Slot<T> {
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
  void didUpdateWidget(covariant SlotWidget<T> oldWidget) {
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
  void onValue(T value) {
    if (mounted) setState(() {});
  }
}
