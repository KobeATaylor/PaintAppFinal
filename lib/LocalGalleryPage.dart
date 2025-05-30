import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalGalleryPage extends StatefulWidget {
  const LocalGalleryPage({super.key});

  @override
  State<LocalGalleryPage> createState() => _LocalGalleryPageState();
}

class _ImageWithMetadata {
  final File image;
  final String? title;
  final String? description;

  _ImageWithMetadata(this.image, this.title, this.description);
}

class _LocalGalleryPageState extends State<LocalGalleryPage> {
  List<_ImageWithMetadata> imageFilesWithMeta = [];

  @override
  void initState() {
    super.initState();
    loadImagesAndMetadata();
  }

  Future<void> loadImagesAndMetadata() async {
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();

    final pngFiles = allFiles.whereType<File>().where((file) => file.path.endsWith(".png")).toList();

    final snapshot = await FirebaseFirestore.instance.collection('paintings').get();
    final metadataList = snapshot.docs.map((doc) => doc.data()).toList();

    final List<_ImageWithMetadata> imagesWithMeta = [];

    for (final image in pngFiles) {
      final filename = image.uri.pathSegments.last;
      final metadata = metadataList.firstWhere(
            (data) => data['filename'] == filename,
        orElse: () => {},
      );

      final title = metadata['title'] ?? '';
      final description = metadata['description'] ?? '';

      imagesWithMeta.add(_ImageWithMetadata(image, title, description));
    }

    setState(() {
      imageFilesWithMeta = imagesWithMeta.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Paintings")),
      body: imageFilesWithMeta.isEmpty
          ? const Center(child: Text("No saved images yet."))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: imageFilesWithMeta.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final item = imageFilesWithMeta[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.grey[300],
                          child: Image.file(
                            item.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () async {
                          await item.image.delete();
                          setState(() {
                            imageFilesWithMeta.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if ((item.title ?? '').isNotEmpty || (item.description ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${item.title ?? ''}\n${item.description ?? ''}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
