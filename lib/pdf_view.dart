import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PDFProvider extends StateNotifier<PdfView> {
  PDFProvider()
      : super(const PdfView(
          path: "",
        ));

  void setPdfState(PdfView newState) {
    updateShouldNotify(state, newState);
    state = newState;
  }
}

final pdfProvider = StateNotifierProvider<PDFProvider, PdfView>((ref) {
  return PDFProvider();
});

// ignore: must_be_immutable
class PDFScreen extends ConsumerWidget {
  final sampleUrl =
      'https://mini-iac.org/downloads/sequences/2023-knowns/download-file?path=2023+Unlimited.pdf';
  String pdfFlePath = "";
  final progressIndicator = const CircularProgressIndicator();
  var loaderShowing = false;
  var fileExists = false;

  PDFScreen({Key? key}) : super(key: key);

  Future<void> downloadAndSavePdf(BuildContext context, WidgetRef ref) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    fileExists = await file.exists();
    var message = "Downloading PDF...";
    if (fileExists) {
      message = "Loading PDF...";
    }

    // ignore: use_build_context_synchronously
    showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Material(
              type: MaterialType.transparency,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  progressIndicator,
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Builder(
                        builder: (context) {
                          return Text(message,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24));
                        },
                      ))
                ],
              )));
        });

    loaderShowing = true;
    pdfFlePath = file.path;

    // if (fileExists) {
    //   ref.read(pdfProvider.notifier).state = (PdfView(path: file.path));
    //   return;
    // }

    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    ref.read(pdfProvider.notifier).setPdfState(PdfView(path: pdfFlePath));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfView = ref.watch(pdfProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("PDF View"), actions: [
        IconButton(
            onPressed: () {
              downloadAndSavePdf(context, ref);
            },
            icon: const Icon(Icons.refresh)),
      ]),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Builder(
            builder: (context) {
              if (loaderShowing) {
                loaderShowing = false;
                Navigator.of(context).pop();
              }
              return Expanded(child: Builder(builder: (BuildContext context) {
                return PdfView(path: pdfView.path);
              }));
            },
          )
        ]),
      ),
    );
  }
}
