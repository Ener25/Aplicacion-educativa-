import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';
import 'registro_screen.dart';
import 'maestro.dart';
import 'main.dart';

import 'package:flutter/material.dart' as flutter;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode userFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();

  String selectedRole = "Alumno";
  bool _obscurePassword = true;

  late AnimationController _controller;

  StateMachineController? riveController; // 🔧 CAMBIO: eliminado el alias 'rive.'
  SMIBool? isFocus;
  SMINumber? numLook;
  SMIBool? isPrivateField;
  SMIBool? isPrivateFieldShow;
  SMITrigger? successTrigger;
  SMITrigger? failTrigger;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    userFocusNode.addListener(() {
      isFocus?.change(userFocusNode.hasFocus);
    });

    passFocusNode.addListener(() {
      isFocus?.change(passFocusNode.hasFocus);
      isPrivateField?.change(passFocusNode.hasFocus);
    });

    userController.addListener(() {
      if (userFocusNode.hasFocus) {
        numLook?.change(userController.text.length.toDouble() * 2);
      }
    });

    passwordController.addListener(() {
      if (passFocusNode.hasFocus) {
        isPrivateField?.change(passwordController.text.isNotEmpty);
      }
    });
  }

  void _onRiveInit(Artboard artboard) { // 🔧 CAMBIO: sin alias 'rive.'
    final controller = StateMachineController.fromArtboard( // 🔧 CAMBIO: sin alias
      artboard,
      'Login Machine',
    );
    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;

      isFocus = controller.getBoolInput('isFocus'); // 🔧 CAMBIO importante
      numLook = controller.getNumberInput('numLook'); // 🔧 CAMBIO importante
      isPrivateField = controller.getBoolInput('isPrivateField'); // 🔧 CAMBIO importante
      isPrivateFieldShow = controller.getBoolInput('isPrivateFieldShow'); // 🔧 CAMBIO importante
      successTrigger = controller.getTriggerInput('successTrigger'); // 🔧 CAMBIO importante
      failTrigger = controller.getTriggerInput('failTrigger'); // 🔧 CAMBIO importante
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    userFocusNode.dispose();
    passFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final String usuario = userController.text.trim();
    final String contrasena = passwordController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      failTrigger?.change(true);
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(content: Text('Completa todos los campos')),
      );
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('usuario', isEqualTo: usuario)
          .where('contrasena', isEqualTo: contrasena)
          .get();

      if (snapshot.docs.isNotEmpty) {
        successTrigger?.change(true);

        final userDoc = snapshot.docs.first;
        final userData = userDoc.data();
        final role = userData['rol'];
        final uid = userDoc.id;
        final name = userData['nombre'] ?? usuario;

        Future.delayed(const Duration(milliseconds: 1200), () {
          if (role == 'Alumno') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen(userName: name, uid: uid)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TeacherDashboardFull(userName: name)),
            );
          }
        });
      } else {
        failTrigger?.change(true);
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text('Usuario o contraseña incorrectos ❌'),
          ),
        );
      }
    } catch (e) {
      failTrigger?.change(true);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text('Error al iniciar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
        decoration: BoxDecoration(
  gradient: flutter.LinearGradient(
    colors: [
      Color(0xFF0F2027),
      Color(0xFF203A43),
      Color(0xFF2C5364),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  ),
),

          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: BorderAnimationPainter(progress: _controller.value),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 200,
                          child: RiveAnimation.asset( // 🔧 CAMBIO: sin alias
                            'assets/animations/auth_teddy.riv',
                            fit: BoxFit.contain,
                            onInit: _onRiveInit,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Bienvenido de nuevo',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text('Inicia sesión en tu cuenta', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 20),
                        TextField(
                          controller: userController,
                          focusNode: userFocusNode,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Nombre de usuario',
                            hintStyle: const TextStyle(color: Colors.white60),
                            prefixIcon: const Icon(Icons.person, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          focusNode: passFocusNode,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(color: Colors.white60),
                            prefixIcon: const Icon(Icons.lock, color: Colors.white),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                  isPrivateFieldShow?.change(!_obscurePassword);
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.05),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black87,
                              value: selectedRole,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Alumno',
                                  child: Text('Alumno', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem(
                                  value: 'Docente',
                                  child: Text('Docente', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                          child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            '¿No tienes cuenta? Regístrate aquí',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BorderAnimationPainter extends CustomPainter {
  final double progress;

  BorderAnimationPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Rect rect = Offset.zero & size;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(25)));

    for (final metric in path.computeMetrics()) {
      final start = metric.length * progress;
      final end = start + metric.length * 0.2;
      canvas.drawPath(
        metric.extractPath(start, end.clamp(0, metric.length)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
