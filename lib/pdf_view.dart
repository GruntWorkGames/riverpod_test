import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

const key = 'customCacheKey';
CacheManager pdfCacheManager = CacheManager(
  Config(
    key,
    stalePeriod: const Duration(minutes: 1),
    maxNrOfCacheObjects: 200,
  ),
);

var pdfProvider = FutureProvider<PDFView>((ref) async {
  const sampleUrl =
      'https://mini-iac.org/downloads/sequences/2023-knowns/download-file?path=2023+Unlimited.pdf';
  var file = await pdfCacheManager.getFileFromCache("pdf");

  if (file == null) {
    print("downloading");
    await pdfCacheManager.downloadFile(sampleUrl, key: "pdf");
    file = await pdfCacheManager.getFileFromCache("pdf");
  } else {
    print("loading from cache");
  }

  return PDFView(filePath: file?.file.path);
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
      appBar: AppBar(title: const Text("PDF View")),
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
}
