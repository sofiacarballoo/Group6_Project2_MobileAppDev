import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _ownerController = TextEditingController();
  final _locationController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        _nameController.text = userData['name'] ?? '';
        _breedController.text = userData['breed'] ?? '';
        _ageController.text = userData['age'] ?? '';
        _locationController.text = userData['location'] ?? '';
        _bioController.text = userData['bio'] ?? '';
        _ownerController.text = userData['owner'] ?? '';
        _likesController.text = userData['likes'] ?? '';
        _dislikesController.text = userData['dislikes'] ?? '';
      }
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'breed': _breedController.text,
        'age': _ageController.text,
        'location': _locationController.text,
        'bio': _bioController.text,
        'owner': _ownerController.text,
        'likes': _likesController.text,
        'dislikes': _dislikesController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _breedController,
                    label: 'Breed',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _ageController,
                    label: 'Age',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _ownerController,
                    label: 'Owner',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _likesController,
                    label: 'Likes',
                    icon: Icons.favorite,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _dislikesController,
                    label: 'Dislikes',
                    icon: Icons.thumb_down,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
