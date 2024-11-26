import 'package:challenge_champs/widgets/reward_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../widgets/task_card.dart';
import 'task_templates.dart';
import 'reward_templates.dart';
import '../../models/task.dart';
import '../../models/reward.dart';
class ParentDashboard extends StatelessWidget {
  const ParentDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(    
      child: Container(  
        decoration: const BoxDecoration(
          image: DecorationImage(            
            image: AssetImage('assets/fondo_principal.png'),
            fit: BoxFit.fill,
          ),
        ),      
        child: Container(        
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(context),              
              const SizedBox(height: 16),
              _buildProgressSection(context),              
              const SizedBox(height: 30),              
              _buildActiveTasks(context),              
              const SizedBox(height: 7),
              _buildActiveRewards(context),
            ],
          ),
        ),
      )
    );
  }
  Widget _buildProfileSection(BuildContext context) {
    /*final taskProvider = context.watch<TaskProvider>(); 
    final userProvider = context.watch<TaskProvider>();//Provider.of<UserProvider>(context, listen: false);
    int completedPoints = taskProvider.tasks
        .where((task) => task.isCompleted)
        .fold(0, (sum, task) => sum + task.points);
    userProvider.updatePoints(completedPoints);*/
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {         
        return Column(
          children: [
            const CircleAvatar(              
              radius: 30,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            const SizedBox(height: 8),
            Text(
              'Hola, ${userProvider.userName}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    const Text(
                      'Puntos actuales: ',                      
                      style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${userProvider.points-userProvider.usedPoints}', 
                      style: const TextStyle(
                        fontSize: 16,                        
                      ),
                    ),
                  ],
                ),
                const Spacer(), 
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
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(          
          'Progreso',
          style: TextStyle(            
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('$completedTasks tareas completadas de $totalTasks activas'), 
        const SizedBox(height: 5),
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(10),
          minHeight: 7,
          value: totalTasks > 0? completedTasks / totalTasks : 0,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 153, 221, 156),
          ),
        ),
      ],
    );
  }
  Widget _buildActiveTasks(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tareas activas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,            
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 130,                  
                  child: TaskCard(task: taskProvider.tasks[index]),                  
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Nueva tarea'),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: Colors.pink[100],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskTemplatesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildActiveRewards(BuildContext context) {
    final rewardProvider = context.watch<RewardProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recompensas activas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rewardProvider.rewards.length,
          itemBuilder: (context, index) {
            return RewardCardSmall(reward: rewardProvider.rewards[index], isSelected: false);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Nueva recompensa'),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: Colors.pink[100],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RewardTemplatesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}