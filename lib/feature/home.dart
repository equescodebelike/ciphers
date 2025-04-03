import 'package:cipher/feature/choose.dart';
import 'package:flutter/material.dart';
import 'realization.dart';

final symmetricCiphers = [
  'ШИФР ЦЕЗАРЯ',
  'КЛЮЧЕВОЙ ШИФР',
  'ШИФР ПЛЕЙФЕРА',
  'ШИФР РЕШЕТКИ',
  'ШИФР ВИЖЕНЕРА',
];

final assymetricCiphers = [
  'ДИФФИ-ХЕЛЛМАНА',
  'RSA',
];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              'СИММЕТРИЧНЫЕ СИСТЕМЫ',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 330,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: symmetricCiphers.length,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Choose(title: symmetricCiphers[index]),
                          ),
                        );
                      },
                      leading: Icon(Icons.lock, color: Colors.black),
                      title: Text(symmetricCiphers[index]),
                    ),
                  );
                },
              ),
            ),
            Text(
              'АССИММЕТРИЧНЫЕ СИСТЕМЫ',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: assymetricCiphers.length,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Choose(title: assymetricCiphers[index]),
                          ),
                        );
                      },
                      leading: Icon(Icons.lock, color: Colors.black),
                      title: Text(assymetricCiphers[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
