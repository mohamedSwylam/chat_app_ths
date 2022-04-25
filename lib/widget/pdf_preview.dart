import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFView extends StatelessWidget {
  final String url;
  PdfViewerController? _pdfViewerController;

  PDFView({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf View'),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.black,
          child: SfPdfViewer.network(
            url,
            controller: _pdfViewerController,
          )),
    );
  }
}
