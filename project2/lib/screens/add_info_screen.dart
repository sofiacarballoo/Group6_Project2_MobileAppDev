import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:project2/utils/colors.dart';
import 'package:project2/utils/utils.dart';

class AddInfoScreen extends StatefulWidget {
  const AddInfoScreen({Key? key}) : super(key: key);

  @override
  _AddInfoScreenState createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends State<AddInfoScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  int _age = 0;
  String _species = 'Cat';
  File? _image;
  String? _imageUrl;
  bool _isLoading = false;
  DocumentReference? _documentReference;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('extra_info')
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        setState(() {
          _bioController.text = data['bio'];
          _species = data['species'];
          _breedController.text = data['breed'];
          _age = data['age'];
          _ownerNameController.text = data['ownerName'];
          _imageUrl = data['picUrl'];
          _documentReference = docSnapshot.docs.first.reference;
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _breedController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = _imageUrl;
      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('extra_info')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child(
                'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      final extraInfo = {
        'bio': _bioController.text,
        'species': _species,
        'breed': _breedController.text,
        'age': _age,
        'ownerName': _ownerNameController.text,
        'picUrl': imageUrl,
      };

      if (_documentReference != null) {
        await _documentReference!.update(extraInfo);
      } else {
        _documentReference = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('extra_info')
            .add(extraInfo);
      }

      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Add Information'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _species,
                      onChanged: (String? newValue) {
                        setState(() {
                          _species = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Species',
                      ),
                      items: <String>['Cat', 'Dog', 'Fish', 'Hamster', 'Bird']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _breedController,
                      decoration: const InputDecoration(labelText: 'Breed'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Age: ',
                        style: TextStyle(fontSize: 16,)),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () {
                            setState(() {
                              if (_age > 0) _age--;
                            });
                          },
                        ),
                        Text(_age.toString()),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              _age++;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ownerNameController,
                      decoration:
                          const InputDecoration(labelText: 'Owner Name'),
                    ),
                    const SizedBox(height: 25),
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_image!),
                          )
                        : _imageUrl != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(_imageUrl!),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.upload),
                              ),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text('Upload Photo',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
