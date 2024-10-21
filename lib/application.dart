import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/utils/theme_helper.dart';
import 'package:todo_application/screens/home_screen.dart';

import 'locator.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late ThemeHelper themeHelper;

  @override
  void initState() {
    themeHelper = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeHelper),
      ],
      child: ScreenUtilInit(
        designSize: Size(414, 896),
        minTextAdapt: true,
        builder: (context, child) {
          return Consumer<ThemeHelper>(
            builder: (context, value, child) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  brightness: value.isDark ? Brightness.dark : Brightness.light,
                  useMaterial3: false,
                ),
                home: HomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
