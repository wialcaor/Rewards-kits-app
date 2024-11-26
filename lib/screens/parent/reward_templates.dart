import 'package:flutter/material.dart';
import '../../models/reward.dart';
import '../parent/reward_editor.dart';

class RewardTemplatesScreen extends StatefulWidget {
  const RewardTemplatesScreen({Key? key}) : super(key: key);

  @override
  _RewardTemplatesScreenState createState() => _RewardTemplatesScreenState();
}

class _RewardTemplatesScreenState extends State<RewardTemplatesScreen> {
  final List<Reward> predefinedRewards = [
    Reward(
      id: DateTime.now().toString(),
      name: 'Visita al planetario',
      description: 'Obten una visita al planetario',
      points: 250,
      imageUrl: 'assets/rewards/reward0.png',
    ),
    Reward(
      id: DateTime.now().toString(), 
      name: 'Auto de juguete',
      description: 'Un auto a control remoto',
      points: 500,
      imageUrl: 'assets/rewards/reward1.png',
    ),
    Reward(
      id: DateTime.now().toString(),
      name: 'Casa de muñecas',
      description: 'Consigue una nueva casa para tus muñecas',
      points: 800,
      imageUrl: 'assets/rewards/reward2.png',
    ),
    Reward(
      id: DateTime.now().toString(), 
      name: 'Salitre Mágico',
      description: 'Pase platino para Salitre Mágico',
      points: 2800,
      imageUrl: 'assets/rewards/reward3.png',
    ),
    Reward(
      id: DateTime.now().toString(), 
      name: 'Sandwich Qbano',
      description: 'Combo Jr. en Sandwich cubano',
      points: 1500,
      imageUrl: 'assets/rewards/reward4.png',
    ),
    Reward(
      id: DateTime.now().toString(),
      name: 'Cine con palomitas',
      description: 'Una peli en el cine con palomitas incluidas',
      points: 200,
      imageUrl: 'assets/rewards/reward5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar recompensas', style: TextStyle(fontWeight: FontWeight.bold)),
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
                'Selecciona una recompensa para editarla:',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top:16, left: 30, right: 30),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: predefinedRewards.length,
                itemBuilder: (context, index) {
                  final reward = predefinedRewards[index];
                  return _buildRewardCard(reward, context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16, left: 30, right: 30, bottom: 16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RewardEditorScreen(),
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
                    child: const Text('Crear nueva recompensa',style: TextStyle(
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
                    child: const Text('Regresar',style: TextStyle(
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
      )
    );
  }

  Widget _buildRewardCard(Reward reward, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RewardEditorScreen(initialReward: reward),
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
                reward.imageUrl,
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
                  '${reward.points} Pts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                reward.name,
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