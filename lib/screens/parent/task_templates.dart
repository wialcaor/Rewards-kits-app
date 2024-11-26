import 'package:flutter/material.dart';
import '../parent/task_editor.dart';
import '../../models/task.dart';

class TaskTemplatesScreen extends StatefulWidget {
  const TaskTemplatesScreen({Key? key}) : super(key: key);

  @override
  _TaskTemplatesScreenState createState() => _TaskTemplatesScreenState();
}

class _TaskTemplatesScreenState extends State<TaskTemplatesScreen> {
  final List<Task> predefinedTasks = [
    Task(
      id: DateTime.now().toString(),
      name: 'Pintar con acuarelas',
      description: 'Encuentra una idea inspiradora y dale vida con punturas de acurela',
      points: 100,
      imageUrl: 'assets/tasks/task0.png',
    ),
    Task(
      id: DateTime.now().toString(),
      name: 'Leer un libro',
      description: 'Leer un libro completo durante la semana',
      points: 40,
      imageUrl: 'assets/tasks/task1.png',
    ),
    Task(
      id: DateTime.now().toString(), 
      name: 'Practicar música',
      description: 'Practicar un instrumento musical por 30 minutos',
      points: 60,
      imageUrl: 'assets/tasks/task2.png',
    ),
    Task(
      id: DateTime.now().toString(),
      name: 'Idioma extranjero',
      description: 'Estudiar un idioma por 45 minutos',
      points: 100,
      imageUrl: 'assets/tasks/task3.png',
    ),      
    Task(
      id: DateTime.now().toString(), 
      name: 'germina una planta',
      description: 'Haz crecer un frijol o un aguacate',
      points: 80,
      imageUrl: 'assets/tasks/task4.png',
    ),  
    Task(
      id: DateTime.now().toString(),
      name: 'Matemáticas',
      description: 'Completar ejercicios de matemáticas',
      points: 20,
      imageUrl: 'assets/tasks/task5.png',
    ),    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar tarea', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container( 
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_principal.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                'Para hacerlo sencillo, tenemos algunas tareas recomendadas:',
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 7),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top:16, left: 30, right: 30),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: predefinedTasks.length,
                itemBuilder: (context, index) {
                  final task = predefinedTasks[index];
                  return _buildTaskCard(task, context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16, bottom:16, left: 30, right: 30),              
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskEditorScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Crear nueva tarea',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Regresar', style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskEditorScreen(initialTask: task),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                task.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Positioned( 
              top: 50,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,  
                    end: Alignment.topCenter,    
                    colors: [
                      Color.fromARGB(208, 0, 0, 0),          
                      Colors.transparent,     
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${task.points}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 8,
              right: 8,
              child: Text(
                task.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}