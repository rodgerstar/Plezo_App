import 'package:flutter/material.dart';
import 'package:plezo_test/model/user.dart';
import 'package:plezo_test/services/storage_service.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final StorageService storageService = StorageService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final loadedUsers = await storageService.getUsers();
    setState(() {
      users = loadedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: users.isEmpty
          ? const Center(child: Text('No users added'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                ],
                rows: users
                    .map((user) => DataRow(cells: [
                          DataCell(Text(user.name)),
                          DataCell(Text(user.age.toString())),
                        ]))
                    .toList(),
              ),
            ),
    );
  }
}