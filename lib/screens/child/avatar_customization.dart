import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/accessory.dart';
import '../../widgets/accessory_card.dart';

class AvatarCustomization extends StatefulWidget {
  const AvatarCustomization({Key? key}) : super(key: key);

  @override
  _AvatarCustomizationState createState() => _AvatarCustomizationState();
}

class _AvatarCustomizationState extends State<AvatarCustomization> {
    
  Map<String, int> accessoryPrices = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize providers after build
      Provider.of<AccessoryProvider>(context, listen: false);
      Provider.of<UserProvider>(context, listen: false);
    });
  }

  Future<bool> _showConfirmationDialog(int totalCost) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar compra'),
          content: Text('¿Deseas gastar $totalCost puntos en estos accesorios?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false), // Return false
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: 
                () => Navigator.of(context).pop(true),  // Return true
            ),
          ],
        );
      },
    ) ?? false; 
  }
  
  void _showInsufficientPointsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Puntos insuficientes'),
          content: const Text('No tienes suficientes puntos para comprar estos accesorios.'),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
  
  void _saveChanges() async {
    final accessoryProvider = Provider.of<AccessoryProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    int totalCost = 0;
    for (var accessory in accessoryProvider.selectedAccessories) {
      if (!accessoryProvider.purchasedAccessories.contains(accessory)) {
        totalCost += accessory.points;
      }
    }

    if (totalCost > userProvider.points) {
      _showInsufficientPointsAlert();
      return;
    }

    
    if (totalCost > 0) {
      final confirm = await _showConfirmationDialog(totalCost);
      if (!confirm) {
        return;
      }
      
      userProvider.deductPoints(totalCost);
      accessoryProvider.saveAccessories();
      
      accessoryProvider.selectedAccessories.forEach((accessory) {
        if (!accessoryProvider.purchasedAccessories.contains(accessory)) {
          accessoryProvider.purchasedAccessories.add(accessory);                    
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se guardaron los cambios')),
    );
    Navigator.of(context).pop();
    accessoryProvider.saveAccessories();
  }

  Future<bool> _showDiscardDialog() async {
    final accessoryProvider = Provider.of<AccessoryProvider>(context, listen: false);
    
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Descartar cambios'),
          content: const Text('No se guardarán los cambios, ¿deseas descartarlos?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                accessoryProvider.undoChanges();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    
    if (result ?? false) {
      Navigator.of(context).pop();
    }    
    return (result ?? false); 
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showDiscardDialog,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Personalizar', 
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondo_principal.png'),
              fit: BoxFit.fill, // Changed from fill to cover
            ),
          ),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return SafeArea(
                child: Column(
                  children: [
                    _buildHeader(userProvider),
                    Expanded( // Wrapped in Expanded
                      child: _buildAvatarSection(),
                    ),
                    _buildAccessoriesList(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tienes',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),                
                ),
                Text(
                  '${userProvider.points-userProvider.usedPoints} Pts!',
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),                
              ],
            ),
          ),
          Column(
            children: [
              Image.asset(
                'assets/levels/${userProvider.level}.png',
                height: 50,
                width: 50,
              ),
              Text(
                'ⓘ Nivel: ${userProvider.level}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row( // Removed unnecessary Expanded
        children: [
          Expanded(
            flex: 2,
            child: _buildAvatarWithAccessories(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton('Guardar', Colors.green, _saveChanges),
                const SizedBox(height: 16),
                _buildActionButton('Descartar', Colors.blue, _showDiscardDialog),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithAccessories() {
    return Consumer<AccessoryProvider>( // Changed to Consumer pattern
      builder: (context, accessoryProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/avatar/avatar.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading avatar: $error');
                    return const SizedBox.shrink();
                  },
                ),
                ...accessoryProvider.selectedAccessories.map((accessory) {
                  return Positioned.fill(
                    child: Image.asset(
                      accessory.imageUrl,
                      fit: BoxFit.contain, // Changed from fill to contain
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading accessory: $error');
                        return const SizedBox.shrink();
                      },
                    ),
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAccessoriesList() {
    return SizedBox( // Changed from Container to SizedBox
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AccessoryProvider>(
          builder: (context, accessoryProvider, child) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: accessoryProvider.accessories.length,
              itemBuilder: (context, index) {
                final accessory = accessoryProvider.accessories[index];
                return GestureDetector(
                  onTap: () {
                    if (accessoryProvider.selectedAccessories.contains(accessory)) {
                      accessoryProvider.removeAccessory(accessory);
                    } else {
                      accessoryProvider.selectedAccessories
                          .where((a) => a.type == accessory.type)
                          .toList()
                          .forEach((a) => accessoryProvider.removeAccessory(a));
                      accessoryProvider.addAccessory(accessory);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 130,
                      child: AccessoryCard(accessory: accessory),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label),
    );
  }
}
