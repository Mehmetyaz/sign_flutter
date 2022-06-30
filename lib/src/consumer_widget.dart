import 'package:flutter/material.dart';
import 'package:sign/sign.dart';
import 'package:sign_flutter/src/slot_widget.dart';

///
abstract class ConsumerWidget<V> extends StatefulWidget {
  ///
  const ConsumerWidget({required this.signal, Key? key}) : super(key: key);

  ///
  final Signal<V> signal;

  /// Build function that will be called when the notifier changes
  Widget build(BuildContext context, V value);

  @override
  State<ConsumerWidget<V>> createState() => _ConsumerState<V>();
}

class _ConsumerState<V> extends State<ConsumerWidget<V>> {
  @override
  Widget build(BuildContext context) => SlotWidget<V>(
      signal: widget.signal, builder: (v) => widget.build(context, v));
}
