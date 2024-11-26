import 'package:challenge_champs/models/accessory.dart';

import '../models/task.dart';
import '../models/reward.dart';
 
final List<Task> tasksData = [
    Task(
      id: '0', 
      name: 'Pintar con acuarelas',
      description: 'Encuentra una idea inspiradora y dale vida con punturas de acurela',
      points: 100,
      imageUrl: 'assets/tasks/task0.png',
      isCompleted: true,
      dueDate: DateTime.now(),
    ),
    Task(
      id: '1',
      name: 'Leer un libro',
      description: 'Leer un libro completo durante la semana',
      points: 40,
      imageUrl: 'assets/tasks/task1.png',
    ),
    Task(
      id: '2', 
      name: 'Practicar música',
      description: 'Practicar un instrumento musical por 30 minutos',
      points: 60,
      imageUrl: 'assets/tasks/task2.png',
    ),
    Task(
      id: '3', 
      name: 'Idioma extranjero',
      description: 'Estudiar un idioma por 45 minutos',
      points: 100,
      imageUrl: 'assets/tasks/task3.png',      
    ),
    Task(
      id: '4', 
      name: 'Germina una planta',
      description: 'Haz crecer un frijol o un aguacate',
      points: 80,
      imageUrl: 'assets/tasks/task4.png',
    ),  
    Task(
      id: '5',
      name: 'Matemáticas',
      description: 'Completar ejercicios de matemáticas',
      points: 20,
      imageUrl: 'assets/tasks/task5.png',
    ),    
  ];

  final List<Accessory> accessoryData = [
    Accessory(
      id: '0', 
      type: "moustache",     
      points: 0,
      imageUrl: 'assets/accesories/bigote2.png',
      thumbnail: 'assets/accesories/bigote.png',
    ),
    Accessory(
      id: '1',
      type: "hat",      
      points: 0,
      imageUrl: 'assets/accesories/sombrero_negro2.png',
      thumbnail: 'assets/accesories/sombrero_negro.png',
    ),
    Accessory(
      id: '2', 
      type: "hat",      
      points: 0,
      imageUrl: 'assets/accesories/sombrero_navideno2.png',
      thumbnail: 'assets/accesories/sombrero_navideno.png',
    ),
    Accessory(
      id: '3', 
      type: "hat",      
      points: 100,
      imageUrl: 'assets/accesories/gorra2.png',
      thumbnail: 'assets/accesories/gorra.png',
    ),
    Accessory(
      id: '4', 
      type: "hat",      
      points: 60,
      imageUrl: 'assets/accesories/sombrero_cafe2.png',
      thumbnail: 'assets/accesories/sombrero_cafe.png',
    ),
    Accessory(
      id: '5', 
      type: "glasses",      
      points: 0,
      imageUrl: 'assets/accesories/gafas_transparentes2.png',
      thumbnail: 'assets/accesories/gafas_transparentes.png',
    ),
    Accessory(
      id: '6',   
      type: "glasses",    
      points: 0,
      imageUrl: 'assets/accesories/gafas_corazon2.png',
      thumbnail: 'assets/accesories/gafas_corazon.png',
    ),
    Accessory(
      id: '7', 
      type: "glasses",      
      points: 80,
      imageUrl: 'assets/accesories/gafas_aviador2.png',
      thumbnail: 'assets/accesories/gafas_aviador.png',
    ),
    Accessory(
      id: '8', 
      type: "glasses",      
      points: 40,
      imageUrl: 'assets/accesories/gafas_wayfarer2.png',
      thumbnail: 'assets/accesories/gafas_wayfarer.png',
    ),    
  ];

  final List<Reward> rewardsData = [
    Reward(
      id: '0',
      name: 'Visita al planetario',
      description: 'Obten una visita al planetario',
      points: 250,
      imageUrl: 'assets/rewards/reward0.png',
    ),
    Reward(
      id: '1', 
      name: 'Auto de juguete',
      description: 'Un auto a control remoto',
      points: 500,
      imageUrl: 'assets/rewards/reward1.png',
    ),
    Reward(
      id: '2',
      name: 'Casa de muñecas',
      description: 'Consigue una nueva casa para tus muñecas',
      points: 800,
      imageUrl: 'assets/rewards/reward2.png',
    ),
    Reward(
      id: '3', 
      name: 'Salitre Mágico',
      description: 'Pase platino para Salitre Mágico',
      points: 2800,
      imageUrl: 'assets/rewards/reward3.png',
    ),
    Reward(
      id: '4', 
      name: 'Sandwich Qbano',
      description: 'Combo Jr. en Sandwich cubano',
      points: 1500,
      imageUrl: 'assets/rewards/reward4.png',
    ),
    Reward(
      id: '5', 
      name: 'Cine con palomitas',
      description: 'Una peli en el cine con palomitas incluidas',
      points: 200,
      imageUrl: 'assets/rewards/reward5.png',
    ),
  ];