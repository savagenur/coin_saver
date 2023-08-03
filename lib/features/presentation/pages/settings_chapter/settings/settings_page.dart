import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/hive/hive_local_data_source.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../domain/usecases/settings/delete_all_data_usecase.dart';
import '../../../bloc/settings/settings_bloc.dart';
import '../../../widgets/my_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return true;
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: const MyDrawer(),
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(FontAwesomeIcons.bars)),
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.settings),
            ),
            body: Column(
              children: [
                PullDownButton(
                  itemBuilder: (context) {
                    return [
                      PullDownMenuItem.selectable(
                        selected: settingsState.language == null &&
                                Localizations.localeOf(context) ==
                                    const Locale("en") ||
                            settingsState.language == "en",
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(const UpdateLanguage(language: "en"));
                        },
                        title: "English",
                      ),
                      PullDownMenuItem.selectable(
                        selected: settingsState.language == null &&
                                Localizations.localeOf(context) ==
                                    const Locale("ru") ||
                            settingsState.language == "ru",
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(const UpdateLanguage(language: "ru"));
                        },
                        title: "Русский",
                      ),
                      PullDownMenuItem.selectable(
                        selected: settingsState.language == null &&
                                Localizations.localeOf(context) ==
                                    const Locale("tr") ||
                            settingsState.language == "tr",
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(const UpdateLanguage(language: "tr"));
                        },
                        title: "Türkçe",
                      ),
                    ];
                  },
                  buttonBuilder: (context, showMenu) {
                    return ListTile(
                      onTap: showMenu,
                      leading: const Icon(
                        FontAwesomeIcons.globe,
                      ),
                      title: Text(AppLocalizations.of(context)!.languageTitle),
                      subtitle: Text(
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    );
                  },
                ),
                PullDownButton(
                  itemBuilder: (context) {
                    return [
                      PullDownMenuItem.selectable(
                        selected: !settingsState.isDarkTheme,
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(const UpdateTheme(isDarkTheme: false));
                        },
                        title: AppLocalizations.of(context)!.lightTheme,
                      ),
                      PullDownMenuItem.selectable(
                        selected: settingsState.isDarkTheme,
                        onTap: () {
                          context
                              .read<SettingsBloc>()
                              .add(const UpdateTheme(isDarkTheme: true));
                        },
                        title: AppLocalizations.of(context)!.darkTheme,
                      ),
                    ];
                  },
                  buttonBuilder: (context, showMenu) {
                    final theme = settingsState.isDarkTheme
                        ? AppLocalizations.of(context)!.darkTheme
                        : AppLocalizations.of(context)!.lightTheme;
                    return ListTile(
                      onTap: showMenu,
                      leading: const Icon(
                        FontAwesomeIcons.moon,
                      ),
                      title: Text(AppLocalizations.of(context)!.themeTitle),
                      subtitle: Text(
                        theme,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    );
                  },
                ),
                const Spacer(),
                ListTile(
                  onTap: () async {
                    await sl<DeleteAllDataUsecase>().call();
                    SystemNavigator.pop();
                  },
                  leading: Icon(
                    FontAwesomeIcons.trashCan,
                    color: Colors.red.shade900,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.deleteAllTheData,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
