import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Alumno';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nombre completo
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Nombre completo', Icons.person),
                          validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
                        ),
                        const SizedBox(height: 15),

                        // Nombre de usuario
                        TextFormField(
                          controller: usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Nombre de usuario', Icons.account_circle),
                          validator: (value) => value!.isEmpty ? 'Ingresa un usuario' : null,
                        ),
                        const SizedBox(height: 15),

                        // Contraseña
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('Contraseña', Icons.lock),
                          validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
                        ),
                        const SizedBox(height: 15),

                        // Rol
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.school, color: Colors.white),
                            const SizedBox(width: 10),
                            const Text('Soy:', style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              dropdownColor: Colors.black87,
                              value: selectedRole,
                              style: const TextStyle(color: Colors.white),
                              items: const [
                                DropdownMenuItem(value: 'Alumno', child: Text('Alumno')),
                                DropdownMenuItem(value: 'Docente', child: Text('Docente')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Botón registrar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                            ),
                            onPressed: _registerUser,
                            child: const Text('Registrarse', style: TextStyle(fontSize: 18)),
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

  void _registerUser() async {
    final String name = nameController.text.trim();
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance.collection('usuarios').add({
  'nombre': name,
  'usuario': username,
  'contrasena': password,
  'rol': selectedRole, // Guardamos el rol elegido (Alumno o Docente)
});


      if (mounted) {
        Navigator.pop(context); // Regresa al login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito ✅')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    }
  }
}
