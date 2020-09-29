class Item {
  int id;
  String title;
  int amountOfGram;
  double score;
  double energy;
  double su;

  Item({this.title, this.amountOfGram, this.score, this.energy, this.su});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      "score": score,
      "energy": energy,
      "su": su,
      "amountOfGram": amountOfGram,
    };
  }

  @override
  String toString() {
    return "[title:${title} , score:${score} , energy:${energy} , su:${su} , amountOfGram:${amountOfGram}]";
  }
}
