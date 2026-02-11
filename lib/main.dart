import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MaterialApp(
      home: GamePage(),
      debugShowCheckedModeBanner: false,
    ));

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

  final List<List<String>> keyboardRows = [
    ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
    ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
    ["Z", "X", "C", "V", "B", "N", "M"],
  ];

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    final data = words[Random().nextInt(words.length)];
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

    if (!hiddenWord.contains("*")) goToResult("🎉 OU GENYEN !");
    if (chances == 0) goToResult("❌ OU PÈDI !");
  }

  Future<void> goToResult(String result) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(result)),
    );
    setState(() => startNewGame());
  }

  void quitGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GoodbyePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
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
          const SizedBox(height: 10),
          const Text(
            "💡 Chak erè se yon opòtinite pou aprann. Kenbe fèm! 🚀",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          // Keyboard
          Column(
            children: keyboardRows.map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((letter) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(40, 50),
                        ),
                        onPressed: () => checkLetter(letter),
                        child:
                            Text(letter, style: const TextStyle(fontSize: 16)),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: quitGame,
              child: const Text("Kite", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

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
            Text(message,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("🔁 Rejwe"),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const GoodbyePage()),
                    );
                  },
                  child: const Text("Kite", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GoodbyePage extends StatelessWidget {
  const GoodbyePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // or Colors.white if you prefer
      body: const Center(
        child: Text(
          "Thank you for playing!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white, // black background
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
