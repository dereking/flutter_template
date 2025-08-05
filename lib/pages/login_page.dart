import 'package:flutter/material.dart';
import '../providers/app_info_provider.dart';
import '../services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  final _authService = AuthService();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _handleEmailAuth() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (_isLogin) {
          Navigator.pushReplacementNamed(context, "/chat");
        } else {
          // final AuthRegisterPost200Response? res =
          //     await _authService.signUpWithEmail(
          //   _emailController.text,
          //   _passwordController.text,
          // );
          // if (res == null || res.code != 200) {
          //   _showError(res == null ? "" : res.message ?? "");
          // }
          // Provider.of<AppInfoProvider>(context, listen: false).user = res!.data;
          // _showSuccess(res.message!);
        }

        // _showError(result['message']);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSocialAuth(
    Future<Map<String, dynamic>> Function() authMethod,
  ) async {
    setState(() => _isLoading = true);

    try {
      final result = await authMethod();
      if (result['success']) {
        _showSuccess(result['message']);
        Navigator.pushReplacementNamed(context, "/chat");
      } else {
        _showError(result['message']);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin ? '欢迎回来' : '创建账号',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: '电子邮箱',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入电子邮箱';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return '请输入有效的电子邮箱';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Input password';
                                  }
                                  // if (!RegExp(
                                  //         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  //     .hasMatch(value)) {
                                  //   return '请输入有效的电子邮箱';
                                  // }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _handleEmailAuth,
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : Text(_isLogin ? '登录' : '注册'),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin ? '没有账号？立即注册' : '已有账号？立即登录',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 32),
                        Text(
                          '或使用以下方式登录',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // _buildSocialButton(
                            //   icon: FontAwesomeIcons.google,
                            //   color: Colors.red,
                            //   onPressed: () => _handleSocialAuth(
                            //     _authService.signInWithGoogle,
                            //   ),
                            // ),
                            // _buildSocialButton(
                            //   icon: FontAwesomeIcons.facebook,
                            //   color: Colors.blue,
                            //   onPressed: () => _handleSocialAuth(
                            //     _authService.signInWithFacebook,
                            //   ),
                            // ),
                            _buildSocialButton(
                              icon: FontAwesomeIcons.microsoft,
                              color: Colors.grey,
                              onPressed: () => _handleSocialAuth(
                                _authService.signInWithMicrosoft,
                              ),
                            ),
                            // _buildSocialButton(
                            //   icon: FontAwesomeIcons.apple,
                            //   color: Colors.black,
                            //   onPressed: () => _handleSocialAuth(
                            //     _authService.signInWithApple,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: FaIcon(icon, color: color),
      onPressed: onPressed,
    );
  }
}
