import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:makingsentences/data_classes/data_manager.dart';
import 'package:makingsentences/data_classes/sentence.dart';
import 'package:makingsentences/helping_classes/language_availability.dart';
import 'package:makingsentences/helping_widgets/language_not_available_page.dart';
import 'package:makingsentences/localization/my_localizations.dart';
import 'package:makingsentences/localization/string_keys.dart';
import 'package:makingsentences/star_animation/particles.dart';

class MakeSentencePage extends StatefulWidget {
  final String _title;
  final String _chosenLanguage;
  final String _localeLanguage;
  final Function _showAd;

  MakeSentencePage(this._title, this._chosenLanguage, this._localeLanguage, this._showAd);

  @override
  State<StatefulWidget> createState() {
    return MakeSentencesPageState();
  }
}

class MakeSentencesPageState extends State<MakeSentencePage> {
  double _width;
  double _height;
  bool _firstScreenLoaded = false;
  Map<int, String> _matched = {};
  List<SentencePart> _sentenceParts = List<SentencePart>();
  Map<int, bool> _highlightedPictures = {};
  int _screenNumber = 1;
  int _sentencesOnScreen = 2;
  int _numberOfScreens;
  List<Sentence> _sentences;
  AudioPlayer _audioPlayer = AudioPlayer();
  FlutterTts _flutterTts;
  int _descriptionTracker = 0;
  Particles _particles;
  ValueNotifier<bool>_animationFinished;
  bool _youWonSoundStarted = false;

  LanguageAvailability _isLanguageAvailable = LanguageAvailability.undefined;

  @override
  void initState() {
    super.initState();
    DataManager dataManager = DataManager(widget._chosenLanguage);
    _sentences = dataManager.getSentences();
    _numberOfScreens = _sentences.length ~/ _sentencesOnScreen;
    _fillSentenceParts();
    _animationFinished = ValueNotifier(false);
    _initTts();
    _particles = Particles(30, _animationFinished);
  }

  @override
  Widget build(BuildContext context) {
    if (!_firstScreenLoaded) {
      _width = MediaQuery.of(context).size.width * 0.23;
      _height = MediaQuery.of(context).size.height * 0.15;
      _firstScreenLoaded = true;

      if (_flutterTts != null) _speakDescriptions();
      else print('tts = null');
    }

    if (_screenNumber == _numberOfScreens && _matched.length == 6 && !_youWonSoundStarted) {
      if (_audioPlayer == null)
        print('audioPlayer is null!!!!');
      else {
        _playSound('sounds/you_win.mp3');
      }
      _youWonSoundStarted = true;
    }

    Widget page;

    if (_isLanguageAvailable == LanguageAvailability.notAvailable) {
      page = LanguageNotAvailablePage(_flutterTts, _parentSetState, widget._chosenLanguage, widget._localeLanguage, widget._title);
    } else {
      Widget body;

      if (_screenNumber == _numberOfScreens && _matched.length == 6) {
        body = Stack(
          children: <Widget>[
            _buildPageContent(),
            Positioned.fill(child: _particles)
          ],
        );
      } else {
        body = _buildPageContent();
      }

      if (_matched.length == 6 && _screenNumber < _numberOfScreens) {
        page = Scaffold(
          appBar: AppBar(
            title: Text(widget._title),
          ),
          body: body,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.play_arrow),
            backgroundColor: Colors.amber,
            onPressed: () {
              if (_screenNumber < _numberOfScreens && _matched.length == 6) {
                _loadNextScreen();
              }
            },
          ),
        );
      }
      else {
        page = Scaffold(
            appBar: AppBar(
              title: Text(widget._title),
            ),
            body: body
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

  Widget _drawSentencePartPicture(int index) {
    SentencePart sentencePart = _sentenceParts[index];
    int maxSimultaneousDrags = _matched.containsKey(sentencePart.index) ? 0 : 1;
    if (_matched.containsKey(sentencePart.index)) {
      return Container(width: _width, height: _height);
    }
    else {
      if (!_highlightedPictures[index]) {
        return Draggable<SentencePart>(
          data: sentencePart,
          maxSimultaneousDrags: maxSimultaneousDrags,
          child: Container(
            width: _width,
            height: _height,
            padding: EdgeInsets.all(2),
            child: Image.asset(sentencePart.imageName, fit: BoxFit.contain),
          ),
          feedback: Image.asset(sentencePart.imageName,
              width: _width, height: _height, fit: BoxFit.contain),
          childWhenDragging: Container(width: _width, height: _height),
          onDragStarted: () {
            if (_flutterTts != null)
              _speakString(sentencePart.description);
            setState(() {
              for (int i = 0; i < _sentenceParts.length; i++) {
                _highlightedPictures[i] = false;
              }
            });
          },
        );
      }
      else {
        return Draggable<SentencePart>(
          data: sentencePart,
          maxSimultaneousDrags: maxSimultaneousDrags,
          child: Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Image.asset(sentencePart.imageName, fit: BoxFit.contain),
          ),
          feedback: Image.asset(sentencePart.imageName,
              width: _width, height: _height, fit: BoxFit.contain),
          childWhenDragging: Container(width: _width, height: _height),
          onDragStarted: () {
            if (_flutterTts != null)
              _speakString(sentencePart.description);
            setState(() {
              for (int i = 0; i < _sentenceParts.length; i++) {
                _highlightedPictures[i] = false;
              }
            });
          },

        );
      }
    }
  }

  Widget _drawSentencePartsRow(int startIndex, int endIndex) {
    List<Widget> sentencePartsPics = List<Widget>();

    for (int i = startIndex; i <= endIndex; i++) {
      sentencePartsPics.add(_drawSentencePartPicture(i));
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: sentencePartsPics
    );
  }

  DragTarget<SentencePart> _drawPlaceholder(
      SentencePartPlaceholder placeholder) {
    return DragTarget<SentencePart>(
      builder: (BuildContext context, List<SentencePart> incoming,
          List rejected) {
        if (_matched.containsKey(placeholder.index))
          return Container(
              width: _width,
              height: _height,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset(_matched[placeholder.index], width: _width,
                  height: _height,
                  fit: BoxFit.contain)
          );
        else
          return Container(
            width: _width,
            height: _height,
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black26),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: AutoSizeText(
              placeholder.label,
              style: TextStyle(fontSize: 20, color: Colors.black26),
              maxLines: 2,
            ),
            alignment: Alignment(0.0, 0.0),
          );
      },
      onWillAccept: (data) {
        if (_matched.length >= 1)
          return data.index == placeholder.index;
        else
          return data.index == placeholder.index ||
              data.index == placeholder.index - 3;
      },
      onAccept: (data) {
        setState(() {
          if (_matched.length < 1) {
            for (SentencePart sentencePart in _sentenceParts) {
              if (placeholder.index > 3 &&
                  sentencePart.sentenceIndex == data.sentenceIndex) {
                sentencePart.index += 3;
              }
              if (placeholder.index <= 3 &&
                  sentencePart.sentenceIndex != data.sentenceIndex) {
                sentencePart.index += 3;
              }
            }
          }
          _matched[placeholder.index] = data.imageName;
          if (_audioPlayer == null)
            print('audioPlayer is null!!!!');
          else
            _playSound('sounds/correct.mp3');
        });
      },
    );
  }

