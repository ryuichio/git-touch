import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'providers/notification.dart';
import 'providers/settings.dart';
import 'screens/news.dart';
import 'screens/notifications.dart';
import 'screens/search.dart';
import 'screens/me.dart';
import 'screens/login.dart';
import 'screens/issue.dart';
import 'screens/repos.dart';
import 'screens/organization.dart';
import 'screens/trending.dart';
import 'utils/utils.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int active = 0;
  // String login;

  Widget _buildNotificationIcon(BuildContext context) {
    int count = NotificationProvider.of(context).count;
    if (count == 0) {
      return Icon(Icons.notifications_none);
    }

    // String text = count > 99 ? '99+' : count.toString();

    // https://stackoverflow.com/a/45434404
    return new Stack(children: <Widget>[
      new Icon(Icons.notifications_none),
      new Positioned(
        // draw a red marble
        top: 0.0,
        right: 0.0,
        child: new Icon(Icons.brightness_1, size: 8.0, color: Colors.redAccent),
      )
    ]);
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.rss_feed),
        title: Text('News'),
      ),
      BottomNavigationBarItem(
        icon: _buildNotificationIcon(context),
        title: Text('Notification'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.trending_up),
        title: Text('Trending'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        title: Text('Me'),
      ),
    ];
  }

  _buildScreen(int index) {
    // return IssueScreen(number: 29, owner: 'reactjs', name: 'rfcs');
    // return ReposScreen('pd4d10');
    // return OrganizationScreen('flutter');
    // return TrendingScreen();
    switch (index) {
      case 0:
        return NewsScreen();
      case 1:
        return NotificationScreen();
      case 2:
        return TrendingScreen();
      case 3:
        return SearchScreen();
      case 4:
        return MeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    var settings = SettingsProvider.of(context);
    var themData = ThemeData(
      // primaryColor: HSLColor.fromColor(Palette.primary)
      //     .withLightness(0.3)
      //     .toColor(),
      // primaryColor: Color(0xff333333),
      primaryColor: Palette.primary,
      accentColor: Palette.primary,
    );

    // TODO:
    if (!settings.ready) {
      return MaterialApp(theme: themData, home: Scaffold(body: Text('a')));
    }

    // print(settings.activeLogin);
    if (settings.activeLogin == null) {
      return MaterialApp(theme: themData, home: LoginScreen());
    }

    switch (settings.theme) {
      case ThemeMap.cupertino:
        return CupertinoApp(
          home: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                // primaryColor: Palette.primary,
                textStyle: TextStyle(color: Palette.primary),
              ),
            ),
            child: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(items: _buildNavigationItems()),
              tabBuilder: (context, index) {
                return CupertinoTabView(builder: (context) {
                  return _buildScreen(index);
                });
              },
            ),
          ),
        );
      default:
        return MaterialApp(
          theme: themData,
          home: Scaffold(
            body: _buildScreen(active),
            bottomNavigationBar: BottomNavigationBar(
              items: _buildNavigationItems(),
              currentIndex: active,
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                setState(() {
                  active = index;
                });
              },
            ),
          ),
        );
    }
  }
}

class App extends StatelessWidget {
  @override
  build(context) {
    return NotificationProvider(
      child: SettingsProvider(
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          child: Home(),
          // theme: ThemeData(
          //   textTheme: TextTheme(
          //     title: TextStyle(color: Colors.red),
          //   ),
          // ),
        ),
      ),
    );
  }
}

void main() async {
  // Platform messages may fail, so we use a try/catch PlatformException.

  // try {
  //   String initialLink = await getInitialLink();
  //   print(initialLink);
  // } on PlatformException {
  //   print('test');
  // }

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

  // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  // print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"

  runApp(App());
}
