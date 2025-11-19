import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_appedu/configuracion.dart';
import 'login_screen.dart';

class TeacherDashboardFull extends StatefulWidget {
  final String userName;

  const TeacherDashboardFull({super.key, required this.userName});

  @override
  State<TeacherDashboardFull> createState() => _TeacherDashboardFullState();
}

class _TeacherDashboardFullState extends State<TeacherDashboardFull> {
  int currentIndex = 0;
  String selectedStudent = 'General';

  final List<Map<String, dynamic>> students = [
    {
      'name': 'Juan',
      'progress': 70,
      'activity': [2.0, 3.5, 4.5, 6.0, 5.0, 7.0, 6.5, 8.0],
    },
    {
      'name': 'Ana',
      'progress': 85,
      'activity': [3.0, 4.0, 5.5, 6.5, 7.0, 8.0, 8.5, 9.0],
    },
    {
      'name': 'Luis',
      'progress': 40,
      'activity': [1.0, 1.5, 2.0, 2.5, 3.0, 3.2, 3.5, 4.0],
    },
    {
      'name': 'Carla',
      'progress': 90,
      'activity': [3.0, 4.0, 5.0, 6.0, 7.5, 8.0, 8.5, 9.5],
    },
  ];

  final Color background = const Color(0xFF0F2A37);
  final Color panel = const Color(0xFF1E2D3B);
  final Color cardBackground = const Color(0xFF182833);
  final Color accent = Colors.tealAccent;

  void _mostrarFormularioAgregarAlumno() {
    String nombre = '';
    String usuario = '';
    String contrasena = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: panel,
          title: const Text(
            'Agregar Alumno',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) => nombre = value,
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) => usuario = value,
              ),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) => contrasena = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (nombre.isNotEmpty &&
                    usuario.isNotEmpty &&
                    contrasena.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('usuarios').add({
                    'nombre': nombre,
                    'usuario': usuario,
                    'contrasena': contrasena,
                    'nivel': 0,
                    'puntos': 0,
                    'rol': 'Alumno',
                  });

                  setState(() {
                    students.add({
                      'name': nombre,
                      'progress': 0.0,
                      'activity': List.filled(8, 0.0),
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> Leerestu() async {
    final collection = FirebaseFirestore.instance.collection('usuarios');
    final query = await collection.get();

    return query.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'name': data['nombre'] ?? 'Sin nombre',
        'progress': data['nivel'] ?? 0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Text(
            'Bienvenido, ${widget.userName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: _getMainView()),
        BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Alumnos'),
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              label: 'Juegos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Perfil',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 80,
          color: panel,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _sidebarButton(Icons.dashboard, 0),
              const SizedBox(height: 20),
              _sidebarButton(Icons.people, 1),
              const SizedBox(height: 20),
              _sidebarButton(Icons.videogame_asset, 2),
              const SizedBox(height: 20),
              _sidebarButton(Icons.settings, 3),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white54),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido, ${widget.userName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(child: _getMainView()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sidebarButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentIndex == index ? Colors.tealAccent : Colors.white,
      ),
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget _getMainView() {
    switch (currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildStudentsView();
      case 2:
        final juegosDisponibles = [
          {'nombre': 'Colores', 'icono': Icons.color_lens},
          {'nombre': 'Números', 'icono': Icons.looks_one},
          {'nombre': 'Letras', 'icono': Icons.abc},
          {'nombre': 'Figuras', 'icono': Icons.category},
          {'nombre': 'Sopa de letras', 'icono': Icons.search},
          {'nombre': 'Kahoot', 'icono': Icons.quiz},
        ];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Juegos Disponibles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: juegosDisponibles.map((juego) {
                    return Card(
                      color: const Color(0xFF1E2D3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              juego['icono'] as IconData,
                              size: 40,
                              color: Colors.tealAccent,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              juego['nombre'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );

      case 3:
        return ConfiguracionScreen();

      default:
        return Container();
    }
  }

  Widget _buildDashboard() {
    List<double> chartData = selectedStudent == 'General'
        ? [4, 6, 7, 8, 5, 6, 9, 8]
        : students.firstWhere((s) => s['name'] == selectedStudent)['activity'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen General',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _metricCard(
                'Estudiantes',
                Icons.people,
                students.length.toString(),
              ),
              _metricCard('Promedio', Icons.show_chart, '72%'),
              _metricCard('Completados', Icons.emoji_events, '143'),
              _buildDonutChart(0.72),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedStudent,
            dropdownColor: cardBackground,
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            items: [
              const DropdownMenuItem(value: 'General', child: Text('General')),
              ...students.map(
                (s) =>
                    DropdownMenuItem(value: s['name'], child: Text(s['name'])),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedStudent = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _buildLineChart(chartData)),
          const SizedBox(height: 30),
          const Text(
            'Progreso de Alumnos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: students
                .map((student) => _buildStudentProgressCard(student))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, IconData icon, String value) {
    return Container(
      width: 160,
      height: 110,
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: accent, size: 24),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

 Widget _buildDonutChart(double percent) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: percent),
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeOut,
    builder: (context, animatedValue, child) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: 1,
        child: Transform.translate(
          offset: const Offset(0, 10),
          child: Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.tealAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 30,
                sectionsSpace: 0,
                startDegreeOffset: 180,
                sections: [
                  PieChartSectionData(
                    value: animatedValue * 100,
                    color: Colors.tealAccent,
                    radius: 45,
                    title: '${(animatedValue * 100).toInt()}%',
                    titleStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  PieChartSectionData(
                    value: 100 - animatedValue * 100,
                    color: Colors.grey.withOpacity(0.2),
                    radius: 45,
                    title: '',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildLineChart(List<double> values) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeInOut,
    builder: (context, animationValue, child) {
      return Transform.scale(
        scale: animationValue,
        child: Opacity(
          opacity: animationValue,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 2),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 4,
                  gradient: LinearGradient(
                    colors: [Colors.tealAccent, Colors.cyanAccent],
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.tealAccent.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                      radius: 4,
                      color: Colors.tealAccent,
                      strokeWidth: 1.5,
                      strokeColor: Colors.white,
                    ),
                  ),
                  spots: List.generate(
                    values.length,
                    (index) => FlSpot(index.toDouble(), values[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildStudentProgressCard(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student['name'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: student['progress'] / 100,
            color: accent,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(height: 4),
          Text(
            '${student['progress']}% completado',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                const Text(
                  'Listado de estudiantes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _mostrarFormularioAgregarAlumno,
                  icon: const Icon(Icons.person_add),
                  label: const Text("Agregar Alumno"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Leerestu(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay estudiantes registrados',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final studentsList = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                    ), // margen extra inferior
                    itemCount: studentsList.length,
                    itemBuilder: (context, index) {
                      final student = studentsList[index];
                      return Card(
                        color: Colors.white12,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            student['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Progreso: ${student['progress']}%',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          // Sin trailing (sin flecha)
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
