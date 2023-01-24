import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Edit Profile Screen'),
              CircleAvatar(
                child: const Icon(Icons.person),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ));
  }
}
