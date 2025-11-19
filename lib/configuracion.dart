import 'package:flutter/material.dart';
import 'login_screen.dart';

class ConfiguracionScreen extends StatefulWidget {
  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombreUsuario = '';
  String idioma = 'Español';
  bool modoOscuro = false;
  double volumen = 0.5;
  bool notificaciones = true;

  void guardarConfiguracion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Configuración guardada')),
      );
    }
  }

  void cerrarSesion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2533),
        title: const Text('Configuración'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Ajustes de usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),

              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => nombreUsuario = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Escribe un nombre' : null,
              ),

              const SizedBox(height: 20),

              const Text('Idioma', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  isExpanded: true,
                  value: idioma,
                  underline: const SizedBox(),
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  items: ['Español', 'Inglés', 'Francés'].map(
                    (lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() => idioma = value!);
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Divider(color: Colors.white30),

              SwitchListTile(
                title: const Text('Modo oscuro', style: TextStyle(color: Colors.white)),
                value: modoOscuro,
                onChanged: (value) => setState(() => modoOscuro = value),
                secondary: const Icon(Icons.dark_mode, color: Colors.white),
              ),

              ListTile(
                title: Text('Volumen: ${(volumen * 100).toInt()}%', style: const TextStyle(color: Colors.white)),
                subtitle: Slider(
                  value: volumen,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  activeColor: Colors.cyanAccent,
                  onChanged: (value) => setState(() => volumen = value),
                ),
                leading: const Icon(Icons.volume_up, color: Colors.white),
              ),

              SwitchListTile(
                title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
                value: notificaciones,
                onChanged: (value) => setState(() => notificaciones = value),
                secondary: const Icon(Icons.notifications, color: Colors.white),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: guardarConfiguracion,
                icon: const Icon(Icons.save),
                label: const Text('Guardar configuración'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 10),

              TextButton.icon(
                onPressed: cerrarSesion,
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
