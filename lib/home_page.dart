import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'counter_page.dart';
import 'pdf_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Riverpod Test - Home"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                      child: const Text("Go to counter page"),
                      onPressed: () {
                        ref.read(counterProvider.notifier).state++;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: ((context) => const CounterPage())),
                        );
                      })),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const PDFView())));
                      },
                      child: const Text("Go to PDF")))
            ],
          ),
        ));
  }
}
