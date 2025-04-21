import 'dart:async';
import 'dart:math';
import 'Gradient.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();



  Future<void> savePainting(String title, String description) async {
    try {
      await FirebaseFirestore.instance.collection('paintings').add({
        'title': title,
        'Description': description,
        'PaintingUrl': '',
        'CreatedAt': Timestamp.now(),
        'UpdatedAt': Timestamp.now(),
      });
      debugPrint("Painting saved!");
    } catch (e) {
      debugPrint("Error saving painting: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paint Canvas")),
      body: AnimatedBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16), // spacing between the fields
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final desc = _descController.text.trim();
                  savePainting(title, desc);
                },
                child: const Text("Save to Firebase"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}