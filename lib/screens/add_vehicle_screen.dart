import 'package:flutter/material.dart';
import 'package:plezo_test/model/vehicle.dart';
import 'package:plezo_test/widgets/header.dart';
import 'package:plezo_test/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

class AddVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const AddVehicleScreen({super.key, this.vehicle});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String vehicleRegNo = '';
  String ownerName = '';
  String passengerCapacity = '';
  bool status = true;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      vehicleRegNo = widget.vehicle!.vehicleRegNo;
      ownerName = widget.vehicle!.ownerName;
      passengerCapacity = widget.vehicle!.passengerCapacity.toString();
      status = widget.vehicle!.status;
    }
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final vehicleList = prefs.getStringList('vehicles') ?? [];
      final id = widget.vehicle?.id ?? const Uuid().v4();
      final vehicleData = '$id|$vehicleRegNo|$ownerName|$passengerCapacity|$status';
      if (widget.vehicle == null) {
        vehicleList.add(vehicleData);
      } else {
        final index = vehicleList.indexWhere((v) => v.split('|')[0] == id);
        if (index != -1) {
          vehicleList[index] = vehicleData;
        }
      }
      await prefs.setStringList('vehicles', vehicleList);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.vehicle == null ? 'Vehicle added' : 'Vehicle updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vehicle == null ? 'Add New Vehicle' : 'Edit Vehicle',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: vehicleRegNo,
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration No',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle registration number';
                  }
                  return null;
                },
                onChanged: (value) {
                  vehicleRegNo = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: ownerName,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter owner name';
                  }
                  return null;
                },
                onChanged: (value) {
                  ownerName = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: passengerCapacity,
                decoration: InputDecoration(
                  labelText: 'Passenger Capacity',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter passenger capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  passengerCapacity = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value ?? true;
                      });
                    },
                  ),
                  const Text('Active'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _saveVehicle,
                    child: Text(widget.vehicle == null ? 'Add' : 'Update'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFffc107),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}