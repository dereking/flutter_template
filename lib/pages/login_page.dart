import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../models/user_session.dart';
import '../providers/app_state_provider.dart';
import '../providers/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final state = context.read<AppStateProvider>();
    _emailController = TextEditingController(text: state.lastUserEmail);
    _passwordController = TextEditingController(text: state.lastUserPassword);

    _emailController.addListener(() {
      // 每次文本改变，更新 provider
      state.lastUserEmail = _emailController.text;
    });

    _passwordController.addListener(() {
      // 每次文本改变，更新 provider
      state.lastUserPassword = _passwordController.text;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  /// 登录
  Future<void> _login() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.isLoggedIn) {
      _showSuccess("已登录");
      return;
    }

    final UserSession? user = await userProvider.login(
      _emailController.text,
      _passwordController.text,
    );
    if (user == null) {
      _showError("登录失败");
      return;
    }
    _showSuccess("登录成功");
    userProvider.navigateTo("/home");
  }

  /// 注册
  Future<void> _register() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserSession? user = await userProvider.signUp(
      _emailController.text,
      _passwordController.text,
    );
    if (user == null) {
      _showError("reg失败");
    } else {
      _showSuccess("reg成功");
      userProvider.navigateTo("/home");
    }
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _login();
      } else {
        await _register();
      }

      // _showError(result['message']);
    } catch (e) {
      print("login error $e");
      _showError("登录失败,$e");
    } finally {
      setState(() => _isLoading = false);
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
  Widget build(BuildContext context) {
    final appState = Provider.of<UserProvider>(context);

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
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
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
                          Consumer<AppStateProvider>(
                            builder: (context, appState, child) {
                              return Form(
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
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                            ? LoadingAnimationWidget.staggeredDotsWave(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                size: 16,
                                              )
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
                                            ? AppLocalizations.of(
                                                context,
                                              )!.noAccount
                                            : AppLocalizations.of(
                                                context,
                                              )!.haveAccount,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // ..._build3rdLoginButtons(),
                        ],
                      ),
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

  List<Widget> _build3rdLoginButtons() {
    return [
      const Divider(height: 32),
      Text(
        AppLocalizations.of(context)!.orLoginWithThose,
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
              Provider.of<UserProvider>(
                context,
                listen: false,
              ).signInWithMicrosoft,
            ),
          ),
          _buildSocialButton(
            icon: FontAwesomeIcons.apple,
            color: Colors.black,
            onPressed: () => _handleSocialAuth(
              Provider.of<UserProvider>(context, listen: false).signInWithApple,
            ),
          ),
        ],
      ),
    ];
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
