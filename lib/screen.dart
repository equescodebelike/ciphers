import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'logic.dart';

Logic logic = Logic();
late String result;

class Screen extends StatefulWidget {
  final String title;

  Screen({required this.title});

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();
    result = '';
  }

  List<TextInputFormatter> inputFormatting() {
    if (widget.title == 'ШИФР ЦЕЗАРЯ' || widget.title == 'ШИФР ВИЖЕНЕРА') {
      return [FilteringTextInputFormatter.allow(RegExp("[а-яА-ЯёЁ ]"))];
    }
    return [];
  }

  List<TextInputFormatter> keyFormatting() {
    if (widget.title == 'ШИФР ЦЕЗАРЯ' || widget.title == "ШИФР РЕШЕТКИ") {
      return [FilteringTextInputFormatter.allow(RegExp("[0-9]"))];
    } else if (widget.title == 'ШИФР ВИЖЕНЕРА' ||
        widget.title == 'КЛЮЧЕВОЙ ШИФР') {
      return [FilteringTextInputFormatter.allow(RegExp("[а-яА-ЯёЁ ]"))];
    }
    return [];
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController input = TextEditingController();
  TextEditingController key = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
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
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 2),
                        child: SfPdfViewer.network(
                          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: TextFormField(
                    controller: input,
                    inputFormatters: inputFormatting(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Обязательно';
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      hintText: 'Ввод',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: TextFormField(
                    controller: key,
                    inputFormatters: keyFormatting(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Обязательно';
                      } else if (widget.title == 'ШИФР РЕШЕТКИ' &&
                          int.parse(value) > input.text.length) {
                        return 'Числовой ключ не должен быть больше длины текста.';
                      } else if (widget.title == 'ШИФР ПЛЕЙФЕРА' &&
                          key.text.length < 6) {
                        return 'Длина ключа Плейфера должна быть не менее 6 символов.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      hintText: 'Ключ',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              if (widget.title == "ШИФР ЦЕЗАРЯ") {
                                result = logic.caesar(
                                    input.text, int.parse(key.text), 1);
                              } else if (widget.title == "ШИФР ВИЖЕНЕРА") {
                                result =
                                    logic.vigenere(input.text, key.text, 1);
                              } else if (widget.title == "ШИФР РЕШЕТКИ") {
                                result = logic.railfenceEncrypt(
                                    input.text, int.parse(key.text));
                              } else if (widget.title == "ШИФР ПЛЕЙФЕРА") {
                                result =
                                    logic.playfairEncrypt(input.text, key.text);
                              } else if (widget.title == "КЛЮЧЕВОЙ ШИФР") {
                                result =
                                    logic.keywordEncrypt(input.text, key.text);
                              }
                            });
                          }
                        },
                        icon: Icon(Icons.lock_outline),
                        label: Text('ЗАШИФРОВАТЬ'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              if (widget.title == "ШИФР ЦЕЗАРЯ") {
                                result = logic.caesar(
                                    input.text, int.parse(key.text), 0);
                              } else if (widget.title == "ШИФР ВИЖЕНЕРА") {
                                result =
                                    logic.vigenere(input.text, key.text, 0);
                              } else if (widget.title == "ШИФР РЕШЕТКИ") {
                                result = logic.railfenceDecrypt(
                                    input.text, int.parse(key.text));
                              } else if (widget.title == "ШИФР ПЛЕЙФЕРА") {
                                result =
                                    logic.playfairDecrypt(input.text, key.text);
                              } else if (widget.title == "КЛЮЧЕВОЙ ШИФР") {
                                result =
                                    logic.keywordDecrypt(input.text, key.text);
                              }
                            });
                          }
                        },
                        icon: Icon(Icons.lock_open_rounded),
                        label: Text('РАСШИФРОВАТЬ'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: ListTile(
                    title: Text(
                      'ВЫВОД',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: ListTile(
                    title: Text(
                      result,
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
