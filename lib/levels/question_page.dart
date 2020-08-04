import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:makingsentences/helping_classes/boolean.dart';
import 'package:makingsentences/data_classes/data_manager.dart';
import 'package:makingsentences/data_classes/sentence.dart';
import 'package:makingsentences/helping_classes/language_availability.dart';
import 'package:makingsentences/helping_widgets/language_not_available_page.dart';
import 'package:makingsentences/helping_widgets/option_picture.dart';
import 'package:makingsentences/star_animation/particles.dart';

class QuestionPage extends StatefulWidget {
  final String _title;
  final String _chosenLanguage;
  final String _localeLanguage;
  final int _questionIndex;
  final Function _showAd;

  QuestionPage(this._title, this._chosenLanguage, this._localeLanguage,
      this._questionIndex, this._showAd);

  @override
  State<StatefulWidget> createState() {
    return QuestionPageState();
  }
}

class QuestionPageState extends State<QuestionPage> {
  double _width;
  double _height;
  bool _firstScreenLoaded = false;
  List<OptionsSet> _optionsSetList = List<OptionsSet>();

  int _questionNumber = 1;
  int _numberOfQuestions = 10;
  int _numberOfOptions = 4;
  Boolean _isCorrectAnswerClicked;
  AudioPlayer _audioPlayer = AudioPlayer();
  List<bool> _picturesClicked = [false, false, false, false];
  List<OptionPicture> _optionPictures = new List<OptionPicture>();
  int _descriptionTracker = -1;
  FlutterTts _flutterTts;
  Map<int, bool> _highlightedPictures = {};
  LanguageAvailability _isLanguageAvailable = LanguageAvailability.undefined;

  bool _descriptionsWereVoiced = false;

  ValueNotifier<bool> _animationFinished;
  Particles _particles;

  @override
  void initState() {
    super.initState();
    _fillOptionsSetList();
    _isCorrectAnswerClicked = new Boolean();
    _animationFinished = ValueNotifier(false);
    _initTts();
    _particles = Particles(30, _animationFinished);
  }

