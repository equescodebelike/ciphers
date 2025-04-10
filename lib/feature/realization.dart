import 'package:cipher/feature/widgets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'presenter/logic.dart';

Logic logic = Logic();
late String result;

class Realization extends StatefulWidget {
  final String title;

  Realization({required this.title});

  @override
  _RealizationState createState() => _RealizationState();
}

class _RealizationState extends State<Realization> {
  Map<String, String>? _publicKey;
  Map<String, String>? _privateKey;
  
  // Diffie-Hellman parameters and keys
  BigInt? _dhP;
  BigInt? _dhG;
  int? _dhPrivateKeyA;
  int? _dhPrivateKeyB;
  BigInt? _dhPublicKeyA;
  BigInt? _dhPublicKeyB;
  BigInt? _dhSharedSecretA;
  BigInt? _dhSharedSecretB;
  TextEditingController _privateKeyAController = TextEditingController();
  TextEditingController _privateKeyBController = TextEditingController();
  
  // El-Gamal parameters and keys
  Map<String, String>? _elGamalPublicKey;
  Map<String, String>? _elGamalPrivateKey;
  Map<String, String>? _elGamalCiphertext;
  TextEditingController _elGamalPrivateKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    result = '';
  }

  // Helper method to check if a number is prime
  bool _isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    int i = 5;
    while (i * i <= n) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
      i += 6;
    }
    return true;
  }

  List<TextInputFormatter> inputFormatting() {
    if (widget.title == 'ШИФР ЦЕЗАРЯ' || widget.title == 'ШИФР ВИЖЕНЕРА') {
      return [FilteringTextInputFormatter.allow(RegExp("[а-яА-ЯёЁ ]"))];
    }
    return [];
  }

  List<TextInputFormatter> keyFormatting() {
    if (widget.title == 'ШИФР ЦЕЗАРЯ' || widget.title == "ШИФР РЕШЕТКИ" || widget.title == "ШИФР RSA" || 
        widget.title == "ШИФР ДИФФИ-ХЕЛЛМАНА" || widget.title == "ШИФР ЭЛЬ-ГАМАЛЯ") {
      return [FilteringTextInputFormatter.allow(RegExp("[0-9,]"))];
    } else if (widget.title == 'ШИФР ВИЖЕНЕРА' || widget.title == 'КЛЮЧЕВОЙ ШИФР') {
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
        title:
            // CustomTooltip(
            //   maxWidth: 800,
            //   message: 'Нажмите на название шифра,\nчтобы посмотреть подробную информацию',
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) {
            //             return Scaffold(
            //               appBar: AppBar(
            //                 title: Text(
            //                   widget.title,
            //                 ),
            //               ),
            //               body: Center(
            //                 child: ConstrainedBox(
            //                   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
            //                   child: SfPdfViewer.network(
            //                     'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
            //                   ),
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     },
            //     child:
            Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                if (widget.title != "ШИФР ДИФФИ-ХЕЛЛМАНА" && widget.title != "ШИФР ЭЛЬ-ГАМАЛЯ")
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
                        hintText: widget.title == "ШИФР RSA" ? 'Текст для шифрования/зашифрованный текст' : 'Ввод',
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
                      } else if (widget.title == 'ШИФР РЕШЕТКИ' && int.parse(value) > input.text.length) {
                        return 'Числовой ключ не должен быть больше длины текста.';
                      } else if (widget.title == 'ШИФР ПЛЕЙФЕРА' && key.text.length < 6) {
                        return 'Длина ключа Плейфера должна быть не менее 6 символов.';
                      } else if (widget.title == 'ШИФР RSA') {
                        List<String> primes = value.split(',');
                        if (primes.length != 2) {
                          return 'Введите два простых числа через запятую (например: 61,53)';
                        }
                        try {
                          int p = int.parse(primes[0]);
                          int q = int.parse(primes[1]);
                          if (!_isPrime(p) || !_isPrime(q)) {
                            return 'Оба числа должны быть простыми';
                          }
                        } catch (e) {
                          return 'Введите корректные числа';
                        }
                      } else if (widget.title == 'ШИФР ДИФФИ-ХЕЛЛМАНА') {
                        List<String> params = value.split(',');
                        if (params.length != 2) {
                          return 'Введите p,g через запятую (например: 23,5)';
                        }
                        try {
                          int p = int.parse(params[0]);
                          int g = int.parse(params[1]);
                          if (!_isPrime(p)) {
                            return 'p должно быть простым числом';
                          }
                          if (g <= 1 || g >= p) {
                            return 'g должно быть в диапазоне [2, p-1]';
                          }
                        } catch (e) {
                          return 'Введите корректные числа';
                        }
                      } else if (widget.title == 'ШИФР ЭЛЬ-ГАМАЛЯ') {
                        List<String> params = value.split(',');
                        if (params.length != 2) {
                          return 'Введите p,g через запятую (например: 23,5)';
                        }
                        try {
                          int p = int.parse(params[0]);
                          int g = int.parse(params[1]);
                          if (!_isPrime(p)) {
                            return 'p должно быть простым числом';
                          }
                          if (g <= 1 || g >= p) {
                            return 'g должно быть в диапазоне [2, p-1]';
                          }
                        } catch (e) {
                          return 'Введите корректные числа';
                        }
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      hintText: widget.title == "ШИФР RSA" 
                        ? 'Два простых числа через запятую (например: 61,53)' 
                        : widget.title == "ШИФР ДИФФИ-ХЕЛЛМАНА" 
                          ? 'Общие параметры p,g (например: 23,5)'
                          : widget.title == "ШИФР ЭЛЬ-ГАМАЛЯ"
                            ? 'Общие параметры p,g (например: 23,5)'
                            : 'Ключ',
                    ),
                  ),
                ),
                if (widget.title == "ШИФР ДИФФИ-ХЕЛЛМАНА") ...[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: TextFormField(
                      controller: _privateKeyAController,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Обязательно';
                        }
                        try {
                          int a = int.parse(value);
                          if (_dhP != null && (a <= 1 || a >= _dhP!.toInt())) {
                            return 'Секретный ключ должен быть в диапазоне [2, p-1]';
                          }
                        } catch (e) {
                          return 'Введите корректное число';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        hintText: 'Секретный ключ стороны A',
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
                      controller: _privateKeyBController,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Обязательно';
                        }
                        try {
                          int b = int.parse(value);
                          if (_dhP != null && (b <= 1 || b >= _dhP!.toInt())) {
                            return 'Секретный ключ должен быть в диапазоне [2, p-1]';
                          }
                        } catch (e) {
                          return 'Введите корректное число';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        hintText: 'Секретный ключ стороны B',
                      ),
                    ),
                  ),
                ],
                
                if (widget.title == "ШИФР ЭЛЬ-ГАМАЛЯ") ...[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: TextFormField(
                      controller: _elGamalPrivateKeyController,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Обязательно';
                        }
                        try {
                          int x = int.parse(value);
                          if (key.text.isNotEmpty) {
                            List<String> params = key.text.split(',');
                            if (params.length == 2) {
                              int p = int.parse(params[0]);
                              if (x <= 1 || x >= p - 1) {
                                return 'Секретный ключ должен быть в диапазоне [2, p-2]';
                              }
                            }
                          }
                        } catch (e) {
                          return 'Введите корректное число';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        hintText: 'Секретный ключ x',
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
                      controller: input,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Обязательно';
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        hintText: 'Текст для шифрования/зашифрованный текст',
                      ),
                    ),
                  ),
                ],
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
                                result = logic.caesar(input.text, int.parse(key.text), 1);
                              } else if (widget.title == "ШИФР ВИЖЕНЕРА") {
                                result = logic.vigenere(input.text, key.text, 1);
                              } else if (widget.title == "ШИФР РЕШЕТКИ") {
                                result = logic.railfenceEncrypt(input.text, int.parse(key.text));
                              } else if (widget.title == "ШИФР ПЛЕЙФЕРА") {
                                result = logic.playfairEncrypt(input.text, key.text);
                              } else if (widget.title == "КЛЮЧЕВОЙ ШИФР") {
                                result = logic.keywordEncrypt(input.text, key.text);
                              } else if (widget.title == "ШИФР RSA") {
                                List<String> primes = key.text.split(',');
                                int p = int.parse(primes[0]);
                                int q = int.parse(primes[1]);
                                var keys = logic.rsaGenerateKeys(p, q);
                                _publicKey = keys['publicKey'];
                                _privateKey = keys['privateKey'];
                                result = "Открытый ключ: {e: ${_publicKey!['e']}, n: ${_publicKey!['n']}}\n" +
                                         "Закрытый ключ: {d: ${_privateKey!['d']}, n: ${_privateKey!['n']}}\n\n" +
                                         "Зашифрованный текст: ${logic.rsaEncrypt(input.text, _publicKey!)}";
                              } else if (widget.title == "ШИФР ДИФФИ-ХЕЛЛМАНА") {
                                List<String> params = key.text.split(',');
                                int p = int.parse(params[0]);
                                int g = int.parse(params[1]);
                                
                                // Generate parameters
                                var dhParams = logic.diffieHellmanGenerateParams(p, g);
                                _dhP = dhParams['p'];
                                _dhG = dhParams['g'];
                                
                                // Generate keys for both parties
                                _dhPrivateKeyA = int.parse(_privateKeyAController.text);
                                _dhPrivateKeyB = int.parse(_privateKeyBController.text);
                                
                                var keysA = logic.diffieHellmanGenerateKeys(_dhP!, _dhG!, _dhPrivateKeyA!);
                                var keysB = logic.diffieHellmanGenerateKeys(_dhP!, _dhG!, _dhPrivateKeyB!);
                                
                                _dhPublicKeyA = keysA['publicKey'];
                                _dhPublicKeyB = keysB['publicKey'];
                                
                                // Compute shared secrets
                                _dhSharedSecretA = logic.diffieHellmanComputeSharedSecret(_dhP!, keysA['privateKey'], _dhPublicKeyB!);
                                _dhSharedSecretB = logic.diffieHellmanComputeSharedSecret(_dhP!, keysB['privateKey'], _dhPublicKeyA!);
                                
                                result = "Общие параметры:\n" +
                                         "p = $_dhP\n" +
                                         "g = $_dhG\n\n" +
                                         "Сторона A:\n" +
                                         "Секретный ключ a = $_dhPrivateKeyA\n" +
                                         "Открытый ключ A = $_dhPublicKeyA\n\n" +
                                         "Сторона B:\n" +
                                         "Секретный ключ b = $_dhPrivateKeyB\n" +
                                         "Открытый ключ B = $_dhPublicKeyB\n\n" +
                                         "Общий секрет для стороны A: $_dhSharedSecretA\n" +
                                         "Общий секрет для стороны B: $_dhSharedSecretB\n\n" +
                                         "Совпадают ли ключи? ${_dhSharedSecretA == _dhSharedSecretB ? 'Да' : 'Нет'}";
                              } else if (widget.title == "ШИФР ЭЛЬ-ГАМАЛЯ") {
                                List<String> params = key.text.split(',');
                                int p = int.parse(params[0]);
                                int g = int.parse(params[1]);
                                int x = int.parse(_elGamalPrivateKeyController.text);
                                
                                // Generate keys
                                var keys = logic.elGamalGenerateKeys(p, g);
                                _elGamalPublicKey = keys['publicKey'];
                                _elGamalPrivateKey = keys['privateKey'];
                                
                                // Encrypt the message
                                _elGamalCiphertext = logic.elGamalEncrypt(input.text, _elGamalPublicKey!);
                                
                                // Decrypt the message for verification
                                String decryptedText = logic.elGamalDecrypt(_elGamalCiphertext!, _elGamalPrivateKey!);
                                
                                result = "Общие параметры:\n" +
                                         "p = ${_elGamalPublicKey!['p']}\n" +
                                         "g = ${_elGamalPublicKey!['g']}\n\n" +
                                         "Секретный ключ x = ${_elGamalPrivateKey!['x']}\n" +
                                         "Открытый ключ y = ${_elGamalPublicKey!['y']}\n\n" +
                                         "Исходный текст: ${input.text}\n\n" +
                                         "Зашифрованный текст (a,b):\n${_elGamalCiphertext!['a']}\n${_elGamalCiphertext!['b']}\n\n" +
                                         "Расшифрованный текст: $decryptedText\n\n" +
                                         "Совпадают ли тексты? ${input.text == decryptedText ? 'Да' : 'Нет'}";
                              }
                            });
                          }
                        },
                        icon: Icon(Icons.lock_outline),
                        label: Text(widget.title == "ШИФР ДИФФИ-ХЕЛЛМАНА" || widget.title == "ШИФР ЭЛЬ-ГАМАЛЯ" ? 'ВЫЧИСЛИТЬ' : 'ЗАШИФРОВАТЬ'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      if (widget.title != "ШИФР ДИФФИ-ХЕЛЛМАНА" && widget.title != "ШИФР ЭЛЬ-ГАМАЛЯ")
                        ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                if (widget.title == "ШИФР ЦЕЗАРЯ") {
                                  result = logic.caesar(input.text, int.parse(key.text), 0);
                                } else if (widget.title == "ШИФР ВИЖЕНЕРА") {
                                  result = logic.vigenere(input.text, key.text, 0);
                                } else if (widget.title == "ШИФР РЕШЕТКИ") {
                                  result = logic.railfenceDecrypt(input.text, int.parse(key.text));
                                } else if (widget.title == "ШИФР ПЛЕЙФЕРА") {
                                  result = logic.playfairDecrypt(input.text, key.text);
                                } else if (widget.title == "КЛЮЧЕВОЙ ШИФР") {
                                  result = logic.keywordDecrypt(input.text, key.text);
                                } else if (widget.title == "ШИФР RSA") {
                                  if (_privateKey != null) {
                                    result = "Расшифрованный текст: ${logic.rsaDecrypt(input.text, _privateKey!)}";
                                  } else {
                                    result = "Сначала сгенерируйте ключи, нажав на кнопку 'ЗАШИФРОВАТЬ'";
                                  }
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
