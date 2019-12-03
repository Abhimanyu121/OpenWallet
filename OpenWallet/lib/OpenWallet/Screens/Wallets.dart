import 'package:OpenWallet/OpenWallet//UIview/extraTip.dart';
import 'package:OpenWallet/OpenWallet//UIview/balanceCard.dart';
import 'package:OpenWallet/OpenWallet//UIview/titleView.dart';
import 'package:OpenWallet/OpenWallet//walletTheme.dart';
import 'package:OpenWallet/OpenWallet//Screens/chainList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loader.dart';
import 'package:OpenWallet/wrappers/ethWrapper.dart';
import 'dart:async';
class WalletsScreen extends StatefulWidget {
  final AnimationController animationController;

  const WalletsScreen({Key key, this.animationController}) : super(key: key);
  @override
  _WalletsScreenState createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen>with
    AutomaticKeepAliveClientMixin {
    //with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  int loading=0 ;
  String balanceRopsten="";
  String balanceMatic = "";
  int maticCount =0;
  int ropstenCount=0;
  String phone="";
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {

    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    _fetchBalance().then((val){
      _fetchCount().then((val){
        _fetchPhone().then((val){
          addAllListData();
          print("load ="+loading.toString());
        });
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
  _fetchPhone()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str= prefs.getString("phoneNo");
    setState(() {
      phone= str;
    });
    return str;
  }
  _fetchCount() async {
    EthWrapper wrapper = new EthWrapper();
    int ropsten = await wrapper.ropstenTransactionNumber();
    setState(() {
      ropstenCount= ropsten;
      loading= loading+1;
    });
  }
  _fetchBalance()async{
    EthWrapper wrapper = new EthWrapper();

    String matic= await  wrapper.checkBalanceMatic();
    String ropsten = await wrapper.checkBalanceRopsten();
    setState(() {
      balanceRopsten =ropsten;
      balanceMatic = matic;
      loading= loading+1;
    });
    return true;
  }
  void addAllListData() {
    var count = 9;

    listViews.add(
      TitleView(
        titleTxt: 'Wallet Balances',
        //subTxt: 'Details',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      BalanceCardView(
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        balanceMatic: balanceMatic,
        balanceRopsten: balanceRopsten,
        phone: phone,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Transaction History',
        //subTxt: 'Trnsactions',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      ChainListView(
        mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
        maticCount: maticCount,
        ropstenCount: ropstenCount,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Extras',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      ExtraTip(
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

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
            loading!=2? Loader(): getMainListViewUI(),
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
