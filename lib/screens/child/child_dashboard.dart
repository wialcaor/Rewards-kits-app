import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import 'avatar_customization.dart';
import 'pending_tasks.dart';
import 'available_rewards.dart';
import '../../models/task.dart';
import '../../models/accessory.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({Key? key}) : super(key: key);

  Future<void> _handleRefresh(BuildContext context) async {
    // Refresh data from providers
    await Future.wait([
      //context.read<UserProvider>().refreshUser(),
      context.read<TaskProvider>().refreshTasks(),
      context.read<AccessoryProvider>().refreshAccessories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/fondo_avatar.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => _handleRefresh(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                              MediaQuery.of(context).padding.top - 
                              MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeaderSection(context),
                        const SizedBox(height: 24),
                        _buildProgressSection(context),
                        const SizedBox(height: 50),
                        _buildAvatarSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
        
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hola, ${userProvider.userName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,                
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[                    
                    const Text(
                      'Tienes:',
                      style: TextStyle(                        
                        fontSize: 18,
                        fontWeight: FontWeight.w500,                                            
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('${userProvider.points - userProvider.usedPoints} Pts.',
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(97, 202, 244, 1),
                      ),
                    ),
                  ]
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showLevelInfoDialog(context);  // Call the dialog function
                      },
                      child: Image.asset(
                        'assets/levels/${userProvider.level}.png',
                        height: 50,
                        width: 50,
                      ),
                    ),  
                    Text(
                      'ⓘ Nivel: ${userProvider.level}',
                      style: const TextStyle(
                        fontSize: 14,                        
                      ),
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
    
    return Consumer<TaskProvider>(  
      builder: (context, taskProvider, child) { 
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
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
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                  minHeight: 15,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 153, 221, 156),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Row(      
      children: [        
        Expanded(
          flex: 2,          
          child: Padding(padding: 
            const EdgeInsets.only(top:70.0),
            child: _buildAvatarWithAccessories(context),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildActionButton(
                context,
                'Personalizar',
                'assets/buttons/customize.png',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AvatarCustomization(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                'Recompensas',
                'assets/buttons/rewards.png',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AvailableRewards(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                'Retos',
                'assets/buttons/tasks.png',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PendingTasks(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarWithAccessories(BuildContext context) {
    final accessoryProvider = context.watch<AccessoryProvider>();
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Base avatar image
        Image.asset(
          'assets/avatar/avatar.png',
          fit: BoxFit.contain,
        ),
               

        ...accessoryProvider.selectedAccessories.map((accessory) {
          return Positioned.fill(
            child: Image.asset(
              accessory.imageUrl,
              fit: BoxFit.fill,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String iconPath,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              iconPath,
              width: 40,
              height: 40,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
