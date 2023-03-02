import 'package:flutter/cupertino.dart';

import '../sign_flutter.dart';

extension ValueNotifierConverter<T> on ValueNotifier<T> {
  /// Convert [ValueNotifier] to [Signal]
  Signal<T> asSignal() => ValueNotifierSignal(this);
}

extension ChangeNotifierConverter on ChangeNotifier {
  /// Convert [ChangeNotifier] to [Signal]
  Signal<void> asSignal() => ChangeNotifierSignal(this);
}

class ChangeNotifierSignal<T> extends Signal<void> {
  ChangeNotifierSignal(this.changeNotifier) : super(null);
  final ChangeNotifier changeNotifier;

  void _listener() {
    emit();
  }

  @override
  void addSlot(Slot slot) {
    super.addSlot(slot);
    changeNotifier.addListener(_listener);
  }

  @override
  void removeSlot(Slot slot) {
    super.removeSlot(slot);
    if (slots.isEmpty) {
      changeNotifier.removeListener(_listener);
    }
  }

  @override
  void clearSlots() {
    changeNotifier.removeListener(_listener);
    super.clearSlots();
  }
}

class ValueNotifierSignal<T> extends Signal<T> {
  ValueNotifierSignal(this.valueNotifier) : super(valueNotifier.value);
  final ValueNotifier<T> valueNotifier;

  void _listener() {
    value = valueNotifier.value;
  }

  @override
  void addSlot(Slot slot) {
    super.addSlot(slot);
    valueNotifier.addListener(_listener);
  }

  @override
  void removeSlot(Slot slot) {
    super.removeSlot(slot);
    if (slots.isEmpty) {
      valueNotifier.removeListener(_listener);
    }
  }

  @override
  void clearSlots() {
    valueNotifier.removeListener(_listener);
    super.clearSlots();
  }
}
