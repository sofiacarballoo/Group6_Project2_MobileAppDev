import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot> _userDocument;

  @override
  void initState() {
    super.initState();
    _userDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userDocument,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User document does not exist.'));
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 16.0), // Adjusted padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover image placeholder
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userData['coverImage'] ?? 'https://via.placeholder.com/800x200'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData['profileImage'] ?? 'https://via.placeholder.com/120'),
                        child: const Icon(Icons.pets, size: 60, color: Colors.white), 
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display user information in cards
                    _buildProfileCard(
                      'Basic Information',
                      [
                        _buildProfileField('Name', userData['name'] ?? 'No Name'),
                        _buildProfileField('Breed', userData['breed'] ?? 'No Breed'),
                        _buildProfileField('Age', userData['age'] ?? 'No Age'),
                        _buildProfileField('Location', userData['location'] ?? 'No Location'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProfileCard(
                      'About',
                      [
                        _buildProfileField('Owner', userData['owner'] ?? 'No Owner'),
                        _buildProfileField('Bio', userData['bio'] ?? 'No Bio'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProfileCard(
                      'Preferences',
                      [
                        _buildProfileField('Likes', userData['likes'] ?? 'No Likes'),
                        _buildProfileField('Dislikes', userData['dislikes'] ?? 'No Dislikes'),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10, 
                right: 16,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilePage()),
                    ).then((_) {
                      setState(() {
                        _userDocument = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                      });
                    });
                  },
                  child: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white, 
                    minimumSize: const Size(150, 50), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), 
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
