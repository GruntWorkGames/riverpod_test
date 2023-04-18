import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

var pdfProvider = FutureProvider<PDFView>((ref) async {
  const sampleUrl =
      'https://mini-iac.org/downloads/sequences/2023-knowns/download-file?path=2023+Unlimited.pdf';
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/imac.pdf');
  final response = await http.get(Uri.parse(sampleUrl));
  await file.writeAsBytes(response.bodyBytes);
  return PDFView(filePath: file.path);
});

// ignore: must_be_immutable
class PDFScreen extends ConsumerWidget {
  var shouldDisplay = false;
  final progressIndicator = const CircularProgressIndicator();
  var loaderShowing = false;
  var fileLoaded = false;
  PDFScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PDFView> pdfView = ref.watch(pdfProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("PDF View"), actions: [
        IconButton(
            onPressed: () {
              downloadAndSavePdf(context, ref);
            },
            icon: const Icon(Icons.refresh)),
      ]),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: pdfView.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (pdf) {
                return pdf;
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndSavePdf(BuildContext context, WidgetRef ref) async {
    // ignore: use_build_context_synchronously
    // showDialog(
    //     barrierDismissible: false,
    //     useSafeArea: true,
    //     context: context,
    //     builder: (context) {
    //       return Material(
    //           type: MaterialType.transparency,
    //           child: Center(
    //               child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               // progressIndicator,
    //               // Container(
    //               //     margin: const EdgeInsets.only(top: 15),
    //               //     child: Builder(
    //               //       builder: (context) {
    //               //         return const Text("loading PDF",
    //               //             style:
    //               //                 TextStyle(color: Colors.white, fontSize: 24));
    //               //       },
    //               //     ))
    //             ],
    //           )));
    //     });
  }
}