  Widget _drawPlaceholdersRow(int initialIndex) {
    List<Widget> placeholders = List<Widget>();
    String labelWho = MyLocalizations.of(
        widget._chosenLanguage, StringKeys.who);
    String labelDoesWhat = MyLocalizations.of(
        widget._chosenLanguage, StringKeys.doesWhat);
    String labelWhereWhen = MyLocalizations.of(
        widget._chosenLanguage, StringKeys.whereWhen);
    placeholders.add(
        _drawPlaceholder(SentencePartPlaceholder(labelWho, initialIndex)));
    placeholders.add(_drawPlaceholder(
        SentencePartPlaceholder(labelDoesWhat, initialIndex + 1)));
    placeholders.add(_drawPlaceholder(
        SentencePartPlaceholder(labelWhereWhen, initialIndex + 2)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: placeholders,
    );
  }

  void _loadNextScreen() {
    setState(() {
      _descriptionTracker = 0;
      _screenNumber++;
      _matched.clear();
      _fillSentenceParts();
      if (_flutterTts != null)
        _speakDescriptions();
    });
  }

  void _fillSentenceParts() {
    _sentenceParts.clear();

    for (int i = (_screenNumber - 1) * _sentencesOnScreen; i <
        _screenNumber * _sentencesOnScreen; i++) {
      Sentence sentence = _sentences[i];
      _sentenceParts.add(sentence.whoPart);
      _sentenceParts.add(sentence.doesWhatPart);
      _sentenceParts.add(sentence.whereWhenPart);
    }

    _sentenceParts.shuffle();

    for (int i = 0; i < _sentenceParts.length; i++) {
      _highlightedPictures[i] = false;
    }
  }

  Widget _buildPageContent() {
    return Column(
      children: <Widget>[
        _drawPlaceholdersRow(1),
        _drawPlaceholdersRow(4),
        _drawSentencePartsRow(0, 2),
        SizedBox(width: 20, height: 20),
        _drawSentencePartsRow(3, 5)
      ],
    );
  }

  Future _playSound(String soundName) async {
    _audioPlayer = await AudioCache().play(soundName);
  }

  _initTts() {
    _flutterTts = FlutterTts()
      ..setSpeechRate(0.7);

    _flutterTts.setLanguage(widget._chosenLanguage);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _highlightedPictures[_descriptionTracker] = false;
        _descriptionTracker++;
        if (_descriptionTracker < _sentenceParts.length) {
          _highlightedPictures[_descriptionTracker] = true;
          sleep(const Duration(milliseconds: 200));
          _flutterTts.speak(_sentenceParts[_descriptionTracker].description);
        }
      });
    });
  }

  Future _speakDescriptions() async {
    _descriptionTracker = 0;
    _highlightedPictures[0] = true;
    sleep(const Duration(milliseconds: 200));
    var result = await _flutterTts.speak(_sentenceParts[0].description);
    if (result == 1) setState(() => {});
  }

  Future _speakString(String text) async {
    _descriptionTracker = 7;
    var result = await _flutterTts.speak(text);
    if (result == 1) setState(() => {});
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