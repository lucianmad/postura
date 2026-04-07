import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:postura/features/home/home_providers.dart';

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
                      textAlign: TextAlign.center,
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
