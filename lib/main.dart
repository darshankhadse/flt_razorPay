import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Home.dart';

void main() {
  dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AppLifecycleListener _listener;
  late AppLifecycleState? _currentState;
  final List<String> _states = <String>[];
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentState = SchedulerBinding.instance.lifecycleState;

    if (_currentState != null) {
      _states.add(_currentState!.name);
    }

    _listener = AppLifecycleListener(
      onShow: () => _pushState('show'),
      onResume: () => _pushState('resume'),
      onHide: () => _pushState('hide'),
      onInactive: () => _pushState('inactive'),
      onPause: () => _pushState('pause'),
      onDetach: () => _pushState('detach'),
      onRestart: () => _pushState('restart'),
      onStateChange: _handleStateChange,
      onExitRequested: _handleExitRequest,
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
  void _pushState(String state) {
    setState(() {
      _states.add(state);
    });
  }
  void _handleStateChange(AppLifecycleState state) {
    setState(() {
      _currentState = state;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  Future<AppExitResponse> _handleExitRequest() async {
    /// Exit can proceed.
    return AppExitResponse.exit;

    /// Cancel the exit.
    return AppExitResponse.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Current State:\n${_currentState.toString()}', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text('States:\n${_states.join('\n')}', textAlign: TextAlign.center),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
