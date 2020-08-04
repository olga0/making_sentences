import 'package:makingsentences/localization/my_localizations.dart';
import 'package:makingsentences/localization/string_keys.dart';

class QuestionIndexMap {
  String _chosenLanguage;
  Map questionMap = Map();

  QuestionIndexMap(String chosenLanguage) {
    this._chosenLanguage = chosenLanguage;
    questionMap[1] = MyLocalizations.of(_chosenLanguage, StringKeys.whoOrWhat);
    questionMap[2] = MyLocalizations.of(_chosenLanguage, StringKeys.doesWhat);
    questionMap[3] = MyLocalizations.of(_chosenLanguage, StringKeys.whereOrWhen);
  }
}