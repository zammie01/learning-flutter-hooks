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

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useState("");
    useEffect(
      () {
        controller.addListener(() {
          text.value = controller.text;
        });
        return null;
      },
      [controller],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextField(controller: controller),
          const SizedBox(height: 10),
          Text("You typed: ${text.value}"),
        ],
      ),
    );
  }
}
