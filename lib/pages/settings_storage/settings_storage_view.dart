import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/callkeep_manager.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/settings_switch_list_tile.dart';
import 'settings_storage.dart';

class SettingsStorageView extends StatelessWidget {
  final SettingsStorageController controller;
  const SettingsStorageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.chat)),
      body: ListTileTheme(
        iconColor: theme.textTheme.bodyLarge!.color,
        child: MaxWidthBody(
          child: Column(
            children: [
              SettingsSwitchListTile.adaptive(
                title: "Enable Cache On Fly",
                subtitle: "Cache everything automatically",
                onChanged: (b) => AppConfig.cacheOnFly = b,
                storeKey: SettingKeys.cacheOnFly,
                defaultValue: AppConfig.cacheOnFly,
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
