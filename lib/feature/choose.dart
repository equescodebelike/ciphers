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
        return SfPdfViewer.asset(
          'symetric/caesar_cipher.pdf',
        );
      case 'КЛЮЧЕВОЙ ШИФР':
        return SfPdfViewer.asset(
          'symetric/key_cipher.pdf',
        );
      case 'ШИФР ВИЖЕНЕРА':
        return SfPdfViewer.asset(
          'symetric/vigenere_cipher.pdf',
        );
      case 'ШИФР ПЛЕЙФЕРА':
        return SfPdfViewer.asset(
          'symetric/playfair_cipher.pdf',
        );
      case 'ШИФР РЕШЕТКИ':
        return SfPdfViewer.asset(
          'symetric/grid_cipher.pdf',
        );
      case 'ШИФР ДИФФИ-ХЕЛЛМАНА':
        return SfPdfViewer.asset(
          'assymetric/diffie_hellman_cipher.pdf',
        );
      case 'ШИФР ЭЛЬ-ГАМАЛЯ':
        return SfPdfViewer.asset(
          'assymetric/el_gamal_cipher.pdf',
        );
      case 'ШИФР RSA':
        return SfPdfViewer.asset(
          'assymetric/rsa_cipher.pdf',
        );
      default:
        return SfPdfViewer.asset(
          'symetric/caesar_cipher.pdf',
        );
    }
  }
}
