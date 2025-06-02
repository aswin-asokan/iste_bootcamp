import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
  });
  final String title;
  final IconData leadingIcon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(leadingIcon, color: Colors.black54),
          title: Text(title, style: TextStyle(color: Colors.black54)),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black54,
            size: 15,
          ),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
