import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/disclaim.dart';
import 'package:todo/pages/check_update_page.dart';
import 'package:todo/pages/download_ussd_page.dart';
import 'package:todo/services/AppStateNotifier.dart';
import 'package:todo/services/PlatformService.dart';
import 'package:todo/utils/transitions.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsWidget extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  var darkMode = false;
  var showWidget = true;
  var turnOffWifi = true;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then(
      (prefs) {
        final dm = prefs.getBool('darkmode');
        if (dm != null) {
          setState(() {
            darkMode = dm;
          });

          Provider.of<AppStateNotifier>(context, listen: false).updateTheme(dm);
        }
      },
    );

    getShowWidgetPreference().then((value) {
      setState(() {
        showWidget = value;
      });
    });

    getTurnOffWifiPreference().then((value) {
      setState(() {
        turnOffWifi = value;
      });
    });
  }

  static const String versionInfo = 'Versión 1.2.5 | 27-07-2020';

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Center(
          child: ImageIcon(
            AssetImage("logo.png"),
            color: Colors.white,
            size: 96,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  versionInfo,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Activar modo oscuro',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      activeColor: Theme.of(context).focusColor,
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });

                        Provider.of<AppStateNotifier>(context, listen: false)
                            .updateTheme(darkMode);

                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool('darkmode', darkMode);
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Activar widget flotante',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      activeColor: Theme.of(context).focusColor,
                      activeTrackColor: this.darkMode ? null : Colors.white,
                      value: showWidget,
                      onChanged: (value) {
                        setState(() {
                          showWidget = value;
                        });

                        if (value) {
                          setTrueShowWidget();
                        } else {
                          setFalseShowWidget();
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Apagar wifi al desconectar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      activeColor: Theme.of(context).focusColor,
                      activeTrackColor: this.darkMode ? null : Colors.white,
                      value: turnOffWifi,
                      onChanged: (value) {
                        setState(() {
                          turnOffWifi = value;
                        });

                        if (value) {
                          setTrueTurnOffWifi();
                        } else {
                          setFalseTurnOffWifi();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Actualizar códigos USSD',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(Icons.file_download,
                            color: Theme.of(context).scaffoldBackgroundColor ==
                                    Theme.of(context).focusColor
                                ? Colors.white
                                : Theme.of(context).focusColor,
                            semanticLabel: "Actualizar códigos USSD"),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      TodoPageRoute(
                        builder: (context) => DownloadUssdPage(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Actualizar aplicación',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(Icons.file_download,
                            color: Theme.of(context).scaffoldBackgroundColor ==
                                    Theme.of(context).focusColor
                                ? Colors.white
                                : Theme.of(context).focusColor,
                            semanticLabel: 'Actualizar aplicación'),
                      ),
                    ],
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      TodoPageRoute(
                        builder: (context) => CheckUpdatePage(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      TodoPageRoute(
                        builder: (context) => DisclaimerWidget(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Términos de uso',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.verified_user,
                          color: Theme.of(context).scaffoldBackgroundColor ==
                                  Theme.of(context).focusColor
                              ? Colors.white
                              : Theme.of(context).focusColor,
                          semanticLabel: 'Leer Términos de uso',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 2, right: 8, bottom: 10),
                  child: GFButton(
                    icon: Icon(
                      FontAwesomeIcons.telegram,
                      color: Theme.of(context).scaffoldBackgroundColor ==
                              Theme.of(context).focusColor
                          ? Colors.white
                          : Theme.of(context).focusColor,
                      semanticLabel: 'Habla con nosotros en Telegram',
                    ),
                    text: 'Habla con nosotros en Telegram',
                    textColor: Colors.white,
                    color: Theme.of(context).scaffoldBackgroundColor ==
                            Theme.of(context).focusColor
                        ? Colors.white
                        : Theme.of(context).focusColor,
                    size: GFSize.LARGE,
                    type: GFButtonType.outline2x,
                    fullWidthButton: true,
                    onPressed: () async {
                      const url = 'https://t.me/todoapp_cuba';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 2, right: 8, bottom: 10),
                  child: GFButton(
                    icon: Icon(
                      Icons.info,
                      color: Theme.of(context).scaffoldBackgroundColor ==
                              Theme.of(context).focusColor
                          ? Colors.white
                          : Theme.of(context).focusColor,
                      semanticLabel: 'Información',
                    ),
                    text: 'Acerca',
                    textColor: Colors.white,
                    color: Theme.of(context).scaffoldBackgroundColor ==
                            Theme.of(context).focusColor
                        ? Colors.white
                        : Theme.of(context).focusColor,
                    size: GFSize.LARGE,
                    type: GFButtonType.outline2x,
                    fullWidthButton: true,
                    onPressed: () async {
                      showAboutDialog(
                        context: context,
                        applicationVersion: versionInfo,
                        applicationLegalese:
                            'TODO es una aplicación multiplataforma creada con el objetivo de ayudar a los usuarios a gestionar los servicios de ETECSA',
                        //applicationIcon: Image.asset('todo.ico') too big,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
