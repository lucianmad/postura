import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:postura/firebase_options.dart';
import 'package:postura/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postura',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postureStreamStatus = ref.watch(postureStateProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: postureStreamStatus.when(
            data: (state) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.status == 'Posture OK'
                        ? Colors.green
                        : Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      state.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight(900),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm:ss').format(
                    DateTime.fromMillisecondsSinceEpoch(state.timestamp * 1000),
                  ),
                ),
              ],
            ),
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text(err.toString()),
          ),
        ),
      ),
    );
  }
}
