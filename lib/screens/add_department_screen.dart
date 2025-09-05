import 'package:flutter/material.dart';
import 'package:plezo_test/model/department.dart';
import 'package:plezo_test/widgets/header.dart';
import 'package:plezo_test/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

class AddDepartmentScreen extends StatefulWidget {
  final Department? department;

  const AddDepartmentScreen({super.key, this.department});

  @override
  _AddDepartmentScreenState createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String code = '';
  bool status = true;

  @override
  void initState() {
    super.initState();
    if (widget.department != null) {
      name = widget.department!.name;
      code = widget.department!.code;
      status = widget.department!.status;
    }
  }

  Future<void> _saveDepartment() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final departmentList = prefs.getStringList('departments') ?? [];
      final id = widget.department?.id ?? const Uuid().v4();
      final departmentData = '$id|$name|$code|$status';
      if (widget.department == null) {
        departmentList.add(departmentData);
      } else {
        final index = departmentList.indexWhere((d) => d.split('|')[0] == id);
        if (index != -1) {
          departmentList[index] = departmentData;
        }
      }
      await prefs.setStringList('departments', departmentList);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.department == null ? 'Department added' : 'Department updated')),
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
                widget.department == null ? 'Add New Department' : 'Edit Department',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  labelText: 'Department Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department name';
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: code,
                decoration: InputDecoration(
                  labelText: 'Department Code',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department code';
                  }
                  return null;
                },
                onChanged: (value) {
                  code = value;
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
                    onPressed: _saveDepartment,
                    child: Text(widget.department == null ? 'Add' : 'Update'),
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