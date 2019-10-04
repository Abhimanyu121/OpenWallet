import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/OpenWallet//UIview/titleView.dart';
import 'package:best_flutter_ui_templates/OpenWallet//walletTheme.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loader.dart';
import 'package:best_flutter_ui_templates/OpenWallet/UIview/Card_widget.dart';
import 'login.dart';
import 'package:toast/toast.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
class CardScreen extends StatefulWidget {
  final AnimationController animationController;

  const CardScreen({Key key, this.animationController}) : super(key: key);
  @override
  _cardScreenState createState() => _cardScreenState();
}

class _cardScreenState extends State<CardScreen>with
    AutomaticKeepAliveClientMixin {
  //with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  bool loading=true;
  bool fetching =true;
  List ls;
  bool kyc = false;
  bool cards= false;
  var _cardNo = new TextEditingController();
  var _cvv = new TextEditingController();
  var _expiry = new TextEditingController();
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {

    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    _initState().then((val){
      _getCard().then((val){

        setState(() {
          ls =val;
          for(int i = ls.length;i>2;i--){
            ls.removeLast();
          }
          fetching =false;
        });
        addAllListData();
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
  _getCard() async  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    MoonPayWrapper wrapper = new MoonPayWrapper();
    List js =  await wrapper.getCardList(jwt);
    return js;
  }
    _fetchjwt()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var jwt =prefs.getString("jwt");
      if(jwt==null){
        return false;
      }
      else return true;
    }
    _initState()async {
      bool state = await _fetchjwt();
      if(state){
        setState(() {
          cards=true;
          loading = false;
        });
      }
      else{
        setState(() {
          loading =false;
          kyc =true;
        });

      }
    }


  _kycButton(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("To use Cards you need to complete kyc"),
          SizedBox(height: 25,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login_email()),
                );
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Start KYC', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
  void addAllListData() {
    var count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Cards',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    if(ls.length==1){
      listViews.add(Row(
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
                   _getCard();
                });
              },
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
          )
        ],
      ));
    }
    listViews.add(
      CardWidget(ls[0]["lastDigits"].toString(), ls[0]["id"].toString(), ls[0]["expiryYear"].toString()),
    );
    if (ls.length>1){
      listViews.add(
        CardWidget(ls[1]["lastDigits"].toString(), ls[1]["id"].toString(), ls[1]["expiryYear"].toString()),
      );
    }
  }

  Future<bool> getData() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: WalletAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            loading?whiteLoader():kyc?_kycButton():fetching?whiteLoader():getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: WalletAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: WalletAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
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
                                  "Cards",
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
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
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
                  Toast.show("Adding", context);
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
        setState((){
          fetching =false;
        });

      });
    });
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
