# Sign Package Documentation

## Introduction

Sign is a lightweight state management solution that follows the signal-slot pattern. It provides a simple way to handle state changes and reactive programming in Dart applications.

## Basic Usage

### Creating a Signal

1. **Direct Creation**

   ```dart
   final mySignal = Signal<int>(0);
   ```

2. **Using Extension**

   ```dart
   final mySignal = 0.signal;
   ```

3. **Custom Signal Class**
   ```dart
   class CounterSignal extends Signal<int> {
     CounterSignal() : super(0);
   }
   ```

### Creating a Slot

1. **Using Mixin**

   ```dart
   class MySlot with Slot<int> {
     void onValue(int value) {
       // Handle value change
     }
   }
   ```

2. **Quick Handler**
   ```dart
   final mySlot = SlotWithHandler<int>((value) {
     // Handle value change
   });
   ```

### Connecting Signals and Slots

```dart
// Add slot to signal
mySignal.addSlot(mySlot);

// Remove when done
mySignal.removeSlot(mySlot);
```

## Advanced Features

### 1. Global State Management

Global signals allow you to manage application-wide state:

```dart
// Create global signal
final globalCounter = 0.globalSignal;

// Create global slot
class MyGlobalSlot extends GlobalSlot<int, GlobalCounter> {
  void onValue(int value) {
    // Handle global updates
  }
}
```

### 2. Collection Management

For Lists:

```dart
// Create signal list
final items = <String>[].signalList;

// Modifications automatically trigger slots
items.add('item');
items.remove('item');
```

For Maps:

```dart
// Create signal map
final data = <String, int>{}.signalMap;

// Modifications automatically trigger slots
data['key'] = 1;
data.remove('key');
```

### 3. Multiple Signal Handling

When you need to respond to multiple signals:

```dart
// Method 1: Direct MultiSignal creation
final combinedSignal = MultiSignal([signal1, signal2]);
combinedSignal.addSlot(mySlot);

// Method 2: Using List extension
final signals = <Signal<int>>[
  counterSignal,
  timerSignal,
  scoreSignal
];

// Convert the list of signals into a MultiSignal
final combinedSignal = signals.multiSignal;
combinedSignal.addSlot(SlotWithHandler((_) {
  // This will be called when ANY of the signals change
  print('One of the signals changed!');
}));
```

The `multiSignal` extension is particularly useful when:

- You have a dynamic list of signals
- You want to monitor multiple related signals as one
- You need to combine signals of the same type
- You want to create a single point of observation for multiple state changes

Example with dynamic signals:

```dart
class GameState {
  final List<Signal<PlayerScore>> playerScores = [];
  late final MultiSignal scoreUpdates;

  void initializeScores(int playerCount) {
    for (int i = 0; i < playerCount; i++) {
      playerScores.add(PlayerScore(0).signal);
    }

    // Monitor all player scores with a single slot
    scoreUpdates = playerScores.multiSignal;
    scoreUpdates.addSlot(SlotWithHandler((_) => updateScoreboard()));
  }
}
```

## Best Practices

1. **Signal Management**

   - Keep signals focused on single responsibilities
   - Dispose of signals when no longer needed
   - Use value equality checks for efficient updates

2. **Slot Management**

   - Remove slots when they're no longer needed
   - Keep slot logic simple and focused
   - Consider using SlotWithHandler for simple cases

3. **Global Signals**

   - Use sparingly for truly global state
   - Consider scoped alternatives when possible
   - Handle registration/unregistration properly

4. **Performance**
   - Use SignalList and SignalMap for collections
   - Avoid unnecessary signal emissions
   - Clean up unused slots and signals

## Common Use Cases

1. **Form State Management**

   ```dart
   final formField = ''.signal;
   formField.addSlot(SlotWithHandler((value) => validateField(value)));
   ```

2. **Counter Example**

   ```dart
   final counter = 0.signal;
   counter.addSlot(SlotWithHandler((count) => updateUI(count)));
   ```

3. **Collection Management**
   ```dart
   final todoList = <String>[].signalList;
   todoList.addSlot(SlotWithHandler((_) => refreshTodoUI()));
   ```

## Tips and Tricks

1. **Conditional Updates**

   - Use custom signal classes for complex update logic
   - Implement custom equality checks when needed

2. **Error Handling**

   - Wrap slot handlers in try-catch blocks
   - Provide error recovery mechanisms

3. **Testing**
   - Create mock signals for testing
   - Test slot behavior independently
   - Verify signal-slot connections

## Limitations

1. **Thread Safety**

   - Package is not thread-safe by default
   - Implement your own synchronization if needed

2. **Memory Management**

   - Remember to remove slots when not needed
   - Be cautious with global signals lifecycle

3. **Value Types**
   - Consider immutable types for signal values
   - Be aware of reference type implications

## Migration Guide

### From Other State Management Solutions

1. **From ChangeNotifier**

   - Replace notifyListeners() with signal emissions
   - Convert listeners to slots

2. **From Streams**

   - Replace StreamController with signals
   - Convert StreamSubscription to slots

3. **From GetX**
   - Replace Rx variables with signals
   - Convert .obs to .signal

## Sign Flutter Integration

Sign Flutter, Sign paketinin Flutter uygulamalarında kullanımını kolaylaştıran bir eklentidir. Widget tabanlı state yönetimi ve Flutter'a özel çözümler sunar.

### Temel Bileşenler

