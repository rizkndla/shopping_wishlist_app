import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;
  late Animation<double> _floatAnimation1;
  late Animation<double> _floatAnimation2;
  late Animation<double> _floatAnimation3;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _floatAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _floatAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _floatAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      print('Registration successful!');
      // TODO: Navigate to login or dashboard
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background (same as login)
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFf7f4f0),
                      Color(0xFFeae6e0),
                      Color(0xFFf7f4f0),
                      Color(0xFFeae6e0),
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75],
                    transform: GradientRotation(
                      _gradientAnimation.value * 3.14 * 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Floating Shapes (same as login)
          _buildFloatingShapes(),

          // Main Content
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF1c1c1c)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF325eba),
                          Color(0xFF4a7ad6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF325eba).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),

                  SizedBox(height: 24),

                  // Title
                  Column(
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1c1c1c),
                          letterSpacing: -1.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Join WishListify today',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1c1c1c).withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  // Glassmorphism Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Color(0xFFf7f4f0).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Color(0xFF325eba).withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF1c1c1c).withOpacity(0.1),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 30,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF1c1c1c).withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Full name',
                                hintStyle: TextStyle(
                                  color: Color(0xFF1c1c1c).withOpacity(0.4),
                                ),
                                prefixIcon: Container(
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF325eba).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.person_rounded, 
                                      color: Color(0xFF325eba)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, 
                                  vertical: 16,
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF1c1c1c),
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 20),

                          // Email Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF1c1c1c).withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                hintStyle: TextStyle(
                                  color: Color(0xFF1c1c1c).withOpacity(0.4),
                                ),
                                prefixIcon: Container(
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF325eba).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.email_rounded, 
                                      color: Color(0xFF325eba)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, 
                                  vertical: 16,
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF1c1c1c),
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 20),

                          // Password Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF1c1c1c).withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Color(0xFF1c1c1c).withOpacity(0.4),
                                ),
                                prefixIcon: Container(
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF325eba).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.lock_rounded, 
                                      color: Color(0xFF325eba)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword 
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: Color(0xFF325eba).withOpacity(0.6),
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, 
                                  vertical: 16,
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF1c1c1c),
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 20),

                          // Confirm Password Field
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF1c1c1c).withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: 'Confirm password',
                                hintStyle: TextStyle(
                                  color: Color(0xFF1c1c1c).withOpacity(0.4),
                                ),
                                prefixIcon: Container(
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF325eba).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.lock_outline_rounded, 
                                      color: Color(0xFF325eba)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword 
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: Color(0xFF325eba).withOpacity(0.6),
                                  ),
                                  onPressed: _toggleConfirmPasswordVisibility,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, 
                                  vertical: 16,
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF1c1c1c),
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 30),

                          // Register Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF325eba),
                                  Color(0xFF4a7ad6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF325eba).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _isLoading ? null : _register,
                                child: Stack(
                                  children: [
                                    // Shimmer Effect
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return Positioned(
                                          left: -100 + (_controller.value * 200),
                                          child: Container(
                                            width: 100,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.white.withOpacity(0.3),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Center(
                                      child: _isLoading
                                          ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation(Colors.white),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person_add_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Create Account',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Color(0xFF1c1c1c).withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
GestureDetector(
  onTap: () {
    // Navigate back to login screen
    Navigator.pushNamed(context, '/login');
  },
  child: Text(
    'Sign In',
    style: TextStyle(
      color: Color(0xFF325eba),
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    ),
  ),
),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingShapes() {
    return Stack(
      children: [
        // Shape 1
        AnimatedBuilder(
          animation: _floatAnimation1,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.1,
              child: Transform.translate(
                offset: Offset(0, _floatAnimation1.value * 20 - 10),
                child: Transform.rotate(
                  angle: _floatAnimation1.value * 3.14,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF325eba).withOpacity(0.1),
                          Color(0xFF4a7ad6).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Shape 2
        AnimatedBuilder(
          animation: _floatAnimation2,
          builder: (context, child) {
            return Positioned(
              right: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.6,
              child: Transform.translate(
                offset: Offset(0, _floatAnimation2.value * 20 - 10),
                child: Transform.rotate(
                  angle: _floatAnimation2.value * 3.14,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF325eba).withOpacity(0.1),
                          Color(0xFF4a7ad6).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Shape 3
        AnimatedBuilder(
          animation: _floatAnimation3,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * 0.2,
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: Transform.translate(
                offset: Offset(0, _floatAnimation3.value * 20 - 10),
                child: Transform.rotate(
                  angle: _floatAnimation3.value * 3.14,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF325eba).withOpacity(0.1),
                          Color(0xFF4a7ad6).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}