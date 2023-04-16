import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final counterProvider = StateProvider((ref) => 0);

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int counter = ref.watch(counterProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Riverpod Test - Counter"),
          actions: [
            IconButton(
                onPressed: () {
                  ref.invalidate(counterProvider);
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Center(
          child: Text(counter.toString(),
              style: Theme.of(context).textTheme.displayMedium),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //ref.read(counterProvider.notifier).state++;
          },
          child: const Icon(Icons.add),
        ));
  }
}
