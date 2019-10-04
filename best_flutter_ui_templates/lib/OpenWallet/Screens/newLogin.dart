import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:best_flutter_ui_templates/wrappers/keyInterface.dart';
import 'package:web3dart/web3dart.dart';
import 'package:toast/toast.dart';
import 'package:best_flutter_ui_templates/OpenWallet/home.dart';
class newLogin extends StatefulWidget{
  newLoginState createState () => new newLoginState();
}
class newLoginState extends State<newLogin>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _phoneno = new TextEditingController();
  bool checking =false;
  bool phoneNo = true;
  bool gen= false;
  bool otp =false;
  var _ppk = new TextEditingController();
  var _mn = new TextEditingController();
  var _newMn = new TextEditingController();
  bool keys = false;
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
            phoneNo?_phoneNo():_keys()
          ],
        ),
      ),
    );
  }

  _phoneNo(){
    final phoneui = TextFormField(
      keyboardType: TextInputType.number,
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
    _button(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            setState(() {
              checking =true;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("phoneNo",_phoneno.text);
            setState(() {
              checking =false;
              phoneNo = false;
              otp =true;
            });
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child:checking? SpinKitCircle(size :10, color: Colors.black,):Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Column(
      children: <Widget>[
        phoneui,
        SizedBox(
          height: 25,
        ),
        _button(),

      ],
    );
  }

   _keys(){
     _button1() {
       return Padding(
         padding: EdgeInsets.symmetric(vertical: 16.0),
         child: RaisedButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(24),
           ),
           onPressed: () async {
             EthWrapper wrapper = new EthWrapper();

             FocusScope.of(context).requestFocus(FocusNode());
             setState(() {
               checking = true;
             });

             SharedPreferences prefs = await SharedPreferences.getInstance();
             prefs.setString("privateKey", _ppk.text);
             Credentials fromHex = EthPrivateKey.fromHex(_ppk.text);
             var address = await fromHex.extractAddress();
             print(address);
             prefs.setString("address", address.toString());
             prefs.setBool("allow", false);
             prefs.setBool("approve",false);
             var ph = prefs.getString("phoneNo");
             var val = await wrapper.mapNumber(ph);

             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                 Home()), (Route<dynamic> route) => false);

           },
           padding: EdgeInsets.all(12),
           color: Colors.blueAccent,
           child: checking
               ? SpinKitCircle(size: 10, color: Colors.black,)
               : Text('Continue', style: TextStyle(color: Colors.white)),
         ),
       );
     }
     _buttongen() {
       return Padding(
         padding: EdgeInsets.symmetric(vertical: 16.0),
         child: RaisedButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(24),
           ),
           onPressed: () async {

             FocusScope.of(context).requestFocus(FocusNode());
             setState(() {
               checking = true;
             });
             Toast.show("Generating", context,duration: Toast.LENGTH_LONG);
             KeyInterface wrapper = new KeyInterface();
             _newMn.text =await wrapper.generateKey();
             gen =true;
             setState(() {
               checking =false;
             });
           },
           padding: EdgeInsets.all(12),
           color: Colors.blueAccent,
           child:checking? SpinKitCircle(size :10, color: Colors.black,):Text('Generate mnemonic', style: TextStyle(color: Colors.white)),
         ),
       );
     }
     _buttoncont() {
       return Padding(
         padding: EdgeInsets.symmetric(vertical: 16.0),
         child: RaisedButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(24),
           ),
           onPressed: () async {
             FocusScope.of(context).requestFocus(FocusNode());
             SharedPreferences prefs= await SharedPreferences.getInstance();
             prefs.setBool("allow", false);
             prefs.setBool("approve",false);
             setState(() {
               checking = true;
             });
             if (gen){
               EthWrapper wrapper = new EthWrapper();
               Clipboard.setData(new ClipboardData(text: _newMn.text));
               var ph = prefs.getString("phoneNo");
               var val = await wrapper.mapNumber(ph);
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                   Home()), (Route<dynamic> route) => false);
             }
             else{
               Toast.show("Generate mnemonic first", context,duration: Toast.LENGTH_LONG);
             }
             checking =false;

           },
           padding: EdgeInsets.all(12),
           color: Colors.blueAccent,
           child: Text('Continue (Make sure you have saved mnemonic)', style: TextStyle(color: Colors.white)),
         ),
       );
     }
     _buttonmn() {
       return Padding(
         padding: EdgeInsets.symmetric(vertical: 16.0),
         child: RaisedButton(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(24),
           ),
           onPressed: () async {
             FocusScope.of(context).requestFocus(FocusNode());
             setState(() {
               checking = true;
             });
             KeyInterface key = new KeyInterface();
             key.fromMenmonic(_mn.text);

           },
           padding: EdgeInsets.all(12),
           color: Colors.blueAccent,
           child: checking
               ? SpinKitCircle(size: 10, color: Colors.black,)
               : Text('Continue', style: TextStyle(color: Colors.white)),
         ),
       );
     }
     const mne= Text("Add account using Mnemonic");
     final mnemonic = TextFormField(
       keyboardType: TextInputType.number,
       autovalidate: true,
       validator: (val) => val.length<10
           ? 'Invalid private key'
           : null,
       decoration: InputDecoration(
         hintText: 'Private key',
         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
       ),
       controller: _mn,
     );
     const ppk= Text("Add account using Private Key");
     final private_key = TextFormField(
       keyboardType: TextInputType.number,
       autovalidate: true,
       validator: (val) => val.length<10
           ? 'Invalid private key'
           : null,
       decoration: InputDecoration(
         hintText: 'Private key',
         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
       ),
       controller: _ppk,
     );
     const newacc= Text("Create new account(Copy the generated mnemonic somewhere safe)");
     final newMnemonic = TextFormField(
       keyboardType: TextInputType.number,
       autovalidate: true,
       autofocus: false,
       decoration: InputDecoration(
         hintText: 'Your Mnemonic will appear here',
         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
       ),
       controller: _newMn,
     );
     return Column(
       children: <Widget>[


         ppk,
         SizedBox(height: 4.0),
         private_key,
         SizedBox(height: 8.0),
         _button1(),
         SizedBox(height: 8.0),
         newacc,
         SizedBox(height: 4.0),
         newMnemonic,
         SizedBox(height: 8.0),
         _buttongen(),
         SizedBox(height: 8.0),
         _buttoncont(),



       ],
     );
   }

}