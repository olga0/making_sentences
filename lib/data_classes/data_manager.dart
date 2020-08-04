import 'package:makingsentences/data_classes/sentence.dart';

class DataManager {
  List<Sentence> _sentences = List<Sentence>();

  DataManager(String selectedLanguage) {
    List<String> imagesWho = [
      'boy',
      'witch',
      'santa_claus',
      'man',
      'girl',
      'caterpillar',
      'crocodile',
      'leafs',
      'kids',
      'fish',
      'bird',
      'apples',
      'doctor',
      'cat',
      'leopard',
      'tiger',
      'girl',
      'ducks',
      'bird',
      'boy'
    ];
    List<String> imagesDoesWhat = [
      'sleep',
      'ride',
      'put_present',
      'brush_teeth',
      'eat_eggs',
      'crawl_on_mushrooms',
      'swim',
      'fall_down',
      'build_snowman',
      'swim',
      'sit',
      'grow',
      'working_on_computer',
      'stand',
      'lie',
      'drink',
      'lie',
      'swim',
      'fly',
      'swim'
    ];
    List<String> imagesWhereWhen = [
      'bed',
      'night',
      'christmas_tree',
      'morning',
      'morning',
      'summer',
      'pond',
      'fall_tree',
      'winter',
      'ocean',
      'branch',
      'fall_tree',
      'hospital',
      'fence',
      'branch',
      'pond',
      'bed',
      'pond',
      'sky',
      'every_day'
    ];
    List<String> descriptionsWho;
    List<String> descriptionsDoesWhat;
    List<String> descriptionsWhereWhen;
    List<String> sentences;

    if (selectedLanguage == 'ru') {
      descriptionsWho = [
        'мальчик',
        'ведьма',
        'санта клаус',
        'мужчина',
        'девочка',
        'гусеница',
        'крокодил',
        'листья',
        'дети',
        'рыбы',
        'птица',
        'яблоки',
        'доктор',
        'кошка',
        'леопард',
        'тигр',
        'девочка',
        'утки',
        'птица',
        'мальчик'
      ];
      descriptionsDoesWhat = [
        'спит',
        'летает на метле',
        'кладёт подарок',
        'чистит зубы',
        'ест яйца',
        'ползает по грибам',
        'плавает',
        'падают',
        'лепят снеговика',
        'плавают',
        'сидит',
        'растут',
        'работает',
        'стоит',
        'лежит',
        'пьёт',
        'лежит',
        'плавают',
        'летит',
        'плавает'
      ];
      descriptionsWhereWhen = [
        'в кровати',
        'ночью',
        'под ёлку',
        'утром',
        'утром',
        'летом',
        'в пруду',
        'с дерева',
        'зимой',
        'в океане',
        'на ветке',
        'на дереве',
        'в больнице',
        'на заборе',
        'на ветке',
        'из пруда',
        'в кровати',
        'в пруду',
        'в небе',
        'каждый день'
      ];
      sentences = [
        'Мальчик спит в кровати.',
        'Ведьма летает на метле ночью.',
        'Санта клаус кладёт подарки под ёлку.',
        'Мужчина чистит зубы утром.',
        'Девочка ест яйца утром.',
        'Гусеница ползает по грибам летом.',
        'Крокодил плавает в пруду.',
        'Листья падают с дерева.',
        'Дети лепят снеговика зимой.',
        'Рыбы плавают в океане.',
        'Птица сидит на ветке.',
        'Яблоки растут не дереве.',
        'Доктор работает в больнице.',
        'Кошка стоит на заборе.',
        'Леопард лежит на ветке.',
        'Тигр пьёт из пруда.',
        'Девочка лежит в кровати.',
        'Утки плавают в пруду.',
        'Птица летит в небе.',
        'Мальчик плавает каждый день.'
      ];
    } else {
      descriptionsWho = [
        'the boy',
        'the witch',
        'Santa Claus',
        'the man',
        'the girl',
        'the caterpillar',
        'the crocodile',
        'leafs',
        'children',
        'fish',
        'the bird',
        'apples',
        'the doctor',
        'the cat',
        'the leopard',
        'the tiger',
        'the girl',
        'ducks',
        'the bird',
        'the boy'
      ];
      descriptionsDoesWhat = [
        'is slipping',
        'is riding a broom',
        'puts a present',
        'is brushing teeth',
        'is eating eggs',
        'crawls on mushrooms',
        'is swimming',
        'are falling down',
        'build a snowman',
        'swim',
        'is sitting',
        'grow',
        'is working',
        'is standing',
        'is lying',
        'is drinking',
        'is lying',
        'are swimming',
        'is flying',
        'swims'
      ];
      descriptionsWhereWhen = [
        'in a bed',
        'at night',
        'under a christmas tree',
        'int the morning',
        'in the morning',
        'in summer',
        'in a pond',
        'from the tree',
        'in winter',
        'in the ocean',
        'on a branch',
        'on a tree',
        'in a hospital',
        'on a fence',
        'on a branch',
        'from a pond',
        'in a bed',
        'in a pond',
        'in the sky',
        'every day'
      ];
      sentences = [
        'The boy is slipping in a bed.',
        'The witch is riding a broom at night.',
        'Santa Claus puts a present under a christmas tree.',
        'The man is brushing teeth in the morning.',
        'The girl is eating eggs in the moring.',
        'The caterpillar crawls on mushrooms in summer.',
        'The crocodile is swimming in a pond.',
        'Leafs are falling down from the tree.',
        'Children build a snowman in winter.',
        'Fish swim in the ocean.',
        'The bird is sitting on a branch.',
        'Apples grow on a tree.',
        'The doctor is working in a hospital.',
        'The cat is standing on a fence.',
        'The leopard is lying on a branch.',
        'The tiger is drinking from a pond.',
        'The girl is lying in a bed.',
        'Ducks are swimming in a pond.',
        'The bird is flying in the sky.',
        'The boy swims every day.'
      ];
    }

    int sentenceIndex = 1;

    for (int i = 0; i < sentences.length; i++) {
//      print("i = $i");
      if (sentenceIndex <= sentences.length) {
        SentencePart whoPart =
            SentencePart(imagesWho[i], descriptionsWho[i], 1, sentenceIndex);
        SentencePart doesWhatPart = SentencePart(
            imagesDoesWhat[i], descriptionsDoesWhat[i], 2, sentenceIndex);
        SentencePart whereWhenPart = SentencePart(
            imagesWhereWhen[i], descriptionsWhereWhen[i], 3, sentenceIndex);
//        print('imagesWhereWhen[i] = ${imagesWhereWhen[i]}');
        _sentences
            .add(Sentence(whoPart, doesWhatPart, whereWhenPart, sentences[i]));
        sentenceIndex++;
      }
    }
  }

  List<Sentence> getSentences() {
    return _sentences;
  }
}
