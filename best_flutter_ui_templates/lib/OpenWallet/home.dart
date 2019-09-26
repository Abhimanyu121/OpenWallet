import 'package:best_flutter_ui_templates/OpenWallet/models/tabIconData.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Transactions/transaction.dart';
import 'package:flutter/material.dart';
import 'bottomNavigationView/bottomBarView.dart';
import 'walletTheme.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/cards.dart';
import 'Screens/Wallets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin {
  AnimationController animationController;
  int index=0;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget wallets = Container(
    color: WalletAppTheme.background,
  );
  Widget fiatCrypto = Container(
    color: WalletAppTheme.background,
  );
  Widget deposit = Container(
    color: WalletAppTheme.background,
  );
  Widget info = Container(
    color: WalletAppTheme.background,
  );
  Widget transact = Container(
    color: WalletAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    wallets = WalletsScreen(animationController: animationController);
    deposit = TransactionsScreen(animationController: animationController);
    fiatCrypto = BuyandSell(animationController: animationController,);
    info =BuyandSell(animationController: animationController,);
    transact = BuyandSell(animationController: animationController,);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WalletAppTheme.background,
      child: Scaffold(
        appBar: ,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: (){setState(() {
            index=2;
          });},
          backgroundColor: Colors.red,
          child:  Icon(
            (index==2 ? Icons.clear:Icons.add),
            color: Colors.black,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,

          shape: CircularNotchedRectangle(),
          notchMargin: 6,
          child: Container(
            decoration: BoxDecoration(
                color: WalletAppTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                  
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0,8,16,8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.account_balance_wallet),
                    color: (index==0? Colors.red : Colors.blueGrey),
                    onPressed: () {
                      setState(() {
                        index=0;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.file_download),
                    color: (index==1? Colors.red : Colors.blueGrey),
                    onPressed: () {
                      setState(() {
                        index=1;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: (index==3? Colors.red : Colors.blueGrey),
                    onPressed: () {
                      setState(() {
                        index=3;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    color: (index==4? Colors.red : Colors.blueGrey),
                    onPressed: () {
                      setState(() {
                        index =4;
                      });
                    },
                  ),

                ],
              ),
            ),
          ),

        ),
        backgroundColor: Colors.transparent,
        body: index ==0?wallets:(index==1?deposit:(index==2?fiatCrypto:(index==3?transact:info)))
      ),
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
  Future<bool> getData() async {
    return true;
  }
}
