import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_appedu/editorjuegos/word_provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color fondoOscuro = Color(0xFF0F2A37);

class AlumnoHomeScreen extends StatelessWidget {
  final String juego;
  final String uid;
  const AlumnoHomeScreen({super.key, required this.juego, required this.uid});

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (juego.toLowerCase()) {
      case 'colores':
        screen = ColorGame();
        break;
      case 'números':
      case 'numeros': // para aceptar sin tilde también
        screen = NumberGame(uid: uid);
        break;
      case 'letras':
        screen = LetterGame(uid: uid);
        break;
      case 'figuras':
        screen = ShapeGame(uid: uid);
        break;
      case 'sopa de letras':
        screen = WordSearchGame();
        break;
      case 'kahoot':
        screen =
            const KahootGame(); // aunque normalmente este se lanza desde otra lógica
        break;
      default:
        screen = Scaffold(
          body: Center(child: Text('Juego "$juego" no encontrado')),
        );
    }

    return screen;
  }
}

class AlumnoMenuScreen extends StatelessWidget {
  final String uid;

  const AlumnoMenuScreen({super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aprendamos Jugando')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          children: [
           GameCard(
  text: 'Colores',
  icon: Icons.grid_view,
  screen: ColorGame(),
  color: Colors.red.shade400,
),
GameCard(
  text: 'Números',
  icon: Icons.looks_one,
  screen: NumberGame(uid: uid),
  color: Colors.blue.shade400,
),
GameCard(
  text: 'Letras',
  icon: Icons.text_fields,
  screen: LetterGame(uid: uid),
  color: Colors.deepPurple.shade400,
),
GameCard(
  text: 'Figuras',
  icon: Icons.check_circle_outline,
  screen: ShapeGame(uid: uid),
  color: Colors.green.shade400,
),
GameCard(
  text: 'Sopa de Letras',
  icon: Icons.abc,
  screen: WordSearchGame(),
  color: Colors.pink.shade400,
),
GameCard(
  text: 'Kahoot',
  icon: Icons.question_mark,
  screen: KahootGame(),
  color: Colors.orange.shade400,
),

          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String text;
  final Widget screen;
  final Color color;
  final IconData icon;

  const GameCard({
    required this.text,
    required this.screen,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
  width: double.infinity,
  height: double.infinity,
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 6,
        offset: Offset(2, 4),
      ),
    ],
  ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                '100 %',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// -------------------- JUEGO DE COLORES --------------------

class ColorGame extends StatefulWidget {
  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  final Map<String, Color> colorMap = {
    'Rojo': Colors.red,
    'Verde': Colors.green,
    'Azul': Colors.blue,
    'Amarillo': Colors.yellow,
    'Naranja': Colors.orange,
    'Morado': Colors.purple,
    'Rosado': Colors.pink,
    'Marrón': Colors.brown,
    'Gris': Colors.grey,
    'Celeste': Colors.cyan,
  };

  late String correctColorName;
  late Color correctColor;

  @override
  void initState() {
    super.initState();
    _setNewColor();
  }

  void _setNewColor() {
    final random = Random();
    final keys = colorMap.keys.toList();
    correctColorName = keys[random.nextInt(keys.length)];
    correctColor = colorMap[correctColorName]!;
  }

  void _checkAnswer(String selectedColorName) {
    final isCorrect = selectedColorName == correctColorName;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: fondoOscuro,
        title: Text(
          isCorrect ? '¡Correcto!' : 'Incorrecto',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          isCorrect
              ? '¡Bien hecho! Es $correctColorName 🎉'
              : 'La respuesta correcta era $correctColorName.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _setNewColor();
              });
            },
            child: Text(
              'Siguiente',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> options = colorMap.keys.map((name) {
      return GestureDetector(
        onTap: () => _checkAnswer(name),
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorMap[name],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2),
          ),
          height: 80,
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        title: Text('🎨 Adivina el Color'),
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '¿Qué color es este?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: correctColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 4, color: Colors.black),
              ),
              margin: EdgeInsets.only(bottom: 20),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                children: options,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- JUEGO DE NÚMEROS --------------------

class NumberGame extends StatefulWidget {
  final String uid; // <- Recibe el ID del usuario

  NumberGame({required this.uid});

  @override
  _NumberGameState createState() => _NumberGameState();
}

class _NumberGameState extends State<NumberGame> {
  int correctAnswer = 0;
  List<int> options = [];
  int counter = 0;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  void generateQuestion() {
    final rand = Random();
    correctAnswer = rand.nextInt(10) + 1;
    final unique = <int>{correctAnswer};
    while (unique.length < 3) {
      unique.add(rand.nextInt(10) + 1);
    }
    options = unique.toList()..shuffle();
  }

  Future<void> actualizarPuntos(int puntosGanados) async {
    final docRef = db.collection('usuarios').doc(widget.uid);

    await docRef
        .update({'puntos': FieldValue.increment(puntosGanados)})
        .catchError((error) async {
          // Si el documento no existe, lo crea
          await docRef.set({'puntos': puntosGanados});
        });
  }

  void checkAnswer(int answer) {
    final correct = answer == correctAnswer;
    if (correct) {
      setState(() {
        counter++;
      });
      actualizarPuntos(1); // guarda 1 punto por acierto
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          correct ? '¡Correcto! 🎉' : 'Inténtalo otra vez 😅',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(generateQuestion);
            },
            child: Text(
              'Siguiente',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 141, 243),
      appBar: AppBar(
        title: Text('🔢 Encuentra el número'),
        backgroundColor: const Color.fromARGB(255, 247, 245, 245),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Dónde está el número $correctAnswer?',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ...options.map(
                (num) => Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(num),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: const Color.fromARGB(255, 255, 253, 253),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text('$num'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Puntos: $counter',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// -------------------- JUEGO DE LETRAS --------------------

class LetterGame extends StatefulWidget {
  final String uid;

  const LetterGame({required this.uid, super.key});

  @override
  _LetterGameState createState() => _LetterGameState();
}

class _LetterGameState extends State<LetterGame> {
  final List<String> letters = ['A', 'B', 'C', 'D', 'E'];
  late String currentLetter;
  late List<String> options;
  int counter = 0;

  void generateLetter() {
    final rand = Random();
    currentLetter = letters[rand.nextInt(letters.length)];
    options = Set<String>.from([
      currentLetter,
      ...List.generate(2, (_) => letters[rand.nextInt(letters.length)]),
    ]).toList();
    options.shuffle();
  }

  /// ✅ Función que actualiza los puntos en Firebase
  Future<void> actualizarPuntos(int cantidad) async {
    final docRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final puntosActuales = snapshot.data()?['puntos'] ?? 0;
      transaction.update(docRef, {'puntos': puntosActuales + cantidad});
    });
  }

  void checkLetter(String selected) {
    final correct = selected == currentLetter;
    if (correct) {
      counter++;
      actualizarPuntos(1); // ✅ actualiza en la base de datos
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: fondoOscuro,
        title: Text(
          correct ? '¡Bien hecho! 😄' : '¡Esa no es!',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(generateLetter);
            },
            child: const Text(
              'Continuar',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    generateLetter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        title: const Text('🔤 Adivina la Letra'),
        backgroundColor: const Color.fromARGB(255, 240, 242, 243),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Dónde está la letra "$currentLetter"?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...options.map(
                (letter) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => checkLetter(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(letter),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Puntos: $counter',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- JUEGO DE FIGURAS --------------------

class ShapeGame extends StatefulWidget {
  final String uid;

  const ShapeGame({required this.uid, super.key});

  @override
  _ShapeGameState createState() => _ShapeGameState();
}

class _ShapeGameState extends State<ShapeGame> {
  final List<String> shapes = [
    'Círculo',
    'Cuadrado',
    'Triángulo',
    'Rectángulo',
    'Estrella',
    'Pentágono',
    'Hexágono',
    'Corazón'
  ];
  late String correctShape;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    generateShape();
  }

  void generateShape() {
    shapes.shuffle();
    correctShape = shapes[0];
  }

  Future<void> actualizarPuntos(int cantidad) async {
    final docRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final puntosActuales = snapshot.data()?['puntos'] ?? 0;
      transaction.update(docRef, {'puntos': puntosActuales + cantidad});
    });
  }

  void checkShape(String selectedShape) {
    bool correct = selectedShape == correctShape;
    if (correct) {
      counter++;
      actualizarPuntos(1);
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        title: Text(
          correct ? '¡Correcto! 🎉' : '¡Esa no es!',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                generateShape();
              });
            },
            child: const Text(
              'Continuar',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShapeIcon(String shape) {
    Widget icon;
    Color color;
    switch (shape) {
      case 'Círculo':
        icon = Container(width: 60, height: 60, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red));
        break;
      case 'Cuadrado':
        icon = Container(width: 60, height: 60, color: Colors.blue);
        break;
      case 'Triángulo':
        icon = CustomPaint(size: const Size(60, 60), painter: TrianglePainter(color: Colors.green));
        break;
      case 'Rectángulo':
        icon = Container(width: 80, height: 40, color: Colors.orange);
        break;
      case 'Estrella':
        icon = const Icon(Icons.star, size: 60, color: Colors.yellow);
        break;
      case 'Pentágono':
        icon = const Icon(Icons.pentagon, size: 60, color: Colors.purple);
        break;
      case 'Hexágono':
        icon = const Icon(Icons.hexagon, size: 60, color: Colors.cyan);
        break;
      case 'Corazón':
        icon = const Icon(Icons.favorite, size: 60, color: Colors.pink);
        break;
      default:
        icon = const SizedBox();
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        backgroundColor: fondoOscuro,
        title: const Text('🟠 Adivina la Figura', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Dónde está la figura "$correctShape"?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: shapes.map((shape) {
                  return GestureDetector(
                    onTap: () => checkShape(shape),
                    child: Column(
                      children: [
                        buildShapeIcon(shape),
                        const SizedBox(height: 6),
                        Text(
                          shape,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Text(
                'Puntos: $counter',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//Juego sopa de letras

class WordSearchGame extends StatefulWidget {
  @override
  _WordSearchGameState createState() => _WordSearchGameState();
}

class _WordSearchGameState extends State<WordSearchGame> {
  final List<List<String>> grid = [
    ['S', 'O', 'L', 'A', 'B', 'C', 'D', 'E', 'F', 'G'],
    ['M', 'A', 'R', 'U', 'N', 'U', 'B', 'E', 'H', 'I'],
    ['L', 'U', 'N', 'A', 'X', 'I', 'E', 'J', 'K', 'L'],
    ['A', 'R', 'C', 'A', 'T', 'O', 'L', 'L', 'U', 'V'],
    ['S', 'O', 'L', 'M', 'P', 'L', 'E', 'F', 'L', 'O'],
    ['C', 'I', 'E', 'L', 'O', 'H', 'Z', 'M', 'N', 'Ñ'],
    ['N', 'U', 'B', 'E', 'R', 'I', 'O', 'T', 'S', 'P'],
    ['F', 'L', 'O', 'R', 'P', 'E', 'Z', 'A', 'V', 'E'],
    ['B', 'O', 'S', 'Q', 'U', 'E', 'L', 'L', 'U', 'V'],
    ['M', 'O', 'N', 'T', 'A', 'Ñ', 'A', 'E', 'S', 'T'],
  ];

  List<Offset> selectedCells = [];
  Set<String> foundWords = {};

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<WordProvider>(context).words;

    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        title: const Text('🔍 Sopa de Letras'),
        backgroundColor: const Color.fromARGB(255, 249, 252, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Encuentra estas palabras:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: words.map((word) {
                final found = foundWords.contains(word.toUpperCase());
                return Chip(
                  label: Text(
                    word,
                    style: TextStyle(
                      fontSize: 12,
                      decoration: found ? TextDecoration.lineThrough : null,
                      color: found ? Colors.white : Colors.black,
                    ),
                  ),
                  backgroundColor: found ? Colors.green : Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: grid.length * grid[0].length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid[0].length,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ grid[0].length;
                  int col = index % grid[0].length;
                  bool isSelected = selectedCells.contains(
                    Offset(row.toDouble(), col.toDouble()),
                  );
                  return GestureDetector(
                    onTap: () => onLetterTap(row, col, words),
                    child: Card(
                      color: isSelected ? Colors.tealAccent : Colors.white12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          grid[row][col],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: clearSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Limpiar selección'),
            ),
          ],
        ),
      ),
    );
  }

  void onLetterTap(int row, int col, List<String> words) {
    setState(() {
      final pos = Offset(row.toDouble(), col.toDouble());
      selectedCells.add(pos);
      final selectedWord = selectedCells
          .map((e) => grid[e.dx.toInt()][e.dy.toInt()])
          .join();

      if (words.contains(selectedWord.toUpperCase())) {
        foundWords.add(selectedWord.toUpperCase());
        selectedCells.clear();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: fondoOscuro,
            title: const Text(
              '¡Correcto!',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              '¡Encontraste "$selectedWord"! 🎉',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.tealAccent),
                ),
              ),
            ],
          ),
        );
      } else if (selectedWord.length > 12) {
        selectedCells.clear();
      }
    });
  }

  void clearSelection() {
    setState(() {
      selectedCells.clear();
    });
  }
}

class KahootGame extends StatefulWidget {
  const KahootGame({super.key});

  @override
  State<KahootGame> createState() => _KahootGameState();
}

//juego kahoot
class _KahootGameState extends State<KahootGame> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _allQuestions = [
    {
      'question': '¿Cuál es la capital de Francia?',
      'options': ['Madrid', 'París', 'Londres', 'Roma'],
      'answer': 'París',
    },
    {
      'question': '¿Cuánto es 5 x 3?',
      'options': ['8', '15', '10', '20'],
      'answer': '15',
    },
    {
      'question': '¿Quién pintó la Mona Lisa?',
      'options': ['Van Gogh', 'Picasso', 'Da Vinci', 'Rembrandt'],
      'answer': 'Da Vinci',
    },
    {
      'question': '¿Qué planeta es conocido como el rojo?',
      'options': ['Marte', 'Júpiter', 'Saturno', 'Venus'],
      'answer': 'Marte',
    },
    {
      'question': '¿Cuántos días tiene un año bisiesto?',
      'options': ['365', '366', '360', '364'],
      'answer': '366',
    },
    {
      'question': '¿Cuál es el océano más grande?',
      'options': ['Atlántico', 'Índico', 'Ártico', 'Pacífico'],
      'answer': 'Pacífico',
    },
    {
      'question': '¿Qué gas necesitamos para respirar?',
      'options': ['Nitrógeno', 'Oxígeno', 'Dióxido de carbono', 'Hidrógeno'],
      'answer': 'Oxígeno',
    },
    {
      'question': '¿En qué continente está Egipto?',
      'options': ['Asia', 'África', 'Europa', 'América'],
      'answer': 'África',
    },
    {
      'question': '¿Cuál es el metal más ligero?',
      'options': ['Aluminio', 'Oro', 'Litio', 'Hierro'],
      'answer': 'Litio',
    },
    {
      'question': '¿Cuántas patas tiene una araña?',
      'options': ['6', '8', '10', '12'],
      'answer': '8',
    },
    {
      'question': '¿Quién escribió Don Quijote?',
      'options': ['Cervantes', 'Shakespeare', 'Lope de Vega', 'Garcilaso'],
      'answer': 'Cervantes',
    },
    {
      'question': '¿Cuál es el idioma más hablado?',
      'options': ['Inglés', 'Español', 'Chino mandarín', 'Árabe'],
      'answer': 'Chino mandarín',
    },
    {
      'question': '¿Qué órgano bombea la sangre?',
      'options': ['Pulmones', 'Riñón', 'Hígado', 'Corazón'],
      'answer': 'Corazón',
    },
    {
      'question': '¿Cuántos continentes hay?',
      'options': ['5', '6', '7', '8'],
      'answer': '7',
    },
    {
      'question': '¿Cuál es el símbolo del oro?',
      'options': ['Ag', 'Au', 'O', 'Gd'],
      'answer': 'Au',
    },
    {
      'question': '¿Qué planeta es el más grande?',
      'options': ['Tierra', 'Saturno', 'Júpiter', 'Neptuno'],
      'answer': 'Júpiter',
    },
    {
      'question': '¿Cuál es el río más largo del mundo?',
      'options': ['Amazonas', 'Nilo', 'Yangtsé', 'Misisipi'],
      'answer': 'Amazonas',
    },
    {
      'question': '¿Qué animal es el rey de la selva?',
      'options': ['Tigre', 'Elefante', 'León', 'Pantera'],
      'answer': 'León',
    },
    {
      'question': '¿Cuántos colores tiene el arcoíris?',
      'options': ['5', '6', '7', '8'],
      'answer': '7',
    },
    {
      'question': '¿Cuál es el resultado de 9x9?',
      'options': ['81', '72', '99', '91'],
      'answer': '81',
    },
  ];

  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timer = 10;
  Timer? _countdownTimer;
  String _playerName = '';
  bool _gameStarted = false;
  List<Map<String, dynamic>> _ranking = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Color _bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _questions = List.from(_allQuestions)..shuffle();
    _questions = _questions.take(5).toList();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _score = 0;
      _currentQuestionIndex = 0;
      _bgColor = Colors.white;
    });
    _startTimer();
    _animationController.forward(from: 0);
  }

  void _startTimer() {
    _timer = 10;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 0) {
          _timer--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    _countdownTimer?.cancel();
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _bgColor = Colors.white;
      });
      _animationController.forward(from: 0);
      _startTimer();
    } else {
      _ranking.add({'name': _playerName, 'score': _score});
      _ranking.sort((a, b) => b['score'].compareTo(a['score']));
      _showResult();
    }
  }

  void _answerQuestion(String selected) {
    bool correct = selected == _questions[_currentQuestionIndex]['answer'];
    if (correct) _score++;

    setState(() {
      _bgColor = correct ? Colors.green.shade100 : Colors.red.shade100;
    });

    Future.delayed(const Duration(milliseconds: 600), _nextQuestion);
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🏆 Ranking de la sesión'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _ranking
                .asMap()
                .entries
                .map(
                  (entry) => ListTile(
                    leading: Text('#${entry.key + 1}'),
                    title: Text(entry.value['name']),
                    trailing: Text('${entry.value['score']} pts'),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _gameStarted = false;
                _playerName = '';
              });
            },
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameStarted) {
      return Scaffold(
        appBar: AppBar(title: const Text('🧠 Kahoot Educativo')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ingresa tu nombre:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nombre del estudiante',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _playerName = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _playerName.trim().isEmpty ? null : _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    '🎮 Iniciar juego',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final current = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(title: Text('Jugador: $_playerName')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: _timer / 10,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple,
                        ),
                      ),
                    ),
                    Text(
                      '$_timer s',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    current['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...current['options'].map<Widget>((option) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _answerQuestion(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
