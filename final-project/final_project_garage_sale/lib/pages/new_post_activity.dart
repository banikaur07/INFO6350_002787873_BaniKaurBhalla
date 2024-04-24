import 'dart:io';

import 'package:final_project_garage_sale/services/database_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class NewPostActivity extends StatefulWidget {
  const NewPostActivity({Key? key}) : super(key: key);

  @override
  State<NewPostActivity> createState() => _NewPostActivityState();
}

class _NewPostActivityState extends State<NewPostActivity> {
  TextEditingController itemTitle = TextEditingController();
  TextEditingController itemPrice = TextEditingController();
  TextEditingController itemDescription = TextEditingController();
  List<File?> images = [];
  List<String> imageUrls = [];
  final ImagePicker imagePicker = ImagePicker();

  final _priceValidator = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  Future<void> chooseImage() async {
    final selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        if (images.length < 4) {
          images.add(File(selectedImage.path));
        }
      });
    }
  }

  Future<void> captureImage() async {
    final selectedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      setState(() {
        if (images.length < 4) {
          images.add(File(selectedImage.path));
        }
      });
    }
  }

  Future<void> uploadImages() async {
    for (File? image in images) {
      if (image != null) {
        String imageUrl = await uploadImageToFirebase(image);
        imageUrls.add(imageUrl);
      }
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(image);
      String imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  Future<void> uploadItemDetails() async {
    String id = randomAlphaNumeric(10);
    String title = itemTitle.text;
    String price = itemPrice.text;
    String description = itemDescription.text;

    await uploadImages();

    Map<String, dynamic> itemDetails = {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'images': imageUrls,
    };

    await DatabaseMethods().addItemDetails(itemDetails, id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Uploaded'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to browse page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: itemTitle,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: itemPrice,
              inputFormatters: [_priceValidator],
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: itemDescription,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: images.length < 4 ? chooseImage : null,
                  child: const Text('Choose Image'),
                ),
                ElevatedButton(
                  onPressed: images.length < 4 ? captureImage : null,
                  child: const Text('Capture Image'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: List.generate(
                images.length,
                (index) => Image.file(
                  images[index]!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: images.isNotEmpty ? uploadItemDetails : null,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
