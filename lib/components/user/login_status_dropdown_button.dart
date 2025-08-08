import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_session.dart';

class ProfileItem {
  final String title;
  final String value;
  final IconData icon;
  final Function onTap;

  ProfileItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });
}

class LoginStatusDropdownButton extends StatelessWidget {
  final UserSession? user;
  final Function()? onTapLogin;
  final Function()? onTapLogout;
  final Function()? onMySubscription;

  const LoginStatusDropdownButton({
    super.key,
    required this.user,
    this.onTapLogin,
    this.onTapLogout,
    this.onMySubscription,
  });

  static const double LABEL_WIDTH = 80;
  static const double TOP_AVATAR_HEIGHT = 80;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return TextButton(
        onPressed: onTapLogin,
        child: Text(AppLocalizations.of(context)!.loginOrSignUp),
      );
    }

    return PopupMenuButton(
      offset: const Offset(0, 50),
      child: Row(
        children: [
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            child: Icon(Icons.person),
            // backgroundImage: NetworkImage(
            //   widget.userImage ??
            //       'https://static.vecteezy.com/system/resources/previews/005/176/777/large_2x/user-avatar-line-style-free-vector.jpg',
            // ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            child: Text(user!.email ?? "", overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: user!.email,
          child: SizedBox(
            // width: TOP_AVATAR_HEIGHT,
            height: TOP_AVATAR_HEIGHT + 20,

            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: TOP_AVATAR_HEIGHT,
                    child: CircleAvatar(
                      radius: TOP_AVATAR_HEIGHT,
                      child: Icon(Icons.person),
                      // backgroundImage: NetworkImage(
                      //   widget.userImage ??
                      //       'https://static.vecteezy.com/system/resources/previews/005/176/777/large_2x/user-avatar-line-style-free-vector.jpg',
                      // ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(user!.email ?? "")],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const PopupMenuDivider(), // 菜单顶部分割线

        _profileItem(context, "Name", Icons.person, user!.name ?? ""),
        _profileItem(context, "Email", Icons.mail, user!.email ?? ""),
        _profileItem(context, "Phone", Icons.phone, user!.phone ?? ""),
        _profileItem(
          context,
          "Registration",
          Icons.date_range_outlined,
          user!.createdAt?.toString() ?? "",
        ),

        // _profileItem("Phone", Icons.phone, widget.user!.),
        const PopupMenuDivider(), // 菜单顶部分割线

        PopupMenuItem(
          value: 'mySubscription',
          child: Row(
            children: [
                Icon(Icons.payment),
              const SizedBox(width: 5),
              Text(AppLocalizations.of(context)!.mySubscription),
            ],
          ),
        ),

        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout),
              const SizedBox(width: 5),
              Text(AppLocalizations.of(context)!.logout),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        // print("menu item $value");
        switch (value) {
          case 'mySubscription': 
            onMySubscription?.call(); 
            break;
          case 'logout':
            onTapLogout?.call();
            break;
          default:
            Clipboard.setData(ClipboardData(text: value));
            break;
        }
      },
    );
  }

  PopupMenuEntry _profileItem(
    BuildContext context,
    String title,
    IconData icon,
    String value,
  ) {
    return PopupMenuItem(
      value: value,
      child: Tooltip(
        richMessage: value.isNotEmpty
            ? TextSpan(
                text: "$value \n\n",
                // style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.copyToClipboard,
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              )
            : null,
        message: value.isNotEmpty ? null : "No value",
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            SizedBox(width: LABEL_WIDTH, child: Text(title)),
            Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
