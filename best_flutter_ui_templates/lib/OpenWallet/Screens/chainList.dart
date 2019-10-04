import 'package:best_flutter_ui_templates/OpenWallet//walletTheme.dart';
import 'package:best_flutter_ui_templates/OpenWallet//models/chainListData.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/EthereumTransactionsList.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/MaticTransactionList.dart';

class ChainListView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;
  final int maticCount;
  final int ropstenCount;
  const ChainListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation,this.ropstenCount, this.maticCount})
      : super(key: key);
  @override
  _ChainListViewState createState() => _ChainListViewState(maticCount: maticCount,ropstenCount: ropstenCount);
}

class _ChainListViewState extends State<ChainListView>
    with TickerProviderStateMixin {
  final int maticCount;
  final int ropstenCount;
  final String phone;
  _ChainListViewState(
      {this.maticCount, this.ropstenCount, this.phone });
  AnimationController animationController;
  List<ChainListData> chainListData = ChainListData.tabIconsList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: chainListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var count =
                      chainListData.length > 10 ? 10 : chainListData.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return ChainView(
                    chainListData: chainListData[index],
                    animation: animation,
                    animationController: animationController,
                    maticCount: maticCount,
                    ropstenCount: ropstenCount,
                    index:index,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChainView extends StatelessWidget {
  final int maticCount;
  final int ropstenCount;
  final index;
  final ChainListData chainListData;
  final AnimationController animationController;
  final Animation animation;

  const ChainView(
      {Key key, this.chainListData, this.animationController, this.animation,this.ropstenCount,this.maticCount, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: FlatButton(
              onPressed: (){
                if(chainListData.imagePath=="assets/images/eth.png"){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EthereumTranscationsList()),
                  );
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MaticTransactionsList()),
                  );
                }
              },
              child: SizedBox(
                width: 190,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor(chainListData.endColor)
                                    .withOpacity(0.6),
                                offset: Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              HexColor(chainListData.startColor),
                              HexColor(chainListData.endColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                chainListData.titleTxt,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: WalletAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: WalletAppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        chainListData.meals.join("\n"),
                                        style: TextStyle(
                                          fontFamily: WalletAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: WalletAppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              chainListData.kacl != 0
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          index==0?ropstenCount.toString():maticCount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: WalletAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                            letterSpacing: 0.2,
                                            color: WalletAppTheme.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child: Text(
                                            'Transactions',
                                            style: TextStyle(
                                              fontFamily:
                                                  WalletAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              letterSpacing: 0.2,
                                              color: WalletAppTheme.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: WalletAppTheme.nearlyWhite,
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: WalletAppTheme.nearlyBlack
                                                  .withOpacity(0.4),
                                              offset: Offset(8.0, 8.0),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.add,
                                          color: HexColor(chainListData.endColor),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: WalletAppTheme.nearlyWhite.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(chainListData.imagePath),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
