import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:makingsentences/localization/my_localizations.dart';
import 'package:makingsentences/localization/string_keys.dart';

class LanguageNotAvailablePage extends StatelessWidget {
  final FlutterTts _flutterTts;
  final Function _parentSetState;
  final String _chosenLanguage;
  final String _localeLanguage;
  final String _title;

  LanguageNotAvailablePage(this._flutterTts, this._parentSetState, this._chosenLanguage, this._localeLanguage, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.warning, color: Colors.red, size: 50),
                SizedBox(height: 20),
                Text(
                  MyLocalizations.of(
                    _localeLanguage,
                    _chosenLanguage == 'ru'
                        ? StringKeys.languageErrorTextRussian
                        : StringKeys.languageErrorTextEnglish,
                  ),
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    if (_flutterTts != null) _installTheLanguage();
                  },
                  color: Colors.amber,
                  child: Text(MyLocalizations.of(
                      _localeLanguage, StringKeys.installButtonLabel), style: TextStyle(fontSize: 18),),
                )
              ],
            )),
      ),
    );
  }

  Future<void> _installTheLanguage() async {
    const platform = const MethodChannel('com.olgam.makingsentences/install_language');
    try {
      await platform.invokeMethod('installLanguage');
      _parentSetState();
    } on PlatformException catch(error) {
      print(error);
    }
  }

}