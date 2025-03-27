import 'package:cipher/feature/data/samples.dart';
import 'package:flutter/material.dart';
import 'package:universal_code_viewer/universal_code_viewer.dart';

class Code extends StatelessWidget {
  const Code({
    Key? key,
    required this.title,
  }) : super(
          key: key,
        );
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UniversalCodeViewer(
              code: chooseSample()['Python']!,
              style: SyntaxHighlighterStyles.githubLight,
              codeLanguage: 'Python',
            ),
            SizedBox(
              height: 10,
            ),
            UniversalCodeViewer(
              code: chooseSample()['Java']!,
              style: SyntaxHighlighterStyles.githubLight,
              codeLanguage: 'Java',
            ),
            SizedBox(
              height: 10,
            ),
            UniversalCodeViewer(
              code: chooseSample()['C#']!,
              style: SyntaxHighlighterStyles.githubLight,
              codeLanguage: 'C#',
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> chooseSample() {
    switch (title) {
      case 'ШИФР ЦЕЗАРЯ':
        return codeExamplesCeaser;
      case 'КЛЮЧЕВОЙ ШИФР':
        return codeExamplesKeyword;
      case 'ШИФР ВИЖЕНЕРА':
        return codeExamplesVigenere;
      case 'ШИФР ПЛЕЙФЕРА':
        return codeExamplesPlayfair;
      case 'ШИФР РЕШЕТКИ':
        return codeExamplesRailFence;
      default:
        return codeExamplesCeaser;
    }
  }
}
