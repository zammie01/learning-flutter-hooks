import 'dart:math';

import 'package:flutter/material.dart';
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

const url = "https://bit.ly/47o4yXK";

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
}

class State {
  final double rotationDeg;
  final double alpha;

  const State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(rotationDeg: rotationDeg + 10.0, alpha: alpha);

  State rotateLeft() => State(rotationDeg: rotationDeg - 10.0, alpha: alpha);

  State increaseAlpha() =>
      State(rotationDeg: rotationDeg, alpha: min(alpha + 0.1, 1.0));

  State decreaseAlpha() =>
      State(rotationDeg: rotationDeg, alpha: max(alpha - 0.1, 0.0));
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              RotateLeftButton(store: store),
              RotateRightButton(store: store),
              MoreVisibleButton(store: store),
              LessVisibleButton(store: store)
            ],
          ),
          const SizedBox(height: 100),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360),
              child: Image.network(url),
            ),
          ),
        ],
      ),
    );
  }
}

class LessVisibleButton extends StatelessWidget {
  const LessVisibleButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.lessVisible);
        },
        child: const Text("- Alpha"));
  }
}

class MoreVisibleButton extends StatelessWidget {
  const MoreVisibleButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.moreVisible);
        },
        child: const Text("+ Alpha"));
  }
}

class RotateRightButton extends StatelessWidget {
  const RotateRightButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.rotateRight);
        },
        child: const Text("Rotate Right"));
  }
}

class RotateLeftButton extends StatelessWidget {
  const RotateLeftButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(Action.rotateLeft);
        },
        child: const Text("Rotate Left"));
  }
}
