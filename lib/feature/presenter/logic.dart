class Logic {
  // Caesar Cipher encryption and decryption
  String caesar(String text, int key, int encrypt) {
    String result = "";
    for (var i = 0; i < text.length; i++) {
      int ch = text.codeUnitAt(i), offset = 0, x;

      if (ch >= 'а'.codeUnitAt(0) && ch <= 'я'.codeUnitAt(0))
        offset = 'а'.codeUnitAt(0);
      else if (ch >= 'А'.codeUnitAt(0) && ch <= 'Я'.codeUnitAt(0))
        offset = 'А'.codeUnitAt(0);
      else if (ch == ' '.codeUnitAt(0)) {
        result += " ";
        continue;
      }

      if (encrypt == 1)
        x = (ch + key - offset) % 33;
      else
        x = (ch - key - offset) % 33;

      result += String.fromCharCode(x + offset);
    }
    return result;
  }

// Vigenere Cipher encryption and decryption
  String vigenere(String text, String key, int encrypt) {
    String result = '';
    int j = 0;
    for (var i = 0; i < text.length; i++) {
      if (encrypt == 1) {
        int x = (text.codeUnitAt(i) + key.codeUnitAt(j) - 2 * 'а'.codeUnitAt(0)) % 33 + 'а'.codeUnitAt(0);
        result += String.fromCharCode(x);
      } else {
        int y = ((text.codeUnitAt(i) - key.codeUnitAt(j)) % 33 + 33) % 33 + 'а'.codeUnitAt(0);
        result += String.fromCharCode(y);
      }
      if (j < key.length - 1)
        j++;
      else
        j = 0;
    }
    return result;
  }

// Rail fence keyword encryption and decryption
  String railfenceEncrypt(String text, int key) {
    int row = key, col = text.length, x = 0, y = 0;
    String result = '';
    bool dir = false;
    var matrix = List.generate(row, (i) => List.filled(col, ''));
    for (var i = 0; i < text.length; i++) {
      if (x == 0 || x == row - 1) dir = !dir;
      matrix[x][y++] = text[i];
      dir ? x++ : x--;
    }
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < col; j++) {
        if (matrix[i][j] != null) result += matrix[i][j];
      }
    }
    return result;
  }

  String railfenceDecrypt(String text, int key) {
    String result = '';
    int row = 0, col = 0, index = 0;
    late bool dir;
    var matrix = List.generate(key, (i) => List.filled(text.length, ''));

    for (var i = 0; i < text.length; i++) {
      if (row == 0) dir = true;
      if (row == key - 1) dir = false;
      matrix[row][col++] = '*';
      dir ? row++ : row--;
    }

    for (var i = 0; i < key; i++) {
      for (var j = 0; j < text.length; j++) {
        if (matrix[i][j] == '*' && index < text.length) matrix[i][j] = text[index++];
      }
    }

    row = 0;
    col = 0;

    for (var i = 0; i < text.length; i++) {
      if (row == 0) dir = true;
      if (row == key - 1) dir = false;
      if (matrix[row][col] != '*') result += matrix[row][col++];
      dir ? row++ : row--;
    }

    return result;
  }

