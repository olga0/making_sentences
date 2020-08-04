import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:makingsentences/helping_classes/ads_manager.dart';
import 'package:makingsentences/helping_classes/purchase_manager.dart';
import 'package:makingsentences/helping_widgets/level_button.dart';
import 'package:makingsentences/localization/my_localizations.dart';
import 'package:makingsentences/localization/string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helping_classes/const.dart';

class MainPage extends StatefulWidget {
  final SharedPreferences _prefs;

  MainPage(this._prefs);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  String _chosenLanguage;
  String _localeLanguage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // variables for ad
  AdsManager _adsManager;

  // variables for in-app purchases
  bool _isAdRemoved = false;
  PurchaseManager _purchaseManager;
  Future<bool> _isPurchaseDataInitializationFinished;

  @override
  void initState() {
    _chosenLanguage = widget._prefs.get(Constants.CHOSEN_LANGUAGE_KEY);
    _localeLanguage = widget._prefs.get(Constants.LOCALE_LANGUAGE_KEY);

    FirebaseAdMob.instance.initialize(appId: Constants.APP_ID);
    _adsManager = new AdsManager();
    _adsManager.initAds();

    _purchaseManager = new PurchaseManager(_setMainPageState, widget._prefs);
    _isPurchaseDataInitializationFinished =
        _purchaseManager.initializePurchaseData();

    super.initState();
  }

  @override
  void dispose() {
    _adsManager.disposeAds();
    _purchaseManager.cancelSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isPurchaseDataInitializationFinished,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            // task is finished
            print('snapshot has data');
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Making sentences'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.language),
                    onPressed: () {
                      _showLanguageDialog(context);
                    },
                  ),
                ],
              ),
              body: Container(
                width: double.infinity,
                margin: EdgeInsets.all(15.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                    Widget>[
                  LevelButton(
                      context: context,
                      label: MyLocalizations.of(_chosenLanguage, StringKeys.who),
                      icon: 'images/question_mark_green.png',
                      borderColor: Colors.green,
                      backgroundColor: Colors.green[100],
                      highlightColor: Colors.green[200],
                      textColor: Colors.green[700],
                      showAd: _showAd,
                      chosenLanguage: _chosenLanguage,
                      localeLanguage: _localeLanguage,
                      questionIndex: 1)
                      .draw(),
                  SizedBox(width: 20, height: 20),
                  LevelButton(
                    context: context,
                    label:
                    MyLocalizations.of(_chosenLanguage, StringKeys.doesWhat),
                    icon: 'images/question_mark_red.png',
                    borderColor: Colors.red,
                    backgroundColor: Colors.red[100],
                    highlightColor: Colors.red[200],
                    textColor: Colors.red[700],
                    showAd: _showAd,
                    chosenLanguage: _chosenLanguage,
                    localeLanguage: _localeLanguage,
                    questionIndex: 2,)
                      .draw(),
                  SizedBox(width: 20, height: 20),
                  LevelButton(
                      context: context,
                      label:
                      MyLocalizations.of(_chosenLanguage, StringKeys.whereWhen),
                      icon: 'images/question_mark_blue.png',
                      borderColor: Colors.blue,
                      backgroundColor: Colors.blue[100],
                      highlightColor: Colors.blue[200],
                      textColor: Colors.blue[700],
                      showAd: _showAd,
                      chosenLanguage: _chosenLanguage,
                      localeLanguage: _localeLanguage,
                      questionIndex: 3)
                      .draw(),
                  SizedBox(width: 20, height: 20),
                  LevelButton(
                    context: context,
                    label: MyLocalizations.of(
                        _chosenLanguage, StringKeys.makingSentences),
                    icon: 'images/making_sent.png',
                    borderColor: Colors.amber,
                    backgroundColor: Colors.amber[50],
                    highlightColor: Colors.amber[200],
                    textColor: Colors.amber[700],
                    showAd: _showAd,
                    chosenLanguage: _chosenLanguage,
                    localeLanguage: _localeLanguage,
                    questionIndex: 4,)
                      .draw(),
                  SizedBox(width: 20, height: 20),
                  _buildRemoveAdsButton(),
                ]),
              ),
            );
          }
          else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Kids Development'),
                ),
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _buildRemoveAdsButton() {
    // check if remove ads product was retrieved
    ProductDetails prod = _purchaseManager.getAdsProduct();
    if (prod == null) {
      _showSnackBar('Product was not found');
      return Container();
    } else {
      if (_isAdRemoved) {
        // UI if purchased
        return Container();
      }
      // UI if NOT purchased
      else {
        return RaisedButton(
          onPressed: () {
            _showPurchaseDialog(_scaffoldKey.currentContext, prod);
          },
          child: Container(
            alignment: Alignment.center,
            height: 55,
            width: double.infinity,
            child: Text(
                MyLocalizations.of(_localeLanguage, StringKeys.marketDialogTitle),
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.purple)),
          color: Colors.purple,
        );
      }
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  void _showPurchaseDialog(BuildContext context, ProductDetails prod) {
    StringBuffer buffer = new StringBuffer();
    buffer.write(
        MyLocalizations.of(_localeLanguage, StringKeys.marketDialogText));
    buffer.write(prod.price);
    buffer.write('?');
    String text = buffer.toString();

    AlertDialog dialog = AlertDialog(
      title: Text(
          MyLocalizations.of(_localeLanguage, StringKeys.marketDialogTitle)),
      content: Text(text),
      actions: <Widget>[
        FlatButton(
            child: Text(
              MyLocalizations.of(
                  _localeLanguage, StringKeys.marketDialogNegButLabel),
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
            child: Text(
              MyLocalizations.of(
                  _localeLanguage, StringKeys.marketDialogPosButLabel),
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              _purchaseManager.buyProduct(prod);
              Navigator.of(context).pop();
            }),
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void _showAd() {
    if (!_isAdRemoved) {
      _adsManager.showAds();
    }
  }

  void _showLanguageDialog(BuildContext context) {
    SimpleDialog dialog = SimpleDialog(
      title: Text(
          MyLocalizations.of(_localeLanguage, StringKeys.languageDialogTitle)),
      children: <Widget>[
        SimpleDialogOption(
          child: Text(MyLocalizations.of(
              _localeLanguage, StringKeys.languageDialogOption1)),
          onPressed: () {
            setState(() {
              _chosenLanguage = 'en';
              widget._prefs
                  .setString(Constants.CHOSEN_LANGUAGE_KEY, _chosenLanguage);
              Navigator.of(context).pop();
            });
          },
        ),
        SimpleDialogOption(
          child: Text(MyLocalizations.of(
              _localeLanguage, StringKeys.languageDialogOption2)),
          onPressed: () {
            setState(() {
              _chosenLanguage = 'ru';
              widget._prefs
                  .setString(Constants.CHOSEN_LANGUAGE_KEY, _chosenLanguage);
              Navigator.of(context).pop();
            });
          },
        )
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void _setMainPageState({@required bool isAdsRemoved}) {
    setState(() {
      _isAdRemoved = isAdsRemoved;
    });
  }
}
