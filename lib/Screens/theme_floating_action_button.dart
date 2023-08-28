import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_changer.dart';


class ThemeFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    return FloatingActionButton(
      onPressed: () {
        ThemeChanger themeChanger =
        Provider.of<ThemeChanger>(context, listen: false);

        // Toggle the theme
        themeChanger.toggleTheme();
      },
      backgroundColor: themeChanger.isDarkMode ? Colors.white : Colors.black,
      child: Icon(themeChanger.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: themeChanger.isDarkMode ? Colors.black : Colors.white,
        size: 24,),
    );
  }
}
