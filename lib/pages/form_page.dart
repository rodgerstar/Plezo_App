import 'package:flutter/material.dart';
import 'package:plezo_test/model/user.dart';
import 'package:plezo_test/services/storage_service.dart';
import 'package:plezo_test/pages/table_page.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final storageService = StorageService();

    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final age = int.tryParse(ageController.text);
                if (name.isNotEmpty && age != null) {
                  final user = User(name: name, age: age);
                  final users = await storageService.getUsers();
                  users.add(user);
                  await storageService.saveUsers(users);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User added')),
                  );
                  nameController.clear();
                  ageController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid name and age')),
                  );
                }
              },
              child: const Text('Add User'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TablePage()),
                );
              },
              child: const Text('View Users'),
            ),
          ],
        ),
      ),
    );
  }
}