import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _displayName = 'Shahril';
  String _displayAge = '20';
  String _displayLocation = 'Rembau';
  String _selectedFitnessLevel = 'Intermediate';
  String _selectedInterest = 'Cycling';
  File? _profileImage;

  final List<String> _fitnessLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];
  final List<String> _interests = [
    'Hiking',
    'Camping',
    'Cycling',
    'Jogging',
    'Swimming'
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = _displayName;
    _ageController.text = _displayAge;
    _locationController.text = _displayLocation;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
        return;
      }
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    setState(() {
      _displayName = _nameController.text.isNotEmpty ? _nameController.text : _displayName;
      _displayAge = _ageController.text.isNotEmpty ? _ageController.text : _displayAge;
      _displayLocation = _locationController.text.isNotEmpty ? _locationController.text : _displayLocation;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header with Camera
              GestureDetector(
                onTap: _showImagePickerDialog,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                _displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                _selectedFitnessLevel,
                style: const TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 20),

              // Personal Information Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color(0xFF1A2A1A),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          labelStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake, color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _locationController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          labelStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on, color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Preferences Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color(0xFF1A2A1A),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Fitness Level',
                          labelStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.fitness_center, color: Colors.white54),
                        ),
                        style: const TextStyle(color: Colors.white),
                        value: _selectedFitnessLevel,
                        items: _fitnessLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFitnessLevel = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Preferred Activity',
                          labelStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.hiking, color: Colors.white54),
                        ),
                        style: const TextStyle(color: Colors.white),
                        value: _selectedInterest,
                        items: _interests.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedInterest = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Save Profile'),
                ),
              ),
              const SizedBox(height: 15),

              // Current Profile Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Profile Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Name: $_displayName', style: const TextStyle(color: Colors.white70)),
                    Text('Age: $_displayAge', style: const TextStyle(color: Colors.white70)),
                    Text('Location: $_displayLocation', style: const TextStyle(color: Colors.white70)),
                    Text('Fitness Level: $_selectedFitnessLevel', style: const TextStyle(color: Colors.white70)),
                    Text('Preferred Activity: $_selectedInterest', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}