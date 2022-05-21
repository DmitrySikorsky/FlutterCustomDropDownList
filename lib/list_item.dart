// Copyright © 2022 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

import 'package:flutter/material.dart';
import 'package:flutter_custom_drop_down_list/defaults.dart';

class ListItem<T> extends StatelessWidget {
  final String title;
  final T? value;
  final VoidCallback? onTap;

  const ListItem(
    this.title, {
    Key? key,
    this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Defaults.spacing),
          child: Text(title),
        ),
      ),
    );
  }
}
