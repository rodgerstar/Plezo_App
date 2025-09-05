import 'package:flutter/material.dart';
import 'package:plezo_test/model/vehicle.dart';
import 'package:plezo_test/widgets/header.dart';
import 'package:plezo_test/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> vehicles = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final vehicleList = prefs.getStringList('vehicles') ?? [];
    setState(() {
      vehicles = vehicleList.map((v) {
        final parts = v.split('|');
        return Vehicle(
          id: parts[0],
          vehicleRegNo: parts[1],
          ownerName: parts[2],
          passengerCapacity: int.parse(parts[3]),
          status: parts[4] == 'true',
        );
      }).toList();
    });
  }

  Future<void> _deleteVehicle(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final vehicleList = prefs.getStringList('vehicles') ?? [];
    vehicleList.removeWhere((v) => v.split('|')[0] == id);
    await prefs.setStringList('vehicles', vehicleList);
    _loadVehicles();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vehicle deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = vehicles
        .where((v) => v.vehicleRegNo.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicles',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-vehicle').then((_) {
                      _loadVehicles();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: filteredVehicles.map((vehicle) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        vehicle.vehicleRegNo,
                        style: const TextStyle(
                          color: Color(0xFF5F368D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Owner: ${vehicle.ownerName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: vehicle.status,
                            onChanged: null,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddVehicleScreen(vehicle: vehicle),
                                ),
                              ).then((_) {
                                _loadVehicles();
                              });
                            },
                            child: const Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteVehicle(vehicle.id);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}