import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskEditorScreen extends StatefulWidget {
  final Task? initialTask;

  const TaskEditorScreen({Key? key, this.initialTask}) : super(key: key);

  @override
  _TaskEditorScreenState createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  int _difficulty = 1;
  bool _isCompleted = false;
  String? _selectedImage;

  final List<String> _taskImages = [
    'assets/tasks/task0.png',
    'assets/tasks/task1.png',
    'assets/tasks/task2.png',
    'assets/tasks/task3.png',
    'assets/tasks/task4.png',
    'assets/tasks/task5.png',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTask?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialTask?.description ?? '');
    _selectedDate = widget.initialTask?.dueDate ?? DateTime.now();
    _selectedImage = widget.initialTask?.imageUrl;
    _difficulty = widget.initialTask != null 
        ? _calculateDifficultyLevel(widget.initialTask!.points) 
        : 1;
    _isCompleted = widget.initialTask?.isCompleted ?? false;  
  }

  int _calculateDifficultyLevel(int points) {
    if (points <= 20) return 1;
    if (points <= 40) return 2;
    if (points <= 60) return 3;
    if (points <= 80) return 4;
    return 5;
  }

  int _calculatePointsByDifficulty() {
    switch (_difficulty) {
      case 1: return 20;
      case 2: return 40;
      case 3: return 60;
      case 4: return 80;
      case 5: return 100;
      default: return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false); // Get the provider
    final existingTaskIndex = taskProvider.tasks.indexWhere((task) => task.id == widget.initialTask?.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar tarea', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(  // Use a Container for background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_principal.png'),
            fit: BoxFit.fill,
          ),
        ),  
        child: Container(
          padding: const EdgeInsets.only(left: 30, top: 30, right:30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Marcar como completa'),
                  Switch(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value;
                      });
                    },
                  ),
                ],
              ),*/
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Fecha limite',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ),
                    controller: TextEditingController(
                      text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Dificultad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        if (_difficulty > 1) _difficulty--;
                      });
                    },
                  ),
                  Column(                  
                    children: [
                      const SizedBox(height: 30),
                      Row(                      
                        children: List.generate(5, (index) {
                          return Container(
                            width: 40,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            color: index < _difficulty ? const Color.fromRGBO(215, 110, 205, 1) : Colors.grey,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text('Tu campeón/a obtendrá ${_calculatePointsByDifficulty()} puntos'),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        if (_difficulty < 5) _difficulty++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Imagen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _taskImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = _taskImages[index];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: _selectedImage == _taskImages[index]
                              ? Border.all(color: Colors.green, width: 3)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          _taskImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Guardar',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),                
                  const SizedBox(height: 7),
                  ElevatedButton(
                    onPressed: _confirmCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder( // For rounded corners
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Regresar',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  const SizedBox(height: 7),                
                  if (existingTaskIndex != -1)                
                    ElevatedButton(
                      onPressed: _deleteTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(220, 73, 85, 1),
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Eliminar tarea',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),                  
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tarea Guardada'),
        content: const Text('Hemos guardado los cambios'),
        actions: [
          TextButton(
            onPressed: () {
              final Task newTask = Task(
                id: DateTime.now().toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                points: _calculatePointsByDifficulty(),
                imageUrl: _selectedImage!,
                isCompleted: _isCompleted,
                dueDate: _selectedDate,
              );
              
              final taskProvider = Provider.of<TaskProvider>(context, listen: false); 
              final existingTaskIndex = taskProvider.tasks.indexWhere((task) => task.id == widget.initialTask?.id);
              if (existingTaskIndex != -1) {
                if(widget.initialTask?.id != null){
                  newTask.id = widget.initialTask!.id;
                  taskProvider.updateTask(newTask);
                }                
              } else {   
                taskProvider.addTask(newTask);
              }

              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final existingTask = taskProvider.tasks.firstWhere((task) => task.id == widget.initialTask?.id);
              taskProvider.removeTask(existingTask.id);
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );    
  }

  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('No se guardarán los cambios, ¿deseas volver a la pantalla inicial?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}