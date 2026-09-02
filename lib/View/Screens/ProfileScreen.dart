import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/Services/FirestoreService.dart';
import 'package:movie_app/Services/FirebaseAuthService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final FirebaseAuthService authService = FirebaseAuthService();

  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await firestoreService.getUserProfile();

      if (!mounted) return;

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    await authService.logOut();

    if (!mounted) return;

    Navigator.pop(context);
  }

  String getCreatedDate() {
    final createdAt = profile?['createdAt'];

    if (createdAt is Timestamp) {
      final date = createdAt.toDate();

      return '${date.day}/${date.month}/${date.year}';
    }

    return 'Not available';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF101014),

      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF101014),
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            )
          : profile == null
          ? const Center(
              child: Text(
                'Firestore connection failed',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  const SizedBox(height: 15),

                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFFB794F4),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    profile!['name'] ?? 'No Name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '@${profile!['username'] ?? 'username'}',
                    style: const TextStyle(color: Colors.white54, fontSize: 15),
                  ),

                  const SizedBox(height: 35),

                  profileItem(
                    icon: Icons.person_outline,
                    title: 'Name',
                    value: profile!['name'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.alternate_email,
                    title: 'Username',
                    value: profile!['username'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: user?.email ?? profile!['email'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: profile!['phone'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.cake_outlined,
                    title: 'Date of Birth',
                    value: profile!['dateOfBirth'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.public_outlined,
                    title: 'Country',
                    value: profile!['country'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.movie_filter_outlined,
                    title: 'Favorite Movie Genre',
                    value: profile!['favoriteGenre'] ?? 'Not available',
                  ),

                  const SizedBox(height: 14),

                  profileItem(
                    icon: Icons.calendar_month_outlined,
                    title: 'Account Created',
                    value: getCreatedDate(),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFB794F4)),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
