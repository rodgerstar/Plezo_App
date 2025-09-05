import 'package:flutter/material.dart';
import 'package:plezo_test/model/department.dart';
import 'package:plezo_test/widgets/header.dart';
import 'package:plezo_test/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_department_screen.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  List<Department> departments = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final prefs = await SharedPreferences.getInstance();
    final departmentList = prefs.getStringList('departments') ?? [];
    setState(() {
      departments = departmentList.map((d) {
        final parts = d.split('|');
        return Department(
          id: parts[0],
          name: parts[1],
          code: parts[2],
          status: parts[3] == 'true',
        );
      }).toList();
    });
  }

  Future<void> _deleteDepartment(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final departmentList = prefs.getStringList('departments') ?? [];
    departmentList.removeWhere((d) => d.split('|')[0] == id);
    await prefs.setStringList('departments', departmentList);
    _loadDepartments();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Department deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDepartments = departments
        .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
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
              'Departments',
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
                    Navigator.pushNamed(context, '/add-department').then((_) {
                      _loadDepartments();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: filteredDepartments.map((department) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        department.name,
                        style: const TextStyle(
                          color: Color(0xFF5F368D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Code: ${department.code}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: department.status,
                            onChanged: null,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddDepartmentScreen(department: department),
                                ),
                              ).then((_) {
                                _loadDepartments();
                              });
                            },
                            child: const Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteDepartment(department.id);
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