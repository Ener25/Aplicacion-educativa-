import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final String nombre = "Olivia Brown";
  final String correo = "oliviabrown@gmail.com";
  final String rol = "Alumna";
  final int edad = 9;
  final double progreso = 0.78;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mi Perfil")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto de perfil
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/images/avatar.png',
              ), // cambia si usas otra imagen
            ),

            SizedBox(height: 16),

            // Nombre y correo
            Text(
              nombre,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              correo,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            SizedBox(height: 24),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Editar perfil"),
                  onPressed: () {
                    // Acción editar
                  },
                ),
                SizedBox(width: 10),
                OutlinedButton.icon(
                  icon: Icon(Icons.lock),
                  label: Text("Cambiar contraseña"),
                  onPressed: () {
                    // Acción cambiar contraseña
                  },
                ),
              ],
            ),

            SizedBox(height: 24),

            // Tarjetas informativas
            Card(
              child: ListTile(
                leading: Icon(Icons.cake),
                title: Text("Edad"),
                subtitle: Text("$edad años"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.school),
                title: Text("Rol"),
                subtitle: Text(rol),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text("Progreso"),
                subtitle: LinearProgressIndicator(value: progreso),
                trailing: Text("${(progreso * 100).toInt()}%"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
