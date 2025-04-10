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

  // RSA cipher encryption and decryption
  Map<String, dynamic> rsaGenerateKeys(int p, int q) {
    BigInt pBig = BigInt.from(p);
    BigInt qBig = BigInt.from(q);
    BigInt n = pBig * qBig;
    BigInt phi = (pBig - BigInt.one) * (qBig - BigInt.one);
    
    // Choose e (usually 65537)
    BigInt e = BigInt.from(65537);
    while (_gcd(e, phi) != BigInt.one) {
      e += BigInt.one;
    }
    
    // Find d (modular multiplicative inverse of e mod phi)
    BigInt d = _modInverse(e, phi);
    
    return {
      'publicKey': {'e': e.toString(), 'n': n.toString()},
      'privateKey': {'d': d.toString(), 'n': n.toString()}
    };
  }

  String rsaEncrypt(String message, Map<String, String> publicKey) {
    List<String> encrypted = [];
    BigInt e = BigInt.parse(publicKey['e']!);
    BigInt n = BigInt.parse(publicKey['n']!);
    
    for (int i = 0; i < message.length; i++) {
      BigInt m = BigInt.from(message.codeUnitAt(i));
      BigInt c = _modPow(m, e, n);
      encrypted.add(c.toString());
    }
    
    return encrypted.join(',');
  }

  String rsaDecrypt(String ciphertext, Map<String, String> privateKey) {
    List<String> parts = ciphertext.split(',');
    String decrypted = '';
    BigInt d = BigInt.parse(privateKey['d']!);
    BigInt n = BigInt.parse(privateKey['n']!);
    
    for (String part in parts) {
      BigInt c = BigInt.parse(part);
      BigInt m = _modPow(c, d, n);
      decrypted += String.fromCharCode(m.toInt());
    }
    
    return decrypted;
  }

  // Helper methods for RSA
  BigInt _gcd(BigInt a, BigInt b) {
    while (b != BigInt.zero) {
      BigInt t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  BigInt _modPow(BigInt base, BigInt exponent, BigInt modulus) {
    if (modulus == BigInt.one) return BigInt.zero;
    
    BigInt result = BigInt.one;
    base = base % modulus;
    
    while (exponent > BigInt.zero) {
      if (exponent & BigInt.one == BigInt.one) {
        result = (result * base) % modulus;
      }
      exponent = exponent >> 1;
      base = (base * base) % modulus;
    }
    
    return result;
  }

  BigInt _modInverse(BigInt a, BigInt m) {
    BigInt m0 = m;
    BigInt y = BigInt.zero;
    BigInt x = BigInt.one;
    
    if (m == BigInt.one) return BigInt.zero;
    
    while (a > BigInt.one) {
      BigInt q = a ~/ m;
      BigInt t = m;
      
      m = a % m;
      a = t;
      t = y;
      
      y = x - q * y;
      x = t;
    }
    
    if (x < BigInt.zero) x += m0;
    
    return x;
  }

  // Diffie-Hellman key exchange methods
  Map<String, dynamic> diffieHellmanGenerateParams(int p, int g) {
    return {
      'p': BigInt.from(p),
      'g': BigInt.from(g)
    };
  }

  Map<String, dynamic> diffieHellmanGenerateKeys(BigInt p, BigInt g, int privateKey) {
    BigInt privateKeyBig = BigInt.from(privateKey);
    BigInt publicKey = _modPow(g, privateKeyBig, p);
    
    return {
      'privateKey': privateKeyBig,
      'publicKey': publicKey
    };
  }

  BigInt diffieHellmanComputeSharedSecret(BigInt p, BigInt privateKey, BigInt otherPublicKey) {
    return _modPow(otherPublicKey, privateKey, p);
  }

  // El-Gamal cipher encryption and decryption
  Map<String, dynamic> elGamalGenerateKeys(int p, int g) {
    // Check if p is prime and g is a primitive root
    BigInt pBig = BigInt.from(p);
    BigInt gBig = BigInt.from(g);
    
    // Generate a random secret key x
    int x = _generateRandomInt(2, p - 2);
    BigInt xBig = BigInt.from(x);
    
    // Calculate public key y = g^x mod p
    BigInt y = _modPow(gBig, xBig, pBig);
    
    return {
      'publicKey': {'p': pBig.toString(), 'g': gBig.toString(), 'y': y.toString()},
      'privateKey': {'x': xBig.toString(), 'p': pBig.toString()}
    };
  }

  Map<String, String> elGamalEncrypt(String message, Map<String, String> publicKey) {
    BigInt p = BigInt.parse(publicKey['p']!);
    BigInt g = BigInt.parse(publicKey['g']!);
    BigInt y = BigInt.parse(publicKey['y']!);
    
    // Generate a random k for each character
    List<String> a = [];
    List<String> b = [];
    
    for (int i = 0; i < message.length; i++) {
      // Generate a random k for each character
      int k = _generateRandomInt(2, p.toInt() - 2);
      BigInt kBig = BigInt.from(k);
      
      // Calculate a = g^k mod p
      BigInt aBig = _modPow(g, kBig, p);
      
      // Calculate b = m * y^k mod p
      BigInt m = BigInt.from(message.codeUnitAt(i));
      BigInt bBig = (m * _modPow(y, kBig, p)) % p;
      
      a.add(aBig.toString());
      b.add(bBig.toString());
    }
    
    return {
      'a': a.join(','),
      'b': b.join(',')
    };
  }

  String elGamalDecrypt(Map<String, String> ciphertext, Map<String, String> privateKey) {
    List<String> aParts = ciphertext['a']!.split(',');
    List<String> bParts = ciphertext['b']!.split(',');
    
    BigInt x = BigInt.parse(privateKey['x']!);
    BigInt p = BigInt.parse(privateKey['p']!);
    
    String decrypted = '';
    
    for (int i = 0; i < aParts.length; i++) {
      BigInt a = BigInt.parse(aParts[i]);
      BigInt b = BigInt.parse(bParts[i]);
      
      // Calculate s = a^x mod p
      BigInt s = _modPow(a, x, p);
      
      // Calculate m = b * s^(-1) mod p
      BigInt sInverse = _modInverse(s, p);
      BigInt m = (b * sInverse) % p;
      
      decrypted += String.fromCharCode(m.toInt());
    }
    
    return decrypted;
  }

  // Helper method to generate a random integer
  int _generateRandomInt(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }
}
