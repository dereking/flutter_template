import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';
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

class LoginStatusDropdownButton extends StatefulWidget {
  final String userName;
  final String? userImage;
  final String? userEmail;
  final String? userPhone;
  final String? userAddress;
  final String? userBirthday;
  final String? userGender;
  final String? userRole;
  final String? userStatus;
  final DateTime? userCreatedAt;
  final DateTime? userUpdatedAt;
  final DateTime? userDeletedAt;
  final DateTime? userLastLogin;
  final DateTime? userLastLogout;
  final Function()? onTapLogin;
  final Function()? onTapLogout;

  const LoginStatusDropdownButton({
    super.key,
    required this.userName,
    this.userImage,
    this.userEmail,
    this.userPhone,
    this.userAddress,
    this.userBirthday,
    this.userGender,
    this.userRole,
    this.userStatus,
    this.userCreatedAt,
    this.userUpdatedAt,
    this.userDeletedAt,
    this.userLastLogin,
    this.userLastLogout,
    this.onTapLogin,
    this.onTapLogout,
  });

  @override
  State<LoginStatusDropdownButton> createState() => _LoginStatusDropdownButtonState();
}

class _LoginStatusDropdownButtonState extends State<LoginStatusDropdownButton> {
  List<ProfileItem> profileItems = [];
 
  static const double LABEL_WIDTH = 80;
  static const double TOP_AVATAR_HEIGHT = 80;

  @override
  void initState() {
    super.initState();
    if (widget.userEmail != null) {
      profileItems.add(
        ProfileItem(
          title: "email",
          value: widget.userEmail!,
          icon: Icons.email,
          onTap: () {},
        ),
      );
    }
    if (widget.userPhone != null) {
      profileItems.add(
        ProfileItem(
          title: "Phone",
          value: widget.userPhone!,
          icon: Icons.phone,
          onTap: () {},
        ),
      );
    }
    if (widget.userAddress != null) {
      profileItems.add(
        ProfileItem(
          title: "Address",
          value: widget.userAddress!,
          icon: Icons.location_on_outlined,
          onTap: () {},
        ),
      );
    }
    if (widget.userBirthday != null) {
      profileItems.add(
        ProfileItem(
          title: "Birthday",
          value: widget.userBirthday!,
          icon: Icons.date_range_outlined,
          onTap: () {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userName.isEmpty) {
      return TextButton(
        onPressed: widget.onTapLogin,
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
            child: Text(
              widget.userName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 'profile',
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
                      children: [
                        Text('Hi, ${widget.userName}'),
                        Text('${widget.userGender}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const PopupMenuDivider(), // 菜单顶部分割线

        ...profileItems.asMap().entries.map((e) {
          return PopupMenuItem(
            child: Row(
              children: [
                Icon(e.value.icon),
                const SizedBox(width: 5),
                SizedBox(width: LABEL_WIDTH, child: Text(e.value.title)),
                Expanded(
                  child: Text(e.value.value, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        }),
        const PopupMenuDivider(), // 菜单顶部分割线

        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: 5),
              Text('Setting'),
            ],
          ),
        ),
        // const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout),
              const SizedBox(width: 5),
              Text("Logout"),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'profile':
            // Handle profile action
            break;
          case 'settings':
            // Handle settings action
            break;
          case 'logout':
            widget.onTapLogout ?? widget.onTapLogout!();
            break;
        }
      },
    );
  }
}