1. **SlotBuilder**

   Widget'ların Signal değişikliklerine tepki vermesini sağlar:

   ```dart
   // Temel kullanım
   SlotBuilder<int>(
     signal: counterSignal,
     builder: (value) => Text('Count: $value'),
     notifyOnDebug: true, // Debug modda bildirimleri kontrol et
     onDispose: () => print('Widget disposed'),
   )

   // Extension kullanarak daha kısa syntax
   counterSignal.builder(
     (value) => Text('Count: $value'),
     notifyOnDebug: true,
     onDispose: () => print('Widget disposed'),
   )
   ```

2. **ConsumerWidget**

   Özelleştirilmiş widget'lar oluşturmak için abstract sınıf:

   ```dart
   class CounterWidget extends ConsumerWidget<int> {
     const CounterWidget({Key? key, required Signal<int> signal})
         : super(key: key, signal: signal);

     @override
     Widget build(BuildContext context, int value) {
       return Text('Count: $value');
     }
   }
   ```

3. **GlobalSlotWidget**

   Global sinyalleri dinleyen widget'lar için:

   ```dart
   GlobalSlotWidget<ThemeMode, ThemeSignal>(
     builder: (context, themeMode) {
       return MaterialApp(
         themeMode: themeMode,
         // ...
       );
     },
   )
   ```

### Signal Extensions

1. **NotifierExtension**

   Signal'leri birleştirmek ve widget builder'a dönüştürmek için:

   ```dart
   // Birden fazla signal'i birleştirme
   final combinedSignal = counterSignal.combineWith([timerSignal, scoreSignal]);

   // Widget builder extension
   combinedSignal.builder(
     (value) => Text('$value'),
     notifyOnDebug: true,
   )


   [timerSignal, scoreSignal].multiSignal.builder(
     (value) => Text('$value')
   )

   ```

2. **ValueNotifier ve ChangeNotifier Dönüşümleri**

   Flutter'ın built-in state yönetim sınıflarını Signal'e dönüştürmek için:

   ```dart
   // ValueNotifier dönüşümü
   final valueNotifier = ValueNotifier(0);
   final signal = valueNotifier.asSignal();

   // ChangeNotifier dönüşümü
   final changeNotifier = MyChangeNotifier();
   final signal = changeNotifier.asSignal();
   ```

### Built-in Notifier

Performans odaklı state yönetimi için özel olarak tasarlanmış notifier:

BuiltNotifier widget paint your widget after built.

```dart
final counter = 0.signal;


BuiltNotifier(
  child: counter.builder(
    (value) => Text('$value'),
  ),
)

```

### Widget State Management

1. **StatefulWidget ile Kullanım**

   ```dart
   class MyWidget extends StatefulWidget {
     @override
     State<MyWidget> createState() => _MyWidgetState();
   }

   class _MyWidgetState extends State<MyWidget> implements Slot<int> {
     final counter = (0).signal;

     @override
     void initState() {
       super.initState();
       counter.addSlot(this);
     }

     @override
     void dispose() {
       counter.removeSlot(this);
       super.dispose();
     }

     @override
     void onValue(int value) {
       if (mounted) setState(() {});
     }

     @override
     Widget build(BuildContext context) {
       return Text('${counter.value}');
     }
   }
   ```

   Auto listen your signal.

   `SlotState` is a built-in class that implements `Slot` interface.
   It is used to define your signal before initState. It will listen your signal after initState.

   ```dart
   class MyWidget extends StatefulWidget {
     @override
     State<MyWidget> createState() => _MyWidgetState();
   }

   class _MyWidgetState extends SlotState<MyWidget> {
     final counter = defineSignal(0.signal);

      @override
      void onValue(void value) {
        print(value);
      }

   }


   ```

2. **StatelessWidget ile Kullanım**

   ```dart
   class MyWidget extends StatelessWidget {
     final counter = (0).signal;

     @override
     Widget build(BuildContext context) {
       return counter.signal.builder(
         (value) => Text('$value'),
       );
     }
   }
   ```

### Best Practices

1. **Widget Optimizasyonu**

   - `notifyOnDebug` parametresini debug modda bildirimleri kontrol etmek için kullanın
   - Gereksiz build'lerden kaçınmak için `SlotBuilder` kullanın
   - Büyük widget ağaçlarında state'i lokalize edin

2. **Memory Management**

   - `onDispose` callback'ini kullanarak temizlik işlemlerini yapın
   - Widget dispose edildiğinde slot bağlantılarını temizleyin
   - GlobalSlotWidget'ları dikkatli kullanın

3. **Performance**
   - `BuiltNotifier`'ı performans kritik durumlarda tercih edin
   - Extension metodlarını kullanarak kod tekrarını azaltın
   - Signal kombinasyonlarını optimize edin

### Örnek Kullanımlar

1. **Form Yönetimi**

   ```dart
   final formField = ('').signal;

   formField.builder(
     (value) => TextField(
       value: value,
       onChanged: formField.onChange,
     ),
   )
   ```

2. **Tema Yönetimi**

   ```dart
   final themeSignal = ThemeMode.system.globalSignal;

   // Extension kullanarak
   themeSignal.builder(
     (themeMode) => MaterialApp(
       themeMode: themeMode,
       // ...
     ),
   )
   ```

3. **Liste Yönetimi**

   ```dart
   final items = (<String>[]).signalList;

   // To listen all items
   items.multiSignal.builder(
     (list) => ListView.builder(
       itemCount: list.length,
       itemBuilder: (context, index) => Text(list[index]),
     ),
   )

   // To listen first item
   items[0].builder(
     (value) => Text('$value')
   )

   ```
