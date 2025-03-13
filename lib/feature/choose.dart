import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'realization.dart';

final ciphers = [
  'РЕАЛИЗАЦИЯ АЛГОРИТМА',
  'ПОДРОБНАЯ ИНФОРМАЦИЯ',
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
                            title: Text(
                              widget.title,
                            ),
                          ),
                          body: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                              child: SfPdfViewer.network(
                                'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                if (index == 2) {

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
}
