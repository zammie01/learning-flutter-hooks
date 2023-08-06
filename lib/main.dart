import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;

  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(
      const Duration(seconds: 1),
      (v) => from - v,
    ).takeWhile((value) => value >= 0).listen((value) {
      this.value = value;
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countDown = useMemoized(() => CountDown(from: 25));
    final notifier = useListenable(countDown);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Text(notifier.value.toString()),
    );
  }
}
