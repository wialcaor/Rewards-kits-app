import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/reward.dart';

class AvailableRewards extends StatefulWidget {
  const AvailableRewards({Key? key}) : super(key: key);

  @override
  _AvailableRewardsState createState() => _AvailableRewardsState();
}

class _AvailableRewardsState extends State<AvailableRewards> {
  late List<Reward> rewards;
  Reward? selectedReward;

  @override
  void initState() {
    super.initState();    
    rewards = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); 
    final rewardProvider = context.read<RewardProvider>();
    rewards = rewardProvider.rewards;
    if (rewards.isNotEmpty) {
      selectedReward = rewards[0];
    }
  }

  void _redeemReward(BuildContext context, UserProvider userProvider) {
    if (selectedReward == null) return;

    if (userProvider.points-userProvider.usedPoints >= selectedReward!.points) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar redención'),
            content: Text(
              'Vas a redimir ${selectedReward!.points} puntos por ${selectedReward!.name}, ¿continuar?'
            ),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Sí'),
                onPressed: () {
                  // Mostrar felicitaciones
                  _showConfetti(context);
                  
                  // Actualizar puntos
                  userProvider.deductPoints(selectedReward!.points);
                  
                  // Navegar de vuelta al dashboard
                  Navigator.of(context).pop();
                  
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Puntos insuficientes'),
            content: const Text(
              'Aun no tienes los puntos suficientes para esta recompensa, pero ¡muy pronto los tendrás!'
            ),
            actions: [
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  void _showConfetti(BuildContext context) {
    // TODO: Implementar animación a futuro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(        
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.pink,
        content: Text('¡Felicitaciones! Has canjeado tu recompensa',
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Recompensas disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
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
                children: [
                  const SizedBox(height: 16),
                  _buildPointsDisplay(userProvider),
                  _buildRewardsList(userProvider),
                  _buildButtons(context, userProvider),
                ],
              ),
            ),
          )
        );
      },
    );
  }

  Widget _buildPointsDisplay(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Tienes',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '${userProvider.points-userProvider.usedPoints} Pts.',
            style: const TextStyle(
              fontSize: 48,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),          
        ],
      ),
    );
  }

  Widget _buildRewardsList(UserProvider userProvider) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top:16.0, left: 50, right: 50),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          final isSelected = selectedReward?.id == reward.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedReward = reward;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(255, 79, 35, 183).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 10,
                      ),
                    ]
                  : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset(
                      reward.imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${reward.points}',
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: Text(
                          reward.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,              
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: selectedReward != null
                ? () => _redeemReward(context, userProvider)
                : null,
            child: const Text(
              'Redimir',style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
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