import 'package:best_flutter_ui_templates/OpenWallet//walletTheme.dart';
import 'package:flutter/material.dart';

class ExtraTip extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const ExtraTip({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*0.6;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: WalletAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(40.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: WalletAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8,top: 16),
                            child: Text(
                              'Tip',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: WalletAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: WalletAppTheme.darkText),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      width: c_width,
                                      child: Text(
                                        'Transactions on Matic are faster but initial proccess takes time. Transfer amount to matic chain if you do a lot of transactions.',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontFamily: WalletAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: WalletAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: WalletAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '60 times faster',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: WalletAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: WalletAppTheme.darkText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Speed',
                                    textAlign: TextAlign.center
                                    ,
                                    style: TextStyle(
                                      fontFamily: WalletAppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: WalletAppTheme.grey
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '23 Times cheaper',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: WalletAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: WalletAppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Cost',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: WalletAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: WalletAppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
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
          ),
        );
      },
    );
  }
}
