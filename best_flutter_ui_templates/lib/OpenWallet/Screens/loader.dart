import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
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
        color: Colors.white,
        child: SpinKitRipple(
            size: 50,
            color: Colors.indigo
        ),
      ),
    );
  }
}