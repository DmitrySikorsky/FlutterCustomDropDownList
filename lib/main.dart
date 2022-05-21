// Copyright © 2022 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

import 'package:flutter/material.dart';
import 'package:flutter_custom_drop_down_list/defaults.dart';
import 'package:flutter_custom_drop_down_list/drop_down_list.dart';
import 'package:flutter_custom_drop_down_list/list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Custom Drop Down List',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedValue = 'option_1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropDownList<String>(
              listItems: const [
                ListItem<String>(
                  'Option 1',
                  value: 'option_1',
                ),
                ListItem<String>(
                  'Option 2',
                  value: 'option_2',
                ),
                ListItem<String>(
                  'Option 3',
                  value: 'option_3',
                ),
              ],
              value: _selectedValue,
              onChange: (value) => setState(() {
                _selectedValue = value!;
              }),
            ),
            const SizedBox(height: Defaults.spacing),
            Text(_selectedValue),
          ],
        ),
      ),
    );
  }
}
