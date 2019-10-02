import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
class EthereumTransactions extends StatefulWidget{
  @override
  ReceiveUi createState()=> new ReceiveUi();
}
class ReceiveUi extends State<EthereumTransactions>{
  bool approve = false;
  bool allow = false;
  bool increase = false;
  bool eth =false;
  bool deposit = false;
  var recipient = new TextEditingController();
  var amount = new TextEditingController();
  bool loading = false;
  _fetchStatus()async {
    await SharedPreferences.getInstance().then((prefs){
      if(prefs.getBool("approve")!=true){
        setState((){
          approve= true;
        });
      }else if (prefs.getBool("allow")!= true){
        setState(() {
          allow =true;
        });
      }else if (prefs.getBool("increase")!=true){
        setState(() {
          increase= true;
        });
      }else{
        setState((){
          deposit = true;
        });
      }
    });

  }
  @override
  void initState() {
    _fetchStatus();
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: _depositUi(),
    );
  }
  _depositUi(){
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/deposit.png'),
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
              "Deposit on Matic",
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
          "Some approvals",
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
            keyboardType: TextInputType.text,
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
              //_send(recipient.text, double.parse(amount.text));
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

  _approve(){
      EthWrapper wrapper = new EthWrapper();
      wrapper.approveToken(99999);
      Navigator.pop(context);
  }
  _allow(){
      EthWrapper wrapper = new EthWrapper();
      wrapper.allowanceToken();
      Navigator.pop(context);
  }
  _increaseAllowance(){
      EthWrapper wrapper = new EthWrapper();
      wrapper.incAllowanceToken();
      Navigator.pop(context);
  }
  _loader(){
    return SpinKitChasingDots(size: 30,color: Colors.indigo,);
  }
  Future<bool> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insufficient Eth'),
          content: eth?_loader(): Column(
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
            FlatButton(
              child: const Text('Deposit'),
              onPressed: () async {
                setState(() {
                  eth =true;
                });
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
            )
          ],
        );
      },
    );
  }
  _getBalance()async {
    EthWrapper wrapper = new EthWrapper();
    return  wrapper.checkBalanceRopsten();

  }
  _approveUi(){
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/deposit.png'),
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
              "Deposit on Matic",
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
          "Some approvals",
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
          child: RaisedButton(
            child: Text("Approve Side Chain"),
            onPressed: (){},
          )
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
              //_send(recipient.text, double.parse(amount.text));
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
}