import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/loader.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/login.dart';
class EthereumTransactions extends StatefulWidget{
  @override
  ReceiveUi createState()=> new ReceiveUi();
}
class ReceiveUi extends State<EthereumTransactions>{
  var recipient = new TextEditingController();
  var amount = new TextEditingController();
  bool eth =false;
  bool loading = false;
  bool kyc = false;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: _receive_ui(),
    );
  }
  _receive_ui(){
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/eth.png'),
      ),
    );
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 9,
        top: 70,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Send on Ethereum",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        logo,
        SizedBox(
          height: 25,
        ),
        Text(
          "Recipient Phone Number",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: TextFormField(
            controller: recipient,
            keyboardType: TextInputType.number,
            validator:(val) => val.length!=64&&val.length!=0?"Invalid address":null,
            decoration: InputDecoration(
              hintText: 'Recipient',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: amount,
            validator:(val) => val.length!=64&&val.length!=0?"Invalid address":null,
            decoration: InputDecoration(
              hintText: 'Amount',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
             setState(() {
               loading =true;
             });
             EthWrapper wrapper = new EthWrapper();
             await wrapper.checkEth().then((val){
               BigInt wei = val;
               if(wei<BigInt.from(1000000000000000)){
                 _asyncConfirmDialog(context);
               }
               else{
                 _send(recipient.text, double.parse(amount.text));
               }
             });

             setState(() {
               loading =false;
             });
             Navigator.pop(context);
            },
            padding: EdgeInsets.all(12),
            color: Colors.blueAccent,
            child: loading
                ? SpinKitCircle(size: 10, color: Colors.black,)
                : Text('Send', style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );

  }
  _send(address, amount)async {
    EthWrapper wrapper = new EthWrapper();
    Toast.show("Sending Transaction", context,duration: Toast.LENGTH_LONG);
    await wrapper.transferTokenEth(address,amount);
    Toast.show("Transaction DOne", context);

  }
  _fetchjwt()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt =prefs.getString("jwt");
    if(jwt==null){
      return false;
    }
    else return true;
  }
  _initState()async {
    bool state = await _fetchjwt();
    if(state){
      setState(() {
        kyc=false;
        loading = false;
      });
    }
    else{
      setState(() {
        loading =false;
        kyc =true;
      });

    }
  }
  Future<bool> _asyncConfirmDialog(BuildContext context) async {
    await _fetchjwt().then((val)async {
      await _initState().then((abc){

      });
    });
    BuildContext sc = context;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insufficient Eth'),
          content: eth?whiteLoader():kyc?_kycButton(context): Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  'You have insufficient funds for trnasfer of token, would you like to buy some(20 USD) ether?'),
              Text("* Try after 2 minutes of depositing ether", style: TextStyle(color: Colors.red),)
            ],
          ),

          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            !kyc?FlatButton(
              child: const Text('Deposit'),
              onPressed: () async {

                Toast.show("In proccess, please wait for 2 minutes", context,duration: Toast.LENGTH_LONG);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String jwt = prefs.getString("jwt");
                String address= prefs.getString("address");
                MoonPayWrapper wrapper = new MoonPayWrapper();
                List ls = await wrapper.getCardList(jwt);
                await wrapper.addEth(jwt, address, ls[0]["id"]).then((val){
                  setState(() {
                    eth =false;
                  });
                  Navigator.of(context).pop(true);
                });

              },
            ):null,
          ],
        );
      },
    );
  }
  _kycButton(sc){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("To use Cards you need to complete kyc"),
          SizedBox(height: 25,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () async {
                Navigator.push(
                  sc,
                  MaterialPageRoute(builder: (context) => Login_email()),
                );
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Start KYC', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

}