import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrScreen extends StatefulWidget {
  @override
  _OcrScreenState createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  File? selectedMedia;

  void _scanText(BuildContext context) async {
    List<MediaFile>? media = await GalleryPicker.pickMedia(context: context, singleMedia: true);
    if (media != null && media.isNotEmpty) {
      var data = await media.first.getFile();
      setState(() {
        selectedMedia = data;
      });
      print("data entered");
    } else {
      print('error is here');
    }
  }

  Widget _imageUI() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("Enter the image"),
      );
    }
    return Center(
      child: Image.file(selectedMedia!, width: 200,),
    );
  }

  Widget _textFromImage() {

    if (selectedMedia == '') {
      return const Center(
        child: Text("No text is there"),
      );
    }
    else if (selectedMedia == null) {
      return const Center(
        child: Text("No Result"),
      );
    }
    return FutureBuilder(
      future: _extractText(selectedMedia!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(snapshot.data ?? ""),
          ),
        );
      },
    );
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Text', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align the children to the start (left)
            children: [
              Text("Selected image is:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _imageUI(),
              SizedBox(height: 60),
              Text("Extracted text is:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _textFromImage(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scanText(context),
        backgroundColor: Colors.black54, // Button background color
        child: Icon(Icons.camera_alt, color: Colors.white), // Button icon color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the FAB
    );
  }
}
