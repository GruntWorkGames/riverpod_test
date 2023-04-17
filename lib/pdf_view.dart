import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key});
  @override
  PDFState createState() => PDFState();
}

// ignore: must_be_immutable
class PDFState extends State<PDFView> {
  final sampleUrl =
      'https://mini-iac.org/downloads/sequences/2023-knowns/download-file?path=2023+Unlimited.pdf';

  String? pdfFlePath;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final progressIndicator = const CircularProgressIndicator();

  Future<String> downloadAndSavePdf() async {
    var downloadExists = false;
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    downloadExists = await file.exists();
    var message = "Downloading PDF...";
    if (downloadExists) {
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

    if (downloadExists) {
      return file.path;
    }

    _refreshIndicatorKey.currentState?.show();

    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF View"), actions: [
        IconButton(onPressed: loadPdf, icon: const Icon(Icons.refresh)),
      ]),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                if (pdfFlePath != null) {
                  Navigator.of(context).pop();
                  return Expanded(child: PdfView(path: pdfFlePath!));
                } else {
                  return const Text("Pdf is not Loaded");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
