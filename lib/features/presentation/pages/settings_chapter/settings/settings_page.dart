import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../domain/usecases/settings/delete_all_data_usecase.dart';
import '../../../bloc/cubit/first_launch/first_launch_cubit.dart';
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
        Navigator.popUntil(
            context, (route) => route.settings.name == PageConst.homePage);
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
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!
                            .areYouSureYouWantToDelete),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Text(AppLocalizations.of(context)!.no)),
                              ),
                              Expanded(
                                child: TextButton(
                                    onPressed: () async {
                                      loadingScreen(context);

                                      await sl<DeleteAllDataUsecase>().call();

                                      if (mounted) {
                                        context
                                            .read<FirstLaunchCubit>()
                                            .changeIsFirstLaunch(true);

                                        await Future.delayed(
                                            const Duration(seconds: 1));

                                        if (mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              PageConst.homePage,
                                              (route) => false);
                                        }
                                      }
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.yes)),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  leading: Icon(
                    FontAwesomeIcons.trashCan,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.deleteAllTheData,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
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
