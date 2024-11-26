import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/task.dart';
import '../../widgets/task_card.dart';

class PendingTasks extends StatefulWidget {
  const PendingTasks({Key? key}) : super(key: key);

  @override
  _PendingTasksState createState() => _PendingTasksState();
}

class _PendingTasksState extends State<PendingTasks> {
  late List<Task> tasks;
  Task? selectedTask;

  @override
  void initState() {
    super.initState();    
    tasks = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); 
    final taskProvider = context.read<TaskProvider>(); 
    tasks = taskProvider.tasks;
    if (tasks.isNotEmpty) {
      selectedTask = tasks[0];
    }
  }

  void _markAsCompleted() {
    if (selectedTask == null) return;    

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar completado'),
          content: const Text('¿Marcar este reto como completado?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                setState(() {
                  _showConfetti(context);
                  selectedTask!.isCompleted = true;
                });
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                userProvider.addPoints(selectedTask!.points);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfetti(BuildContext context) {
    // TODO: Implementar animación de serpentinas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(        
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.pink,
        content: Text('¡Felicitaciones! Has completado este reto!',
                  textAlign: TextAlign.center,  
                    style: TextStyle(
                      
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retos pendientes', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container( 
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_principal.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(            
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLevelInfo(),
              _buildProgressSection(context),
              _buildTasksList(context),
              if (selectedTask != null) _buildTaskDescription(),
              _buildButtons(context),
            ],
          ),
        ),
      )
    );
  }  

  Widget _buildLevelInfo() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        
        return Padding(
          padding: const EdgeInsets.only(top: 30.0, right:30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showLevelInfoDialog(context);  
                    },
                    child: Image.asset(
                      'assets/levels/${userProvider.level}.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'ⓘ Nivel: ${userProvider.level}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLevelInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información de Niveles'),
          content: const Text(
            'Inicial: Bronce\n'  
            '500 puntos: Plata\n'  
            '1500 puntos: Oro'  
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressSection(BuildContext context) {
  final taskProvider = context.watch<TaskProvider>();
  int completedTasks = taskProvider.tasks.where((task) => task.isCompleted).length;
  int totalTasks = taskProvider.tasks.length;

    return Padding(
      padding: const EdgeInsets.only(right:30.0, left:30, top:16, bottom:16),
      child: Column(      
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(          
            'Progreso',
            style: TextStyle(            
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedTasks tareas completadas de $totalTasks activas',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            minHeight: 7,
            value: totalTasks > 0? completedTasks / totalTasks : 0, // updated progress indicator
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 153, 221, 156),
            ),
          ),
        ],
      )
    );
  }  

  Widget _buildTasksList(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30.0, top: 16),
          child: Text(
            'Estos son tus retos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(          
          height: 175,
          child: Padding(
            padding: const EdgeInsets.only(right:30.0, left:30),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right:16.0, left:7, top: 16.0, bottom:16),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              final isSelected = selectedTask?.id == task.id;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTask = task;
                  });
                },                 
              
                child: Container(                  
                  width: 130,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
                  ),                  
                  child: SizedBox(
                    width: 130,                  
                    child: TaskCard(task: taskProvider.tasks[index],onTap: null,),
                  ),                  
                ),
              );
            },
          ),
          )
        ),
      ],
    );
  }

  Widget _buildTaskDescription() {
    return Padding(
      padding: const EdgeInsets.only(left:30.0, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedTask!.description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:16,right:30.0, left:30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: selectedTask?.isCompleted == true ? null : _markAsCompleted,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(12),
                ),
            ),
            child: const Text(
              'Marcar como completado',style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder( 
                borderRadius: BorderRadius.circular(12),
              ),
              //padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Regresar',style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
        ],
      ),
    );
  }
}
