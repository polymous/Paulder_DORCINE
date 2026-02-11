import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GamePage(),
    );
  }
}

// ================= GAME PAGE =================
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<Map<String, String>> words = [
    {"word": "BONJOU", "hint": "👋 Mo pou salye moun"},
    {"word": "TEKNOLOJI", "hint": "💻 Sa ki gen rapò ak òdinatè"},
    {"word": "FLUTTER", "hint": "📱 Framework mobil"},
    {"word": "ETIDYAN", "hint": "🎓 Moun k ap aprann"},
  ];

  late String secretWord;
  late String hint;
  late List<String> hiddenWord;
  int chances = 5;

  final List<String> keyboard = [
    "Q","W","E","R","T","Y","U","I","O","P",
    "A","S","D","F","G","H","J","K","L",
    "Z","X","C","V","B","N","M"
  ];

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    final random = Random();
    final data = words[random.nextInt(words.length)];

    secretWord = data["word"]!;
    hint = data["hint"]!;
    hiddenWord = List.filled(secretWord.length, "*");
    chances = 5;
  }

  void checkLetter(String letter) {
    bool found = false;

    for (int i = 0; i < secretWord.length; i++) {
      if (secretWord[i] == letter) {
        hiddenWord[i] = letter;
        found = true;
      }
    }

    if (!found) chances--;

    setState(() {});

    if (!hiddenWord.contains("*")) {
      goToResult("🎉 OU GENYEN !");
    }

    if (chances == 0) {
      goToResult("❌ OU PÈDI !");
    }
  }

  Future<void> goToResult(String result) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(result)),
    );

    setState(() {
      startNewGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("❤️ Chans ki rete : $chances"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),

          Text(
            hiddenWord.join(" "),
            style: const TextStyle(
              fontSize: 30,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              hint,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              padding: const EdgeInsets.all(10),
              children: keyboard.map((letter) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => checkLetter(letter),
                    child: Text(
                      letter,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= RESULT PAGE =================
class ResultPage extends StatelessWidget {
  final String message;
  const ResultPage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("🔁 Rejwe"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
