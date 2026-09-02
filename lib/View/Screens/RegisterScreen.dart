import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/Services/FirebaseAuthService.dart';
import 'package:movie_app/Services/FirestoreService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final countryController = TextEditingController();

  String? selectedGenre;

  final FirebaseAuthService authService =
      FirebaseAuthService();

  final FirestoreService firestoreService =
      FirestoreService();

  bool isLoading = false;

  Future<void> selectDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateOfBirthController.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    }
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final dateOfBirth =
        dateOfBirthController.text.trim();
    final country = countryController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword =
        confirmPasswordController.text.trim();

    if (name.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        dateOfBirth.isEmpty ||
        country.isEmpty ||
        selectedGenre == null ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.signUp(
        email: email,
        password: password,
      );

      await firestoreService.createUserProfile(
        name: name,
        username: username,
        phone: phone,
        dateOfBirth: dateOfBirth,
        country: country,
        favoriteGenre: selectedGenre!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully',
          ),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created, but profile could not be saved',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white54,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFB794F4),
      ),
      filled: true,
      fillColor: const Color(0xFF1C1C26),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF8B5CF6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 20,
            ),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6)
                        .withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.movie_creation_rounded,
                    color: Color(0xFFB794F4),
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Join Movie Night today',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 35),

                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Name',
                    icon: Icons.person_outline,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: usernameController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Username',
                    icon: Icons.alternate_email,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Email',
                    icon: Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Phone',
                    icon: Icons.phone_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: dateOfBirthController,
                  readOnly: true,
                  onTap: selectDateOfBirth,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Date of Birth',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: countryController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Country',
                    icon: Icons.public_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedGenre,
                  dropdownColor:
                      const Color(0xFF1C1C26),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Favorite Movie Genre',
                    icon: Icons.movie_filter_outlined,
                  ),
                  items: const [
                    'Action',
                    'Comedy',
                    'Drama',
                    'Horror',
                    'Romance',
                    'Fantasy',
                    'Animation',
                    'Thriller',
                    'Documentary',
                  ].map(
                    (genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGenre = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Password',
                    icon: Icons.lock_outline_rounded,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller:
                      confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: inputDecoration(
                    label: 'Confirm Password',
                    icon: Icons.lock_reset_rounded,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFFB794F4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dateOfBirthController.dispose();
    countryController.dispose();
    super.dispose();
  }
}
