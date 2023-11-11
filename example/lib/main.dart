import 'dart:developer';

import 'package:countdown_timer/countdown_timer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  final CountdownTimerController controller = CountdownTimerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CountDownTimer(
              controller: controller,
              width: 200,
              height: 200,
              duration: 10,
              fillColor: Colors.red,
              ringColor: Colors.blue,
              autoStart: false,
              onStart: () {
                log("on start");
              },
              onComplete: () {
                log("on complete");
              },
              onChange: (duration) {
                log("on change: ${duration.inSeconds}");
              },
              strokeCap: StrokeCap.round,
              strokeWidth: 10,
              builder: (context, duration) {
                return Center(child: Text(duration.inSeconds.toString()));
              },
            ),
            const SizedBox(height: 100),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => controller.start(),
                  child: const Text("Start"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.pause(),
                  child: const Text("Pause"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.resume(),
                  child: const Text("Resume"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.reset(),
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.restart(duration: 3),
                  child: const Text("Restart 3 seconds"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.restart(duration: 5),
                  child: const Text("Restart 5 seconds"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