  @override
  Widget build(BuildContext context) {
    if (!_firstScreenLoaded) {
      _width = MediaQuery.of(context).size.width * 0.4;
      _height = MediaQuery.of(context).size.height * 0.3;
      _firstScreenLoaded = true;
    }

    if (!_descriptionsWereVoiced) _speakDescriptions();

    Widget body;
    bool levelFinished =
        _questionNumber == _numberOfQuestions && _isCorrectAnswerClicked.value;
    if (levelFinished) {
      if (_audioPlayer == null)
        print('audioPlayer is null!!!!');
      else
        _playSound('sounds/you_win.mp3');

      body = Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _buildPageContent(),
          ),
          Positioned.fill(child: _particles)
        ],
      );
    } else {
      body = AnimatedSwitcher(
          duration: Duration(milliseconds: 300), child: _buildPageContent());
    }

    Widget page;

    if (_isLanguageAvailable == LanguageAvailability.notAvailable) {
      page = LanguageNotAvailablePage(_flutterTts, _parentSetState, widget._chosenLanguage, widget._localeLanguage, widget._title);
    } else {
      if (_isCorrectAnswerClicked.value && !levelFinished) {
        page = Scaffold(
            appBar: AppBar(
              title: Text(widget._title),
            ),
            body: body,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.play_arrow),
                backgroundColor: Colors.amber,
                onPressed: () {
                  setState(
                    () {
                      _questionNumber++;
                      _picturesClicked.replaceRange(
                          0, _numberOfOptions, [false, false, false, false]);
                      _isCorrectAnswerClicked.value = false;
                      _descriptionsWereVoiced = false;
                    },
                  );
                }));
      } else {
        page = Scaffold(
          appBar: AppBar(
            title: Text(widget._title),
          ),
          body: body,
        );
      }
    }

    return WillPopScope(
        onWillPop: () async {
          widget._showAd();
          return true;
        },
        child: page
    );
  }

  Future _playSound(String soundName) async {
    _audioPlayer = await AudioCache().play(soundName);
  }

  Widget _buildPageContent() {
    OptionsSet optionsSet = _optionsSetList[_questionNumber - 1];
    _optionPictures.clear();
    _optionPictures.add(new OptionPicture(
        optionsSet.options[0],
        _width,
        _height,
        _isCorrectAnswerClicked,
        0,
        _handleRightAnswerTap,
        _stopTts,
        _picturesClicked,
        _highlightedPictures,
        widget._questionIndex));
    _optionPictures.add(new OptionPicture(
        optionsSet.options[1],
        _width,
        _height,
        _isCorrectAnswerClicked,
        1,
        _handleRightAnswerTap,
        _stopTts,
        _picturesClicked,
        _highlightedPictures,
        widget._questionIndex));
    _optionPictures.add(new OptionPicture(
        optionsSet.options[2],
        _width,
        _height,
        _isCorrectAnswerClicked,
        2,
        _handleRightAnswerTap,
        _stopTts,
        _picturesClicked,
        _highlightedPictures,
        widget._questionIndex));
    _optionPictures.add(new OptionPicture(
        optionsSet.options[3],
        _width,
        _height,
        _isCorrectAnswerClicked,
        3,
        _handleRightAnswerTap,
        _stopTts,
        _picturesClicked,
        _highlightedPictures,
        widget._questionIndex));

    return Column(
      key: ValueKey(_questionNumber),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(16.0),
          child: Text(widget._title, style: TextStyle(fontSize: 30.0)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _optionPictures.elementAt(0),
            _optionPictures.elementAt(1),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _optionPictures.elementAt(2),
            _optionPictures.elementAt(3),
          ],
        ),
      ],
    );
  }

  void _fillOptionsSetList() {
    DataManager dataManager = DataManager(widget._chosenLanguage);
    List<Sentence> sentences = dataManager.getSentences();
    sentences.shuffle();
    List<SentencePart> questionList = List<SentencePart>();
    List<SentencePart> otherList = List<SentencePart>();
    Set<String> usedPictures = Set<String>();

    int i = 0;
    while (questionList.length < _numberOfQuestions) {
      SentencePart whoPart = sentences[i].whoPart;
      SentencePart doesWhatPart = sentences[i].doesWhatPart;
      SentencePart whereWhenPart = sentences[i].whereWhenPart;
      if (widget._questionIndex == 1) {
        _addSentencePart(questionList, usedPictures, whoPart);
        _addSentencePart(otherList, usedPictures, doesWhatPart);
        _addSentencePart(otherList, usedPictures, whereWhenPart);
      } else if (widget._questionIndex == 2) {
        _addSentencePart(questionList, usedPictures, doesWhatPart);
        _addSentencePart(otherList, usedPictures, whoPart);
        _addSentencePart(otherList, usedPictures, whereWhenPart);
      } else {
        _addSentencePart(questionList, usedPictures, whereWhenPart);
        _addSentencePart(otherList, usedPictures, whoPart);
        _addSentencePart(otherList, usedPictures, doesWhatPart);
      }
      i++;
    }

    questionList.shuffle();
    otherList.shuffle();

    for (int i = 0; i < _numberOfQuestions; i++) {
      List<SentencePart> options = new List<SentencePart>();
      options.add(questionList[i]);
      int index1 = _generateRandom(otherList.length);
      int index2 = _generateRandom(otherList.length);
      while (index1 == index2) {
        index2 = _generateRandom(otherList.length);
      }
      int index3 = _generateRandom(otherList.length);
      while (index3 == index1 || index3 == index2) {
        index3 = _generateRandom(otherList.length);
      }
      options.add(otherList[index1]);
      options.add(otherList[index2]);
      options.add(otherList[index3]);
      options.shuffle();
      _optionsSetList.add(OptionsSet(options));
    }

    for (int i = 0; i < _numberOfOptions; i++) {
      _highlightedPictures[i] = false;
    }
  }

  int _generateRandom(int max) {
    Random rand = Random();
    return rand.nextInt(max);
  }

  void _handleRightAnswerTap() {
    setState(() {
      _isCorrectAnswerClicked.value = true;
    });
  }

  void _addSentencePart(List<SentencePart> toAddList, Set<String> usedPictures,
      SentencePart partToAdd) {
    if (!usedPictures.contains(partToAdd.imageName)) {
      toAddList.add(partToAdd);
      usedPictures.add(partToAdd.imageName);
    }
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts()..setSpeechRate(0.7);

    bool isLanguageAvailable =
        await _flutterTts.isLanguageAvailable(widget._chosenLanguage);

    _flutterTts.setLanguage(widget._chosenLanguage);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        if (_descriptionTracker != -1)
          _highlightedPictures[_descriptionTracker] = false;
        _descriptionTracker++;
        if (_descriptionTracker < _numberOfOptions) {
          _highlightedPictures[_descriptionTracker] = true;
          sleep(const Duration(milliseconds: 200));
          _flutterTts.speak(_optionsSetList[_questionNumber - 1]
              .options[_descriptionTracker]
              .description);
        }
      });
    });

    setState(() {
      _isLanguageAvailable = isLanguageAvailable
          ? LanguageAvailability.available
          : LanguageAvailability.notAvailable;
    });
  }

  Future _speakDescriptions() async {
    _descriptionTracker = -1;
    if (_flutterTts != null) {
      if (_isLanguageAvailable == LanguageAvailability.available) {
        sleep(const Duration(milliseconds: 200));
        var result = await _flutterTts.speak(widget._title);
        _descriptionsWereVoiced = true;
        if (result == 1) setState(() => {});
      } else if (_isLanguageAvailable == LanguageAvailability.notAvailable)
        print('languge not available');
    } else
      print('tts = null');
  }

  void _stopTts() {
    _flutterTts.stop();
  }

  Future<void> _parentSetState() async {
    bool languageInstalled = await _flutterTts.isLanguageAvailable(widget._chosenLanguage);
    setState(() {
      _isLanguageAvailable = languageInstalled ? LanguageAvailability.available : LanguageAvailability.notAvailable;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }
}

class OptionsSet {
  List<SentencePart> options;

  OptionsSet(this.options);
}
