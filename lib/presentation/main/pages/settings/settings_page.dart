import 'package:advanced_app/app/app_prefs.dart';
import 'package:advanced_app/app/di.dart';
import 'package:advanced_app/data/data_source/local_data_source.dart';
import 'package:advanced_app/presentation/resources/assets_manager.dart';
import 'package:advanced_app/presentation/resources/routes_manager.dart';
import 'package:advanced_app/presentation/resources/strings_manager.dart';
import 'package:advanced_app/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          ListTile(
            leading: SvgPicture.asset(ImageAssets.changeLangIc),
            title: Text(AppStrings.changeLanguage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
            onTap: (){
              _changeLanguage();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.contactUsIc),
            title: Text(AppStrings.contactUs,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
            onTap: (){
              _contactUs();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
            title: Text(AppStrings.inviteYourFriends,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
            onTap: (){
              _inviteFriends();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.logoutIc),
            title: Text(AppStrings.logout,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
            onTap: (){
              _logout();
            },
          ),
        ],
      ),
    );
  }
  _changeLanguage(){
  }

  _contactUs(){
    // task to open any web page using URL
  }

  _inviteFriends(){
    // task to share app name to friends
    // whatsapp or messenger
  }

  _logout(){
    _appPreferences.logout();
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}
