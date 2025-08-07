import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

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
  final User? user;
  // final String? userImage;
  // final String? userEmail;
  // final String? userPhone;
  // final String? userAddress;
  // final String? userBirthday;
  // final String? userGender;
  // final String? userRole;
  // final String? userStatus;
  // final DateTime? userCreatedAt;
  // final DateTime? userUpdatedAt;
  // final DateTime? userDeletedAt;
  // final DateTime? userLastLogin;
  // final DateTime? userLastLogout;
  final Function()? onTapLogin;
  final Function()? onTapLogout;

  const LoginStatusDropdownButton({
    super.key,
    required this.user,
    // this.userImage,
    // this.userEmail,
    // this.userPhone,
    // this.userAddress,
    // this.userBirthday,
    // this.userGender,
    // this.userRole,
    // this.userStatus,
    // this.userCreatedAt,
    // this.userUpdatedAt,
    // this.userDeletedAt,
    // this.userLastLogin,
    // this.userLastLogout,
    this.onTapLogin,
    this.onTapLogout,
  });

  @override
  State<LoginStatusDropdownButton> createState() =>
      _LoginStatusDropdownButtonState();
}

class _LoginStatusDropdownButtonState extends State<LoginStatusDropdownButton> {
  List<ProfileItem> profileItems = [];

  static const double LABEL_WIDTH = 80;
  static const double TOP_AVATAR_HEIGHT = 80;

  @override
  void initState() {
    super.initState();
    print("init login button :user: ${widget.user?.name}");
    if (widget.user?.email != null) {
      profileItems.add(
        ProfileItem(
          title: "Email",
          value: widget.user!.email,
          icon: Icons.email,
          onTap: () {},
        ),
      );
    }
    if (widget.user?.phone != null) {
      profileItems.add(
        ProfileItem(
          title: "Phone",
          value: widget.user!.phone,
          icon: Icons.phone,
          onTap: () {},
        ),
      );
    }
    if (widget.user?.registration != null) {
      profileItems.add(
        ProfileItem(
          title: "Registration",
          value: widget.user!.registration,
          icon: Icons.date_range_outlined,
          onTap: () {},
        ),
      );
    }

    if (widget.user?.name != null) {
      profileItems.add(
        ProfileItem(
          title: "Name",
          value: widget.user!.name,
          icon: Icons.date_range_outlined,
          onTap: () {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
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
            child: Text(widget.user!.email, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: widget.user!.email,
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
                      children: [Text(widget.user!.email)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const PopupMenuDivider(), // 菜单顶部分割线

        _profileItem("Name", Icons.person, widget.user!.name),
        _profileItem("Email", Icons.mail, widget.user!.email),
        _profileItem("Phone", Icons.phone, widget.user!.phone),
        _profileItem("Registration", Icons.date_range_outlined, widget.user!.registration),
        // _profileItem("Phone", Icons.phone, widget.user!.),
        const PopupMenuDivider(), // 菜单顶部分割线

        PopupMenuItem(
          value: 'logout',
          // onTap: () {
          //   widget.onTapLogout?.call();
          // },
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
        // print("menu item $value");
        switch (value) {
          case 'logout':
            widget.onTapLogout?.call();
            break;
          default:
            Clipboard.setData(ClipboardData(text: value));
            break;
        }
      },
    );
  }

PopupMenuEntry _profileItem(String title, IconData icon, String value) {
  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        SizedBox(width: LABEL_WIDTH, child: Text( title)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}

}
