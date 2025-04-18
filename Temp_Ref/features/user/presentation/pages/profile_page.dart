import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../domain/entities/user.dart';
import '../providers/user_providers.dart';
import '../providers/user_state.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    final user = userState.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context, ref),
          ),
        ],
      ),
      body: userState.status == UserStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileContent(context, user, userState),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    UserEntity? user,
    UserState userState,
  ) {
    if (userState.status == UserStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${userState.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retry loading user
                final userNotifier = ProviderScope.containerOf(context)
                    .read(userNotifierProvider.notifier);
                userNotifier.getUser();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (user == null) {
      return const Center(
        child: Text('No user data available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile picture
          _buildProfilePicture(context, user),
          const SizedBox(height: 24),

          // User name
          Text(
            user.fullName ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Offline indicator
          if (userState.isOffline)
            const Chip(
              label: Text('Offline'),
              backgroundColor: Colors.orange,
              labelStyle: TextStyle(color: Colors.white),
            ),
          const SizedBox(height: 24),

          // User info
          _buildInfoCard('Email', user.email ?? 'Not provided'),
          _buildInfoCard('Phone', user.phoneNumber ?? 'Not provided'),
          _buildInfoCard('Address', user.address ?? 'Not provided'),
          _buildInfoCard('Country', user.country ?? 'Not provided'),
          _buildInfoCard(
            'Date of Birth',
            user.dateOfBirth != null
                ? '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}'
                : 'Not provided',
          ),
          _buildInfoCard(
            'Gender',
            user.gender != null
                ? user.gender.toString().split('.').last
                : 'Not provided',
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context, UserEntity user) {
    final hasProfilePic = user.profilePhoto != null &&
        user.profilePhoto!.isNotEmpty;

    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: hasProfilePic
              ? NetworkImage(user.profilePhoto!)
              : null,
          child: !hasProfilePic
              ? const Icon(Icons.person, size: 50, color: Colors.grey)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () => _updateProfilePicture(context),
              constraints: const BoxConstraints(
                minHeight: 36,
                minWidth: 36,
              ),
              iconSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfilePicture(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final userNotifier =
          ProviderScope.containerOf(context).read(userNotifierProvider.notifier);
      await userNotifier.uploadProfilePicture(File(pickedFile.path));
    }
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(authNotifierProvider.notifier).signOut();
    
    if (success) {
      // Reset user state
      ref.read(userNotifierProvider.notifier).reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign out')),
      );
    }
  }
}

/// Page for editing user profile
class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    final user = userState.user;
    
    // Create the form key
    final _formKey = GlobalKey<FormState>();
    
    // Form controllers
    final nameController = TextEditingController(text: user?.fullName);
    final emailController = TextEditingController(text: user?.email);
    final phoneController = TextEditingController(text: user?.phoneNumber);
    final addressController = TextEditingController(text: user?.address);
    final countryController = TextEditingController(text: user?.country);
    
    // Selected gender
    Gender? selectedGender = user?.gender;
    
    // Selected date of birth
    DateTime? selectedDate = user?.dateOfBirth;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Update user
                final updatedUser = user?.copyWith(
                  fullName: nameController.text,
                  email: emailController.text,
                  phoneNumber: phoneController.text,
                  address: addressController.text,
                  country: countryController.text,
                  gender: selectedGender,
                  dateOfBirth: selectedDate,
                );
                
                if (updatedUser != null) {
                  await ref.read(userNotifierProvider.notifier).updateUser(updatedUser);
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              // Phone
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              // Address
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Country
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Gender selection
              DropdownButtonFormField<Gender>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: Gender.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Gender? value) {
                  selectedGender = value;
                },
              ),
              const SizedBox(height: 16),
              
              // Date of birth
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : '',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
