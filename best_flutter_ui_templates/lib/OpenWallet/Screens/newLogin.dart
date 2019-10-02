import 'package:flutter/material.dart';
class newLogin extends StatefulWidget{
  newLoginState createState () => new newLoginState();
}
class newLoginState extends State<newLogin>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _phoneno = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/trellis.png'),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }
  _login(){

  }
  _phoneNo(){
    final emailui = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autovalidate: true,
      validator: (val) => val.length!=10&&val.length!=0
          ? 'Not a valid Phone number.'
          : null,
      decoration: InputDecoration(
        hintText: 'Phone number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _phoneno,
    );
    final button = RaisedButton(
      
    );
  }
}