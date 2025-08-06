import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import '../providers/user_provider.dart';
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
          Provider.of<UserProvider>(context, listen: false).navigateTo("/home");
        } else {
          // final AuthRegisterPost200Response? res =
          //     await _authService.signUpWithEmail(
          //   _emailController.text,
          //   _passwordController.text,
          // );
          // if (res == null || res.code != 200) {
          //   _showError(res == null ? "" : res.message ?? "");
          // }
          // Provider.of<UserProvider>(context, listen: false).user = res!.data;
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
        // Provider.of<UserProvider>(context, listen: false).loggedInUser = {"name":"ked"};
        Provider.of<UserProvider>(context, listen: false).navigateTo("/home");
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
                          _isLogin
                              ? AppLocalizations.of(context)!.login
                              : AppLocalizations.of(context)!.register,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(
                                    context,
                                  )!.email,
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.pleaseInputEmailAddress;
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.pleaseInputValidEmailAddress;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(
                                    context,
                                  )!.password,
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.pleaseInputPassword;
                                  }
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
                                      : Text(
                                          _isLogin
                                              ? AppLocalizations.of(
                                                  context,
                                                )!.login
                                              : AppLocalizations.of(
                                                  context,
                                                )!.register,
                                        ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? AppLocalizations.of(context)!.noAccount
                                      : AppLocalizations.of(
                                          context,
                                        )!.haveAccount,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 32),
                        Text(
                          AppLocalizations.of(context)!.orLoginWithThose  ,
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
                            _buildSocialButton(
                              icon: FontAwesomeIcons.apple,
                              color: Colors.black,
                              onPressed: () => _handleSocialAuth(
                                  _authService.signInWithApple,
                              ),
                            ),
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
