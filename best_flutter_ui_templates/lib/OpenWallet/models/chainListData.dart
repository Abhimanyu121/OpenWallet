class ChainListData {
  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int kacl;

  ChainListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = "",
    this.endColor = "",
    this.meals,
    this.kacl = 0,
  });

  static List<ChainListData> tabIconsList = [
    ChainListData(
      imagePath: 'assets/images/eth.png',
      titleTxt: 'Ethereum',
      kacl: 525,
      meals: ["Secure,", "Slower,", "Easier"],
      startColor: "#0d47a1",
      endColor: "#1565c0",
    ),
    ChainListData(
      imagePath: 'assets/images/matic.png',
      titleTxt: 'Matic',
      kacl: 602,
      meals: ["Fast,", "cheap,", "Extra steps"],
      startColor: "#455a64",
      endColor: "#546e7a",
    ),

  ];
}
