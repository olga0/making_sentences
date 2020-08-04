class Sentence {
  SentencePart whoPart;
  SentencePart doesWhatPart;
  SentencePart whereWhenPart;
  String sentence;

  Sentence(this.whoPart, this.doesWhatPart, this.whereWhenPart, String sentence);

  void asString() {
    print('who part: image - ${whoPart.imageName}; description - ${whoPart.description}');
    print('does what part: image - ${doesWhatPart.imageName}; description - ${doesWhatPart.description}');
    print('where when part: image - ${whereWhenPart.imageName}; description - ${whereWhenPart.description}');
  }
}

class SentencePart {
  String imageName;
  String description;
  int index;
  int sentenceIndex;

  SentencePart(String imageName, String description, int index, int sentenceIndex) {
    this.imageName = 'images/$imageName.png';
    this.description = description;
    this.index = index;
    this.sentenceIndex = sentenceIndex;
  }
}

class SentencePartPlaceholder {
  String label;
  int index;

  SentencePartPlaceholder(this.label, this.index);
}