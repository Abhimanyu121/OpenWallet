import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/OpenWallet/UIview/Card_widget.dart';
import 'package:best_flutter_ui_templates/OpenWallet/walletTheme.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/loader.dart';
class BuyandSell extends StatefulWidget {
  final AnimationController animationController;
  BuyandSell({this.animationController});
  @override
  _BuyandSellState createState() => _BuyandSellState();
}

class _BuyandSellState extends State<BuyandSell>  with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  List ls;
  var scrollController = ScrollController();
  bool loading=false;
  bool fetching =true;
  var _cardNo = new TextEditingController();
  var _cvv = new TextEditingController();
  var _expiry = new TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  _getCard() async  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    MoonPayWrapper wrapper = new MoonPayWrapper();
    List js =  await wrapper.getCardList(jwt);
    return js;
  }
  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    _getCard().then((val){

      setState(() {
        ls =val;
        for(int i = ls.length;i>2;i--){
          ls.removeLast();
        }
        fetching =false;
      });
    });
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: WalletAppTheme.background,
      child: Scaffold(
        appBar: _appbar(),
        backgroundColor: Colors.transparent,
          body:fetching?
          Loader():_cardList()

      ),
    );
  }
  Future<String> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Card details'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: _cards(),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: Text("Add Card"),
                onPressed: () async {
                  setState(() {
                    loading=true;
                  });
                  MoonPayWrapper wrapper = new MoonPayWrapper();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String jwt = prefs.getString("jwt");
                  await wrapper.addCard2(jwt).then((boolean){
                    print("login valeue:"+boolean.toString());
                    Navigator.of(context).pop("Done!");

                  });
                })
          ],
        );
      },
    );
  }
  _cards(){

    final cardNo = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => val.length!=19
          ? 'Not a valid email.'
          : null,
      decoration: InputDecoration(
        hintText: 'Card Number (XXXX XXXX XXXX XXXX)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _cardNo,
    );
    final cvv = TextFormField(
      keyboardType: TextInputType.number,
      autovalidate: true,
      validator: (val) => val.length!=3
          ? 'Invalid CVV.'
          : null,
      decoration: InputDecoration(
        hintText: 'CVV',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _cvv,
    );
    final expiry = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => val.length!=7
          ? 'Invalid Date'
          : null,
      decoration: InputDecoration(
        hintText: 'Expiry Date MM/YYYY',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _expiry,
    );
    return Column(
      children: <Widget>[

        cardNo,
        SizedBox(height: 8.0),
        cvv,
        SizedBox(height: 8.0),
        expiry,
        SizedBox(height: 8.0),
        loading?Loader:SizedBox(height: 1,)



      ],
    );
  }
  _refresh(){
    setState(() {
      fetching =true;
    });
    _getCard().then((val){

      setState(() {
        ls =val;
        for(int i = ls.length;i>2;i--){
          ls.removeLast();
        }
        fetching =false;
      });
    });
  }


  _appbar(){
    var width = MediaQuery.of(context).size.width * 0.95;
    var height = MediaQuery.of(context).size.height * 0.12;
    return  PreferredSize(
      preferredSize: Size(width, height),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16 - 8.0 * topBarOpacity,
                bottom: 12 - 8.0 * topBarOpacity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Wallets",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: WalletAppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22 + 6 - 6 * topBarOpacity,
                        letterSpacing: 1.2,
                        color: WalletAppTheme.darkerText,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.power_settings_new,
                          color: WalletAppTheme.grey,
                          size: 18,
                        ),
                      ),
                      Text(
                        "Logout",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: WalletAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          letterSpacing: -0.2,
                          color: WalletAppTheme.darkerText,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }


  _cardList(){
    return ListView(
        primary: true,
        shrinkWrap: true,
        children: <Widget>[
          //_appbar(),
          ls.length==1?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.add),
                      Text("Add Card")
                    ],
                  ),
                  onPressed: (){
                    _asyncInputDialog(context).then((str){
                      if(str =="Done!")
                        _refresh();
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
              )
            ],
          ):SizedBox(

          ),
         ListView.builder(
             shrinkWrap: true,
             primary:  false,
             physics: NeverScrollableScrollPhysics(),
             itemCount: ls.length,
             itemBuilder: (context , position){
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: CardWidget(ls[position]["lastDigits"].toString(), ls[position]["id"].toString(), ls[position]["expiryYear"].toString()),
               );
             }

         ),

          SizedBox(
            height: 80,
          )
        ],
      );

  }
}