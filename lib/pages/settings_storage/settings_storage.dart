import 'package:flutter/material.dart';

import 'settings_storage_view.dart';

class SettingsStorage extends StatefulWidget {
  const SettingsStorage({super.key});

  @override
  SettingsStorageController createState() => SettingsStorageController();
}

class SettingsStorageController extends State<SettingsStorage> {
  @override
  Widget build(BuildContext context) => SettingsStorageView(this);
}
