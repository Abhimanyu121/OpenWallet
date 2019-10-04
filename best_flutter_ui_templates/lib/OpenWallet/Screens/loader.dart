import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/OpenWallet/walletTheme.dart';
class Loader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: SpinKitRipple(
        size: 50,
        color: Colors.indigo
      ),
    );
  }

}
class whiteLoader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        color: WalletAppTheme.background,
        child: SpinKitRipple(
            size: 50,
            color: Colors.indigo
        ),
      ),
    );
  }
}