import 'package:flip_transition/flip_transition.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FlipTransition Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
    parent: _flipController,
    curve: Curves.easeInOutSine,
  );
  }

  @override
  Widget build(BuildContext context) {
    const front = Card(
      color: Colors.yellow,
      margin: EdgeInsets.all(32.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Front'),
        ),
      ),
    );

    final back = Transform.flip(
      flipY: true,
      child: const Card(
        color: Colors.cyan,
        margin: EdgeInsets.all(32.0),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Back'),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Flip the card by pressing the button:',
            ),
            TiltTransition(
              tilts: _animation,
              child: PivotSwitcher(
                listenable: _animation,
                pivot: 0.5,
                first: front,
                second: back,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_flipController.isAnimating) {
            return;
          }
          if (_flipController.isCompleted) {
            _flipController.reverse();
          }
          if (_flipController.isDismissed) {
            _flipController.forward();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}
