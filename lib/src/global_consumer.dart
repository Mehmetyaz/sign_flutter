import 'package:flutter/material.dart';
import 'package:sign/sign.dart';
import 'package:sign_flutter/src/global_slot_widget.dart';

///
abstract class GlobalConsumerWidget<V, T extends GlobalSignal<V>>
    extends StatefulWidget {
  ///
  const GlobalConsumerWidget({required this.signal, Key? key})
      : super(key: key);

  ///
  final T signal;

  /// Build function that will be called when the notifier changes
  Widget build(BuildContext context, V value);

  @override
  State<GlobalConsumerWidget> createState() => GlobalConsumerState();
}

class GlobalConsumerState<V, T extends GlobalSignal<V>>
    extends State<GlobalConsumerWidget<V, T>> {
  @override
  Widget build(BuildContext context) => GlobalSlotWidget<V, T>(
      signal: widget.signal, builder: (v) => widget.build(context, v));
}