// Playfair cipher encryption & decryption

  String playfairEncrypt(String text, String key) {
    String table = '', result = '';
    text = text.replaceAll(' ', '');
    text = text.replaceAll('ё', 'е');
    key = key.replaceAll(' ', '');
    key = key.replaceAll('ё', 'е');
    text = text.toLowerCase();
    key = key.toLowerCase();

    for (var i = 0; i < text.length - 1; i++) {
      if (text[i] == text[i + 1]) text = text.substring(0, i + 1) + 'х' + text.substring(i + 1, text.length);
    }
    if (text.length % 2 != 0) text += 'х';

    var matrix = List.generate(5, (i) => List.filled(6, '')), index = 0;

    for (var i = 0; i < key.length; i++) {
      if (table.contains(key[i]) == false) {
        if (key[i] != 'ё') table += key[i];
      }
    }

    for (var i = 'а'.codeUnitAt(0); i <= 'я'.codeUnitAt(0); i++) {
      if (i != 'ё'.codeUnitAt(0) && table.contains(String.fromCharCode(i)) == false) table += String.fromCharCode(i);
    }

    for (var i = 0; i < 5; i++) for (var j = 0; j < 6; j++) matrix[i][j] = table[index++];

    for (var i = 0; i < text.length; i += 2) {
      int row1 = 0, row2 = 0, col1 = 0, col2 = 0;
      for (var j = 0; j < 5; j++) {
        if (matrix[j].contains(text[i]) == true) {
          row1 = j;
          col1 = matrix[j].indexOf(text[i]);
        }
        if (matrix[j].contains(text[i + 1]) == true) {
          row2 = j;
          col2 = matrix[j].indexOf(text[i + 1]);
        }
      }
      if (row1 == row2) {
        result += matrix[row1][(col1 + 1) % 6];
        result += matrix[row2][(col2 + 1) % 6];
      } else if (col1 == col2) {
        result += matrix[(row1 + 1) % 5][col1];
        result += matrix[(row2 + 1) % 5][col2];
      } else {
        result += matrix[row1][col2];
        result += matrix[row2][col1];
      }
    }
    return result;
  }

  String playfairDecrypt(String text, String key) {
    String table = '', result = '';
    text = text.replaceAll(' ', '');
    key = key.replaceAll(' ', '');
    key = key.replaceAll('ё', 'е');
    text = text.toLowerCase();
    key = key.toLowerCase();

    var matrix = List.generate(5, (i) => List.filled(6, '')), index = 0;

    for (var i = 0; i < key.length; i++) {
      if (table.contains(key[i]) == false) {
        if (key[i] != 'ё') table += key[i];
      }
    }

    for (var i = 'а'.codeUnitAt(0); i <= 'я'.codeUnitAt(0); i++) {
      if (i != 'ё'.codeUnitAt(0) && table.contains(String.fromCharCode(i)) == false) table += String.fromCharCode(i);
    }

    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 6; j++) {
        matrix[i][j] = table[index++];
      }
    }

    for (var i = 0; i < text.length; i += 2) {
      int row1 = 0, row2 = 0, col1 = 0, col2 = 0;
      for (var j = 0; j < 5; j++) {
        if (matrix[j].contains(text[i]) == true) {
          row1 = j;
          col1 = matrix[j].indexOf(text[i]);
        }
        if (matrix[j].contains(text[i + 1]) == true) {
          row2 = j;
          col2 = matrix[j].indexOf(text[i + 1]);
        }
      }
      if (row1 == row2) {
        result += matrix[row1][(col1 - 1) % 6];
        result += matrix[row2][(col2 - 1) % 6];
      } else if (col1 == col2) {
        result += matrix[(row1 - 1) % 5][col1];
        result += matrix[(row2 - 1) % 5][col2];
      } else {
        result += matrix[row1][col2];
        result += matrix[row2][col1];
      }
    }
    return result;
  }

// Keyword cipher encryption and decryption

  String keywordEncrypt(String text, String key) {
    String fullKey = '', result = '';
    key = key.toUpperCase();
    text = text.toUpperCase();

    for (var i = 0; i < key.length; i++) if (fullKey.contains(key[i]) == false && key[i] != ' ') fullKey += key[i];

    for (var i = 'А'.codeUnitAt(0); i <= 'Я'.codeUnitAt(0); i++)
      if (fullKey.contains(String.fromCharCode(i)) == false) fullKey += String.fromCharCode(i);

    for (var i = 0; i < text.length; i++) {
      if (text[i] == ' ')
        result += ' ';
      else
        result += fullKey[text[i].codeUnitAt(0) - 'А'.codeUnitAt(0)];
    }

    return result;
  }

  String keywordDecrypt(String text, String key) {
    String fullKey = '', result = '';
    key = key.toUpperCase();
    text = text.toUpperCase();

    for (var i = 0; i < key.length; i++)
      if (fullKey.contains(key[i]) == false &&
          key[i] != ' ' &&
          key[i].codeUnitAt(0) >= 'А'.codeUnitAt(0) &&
          key[i].codeUnitAt(0) <= 'Я'.codeUnitAt(0)) fullKey += key[i];

    for (var i = 'А'.codeUnitAt(0); i <= 'Я'.codeUnitAt(0); i++)
      if (fullKey.contains(String.fromCharCode(i)) == false) fullKey += String.fromCharCode(i);

    for (var i = 0; i < text.length; i++) {
      if (text[i] == ' ')
        result += ' ';
      else {
        result += String.fromCharCode(fullKey.indexOf(text[i]) + 'А'.codeUnitAt(0));
      }
    }

    return result;
  }
}
