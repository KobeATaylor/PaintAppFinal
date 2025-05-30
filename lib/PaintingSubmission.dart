import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaintingSubmission extends StatefulWidget {
  final String imageFilename;

  const PaintingSubmission({super.key, required this.imageFilename});

  @override
  State<PaintingSubmission> createState() => _PaintingSubmissionState();
}

class _PaintingSubmissionState extends State<PaintingSubmission> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> savePainting(String filename, String title, String description) async {
    try {
      await FirebaseFirestore.instance.collection('paintings').add({
        'filename': filename,
        'title': title,
        'description': description,
        'createdAt': Timestamp.now(),
      });
      debugPrint("Painting metadata saved!");
    } catch (e) {
      debugPrint("Error saving painting: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paint Canvas")),
      body: Center(
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
            const SizedBox(height: 16),
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
                savePainting(widget.imageFilename, title, desc);
              },
              child: const Text("Save to Firestore"),
            ),
          ],
        ),
      ),
    );
  }
}