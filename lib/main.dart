import 'package:flutter/material.dart';
import 'package:plezo_test/pages/login_page.dart';
import 'package:plezo_test/pages/register_page.dart';
import 'screens/dashboard_screen.dart';
import 'screens/vehicle_list_screen.dart';
import 'screens/add_vehicle_screen.dart';
import 'screens/department_list_screen.dart';
import 'screens/add_department_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plezo',
      theme: ThemeData(
        primaryColor: const Color(0xFF5F368D),
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5F368D),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF5F368D),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      initialRoute: '/login', // Start at login page
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardScreen(),
        '/vehicles': (context) => const VehicleListScreen(),
        '/add-vehicle': (context) => const AddVehicleScreen(),
        '/departments': (context) => const DepartmentListScreen(),
        '/add-department': (context) => const AddDepartmentScreen(),
        
        // '/branches': (context) => const Scaffold(body: Center(child: Text('Branches Page'))),
        // '/parcels': (context) => const Scaffold(body: Center(child: Text('Parcels Page'))),
      },
    );
  }
}