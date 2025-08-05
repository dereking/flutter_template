import 'package:flutter/material.dart';
import '../providers/app_info_provider.dart';
import 'package:provider/provider.dart';

class HeaderUserPanel extends StatefulWidget {
  const HeaderUserPanel({super.key});

  @override
  State<HeaderUserPanel> createState() => _HeaderUserPanelState();
}

class _HeaderUserPanelState extends State<HeaderUserPanel> {
  @override
  Widget build(BuildContext context) {
    AppInfoProvider provider = Provider.of<AppInfoProvider>(context);
    if (provider.loggedInUser == null) {
      return TextButton(
        onPressed: login,
        child: const Text('Login'),
      );
    }
    return Tooltip(
      message: provider.loggedInUser!.email,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            _buildAvatar(),
            Text(provider.loggedInUser!.name),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.network(
          "https://th.bing.com/th?id=OSK.f7f4e9af4e9ca9ea2585e5df12ff1c5f&w=80&h=80&c=7&o=6&dpr=2&pid=SANGAM",
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void login() {
    // RuiScaffold.pushNamed('/login');
    //Navigator.pushNamed(context, "/login");
    Provider.of<AppInfoProvider>(context, listen: false).curPage = "/login";
  }
}
