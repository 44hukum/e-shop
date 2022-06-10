import 'dart:js';

import 'package:e_shop/Widgets/change_theme_button_widget.dart';
import 'package:e_shop/Widgets/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class theme extends StatelessWidget {
  @override
  Widget build(BuildContext context){

  final text = Provider
      .of<ThemeProvider>(context)
      .themeMode == ThemeMode.dark
      ? 'DarkTheme'
      : 'LightTheme';
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orange,
      title: Text(MyApp.title),
      actions: [
        ChangeThemeButtonWidget(),
      ],
    ),
    body: Center(
      child: Text(
        'Hello $text!',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
  }
}