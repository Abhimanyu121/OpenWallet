import 'package:best_flutter_ui_templates/OpenWallet//UIview/titleView.dart';
import 'package:best_flutter_ui_templates/OpenWallet//walletTheme.dart';
import 'package:best_flutter_ui_templates/wrappers/ScannerWrapper.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:toast/toast.dart';
import 'loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
class ListTransactions extends StatefulWidget {
  final AnimationController animationController;

  const ListTransactions({Key key, this.animationController}) : super(key: key);
  @override
  _ListTransactionsState createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions>with
    AutomaticKeepAliveClientMixin {
  //with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  bool loading=false;
  List json=new List();
  String address= '';
  var count =9;
  bool ld=false;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double c_width;
  double topBarOpacity = 0.0;
  var phno = new TextEditingController();
  @override
  void initState() {
    getData();
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));


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
  _fetch()async {
    setState((){
      loading = true;
    });
    if (phno.text.length!=10){
      Toast.show("Invalid Number", context);
      return;
    }
    EthWrapper wrapper  = new EthWrapper();
    String address = await wrapper.fetchAddress(phno.text);
    ScannerWrapper wrapper2 = new ScannerWrapper();
    await wrapper2.getTxList(address).then((list){
      setState(() {
        json= list;
        this.address = address;
        loading = false;
      });
    });

  }


  Future<bool> getData() async {
    await Future.delayed(Duration(milliseconds: 1000)).then((val){
      setState((){
        ld= true;
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    c_width = MediaQuery.of(context).size.width*0.5;
    return Container(
      color: WalletAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            !ld?whiteLoader():getMainListViewUI(),
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
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(

                      children: <Widget>[
                        TitleView(
                            titleTxt: 'Phone number',
                            //subTxt: 'Details',
                            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                            parent: widget.animationController,
                            curve:
                            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
                            animationController: widget.animationController,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            autovalidate: true,
                            validator: (val) => val.length!=10&&val.length!=0
                                ? 'Not a valid Phone number.'
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Enter Phone number',
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
                            ),
                            controller: phno,
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _fetch();
                          },
                          padding: EdgeInsets.all(12),
                          color: Colors.blueAccent,
                          child:loading?SpinKitSpinningCircle(size:20,color:Colors.white): Text('Fetch Transactions', style: TextStyle(color: Colors.white)),
                        ),
                        json==null?SizedBox():ListView.builder(
                          shrinkWrap: true,
                          itemCount: json.length,
                          itemBuilder: (context, position){
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      json[position]["from"]==address?Icons.call_made:Icons.call_received,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text("From: ",textAlign: TextAlign.left),
                                          FlatButton(
                                            onPressed:(){
                                              ClipboardManager.copyToClipBoard(json[position]["from"]);
                                              Toast.show("Address Copied", context);
                                            },
                                            child: Container(
                                              width: c_width,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                                child: Text(json[position]["from"],textAlign: TextAlign.left),
                                              ),
                                            ),
                                          ),
                                          Text("To: ",textAlign: TextAlign.left),
                                          FlatButton(
                                            onPressed:(){
                                              ClipboardManager.copyToClipBoard(json[position]["to"]);
                                              Toast.show("Address Copied", context);
                                            },
                                            child: Container(
                                              width: c_width,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                                child: Text(json[position]["to"],textAlign: TextAlign.left),
                                              ),
                                            ),
                                          ),
                                          Text("Amount:"),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                            child: Text((int.parse(json[position]["value"])/1000000000000000000).toString(),textAlign: TextAlign.left),
                                          )
                                        ],
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                                  "Transactions",
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
