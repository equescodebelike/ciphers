final Map<String, String> codeExamplesRSA = {
  'Python': '''import math

def generate_keys(p, q):
    n = p * q
    phi = (p - 1) * (q - 1)
    
    # Выбираем e (обычно 65537)
    e = 65537
    while math.gcd(e, phi) != 1:
        e += 1
    
    # Находим d (обратное к e mod phi)
    d = pow(e, -1, phi)
    
    return (e, n), (d, n)

def encrypt(m, public_key):
    e, n = public_key
    return pow(m, e, n)

def decrypt(c, private_key):
    d, n = private_key
    return pow(c, d, n)

# Пример
p, q = 61, 53  # Простые числа
public_key, private_key = generate_keys(p, q)

message = 42
encrypted = encrypt(message, public_key)
decrypted = decrypt(encrypted, private_key)

print(f"Original: {message}")
print(f"Encrypted: {encrypted}")
print(f"Decrypted: {decrypted}")''',
'Java': '''import java.math.BigInteger;
import java.security.SecureRandom;

public class RSA {
    private BigInteger n, e, d;

    public RSA(int bitLength) {
        SecureRandom rnd = new SecureRandom();
        BigInteger p = BigInteger.probablePrime(bitLength, rnd);
        BigInteger q = BigInteger.probablePrime(bitLength, rnd);
        
        n = p.multiply(q);
        BigInteger phi = p.subtract(BigInteger.ONE).multiply(q.subtract(BigInteger.ONE));
        
        e = BigInteger.valueOf(65537);
        while (e.gcd(phi).compareTo(BigInteger.ONE) != 0) {
            e = e.add(BigInteger.ONE);
        }
        
        d = e.modInverse(phi);
    }

    public BigInteger encrypt(BigInteger message) {
        return message.modPow(e, n);
    }

    public BigInteger decrypt(BigInteger ciphertext) {
        return ciphertext.modPow(d, n);
    }

    public static void main(String[] args) {
        RSA rsa = new RSA(1024);
        BigInteger message = new BigInteger("42");
        
        BigInteger encrypted = rsa.encrypt(message);
        BigInteger decrypted = rsa.decrypt(encrypted);
        
        System.out.println("Original: " + message);
        System.out.println("Encrypted: " + encrypted);
        System.out.println("Decrypted: " + decrypted);
    }
}''',
'C#': '''using System;
using System.Numerics;

class RSA
{
    private BigInteger n, e, d;

    public RSA(int bitLength)
    {
        Random rnd = new Random();
        BigInteger p = BigInteger.ProbablePrime(bitLength, rnd);
        BigInteger q = BigInteger.ProbablePrime(bitLength, rnd);
        
        n = p * q;
        BigInteger phi = (p - 1) * (q - 1);
        
        e = 65537;
        while (BigInteger.GreatestCommonDivisor(e, phi) != 1)
        {
            e++;
        }
        
        d = ModInverse(e, phi);
    }

    public BigInteger Encrypt(BigInteger message)
    {
        return BigInteger.ModPow(message, e, n);
    }

    public BigInteger Decrypt(BigInteger ciphertext)
    {
        return BigInteger.ModPow(ciphertext, d, n);
    }

    private BigInteger ModInverse(BigInteger a, BigInteger m)
    {
        BigInteger x, y;
        BigInteger g = ExtendedGcd(a, m, out x, out y);
        if (g != 1)
            throw new Exception("Обратного элемента не существует");
        return (x % m + m) % m;
    }

    private BigInteger ExtendedGcd(BigInteger a, BigInteger b, out BigInteger x, out BigInteger y)
    {
        if (b == 0)
        {
            x = 1;
            y = 0;
            return a;
        }
        BigInteger x1, y1;
        BigInteger gcd = ExtendedGcd(b, a % b, out x1, out y1);
        x = y1;
        y = x1 - (a / b) * y1;
        return gcd;
    }

    static void Main()
    {
        RSA rsa = new RSA(1024);
        BigInteger message = new BigInteger(42);
        
        BigInteger encrypted = rsa.Encrypt(message);
        BigInteger decrypted = rsa.Decrypt(encrypted);
        
        Console.WriteLine("Original: {message}");
        Console.WriteLine("Encrypted: {encrypted}");
        Console.WriteLine("Decrypted: {decrypted}");
    }
}''',
};
final Map<String, String> codeExamplesElGamal = {
  'Python': '''import random
from sympy import isprime, primitive_root

def generate_keys(p=None, g=None):
    if not p or not isprime(p):
        p = 997  # Простое число (можно генерировать динамически)
    if not g:
        g = primitive_root(p)
    x = random.randint(2, p-2)  # Секретный ключ
    y = pow(g, x, p)            # Публичный ключ
    return (p, g, y), x

def encrypt(m, p, g, y):
    k = random.randint(2, p-2)
    a = pow(g, k, p)
    b = (m * pow(y, k, p)) % p
    return (a, b)

def decrypt(a, b, p, x):
    s = pow(a, x, p)
    m = (b * pow(s, p-2, p)) % p  # s^(p-2) ≡ s^(-1) mod p
    return m

# Пример использования:
public, private = generate_keys()
m = 123
a, b = encrypt(m, *public)
decrypted = decrypt(a, b, public[0], private)
print(f"Original: {m}, Decrypted: {decrypted}")''',
  'Java': '''import java.math.BigInteger;
import java.security.SecureRandom;

public class ElGamal {
    private static BigInteger p = new BigInteger("997"); // Простое число
    private static BigInteger g = new BigInteger("5");   // Генератор

    public static BigInteger[] generateKeys() {
        SecureRandom random = new SecureRandom();
        BigInteger x = new BigInteger(p.bitLength() - 2, random); // Секретный ключ
        BigInteger y = g.modPow(x, p);                           // Публичный ключ
        return new BigInteger[]{p, g, y, x};
    }

    public static BigInteger[] encrypt(BigInteger m, BigInteger p, BigInteger g, BigInteger y) {
        SecureRandom random = new SecureRandom();
        BigInteger k = new BigInteger(p.bitLength() - 2, random);
        BigInteger a = g.modPow(k, p);
        BigInteger b = m.multiply(y.modPow(k, p)).mod(p);
        return new BigInteger[]{a, b};
    }

    public static BigInteger decrypt(BigInteger a, BigInteger b, BigInteger p, BigInteger x) {
        BigInteger s = a.modPow(x, p);
        BigInteger m = b.multiply(s.modInverse(p)).mod(p);
        return m;
    }

    public static void main(String[] args) {
        BigInteger[] keys = generateKeys();
        BigInteger m = new BigInteger("123");
        BigInteger[] cipher = encrypt(m, keys[0], keys[1], keys[2]);
        BigInteger decrypted = decrypt(cipher[0], cipher[1], keys[0], keys[3]);
        System.out.println("Original: " + m + ", Decrypted: " + decrypted);
    }
}''',
'C#': '''using System;
using System.Numerics;

class ElGamal {
    static Random random = new Random();

    static (BigInteger p, BigInteger g, BigInteger y, BigInteger x) GenerateKeys() {
        BigInteger p = 997; // Простое число
        BigInteger g = 5;   // Генератор
        BigInteger x = new BigInteger(random.Next(2, (int)p - 1)); // Секретный ключ
        BigInteger y = BigInteger.ModPow(g, x, p);                // Публичный ключ
        return (p, g, y, x);
    }

    static (BigInteger a, BigInteger b) Encrypt(BigInteger m, BigInteger p, BigInteger g, BigInteger y) {
        BigInteger k = new BigInteger(random.Next(2, (int)p - 1));
        BigInteger a = BigInteger.ModPow(g, k, p);
        BigInteger b = (m * BigInteger.ModPow(y, k, p)) % p;
        return (a, b);
    }

    static BigInteger Decrypt(BigInteger a, BigInteger b, BigInteger p, BigInteger x) {
        BigInteger s = BigInteger.ModPow(a, x, p);
        BigInteger m = (b * BigInteger.ModPow(s, p - 2, p)) % p;
        return m;
    }

    static void Main() {
        var (p, g, y, x) = GenerateKeys();
        BigInteger m = 123;
        var (a, b) = Encrypt(m, p, g, y);
        BigInteger decrypted = Decrypt(a, b, p, x);
        Console.WriteLine("Original: {m}, Decrypted: {decrypted}");
    }
}''',
};
final Map<String, String> codeExamplesDiffieHellman = {
  'Python': '''import random

def mod_exp(base, exponent, modulus):
    if modulus == 1:
        return 0
    result = 1
    base = base % modulus
    while exponent > 0:
        if exponent % 2 == 1:
            result = (result * base) % modulus
        exponent = exponent >> 1
        base = (base * base) % modulus
    return result

# Общие параметры
p = 23
g = 5

# Секретные ключи
secret1 = random.randint(1, p-1)
secret2 = random.randint(1, p-1)

# Открытые ключи
public1 = mod_exp(g, secret1, p)
public2 = mod_exp(g, secret2, p)

# Общий секрет
shared1 = mod_exp(public2, secret1, p)
shared2 = mod_exp(public1, secret2, p)

print(f"Сторона 1: секрет = {secret1}, открытый ключ = {public1}")
print(f"Сторона 2: секрет = {secret2}, открытый ключ = {public2}")
print(f"Общий секрет у стороны 1: {shared1}")
print(f"Общий секрет у стороны 2: {shared2}")
print(f"Совпадают ли ключи? {shared1 == shared2}")''',
  'Java': '''import java.math.BigInteger;
import java.security.SecureRandom;

public class DiffieHellman {
    public static void main(String[] args) {
        // Общие параметры
        BigInteger p = BigInteger.valueOf(23);
        BigInteger g = BigInteger.valueOf(5);

        // Секретные ключи
        SecureRandom random = new SecureRandom();
        BigInteger secret1 = new BigInteger(p.bitLength() - 1, random);
        BigInteger secret2 = new BigInteger(p.bitLength() - 1, random);

        // Открытые ключи
        BigInteger public1 = g.modPow(secret1, p);
        BigInteger public2 = g.modPow(secret2, p);

        // Общий секрет
        BigInteger shared1 = public2.modPow(secret1, p);
        BigInteger shared2 = public1.modPow(secret2, p);

        System.out.println("Сторона 1: секрет = " + secret1 + ", открытый ключ = " + public1);
        System.out.println("Сторона 2: секрет = " + secret2 + ", открытый ключ = " + public2);
        System.out.println("Общий секрет у стороны 1: " + shared1);
        System.out.println("Общий секрет у стороны 2: " + shared2);
        System.out.println("Совпадают ли ключи? " + shared1.equals(shared2));
    }
}''',
  'C#': '''using System;
using System.Numerics;

class DiffieHellman
{
    static BigInteger ModExp(BigInteger baseNum, BigInteger exponent, BigInteger modulus)
    {
        return BigInteger.ModPow(baseNum, exponent, modulus);
    }

    static void Main()
    {
        // Общие параметры
        BigInteger p = 23;
        BigInteger g = 5;

        // Секретные ключи
        Random random = new Random();
        BigInteger secret1 = new BigInteger(random.Next(1, (int)p - 1));
        BigInteger secret2 = new BigInteger(random.Next(1, (int)p - 1));

        // Открытые ключи
        BigInteger public1 = ModExp(g, secret1, p);
        BigInteger public2 = ModExp(g, secret2, p);

        // Общий секрет
        BigInteger shared1 = ModExp(public2, secret1, p);
        BigInteger shared2 = ModExp(public1, secret2, p);

        Console.WriteLine("Сторона 1: секрет = {secret1}, открытый ключ = {public1}");
        Console.WriteLine("Сторона 2: секрет = {secret2}, открытый ключ = {public2}");
        Console.WriteLine("Общий секрет у стороны 1: {shared1}");
        Console.WriteLine("Общий секрет у стороны 2: {shared2}");
        Console.WriteLine("Совпадают ли ключи? {shared1 == shared2}");
    }
}''',
};
final Map<String, String> codeExamplesCeaser = {
  'Python': '''
def caesar_cipher(text, shift):
    result = ""
    for char in text:
        if char.isalpha():
            shift_amount = shift % 26
            if char.islower():
                result += chr(((ord(char) - ord('a') + shift_amount) % 26) + ord('a'))
            else:
                result += chr(((ord(char) - ord('A') + shift_amount) % 26) + ord('A'))
        else:
            result += char
    return result

text = "Hello, World!"
shift = 3
encrypted = caesar_cipher(text, shift)
print("Зашифрованный текст:", encrypted)
decrypted = caesar_cipher(encrypted, -shift)
print("Расшифрованный текст:", decrypted)
''',
  'Java': '''
public class CaesarCipher {
    public static String caesarCipher(String text, int shift) {
        StringBuilder result = new StringBuilder();
        for (char character : text.toCharArray()) {
            if (Character.isLetter(character)) {
                int shiftAmount = shift % 26;
                char base = Character.isLowerCase(character) ? 'a' : 'A';
                result.append((char) ((character - base + shiftAmount + 26) % 26 + base));
            } else {
                result.append(character);
            }
        }
        return result.toString();
    }

    public static void main(String[] args) {
        String text = "Hello, World!";
        int shift = 3;
        String encrypted = caesarCipher(text, shift);
        System.out.println("Зашифрованный текст: " + encrypted);
        String decrypted = caesarCipher(encrypted, -shift);
        System.out.println("Расшифрованный текст: " + decrypted);
    }
}
''',
  'C#': '''
using System;

class CaesarCipher
{
    public static string Caesar(string text, int shift)
    {
        string result = "";
        foreach (char character in text)
        {
            if (char.IsLetter(character))
            {
                int shiftAmount = shift % 26;
                char baseChar = char.IsLower(character) ? 'a' : 'A';
                result += (char)((character - baseChar + shiftAmount + 26) % 26 + baseChar);
            }
            else
            {
                result += character;
            }
        }
        return result;
    }

    static void Main()
    {
        string text = "Hello, World!";
        int shift = 3;
        string encrypted = Caesar(text, shift);
        Console.WriteLine("Зашифрованный текст: " + encrypted);
        string decrypted = Caesar(encrypted, -shift);
        Console.WriteLine("Расшифрованный текст: " + decrypted);
    }
}
''',
};
final Map<String, String> codeExamplesKeyword = {
  'Python': '''def create_key_alphabet(key):
    key = key.upper()
    # Удаляем повторяющиеся символы в ключе
    unique_chars = []
    for char in key:
        if char not in unique_chars and char.isalpha():
            unique_chars.append(char)
    # Добавляем оставшиеся символы алфавита
    for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        if char not in unique_chars:
            unique_chars.append(char)
    return "".join(unique_chars)

def key_cipher_encrypt(text, key_alphabet):
    result = ""
    for char in text.upper():
        if char.isalpha():
            # Находим индекс символа в оригинальном алфавите и заменяем его
            index = ord(char) - ord('A')
            result += key_alphabet[index]
        else:
            result += char
    return result

def key_cipher_decrypt(text, key_alphabet):
    result = ""
    for char in text.upper():
        if char.isalpha():
            # Находим индекс символа в ключевом алфавите и заменяем его
            index = key_alphabet.index(char)
            result += chr(index + ord('A'))
        else:
            result += char
    return result

# Пример использования
key = "KEY"
key_alphabet = create_key_alphabet(key)
text = "HELLO WORLD"
encrypted = key_cipher_encrypt(text, key_alphabet)
print("Зашифрованный текст:", encrypted)
decrypted = key_cipher_decrypt(encrypted, key_alphabet)
print("Расшифрованный текст:", decrypted)
''',
  'Java': '''public class KeyCipher {
    public static String createKeyAlphabet(String key) {
        key = key.toUpperCase();
        StringBuilder uniqueChars = new StringBuilder();
        // Удаляем повторяющиеся символы в ключе
        for (char c : key.toCharArray()) {
            if (uniqueChars.indexOf(String.valueOf(c)) == -1 && Character.isLetter(c)) {
                uniqueChars.append(c);
            }
        }
        // Добавляем оставшиеся символы алфавита
        for (char c = 'A'; c <= 'Z'; c++) {
            if (uniqueChars.indexOf(String.valueOf(c)) == -1) {
                uniqueChars.append(c);
            }
        }
        return uniqueChars.toString();
    }

    public static String keyCipherEncrypt(String text, String keyAlphabet) {
        StringBuilder result = new StringBuilder();
        for (char c : text.toUpperCase().toCharArray()) {
            if (Character.isLetter(c)) {
                int index = c - 'A';
                result.append(keyAlphabet.charAt(index));
            } else {
                result.append(c);
            }
        }
        return result.toString();
    }

    public static String keyCipherDecrypt(String text, String keyAlphabet) {
        StringBuilder result = new StringBuilder();
        for (char c : text.toUpperCase().toCharArray()) {
            if (Character.isLetter(c)) {
                int index = keyAlphabet.indexOf(c);
                result.append((char) (index + 'A'));
            } else {
                result.append(c);
            }
        }
        return result.toString();
    }

    public static void main(String[] args) {
        String key = "KEY";
        String keyAlphabet = createKeyAlphabet(key);
        String text = "HELLO WORLD";
        String encrypted = keyCipherEncrypt(text, keyAlphabet);
        System.out.println("Зашифрованный текст: " + encrypted);
        String decrypted = keyCipherDecrypt(encrypted, keyAlphabet);
        System.out.println("Расшифрованный текст: " + decrypted);
    }
}
''',
  'C#': '''
using System;
using System.Text;

class KeyCipher
{
    public static string CreateKeyAlphabet(string key)
    {
        key = key.ToUpper();
        StringBuilder uniqueChars = new StringBuilder();
        // Удаляем повторяющиеся символы в ключе
        foreach (char c in key)
        {
            if (uniqueChars.ToString().IndexOf(c) == -1 && char.IsLetter(c))
            {
                uniqueChars.Append(c);
            }
        }
        // Добавляем оставшиеся символы алфавита
        for (char c = 'A'; c <= 'Z'; c++)
        {
            if (uniqueChars.ToString().IndexOf(c) == -1)
            {
                uniqueChars.Append(c);
            }
        }
        return uniqueChars.ToString();
    }

    public static string KeyCipherEncrypt(string text, string keyAlphabet)
    {
        StringBuilder result = new StringBuilder();
        foreach (char c in text.ToUpper())
        {
            if (char.IsLetter(c))
            {
                int index = c - 'A';
                result.Append(keyAlphabet[index]);
            }
            else
            {
                result.Append(c);
            }
        }
        return result.ToString();
    }

    public static string KeyCipherDecrypt(string text, string keyAlphabet)
    {
        StringBuilder result = new StringBuilder();
        foreach (char c in text.ToUpper())
        {
            if (char.IsLetter(c))
            {
                int index = keyAlphabet.IndexOf(c);
                result.Append((char)(index + 'A'));
            }
            else
            {
                result.Append(c);
            }
        }
        return result.ToString();
    }

    static void Main()
    {
        string key = "KEY";
        string keyAlphabet = CreateKeyAlphabet(key);
        string text = "HELLO WORLD";
        string encrypted = KeyCipherEncrypt(text, keyAlphabet);
        Console.WriteLine("Зашифрованный текст: " + encrypted);
        string decrypted = KeyCipherDecrypt(encrypted, keyAlphabet);
        Console.WriteLine("Расшифрованный текст: " + decrypted);
    }
}
''',
};
final Map<String, String> codeExamplesRailFence = {
  'Python': '''import numpy as np

def create_grid(size):
    # Создаем решетку с отверстиями
    grid = np.zeros((size, size), dtype=int)
    # Пример: отверстия в углах и центре
    grid[0, 0] = 1
    grid[0, -1] = 1
    grid[-1, 0] = 1
    grid[-1, -1] = 1
    grid[size//2, size//2] = 1
    return grid

def encrypt(message, grid):
    size = grid.shape[0]
    encrypted = np.full((size, size), ' ', dtype=str)
    message_index = 0
    for _ in range(4):  # 4 поворота
        for i in range(size):
            for j in range(size):
                if grid[i, j] == 1 and message_index < len(message):
                    encrypted[i, j] = message[message_index]
                    message_index += 1
        grid = np.rot90(grid)  # Поворот решетки
    # Заполняем оставшиеся места случайными символами
    for i in range(size):
        for j in range(size):
            if encrypted[i, j] == ' ':
                encrypted[i, j] = chr(np.random.randint(65, 91))  # Случайная буква A-Z
    return encrypted

def decrypt(encrypted, grid):
    size = grid.shape[0]
    message = []
    for _ in range(4):  # 4 поворота
        for i in range(size):
            for j in range(size):
                if grid[i, j] == 1:
                    message.append(encrypted[i, j])
        grid = np.rot90(grid)  # Поворот решетки
    return ''.join(message)

# Пример использования
grid = create_grid(4)
message = "HELLO"
encrypted = encrypt(message, grid)
print("Зашифрованный текст:")
print(encrypted)
decrypted = decrypt(encrypted, grid)
print("Расшифрованный текст:", decrypted)
''',
  'Java': '''import java.util.Random;

public class GridCipher {
    private static int[][] createGrid(int size) {
        int[][] grid = new int[size][size];
        // Пример: отверстия в углах и центре
        grid[0][0] = 1;
        grid[0][size - 1] = 1;
        grid[size - 1][0] = 1;
        grid[size - 1][size - 1] = 1;
        grid[size / 2][size / 2] = 1;
        return grid;
    }

    private static char[][] encrypt(String message, int[][] grid) {
        int size = grid.length;
        char[][] encrypted = new char[size][size];
        Random random = new Random();
        int messageIndex = 0;
        for (int rotation = 0; rotation < 4; rotation++) {
            for (int i = 0; i < size; i++) {
                for (int j = 0; j < size; j++) {
                    if (grid[i][j] == 1 && messageIndex < message.length()) {
                        encrypted[i][j] = message.charAt(messageIndex++);
                    }
                }
            }
            grid = rotateGrid(grid);
        }
        // Заполняем оставшиеся места случайными символами
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (encrypted[i][j] == 0) {
                    encrypted[i][j] = (char) (random.nextInt(26) + 'A');
                }
            }
        }
        return encrypted;
    }

    private static String decrypt(char[][] encrypted, int[][] grid) {
        int size = grid.length;
        StringBuilder message = new StringBuilder();
        for (int rotation = 0; rotation < 4; rotation++) {
            for (int i = 0; i < size; i++) {
                for (int j = 0; j < size; j++) {
                    if (grid[i][j] == 1) {
                        message.append(encrypted[i][j]);
                    }
                }
            }
            grid = rotateGrid(grid);
        }
        return message.toString();
    }

    private static int[][] rotateGrid(int[][] grid) {
        int size = grid.length;
        int[][] rotated = new int[size][size];
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                rotated[j][size - 1 - i] = grid[i][j];
            }
        }
        return rotated;
    }

    public static void main(String[] args) {
        int[][] grid = createGrid(4);
        String message = "HELLO";
        char[][] encrypted = encrypt(message, grid);
        System.out.println("Зашифрованный текст:");
        for (char[] row : encrypted) {
            for (char c : row) {
                System.out.print(c + " ");
            }
            System.out.println();
        }
        String decrypted = decrypt(encrypted, grid);
        System.out.println("Расшифрованный текст: " + decrypted);
    }
}
''',
  'C#': '''using System;

class GridCipher
{
    private static int[,] CreateGrid(int size)
    {
        int[,] grid = new int[size, size];
        // Пример: отверстия в углах и центре
        grid[0, 0] = 1;
        grid[0, size - 1] = 1;
        grid[size - 1, 0] = 1;
        grid[size - 1, size - 1] = 1;
        grid[size / 2, size / 2] = 1;
        return grid;
    }

    private static char[,] Encrypt(string message, int[,] grid)
    {
        int size = grid.GetLength(0);
        char[,] encrypted = new char[size, size];
        Random random = new Random();
        int messageIndex = 0;
        for (int rotation = 0; rotation < 4; rotation++)
        {
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j < size; j++)
                {
                    if (grid[i, j] == 1 && messageIndex < message.Length)
                    {
                        encrypted[i, j] = message[messageIndex++];
                    }
                }
            }
            grid = RotateGrid(grid);
        }
        // Заполняем оставшиеся места случайными символами
        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                if (encrypted[i, j] == 0)
                {
                    encrypted[i, j] = (char)(random.Next(26) + 'A');
                }
            }
        }
        return encrypted;
    }

    private static string Decrypt(char[,] encrypted, int[,] grid)
    {
        int size = grid.GetLength(0);
        System.Text.StringBuilder message = new System.Text.StringBuilder();
        for (int rotation = 0; rotation < 4; rotation++)
        {
            for (int i = 0; i < size; i++)
            {
                for (int j = 0; j < size; j++)
                {
                    if (grid[i, j] == 1)
                    {
                        message.Append(encrypted[i, j]);
                    }
                }
            }
            grid = RotateGrid(grid);
        }
        return message.ToString();
    }

    private static int[,] RotateGrid(int[,] grid)
    {
        int size = grid.GetLength(0);
        int[,] rotated = new int[size, size];
        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                rotated[j, size - 1 - i] = grid[i, j];
            }
        }
        return rotated;
    }

    static void Main()
    {
        int[,] grid = CreateGrid(4);
        string message = "HELLO";
        char[,] encrypted = Encrypt(message, grid);
        Console.WriteLine("Зашифрованный текст:");
        for (int i = 0; i < encrypted.GetLength(0); i++)
        {
            for (int j = 0; j < encrypted.GetLength(1); j++)
            {
                Console.Write(encrypted[i, j] + " ");
            }
            Console.WriteLine();
        }
        string decrypted = Decrypt(encrypted, grid);
        Console.WriteLine("Расшифрованный текст: " + decrypted);
    }
}
'''
};
final Map<String, String> codeExamplesPlayfair = {
  'Python': '''def create_playfair_table(key):
    key = key.upper().replace("J", "I")
    key_set = set()
    table = []
    # Добавляем буквы ключа
    for char in key:
        if char not in key_set and char.isalpha():
            key_set.add(char)
            table.append(char)
    # Добавляем оставшиеся буквы алфавита
    for char in "ABCDEFGHIKLMNOPQRSTUVWXYZ":
        if char not in key_set:
            table.append(char)
    return [table[i:i+5] for i in range(0, 25, 5)]

def prepare_text(text):
    text = text.upper().replace("J", "I").replace(" ", "")
    prepared_text = ""
    i = 0
    while i < len(text):
        a = text[i]
        b = text[i+1] if i+1 < len(text) else 'X'
        if a == b:
            prepared_text += a + 'X'
            i += 1
        else:
            prepared_text += a + b
            i += 2
    return prepared_text

def find_position(table, char):
    for row in range(5):
        for col in range(5):
            if table[row][col] == char:
                return (row, col)
    return None

def playfair_encrypt(text, key):
    table = create_playfair_table(key)
    text = prepare_text(text)
    encrypted_text = ""
    for i in range(0, len(text), 2):
        a, b = text[i], text[i+1]
        row_a, col_a = find_position(table, a)
        row_b, col_b = find_position(table, b)
        if row_a == row_b:
            encrypted_text += table[row_a][(col_a + 1) % 5] + table[row_b][(col_b + 1) % 5]
        elif col_a == col_b:
            encrypted_text += table[(row_a + 1) % 5][col_a] + table[(row_b + 1) % 5][col_b]
        else:
            encrypted_text += table[row_a][col_b] + table[row_b][col_a]
    return encrypted_text

def playfair_decrypt(text, key):
    table = create_playfair_table(key)
    decrypted_text = ""
    for i in range(0, len(text), 2):
        a, b = text[i], text[i+1]
        row_a, col_a = find_position(table, a)
        row_b, col_b = find_position(table, b)
        if row_a == row_b:
            decrypted_text += table[row_a][(col_a - 1) % 5] + table[row_b][(col_b - 1) % 5]
        elif col_a == col_b:
            decrypted_text += table[(row_a - 1) % 5][col_a] + table[(row_b - 1) % 5][col_b]
        else:
            decrypted_text += table[row_a][col_b] + table[row_b][col_a]
    return decrypted_text

# Пример использования
key = "PLAYFAIR"
text = "HELLO WORLD"
encrypted = playfair_encrypt(text, key)
print("Зашифрованный текст:", encrypted)
decrypted = playfair_decrypt(encrypted, key)
print("Расшифрованный текст:", decrypted)
''',
  'Java': '''
import java.util.*;

public class PlayfairCipher {
    private static char[][] createPlayfairTable(String key) {
        key = key.toUpperCase().replace("J", "I");
        Set<Character> keySet = new LinkedHashSet<>();
        char[][] table = new char[5][5];
        // Добавляем буквы ключа
        for (char c : key.toCharArray()) {
            if (Character.isLetter(c) && !keySet.contains(c)) {
                keySet.add(c);
            }
        }
        // Добавляем оставшиеся буквы алфавита
        for (char c = 'A'; c <= 'Z'; c++) {
            if (c != 'J' && !keySet.contains(c)) {
                keySet.add(c);
            }
        }
        // Заполняем таблицу
        Iterator<Character> it = keySet.iterator();
        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < 5; j++) {
                table[i][j] = it.next();
            }
        }
        return table;
    }

    private static String prepareText(String text) {
        text = text.toUpperCase().replace("J", "I").replace(" ", "");
        StringBuilder preparedText = new StringBuilder();
        int i = 0;
        while (i < text.length()) {
            char a = text.charAt(i);
            char b = (i + 1 < text.length()) ? text.charAt(i + 1) : 'X';
            if (a == b) {
                preparedText.append(a).append('X');
                i++;
            } else {
                preparedText.append(a).append(b);
                i += 2;
            }
        }
        return preparedText.toString();
    }

    private static int[] findPosition(char[][] table, char c) {
        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < 5; j++) {
                if (table[i][j] == c) {
                    return new int[]{i, j};
                }
            }
        }
        return null;
    }

    public static String playfairEncrypt(String text, String key) {
        char[][] table = createPlayfairTable(key);
        text = prepareText(text);
        StringBuilder encryptedText = new StringBuilder();
        for (int i = 0; i < text.length(); i += 2) {
            char a = text.charAt(i);
            char b = text.charAt(i + 1);
            int[] posA = findPosition(table, a);
            int[] posB = findPosition(table, b);
            if (posA[0] == posB[0]) {
                encryptedText.append(table[posA[0]][(posA[1] + 1) % 5]).append(table[posB[0]][(posB[1] + 1) % 5]);
            } else if (posA[1] == posB[1]) {
                encryptedText.append(table[(posA[0] + 1) % 5][posA[1]]).append(table[(posB[0] + 1) % 5][posB[1]]);
            } else {
                encryptedText.append(table[posA[0]][posB[1]]).append(table[posB[0]][posA[1]]);
            }
        }
        return encryptedText.toString();
    }

    public static String playfairDecrypt(String text, String key) {
        char[][] table = createPlayfairTable(key);
        StringBuilder decryptedText = new StringBuilder();
        for (int i = 0; i < text.length(); i += 2) {
            char a = text.charAt(i);
            char b = text.charAt(i + 1);
            int[] posA = findPosition(table, a);
            int[] posB = findPosition(table, b);
            if (posA[0] == posB[0]) {
                decryptedText.append(table[posA[0]][(posA[1] - 1 + 5) % 5]).append(table[posB[0]][(posB[1] - 1 + 5) % 5]);
            } else if (posA[1] == posB[1]) {
                decryptedText.append(table[(posA[0] - 1 + 5) % 5][posA[1]]).append(table[(posB[0] - 1 + 5) % 5][posB[1]]);
            } else {
                decryptedText.append(table[posA[0]][posB[1]]).append(table[posB[0]][posA[1]]);
            }
        }
        return decryptedText.toString();
    }

    public static void main(String[] args) {
        String key = "PLAYFAIR";
        String text = "HELLO WORLD";
        String encrypted = playfairEncrypt(text, key);
        System.out.println("Зашифрованный текст: " + encrypted);
        String decrypted = playfairDecrypt(encrypted, key);
        System.out.println("Расшифрованный текст: " + decrypted);
    }
}
''',
  'C#': '''
using System;
using System.Collections.Generic;
using System.Text;

class PlayfairCipher
{
    private static char[,] CreatePlayfairTable(string key)
    {
        key = key.ToUpper().Replace("J", "I");
        HashSet<char> keySet = new HashSet<char>();
        char[,] table = new char[5, 5];
        // Добавляем буквы ключа
        foreach (char c in key)
        {
            if (char.IsLetter(c) && !keySet.Contains(c))
            {
                keySet.Add(c);
            }
        }
        // Добавляем оставшиеся буквы алфавита
        for (char c = 'A'; c <= 'Z'; c++)
        {
            if (c != 'J' && !keySet.Contains(c))
            {
                keySet.Add(c);
            }
        }
        // Заполняем таблицу
        int index = 0;
        foreach (char c in keySet)
        {
            table[index / 5, index % 5] = c;
            index++;
        }
        return table;
    }

    private static string PrepareText(string text)
    {
        text = text.ToUpper().Replace("J", "I").Replace(" ", "");
        StringBuilder preparedText = new StringBuilder();
        int i = 0;
        while (i < text.Length)
        {
            char a = text[i];
            char b = (i + 1 < text.Length) ? text[i + 1] : 'X';
            if (a == b)
            {
                preparedText.Append(a).Append('X');
                i++;
            }
            else
            {
                preparedText.Append(a).Append(b);
                i += 2;
            }
        }
        return preparedText.ToString();
    }

    private static int[] FindPosition(char[,] table, char c)
    {
        for (int i = 0; i < 5; i++)
        {
            for (int j = 0; j < 5; j++)
            {
                if (table[i, j] == c)
                {
                    return new int[] { i, j };
                }
            }
        }
        return null;
    }

    public static string PlayfairEncrypt(string text, string key)
    {
        char[,] table = CreatePlayfairTable(key);
        text = PrepareText(text);
        StringBuilder encryptedText = new StringBuilder();
        for (int i = 0; i < text.Length; i += 2)
        {
            char a = text[i];
            char b = text[i + 1];
            int[] posA = FindPosition(table, a);
            int[] posB = FindPosition(table, b);
            if (posA[0] == posB[0])
            {
                encryptedText.Append(table[posA[0], (posA[1] + 1) % 5]).Append(table[posB[0], (posB[1] + 1) % 5]);
            }
            else if (posA[1] == posB[1])
            {
                encryptedText.Append(table[(posA[0] + 1) % 5, posA[1]]).Append(table[(posB[0] + 1) % 5, posB[1]]);
            }
            else
            {
                encryptedText.Append(table[posA[0], posB[1]]).Append(table[posB[0], posA[1]]);
            }
        }
        return encryptedText.ToString();
    }

    public static string PlayfairDecrypt(string text, string key)
    {
        char[,] table = CreatePlayfairTable(key);
        StringBuilder decryptedText = new StringBuilder();
        for (int i = 0; i < text.Length; i += 2)
        {
            char a = text[i];
            char b = text[i + 1];
            int[] posA = FindPosition(table, a);
            int[] posB = FindPosition(table, b);
            if (posA[0] == posB[0])
            {
                decryptedText.Append(table[posA[0], (posA[1] - 1 + 5) % 5]).Append(table[posB[0], (posB[1] - 1 + 5) % 5]);
            }
            else if (posA[1] == posB[1])
            {
                decryptedText.Append(table[(posA[0] - 1 + 5) % 5, posA[1]]).Append(table[(posB[0] - 1 + 5) % 5, posB[1]]);
            }
            else
            {
                decryptedText.Append(table[posA[0], posB[1]]).Append(table[posB[0], posA[1]]);
            }
        }
        return decryptedText.ToString();
    }
    

    static void Main()
    {
        string key = "PLAYFAIR";
        string text = "HELLO WORLD";
        string encrypted = PlayfairEncrypt(text, key);
        Console.WriteLine("Зашифрованный текст: " + encrypted);
        string decrypted = PlayfairDecrypt(encrypted, key);
        Console.WriteLine("Расшифрованный текст: " + decrypted);
    }
}

''',
};
final Map<String, String> codeExamplesVigenere = {
  'Python': '''
def vigenere_encrypt(plaintext, key):
    encrypted_text = ""
    key = key.upper()
    key_length = len(key)
    for i, char in enumerate(plaintext):
        if char.isalpha():
            shift = ord(key[i % key_length]) - ord('A')
            if char.islower():
                encrypted_text += chr((ord(char) - ord('a') + shift) % 26 + ord('a'))
            else:
                encrypted_text += chr((ord(char) - ord('A') + shift) % 26 + ord('A'))
        else:
            encrypted_text += char
    return encrypted_text

def vigenere_decrypt(ciphertext, key):
    decrypted_text = ""
    key = key.upper()
    key_length = len(key)
    for i, char in enumerate(ciphertext):
        if char.isalpha():
            shift = ord(key[i % key_length]) - ord('A')
            if char.islower():
                decrypted_text += chr((ord(char) - ord('a') - shift + 26) % 26 + ord('a'))
            else:
                decrypted_text += chr((ord(char) - ord('A') - shift + 26) % 26 + ord('A'))
        else:
            decrypted_text += char
    return decrypted_text

# Пример использования
plaintext = "HELLO WORLD"
key = "KEY"
encrypted = vigenere_encrypt(plaintext, key)
print("Зашифрованный текст:", encrypted)
decrypted = vigenere_decrypt(encrypted, key)
print("Расшифрованный текст:", decrypted)
''',
  'Java': '''public class VigenereCipher {
    public static String vigenereEncrypt(String plaintext, String key) {
        StringBuilder encryptedText = new StringBuilder();
        key = key.toUpperCase();
        int keyLength = key.length();
        for (int i = 0; i < plaintext.length(); i++) {
            char currentChar = plaintext.charAt(i);
            if (Character.isLetter(currentChar)) {
                char keyChar = key.charAt(i % keyLength);
                int shift = keyChar - 'A';
                if (Character.isLowerCase(currentChar)) {
                    encryptedText.append((char) ((currentChar - 'a' + shift) % 26 + 'a'));
                } else {
                    encryptedText.append((char) ((currentChar - 'A' + shift) % 26 + 'A'));
                }
            } else {
                encryptedText.append(currentChar);
            }
        }
        return encryptedText.toString();
    }

    public static String vigenereDecrypt(String ciphertext, String key) {
        StringBuilder decryptedText = new StringBuilder();
        key = key.toUpperCase();
        int keyLength = key.length();
        for (int i = 0; i < ciphertext.length(); i++) {
            char currentChar = ciphertext.charAt(i);
            if (Character.isLetter(currentChar)) {
                char keyChar = key.charAt(i % keyLength);
                int shift = keyChar - 'A';
                if (Character.isLowerCase(currentChar)) {
                    decryptedText.append((char) ((currentChar - 'a' - shift + 26) % 26 + 'a'));
                } else {
                    decryptedText.append((char) ((currentChar - 'A' - shift + 26) % 26 + 'A'));
                }
            } else {
                decryptedText.append(currentChar);
            }
        }
        return decryptedText.toString();
    }

    public static void main(String[] args) {
        String plaintext = "HELLO WORLD";
        String key = "KEY";
        String encrypted = vigenereEncrypt(plaintext, key);
        System.out.println("Зашифрованный текст: " + encrypted);
        String decrypted = vigenereDecrypt(encrypted, key);
        System.out.println("Расшифрованный текст: " + decrypted);
    }
}
''',
  'C#': '''
using System;
using System.Text;

class VigenereCipher
{
    public static string VigenereEncrypt(string plaintext, string key)
    {
        StringBuilder encryptedText = new StringBuilder();
        key = key.ToUpper();
        int keyLength = key.Length;
        for (int i = 0; i < plaintext.Length; i++)
        {
            char currentChar = plaintext[i];
            if (char.IsLetter(currentChar))
            {
                char keyChar = key[i % keyLength];
                int shift = keyChar - 'A';
                if (char.IsLower(currentChar))
                {
                    encryptedText.Append((char)((currentChar - 'a' + shift) % 26 + 'a'));
                }
                else
                {
                    encryptedText.Append((char)((currentChar - 'A' + shift) % 26 + 'A'));
                }
            }
            else
            {
                encryptedText.Append(currentChar);
            }
        }
        return encryptedText.ToString();
    }

    public static string VigenereDecrypt(string ciphertext, string key)
    {
        StringBuilder decryptedText = new StringBuilder();
        key = key.ToUpper();
        int keyLength = key.Length;
        for (int i = 0; i < ciphertext.Length; i++)
        {
            char currentChar = ciphertext[i];
            if (char.IsLetter(currentChar))
            {
                char keyChar = key[i % keyLength];
                int shift = keyChar - 'A';
                if (char.IsLower(currentChar))
                {
                    decryptedText.Append((char)((currentChar - 'a' - shift + 26) % 26 + 'a'));
                }
                else
                {
                    decryptedText.Append((char)((currentChar - 'A' - shift + 26) % 26 + 'A'));
                }
            }
            else
            {
                decryptedText.Append(currentChar);
            }
        }
        return decryptedText.ToString();
    }

    static void Main()
    {
        string plaintext = "HELLO WORLD";
        string key = "KEY";
        string encrypted = VigenereEncrypt(plaintext, key);
        Console.WriteLine("Зашифрованный текст: " + encrypted);
        string decrypted = VigenereDecrypt(encrypted, key);
        Console.WriteLine("Расшифрованный текст: " + decrypted);
    }
}
''',
};
