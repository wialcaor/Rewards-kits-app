import 'package:challenge_champs/models/user.dart';
import 'package:flutter/material.dart';
import '../models/accessory.dart';
import 'package:provider/provider.dart';

class AccessoryCard extends StatelessWidget {
  final Accessory accessory;
  final VoidCallback? onTap;

  const AccessoryCard({
    Key? key,
    required this.accessory,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessoryProvider = Provider.of<AccessoryProvider>(context, listen: false);
    final isParent = userProvider.isParent;
    final hasCost = !(accessory.points == 0 || accessoryProvider.purchasedAccessories.contains(accessory));


    return GestureDetector(
      onTap: isParent
        ? () {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskEditorScreen(initialTask: task),
              ),
            );*/
          }
        : null,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                  accessory.thumbnail,
                  fit: BoxFit.contain,
                  height: 150,
                  width: double.infinity,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color : hasCost? Colors.blue:const Color.fromARGB(0, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: hasCost? Text(
                  '${accessory.points}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ):null,
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                accessory.type,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (accessory.isVisible)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
