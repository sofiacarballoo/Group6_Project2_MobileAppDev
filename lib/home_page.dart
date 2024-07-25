import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeContent(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final _postController = TextEditingController();

  HomeContent({super.key});

  Future<void> _post() async {
    if (_postController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').add({
        'text': _postController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
      _postController.clear();
    }
  }

  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      String name = userDoc['name'] ?? 'Unknown';
      print('Retrieved name for user $userId: $name');
      return name;
    } catch (e) {
      print('Error retrieving name for user $userId: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              decoration: const InputDecoration(labelText: "What's on your mind?"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _post,
              child: const Text('Post'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      return FutureBuilder<String>(
                        future: _getUserName(document['userId']),
                        builder: (context, userNameSnapshot) {
                          if (userNameSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              title: Text(document['text']),
                              subtitle: const Text('Loading...'),
                            );
                          }
                          return ListTile(
                            title: Text(document['text']),
                            subtitle: Text(userNameSnapshot.data ?? 'Unknown'),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
