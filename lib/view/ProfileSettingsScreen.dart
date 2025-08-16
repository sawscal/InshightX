import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:news_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? user;
  late DocumentReference userDocRef;

  bool _isLoading = false;
  bool _isEditingEmail = false;
  bool _isEditingUsername = false;

  String? _profileImageUrl;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    if (user != null) {
      userDocRef = _firestore.collection('users').doc(user!.uid);
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await userDocRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _usernameController.text = data['username'] ?? user?.displayName ?? 'Your Name';
        _profileImageUrl = data['profileImageUrl'];
      } else {
        _usernameController.text = user?.displayName ?? 'Your Name';
      }
      _emailController.text = user?.email ?? '';
    } catch (e) {
      debugPrint('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (pickedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      File file = File(pickedFile.path);

      // Upload to Firebase Storage
      final ref = _storage.ref().child('profile_images').child(user!.uid + '.jpg');
      await ref.putFile(file);

      // Get download URL
      final url = await ref.getDownloadURL();

      // Save URL to Firestore
      await userDocRef.set({'profileImageUrl': url}, SetOptions(merge: true));

      // Update local state to reflect image instantly
      setState(() {
        _profileImageUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_emailController.text.trim().isEmpty) {
        throw Exception('Email cannot be empty.');
      }

      await user?.updateEmail(_emailController.text.trim());
      await user?.reload();
      user = _auth.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email updated successfully')),
      );
      setState(() {
        _isEditingEmail = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please re-authenticate to update your email. Log out and log in again.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email: ${e.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update email: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUsername() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_usernameController.text.trim().isEmpty) {
        throw Exception('Username cannot be empty.');
      }

      // Update Firestore username field
      await userDocRef.set({'username': _usernameController.text.trim()}, SetOptions(merge: true));

      // Optionally update Firebase user displayName as well
      await user?.updateDisplayName(_usernameController.text.trim());
      await user?.reload();
      user = _auth.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully')),
      );
      setState(() {
        _isEditingUsername = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update username: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
   backgroundColor: Colors.white,
       appBar: AppBar(
      iconTheme: const IconThemeData(
      color: Colors.black, 
    ),
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black,
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/images/Animation - 1730377043122.gif') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: InkWell(
                          onTap: _isLoading ? null : _pickAndUploadImage,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: _isEditingUsername
                      ? TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'Username'),
                          autofocus: true,
                          enabled: !_isLoading,
                          onSubmitted: (_) => _updateUsername(),
                        )
                      : Text(_usernameController.text),
                  trailing: IconButton(
                    icon: Icon(_isEditingUsername ? Icons.check : Icons.edit),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_isEditingUsername) {
                              _updateUsername();
                            } else {
                              setState(() {
                                _isEditingUsername = true;
                              });
                            }
                          },
                  ),
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(Icons.email),
                  title: _isEditingEmail
                      ? TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          enabled: !_isLoading,
                          onSubmitted: (_) => _updateEmail(),
                        )
                      : Text(_emailController.text),
                  trailing: IconButton(
                    icon: Icon(_isEditingEmail ? Icons.check : Icons.edit),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_isEditingEmail) {
                              _updateEmail();
                            } else {
                              setState(() {
                                _isEditingEmail = true;
                              });
                            }
                          },
                  ),
                ),
                const Divider(),

                // SwitchListTile(
                //   value: themeProvider.themeMode == ThemeMode.dark,
                //   onChanged: (val) {
                //     themeProvider.toggleTheme(val);
                //   },
                //   title: const Text('Dark Mode'),
                // ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    _logout();
                  },
                ),
              ],
            ),
    );
  }
}
