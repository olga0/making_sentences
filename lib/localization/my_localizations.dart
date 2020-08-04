import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:makingsentences/localization/string_keys.dart';

class MyLocalizations {
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // MAIN PAGE
      // button labels
      StringKeys.who: 'Who?/What?',
      StringKeys.whoOrWhat: 'Who or what?',
      StringKeys.doesWhat: 'Does what?',
      StringKeys.whereOrWhen: 'Where or when?',
      StringKeys.makingSentences: 'Making sentences',
      StringKeys.whereWhen: 'Where?/When?',
      // language dialog
      StringKeys.languageDialogTitle: 'Choose a language',
      StringKeys.languageDialogOption1: 'English',
      StringKeys.languageDialogOption2: 'Russian',

      // QUESTION PAGE
      StringKeys.languageErrorTextEnglish: 'English language is not installed for text to speech. The application will not work properly. Please, install English language and then restart this application.',
      StringKeys.languageErrorTextRussian: 'Russian language is not installed for text to speech. The application will not work properly. Please, install Russian language and then restart this application.',
      StringKeys.installButtonLabel: 'Install the language',
      // market dialog
      StringKeys.marketDialogText: 'Would you like to remove ads from this app for ',
      StringKeys.marketDialogPosButLabel: 'Buy',
      StringKeys.marketDialogNegButLabel: 'Close',
      StringKeys.marketDialogTitle: 'Remove ads',

    },
    'ru': {
      // MAIN PAGE
      // button labels
      StringKeys.who: 'Кто/Что?',
      StringKeys.whoOrWhat: 'Кто или что?',
      StringKeys.doesWhat: 'Что делает?',
      StringKeys.whereOrWhen: 'Где или когда?',
      StringKeys.makingSentences: 'Составление предложений',
      StringKeys.whereWhen: 'Где/Когда?',
      // language dialog
      StringKeys.languageDialogTitle: 'Выберите язык',
      StringKeys.languageDialogOption1: 'английский',
      StringKeys.languageDialogOption2: 'русский',

      // QUESTION PAGE
      StringKeys.languageErrorTextEnglish: 'Английский язык не установлен для программы синтеза речи. Приложение не будет работать корректно. Пожалуйста, установите английский язык, а затем перезапустите приложение.',
      StringKeys.languageErrorTextRussian: 'Русский язык не установлен для программы синтеза речи. Приложение не будет работать корректно. Пожалуйста, установите русский язык, а затем перезапустите приложение.',
      StringKeys.installButtonLabel: 'Установить язык',

      // market dialog
      StringKeys.marketDialogText: 'Хотите удалить рекламу из этого приложения за ',
      StringKeys.marketDialogPosButLabel: 'Купить',
      StringKeys.marketDialogNegButLabel: 'Закрыть',
      StringKeys.marketDialogTitle: 'Убрать рекламу',
    }
  };

  String translate(language, key) {
    if (language == 'ru')
      return _localizedValues['ru'][key];
    else
      return _localizedValues['en'][key];
  }

  static String of(String language, String key) {
    MyLocalizations myLocalizations = MyLocalizations();
    return myLocalizations.translate(language, key);
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(MyLocalizations());
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
