import 'package:flutter/material.dart';
import 'package:makingsentences/data_classes/sentence.dart';

class SentencePartDraggable {
  SentencePart _sentencePart;
  double _width;
  double _height;

  SentencePartDraggable(this._sentencePart, this._width, this._height);

  Draggable<SentencePart> draw() {
    return Draggable<SentencePart>(
      data: _sentencePart,
      child: Image.asset(_sentencePart.imageName,
          width: _width, height: _height, fit: BoxFit.contain),
      feedback: Image.asset(_sentencePart.imageName,
          width: _width, height: _height, fit: BoxFit.contain),
      childWhenDragging: Container(width: _width, height: _height),
    );
  }
}