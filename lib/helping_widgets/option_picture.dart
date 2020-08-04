import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:makingsentences/helping_classes/boolean.dart';
import 'package:makingsentences/data_classes/sentence.dart';

class OptionPicture extends StatefulWidget {
  final SentencePart _sentencePart;
  final double _width;
  final double _height;
  final Boolean _isCorrectAnswerClicked;
  final int _index;
  final Function _handleRightAnswerTap;
  final Function _stopTts;
  final List<bool> _picturesClicked;
  final Map<int, bool> _highlightedPictures;
  final int _correctIndex;

  OptionPicture(
      this._sentencePart,
      this._width,
      this._height,
      this._isCorrectAnswerClicked,
      this._index,
      this._handleRightAnswerTap,
      this._stopTts,
      this._picturesClicked,
      this._highlightedPictures,
      this._correctIndex);

  @override
  State<StatefulWidget> createState() {
    return new OptionPictureState();
  }
}

class OptionPictureState extends State<OptionPicture> {
  Widget child;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    if (!widget._picturesClicked.elementAt(widget._index)) {
      child = Image.asset(
        widget._sentencePart.imageName,
        width: widget._width,
        height: widget._height,
        fit: BoxFit.contain,
      );
    } else {
      String markImage = (widget._sentencePart.index == widget._correctIndex)
          ? 'images/checkmark.png'
          : 'images/x.png';
      child = Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.asset(
            widget._sentencePart.imageName,
            width: widget._width,
            height: widget._height,
            fit: BoxFit.contain,
          ),
          Image.asset(
            markImage,
            width: widget._width,
            height: widget._height,
            fit: BoxFit.contain,
          ),
        ],
      );
    }
    if (widget._highlightedPictures[widget._index]) {
      return GestureDetector(
          onTap: _handleTap,
          child: Container(
//            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: child,
          ));
    }
    return GestureDetector(
        onTap: _handleTap,
        child: Container(
//          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          padding: EdgeInsets.all(2.0),
          child: child,
        ));
  }

  void _handleTap() {
    widget._stopTts();
    setState(() {
      for (int i = 0; i < widget._highlightedPictures.length; i++) {
        widget._highlightedPictures[i] = false;
      }
    });
    if (!widget._isCorrectAnswerClicked.value) {
      setState(() {
        widget._picturesClicked[widget._index] = true;
        if (widget._sentencePart.index == widget._correctIndex) {
          widget._handleRightAnswerTap();
          print('correct answer chosen');
          print(widget._picturesClicked);
        }

        String sound = (widget._sentencePart.index == widget._correctIndex)
            ? 'sounds/correct.mp3'
            : 'sounds/incorrect.mp3';

        if (sound == null)
          print('sound is null!!!!');
        else {
          if (_audioPlayer == null)
            print('audioPlayer is null!!!!');
          else
            _playSound(sound);
        }
      });
    }
  }

  Future _playSound(String soundName) async {
    _audioPlayer = await AudioCache().play(soundName);
  }
}