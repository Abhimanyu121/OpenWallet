import 'package:OpenWallet/main.dart';
import 'package:flutter/material.dart';
import '../walletTheme.dart';
import 'package:toast/toast.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AddressCard extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const AddressCard({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool transacting =false;
  bool noTransactions= true;
  bool loading = true;
  String address= '';
  _getAddress()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address= prefs.getString("address");
      loading =false;
    });
  }
  @override
  void initState(){
    _getAddress();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    WalletAppTheme.nearlyDarkBlue,
                    HexColor("#6F56E8")
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: WalletAppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Your Address',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: WalletAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: WalletAppTheme.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child:FlatButton(
                          onPressed: (){
                            ClipboardManager.copyToClipBoard(address).then((val){
                              Toast.show("Hash Copied", context);
                            });
                          },
                          child: Text(
                            address,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: WalletAppTheme.fontName,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              letterSpacing: 0.0,
                              color: WalletAppTheme.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
