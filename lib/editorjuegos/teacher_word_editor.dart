import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'word_provider.dart';

class TeacherWordEditor extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wordProvider = Provider.of<WordProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('📚 Editar Palabras Sopa de Letras')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nueva palabra',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  wordProvider.addWord(controller.text);
                  controller.clear();
                }
              },
              child: Text('Agregar Palabra'),
            ),
            SizedBox(height: 20),
            Text(
              'Palabras actuales:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: wordProvider.words.length,
                itemBuilder: (context, index) {
                  final word = wordProvider.words[index];
                  return ListTile(
                    title: Text(word),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => wordProvider.removeWord(word),
                    ),
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
