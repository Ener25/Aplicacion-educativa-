import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'editorjuegos/word_provider.dart';
import 'alumno.dart';
import 'configuracion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WordProvider())],
      child: MaterialApp(
        title: 'App Educativa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String uid;
  const DashboardScreen({super.key, required this.userName, required this.uid});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      InicioWidget(userName: widget.userName, uid: widget.uid),
      JuegosWidget(uid: widget.uid),
      ConfiguracionScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E2533),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Juegos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}


class InicioWidget extends StatefulWidget {
  final String userName;
  final String uid;
  const InicioWidget({super.key, required this.userName, required this.uid});
  @override
  State<InicioWidget> createState() => _InicioWidgetState();
}

class _InicioWidgetState extends State<InicioWidget>
    with SingleTickerProviderStateMixin {
  final List<String> frasesMotivadoras = [
    '¡Hoy es un gran día para aprender algo nuevo! 💡',
    'Cada juego te hace más sabio 🧠',
    '¡Aprender es una aventura divertida! 🗺️',
    '¡Sigue así, campeón del conocimiento! 🏆',
    'El conocimiento es tu superpoder 🧠⚡',
    '¡Estás más cerca de tu meta cada día! 🎯',
  ];
  final List<Map<String, dynamic>> juegosRecientes = [
    {'nombre': 'Colores', 'icono': Icons.grid_view, 'color': Colors.redAccent},
    {'nombre': 'Kahoot', 'icono': Icons.chat_bubble_outline, 'color': Colors.cyanAccent},
    {'nombre': 'Figuras', 'icono': Icons.check_circle_outline, 'color': Colors.lightGreenAccent},
  ];

  late final String fraseDelDia;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fraseDelDia = (frasesMotivadoras..shuffle()).first;
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildGameCard(String title, IconData icon, Color borderColor, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: Duration(milliseconds: 300 + index * 100),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A38),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 28, color: borderColor),
                const SizedBox(height: 8),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '100 %',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.black54, size: 30),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '🏆 Nivel 5',
                    style: GoogleFonts.poppins(color: Colors.amber, fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('usuarios').doc(widget.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final puntos = data['puntos'] ?? 0;
                  final progreso = (puntos / 100).clamp(0.0, 1.0);
                  final porcentaje = (progreso * 100).toInt();
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          value: progreso,
                          strokeWidth: 6,
                          valueColor: const AlwaysStoppedAnimation(Colors.cyanAccent),
                          backgroundColor: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$porcentaje%',
                        style: GoogleFonts.poppins(
                            color: Colors.cyanAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  fraseDelDia,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.flash_on, color: Colors.amberAccent),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Últimos juegos jugados:',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(
              juegosRecientes.length,
              (index) => SizedBox(
                width: MediaQuery.of(context).size.width / 3 - 28,
                child: _buildGameCard(
                  juegosRecientes[index]['nombre'],
                  juegosRecientes[index]['icono'],
                  juegosRecientes[index]['color'],
                  index,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Ranking General + Reto del Día
          ScaleTransition(
            scale: CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('usuarios').doc(widget.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const SizedBox.shrink();
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final puntos = data['puntos'] ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A38),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amberAccent, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.military_tech, color: Colors.amber, size: 32),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ranking General',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('$puntos puntos 🎯',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildRetoDelDia(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetoDelDia() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.8), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.amberAccent, size: 28),
              const SizedBox(width: 8),
              Text('Reto del Día',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Resuelve 3 juegos seguidos sin errores para ganar una medalla 🏅',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.33,
            minHeight: 8,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
            backgroundColor: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}



class JuegosWidget extends StatefulWidget {
  const JuegosWidget({super.key, required this.uid});

  final String uid;

  @override
  State<JuegosWidget> createState() => _JuegosWidgetState();
}

class _JuegosWidgetState extends State<JuegosWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> games = [
    {
      'title': 'COLORES',
      'icon': Icons.grid_view,
      'color': Colors.red,
      'juego': 'Colores',
    },
    {
      'title': 'NÚMEROS',
      'icon': Icons.looks_one,
      'color': Colors.blue,
      'juego': 'Numeros',
    },
    {
      'title': 'FIGURAS',
      'icon': Icons.check_circle_outline,
      'color': Colors.green,
      'juego': 'Figuras',
    },
    {
      'title': 'LETRAS',
      'icon': Icons.text_fields,
      'color': Colors.purple,
      'juego': 'Letras',
    },
    {
      'title': 'KAHOOT',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.cyan,
      'juego': 'Kahoot',
    },
    {
      'title': 'SOPA DE LETRAS',
      'icon': Icons.abc,
      'color': Colors.orange,
      'juego': 'Sopa de letras',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildGameCard(Map<String, dynamic> game, int index) {
    return ScaleTransition(
      scale: _animation,
      child: InkWell(
        onTap: () {
          if (game['juego'] == 'Kahoot') {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const KahootGame()));
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) =>
                    AlumnoHomeScreen(juego: game['juego'], uid: widget.uid),
                transitionsBuilder: (_, anim, __, child) =>
                    ScaleTransition(scale: anim, child: child),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2533),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: game['color'].withOpacity(0.8),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(game['icon'], size: 40, color: game['color']),
              const SizedBox(height: 12),
              Text(
                game['title'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '100 %',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Text(
              'Tus Juegos',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: games.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) =>
                  buildGameCard(games[index], index),
            ),
          ),
        ],
      ),
    );
  }
}
