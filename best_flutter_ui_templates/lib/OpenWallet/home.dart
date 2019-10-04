import 'package:best_flutter_ui_templates/OpenWallet/models/tabIconData.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Transactions/transaction.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/cardAndKyc.dart';
import 'walletTheme.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/cards.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/ListTransactions.dart';
import 'Screens/Wallets.dart';
import 'Screens/Information.dart';
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
    wallets = new  WalletsScreen(animationController: animationController);
    deposit = new  TransactionsScreen(animationController: animationController);
    fiatCrypto = new  CardScreen(animationController: animationController,);
    info = new InformationScreen(animationController: animationController,);
    transact = new  ListTransactions(animationController: animationController,);

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

  Future<bool> getData() async {
    return true;
  }
}
