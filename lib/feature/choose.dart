import 'package:cipher/feature/code.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'realization.dart';

final ciphers = [
  'ЗАШИФРОВАТЬ СООБЩЕНИЕ',
  'СХЕМА И ПРИНЦИП РАБОТЫ',
  'КОД АЛГОРИТМА',
];

class Choose extends StatefulWidget {
  final String title;

  Choose({
    required this.title,
  });

  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: ciphers.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.015,
              left: MediaQuery.of(context).size.height * 0.015,
              right: MediaQuery.of(context).size.height * 0.015,
            ),
            child: ListTile(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Realization(
                        title: widget.title,
                      ),
                    ),
                  );
                }
                if (index == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            centerTitle: true,
                            title: Text(
                              widget.title,
                            ),
                          ),
                          body: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                              child: PdfWidget(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                if (index == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Code(
                        title: widget.title,
                      ),
                    ),
                  );
                }
              },
              leading: Icon(Icons.lock, color: Colors.black),
              title: Text(ciphers[index]),
            ),
          );
        },
      ),
    );
  }

  Widget PdfWidget() {
    switch (widget.title) {
      case 'ШИФР ЦЕЗАРЯ':
        return SfPdfViewer.network(
          'https://github.com/equescodebelike/ciphers/raw/refs/heads/master/assets/symetric/%D0%A8%D0%B8%D1%84%D1%80_%D0%A6%D0%B5%D0%B7%D0%B0%D1%80%D1%8F.pdf',
        );
      case 'КЛЮЧЕВОЙ ШИФР':
        return SfPdfViewer.network(
          'https://github.com/equescodebelike/ciphers/raw/refs/heads/master/assets/symetric/%D0%9A%D0%BB%D1%8E%D1%87%D0%B5%D0%B2%D0%BE%D0%B9_%D1%88%D0%B8%D1%84%D1%80.pdf',
        );
      case 'ШИФР ВИЖЕНЕРА':
        return SfPdfViewer.network(
          'https://github.com/equescodebelike/ciphers/raw/refs/heads/master/assets/symetric/%D1%88%D0%B8%D1%84%D1%80_%D0%92%D0%B8%D0%B6%D0%B5%D0%BD%D0%B5%D1%80%D0%B0.pdf',
        );
      case 'ШИФР ПЛЕЙФЕРА':
        return SfPdfViewer.network(
          'https://github.com/equescodebelike/ciphers/raw/refs/heads/master/assets/symetric/%D1%88%D0%B8%D1%84%D1%80_%D0%9F%D0%BB%D0%B5%D0%B9%D1%84%D0%B5%D1%80%D0%B0.pdf',
        );
      case 'ШИФР РЕШЕТКИ':
        return SfPdfViewer.network(
          'https://github.com/equescodebelike/ciphers/raw/refs/heads/master/assets/symetric/%D1%88%D0%B8%D1%84%D1%80_%D1%80%D0%B5%D1%88%D0%B5%D1%82%D0%BA%D0%B8.pdf',
        );
      case 'ШИФР ДИФФИ-ХЕЛЛМАНА':
        return SfPdfViewer.network(
          'https://raw.githubusercontent.com/equescodebelike/ciphers/refs/heads/master/assets/assymetric/%D0%A8%D0%B8%D1%84%D1%80%20%D0%94%D0%B8%D1%84%D1%84%D0%B8-%D0%A5%D0%B5%D0%BB%D0%BB%D0%BC%D0%B0%D0%BD%D0%B0.pdf',
        );
      case 'ШИФР ЭЛЬ-ГАМАЛЯ':
        return SfPdfViewer.network(
          'https://raw.githubusercontent.com/equescodebelike/ciphers/refs/heads/master/assets/assymetric/%D0%A8%D0%B8%D1%84%D1%80%20%D0%AD%D0%BB%D1%8C-%D0%93%D0%B0%D0%BC%D0%B0%D0%BB%D1%8F%20%D1%81%D0%BA%D0%B0%D0%BD.pdf',
        );
      case 'ШИФР RSA':
        return SfPdfViewer.network(
          'https://raw.githubusercontent.com/equescodebelike/ciphers/b2b2aca1cc004dea71c549e88284ecdb128882c2/assets/assymetric/%D1%88%D0%B8%D1%84%D1%80_RSA.pdf',
        );
      default:
        return SfPdfViewer.network(
          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
        );
    }
  }
}
