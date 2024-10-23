import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ListTile(
            //   onTap: () {
            //     themeHelper.toggle();
            //     themeHelper.load();
            //     setState(() {});
            //   },
            //   title: Text(
            //     "Dark",
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 16.sp,
            //     ),
            //   ),
            //   trailing: AbsorbPointer(
            //     child: CupertinoSwitch(
            //       value: themeHelper.isDark,
            //       onChanged: (value) {},
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
