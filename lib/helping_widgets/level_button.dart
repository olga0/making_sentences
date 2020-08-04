import 'package:flutter/material.dart';
import 'package:makingsentences/helping_classes/question_index_map.dart';
import 'package:makingsentences/levels/make_sentence_page.dart';
import 'package:makingsentences/levels/question_page.dart';
import 'package:makingsentences/localization/my_localizations.dart';
import 'package:makingsentences/localization/string_keys.dart';

class LevelButton {
  BuildContext context;
  String label;
  String icon;
  Color borderColor, backgroundColor, highlightColor, textColor;
  String chosenLanguage;
  String localeLanguage;
  Function showAd;
  int questionIndex;

  LevelButton({
    @required this.context,
    @required this.label,
    @required this.icon,
    @required this.borderColor,
    @required this.backgroundColor,
    @required this.highlightColor,
    @required this.textColor,
    @required this.chosenLanguage,
    @required this.localeLanguage,
    @required this.showAd,
    @required this.questionIndex,
  });

  RaisedButton draw() {
    return RaisedButton(
      onPressed: () {
        MaterialPageRoute route = _buildRoute();
        Navigator.push(context, route);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            icon,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 10,
            height: 60,
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: borderColor, width: 2.0)),
      color: backgroundColor,
      highlightColor: highlightColor,
      textColor: textColor,
    );
  }

  MaterialPageRoute _buildRoute() {
    MaterialPageRoute route;
    if (questionIndex == 4) {
      route = MaterialPageRoute(
          builder: (BuildContext context) => MakeSentencePage(
              MyLocalizations.of(chosenLanguage, StringKeys.makingSentences),
              chosenLanguage,
              localeLanguage,
              showAd));
    } else {
      QuestionIndexMap map = QuestionIndexMap(chosenLanguage);
      if (!map.questionMap.containsKey(questionIndex)) {
        print('Unknown question index');
        return null;
      } else {
        String question = map.questionMap[questionIndex];
        route = MaterialPageRoute(
            builder: (BuildContext context) => QuestionPage(question,
                chosenLanguage, localeLanguage, questionIndex, showAd));
      }
    }

    return route;
  }
}
