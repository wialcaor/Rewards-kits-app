import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/parent/parent_dashboard.dart';
import 'screens/child/child_dashboard.dart';
import 'models/task.dart';
import 'models/reward.dart';
import 'models/accessory.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => AccessoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Rewards App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(227, 246, 253, 1),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Champs'),
        actions: [
          // Botón para cambiar entre perfil padre/hijo
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Column(                
                children: [
                  SizedBox(
                    height: 30,  
                    child:  Transform.scale( 
                      scale: 0.75,  
                      child: Switch(
                        value: userProvider.isParent,
                        onChanged: (value) => userProvider.toggleUserType(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20), 
                    child: Text(userProvider.isParent ? "Modo padre" : "Modo hijo"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return userProvider.isParent
              ? const ParentDashboard()
              : const ChildDashboard();
        },
      ),
    );
  }
}