import 'package:flutter/material.dart';
import '../../models/reward.dart';
import 'package:provider/provider.dart';

class RewardEditorScreen extends StatefulWidget {
  final Reward? initialReward;

  const RewardEditorScreen({Key? key, this.initialReward}) : super(key: key);

  @override
  _RewardEditorScreenState createState() => _RewardEditorScreenState();
}

class _RewardEditorScreenState extends State<RewardEditorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isAvailable = true;
  int _points = 500;
  String? _selectedImage;

  final List<String> _rewardImages = [
    'assets/rewards/reward0.png',
    'assets/rewards/reward1.png',
    'assets/rewards/reward2.png',
    'assets/rewards/reward3.png',
    'assets/rewards/reward4.png',
    'assets/rewards/reward5.png',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialReward?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialReward?.description ?? '');
    _selectedImage = widget.initialReward?.imageUrl;
    _points = widget.initialReward?.points ?? 500;
    _isAvailable = widget.initialReward?.isAvailable ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<RewardProvider>(context, listen: false); 
    final existingRewardIndex = taskProvider.rewards.indexWhere((task) => task.id == widget.initialReward?.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Recompensa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(  
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Marcar como disponible'),
                  Switch(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                ],
              ),
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
              const Text(
                'Puntos necesarios',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        if (_points > 100) _points -= 100;
                      });
                    },
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '$_points Pts',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Tu campeón/a necesitará $_points puntos \npara esta recompensa.',
                      textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        _points += 100;
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
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _rewardImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = _rewardImages[index];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: _selectedImage == _rewardImages[index]
                              ? Border.all(color: Colors.green, width: 3)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          _rewardImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _saveReward,
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _confirmCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Regresar',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  const SizedBox(height: 16),
                  if (existingRewardIndex != -1)                
                    ElevatedButton(
                      onPressed: _deleteReward,
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

  void _saveReward() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recompensa Guardada'),
        content: const Text('Hemos guardado los cambios'),
        actions: [
          TextButton(
            onPressed: () {
              final Reward newReward = Reward(
                id: DateTime.now().toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                points: _points,
                imageUrl: _selectedImage!,
                isAvailable: _isAvailable,                
              );
              
              final rewardProvider = Provider.of<RewardProvider>(context, listen: false); 
              final existingRewardIndex = rewardProvider.rewards.indexWhere((task) => task.id == widget.initialReward?.id);
              if (existingRewardIndex != -1) {
                if(widget.initialReward?.id != null){
                  newReward.id = widget.initialReward!.id;
                  rewardProvider.updateTask(newReward);
                }                
              } else {   
                rewardProvider.addTask(newReward);
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

  void _deleteReward() {
    final taskProvider = Provider.of<RewardProvider>(context, listen: false); // Get the provider
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar recompensa'),
        content: const Text('¿Estás seguro de que deseas eliminar esta recompensa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final existingTask = taskProvider.rewards.firstWhere((task) => task.id == widget.initialReward?.id);
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