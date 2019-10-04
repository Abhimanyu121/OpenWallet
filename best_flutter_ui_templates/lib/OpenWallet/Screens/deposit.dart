import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
import 'loader.dart';
import 'login.dart';
import '../home.dart';
class Deposit extends StatefulWidget{
  @override
  ReceiveUi createState()=> new ReceiveUi();
}
class ReceiveUi extends State<Deposit>{
  bool approve = false;
  bool allow = false;
  bool increase = false;
  bool kyc = false;
  bool eth =false;
  bool deposit = false;
  var recipient = new TextEditingController();
  var amount = new TextEditingController();
  bool loading = false;
  _fetchStatus()async {
    await SharedPreferences.getInstance().then((prefs){
      print("status:"+prefs.getBool("allow").toString());
      if(prefs.getBool("approve")==false||prefs.getBool("approve")==null){
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
        child: Image.asset('assets/images/transaction.png'),
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
        approve?Text(
          "Some approvals",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ):SizedBox(),
        //approve?_buttonApprove(context):(allow?_buttonAllow(context):(increase?_buttonIncrease(context):_buttonDeposit(context)))
        approve?Padding(
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
                  _approve();
                }
              });

              setState(() {
                loading =false;
              });
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  Home()), (Route<dynamic> route) => false);
            },
            padding: EdgeInsets.all(12),
            color: Colors.blueAccent,
            child: loading
                ? SpinKitCircle(size: 10, color: Colors.black,)
                : Text('Approve Stable Coin', style: TextStyle(color: Colors.white)),
          ),
        ):Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Amount',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
              ),
              controller: amount,
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
                      _deposit(amount.text);
                    }
                  });

                  setState(() {
                    loading =false;
                  });
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      Home()), (Route<dynamic> route) => false);
                },
                padding: EdgeInsets.all(12),
                color: Colors.blueAccent,
                child: loading
                    ? SpinKitCircle(size: 10, color: Colors.black,)
                    : Text('Deposit', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),

      ],
    );

  }

  _approve() {
      EthWrapper wrapper = new EthWrapper();
       wrapper.approveToken(99999);
      Navigator.pop(context);
  }
//  _allow() {
//      EthWrapper wrapper = new EthWrapper();
//        wrapper.allowanceToken();
//      Navigator.pop(context);
//  }
//  _increaseAllowance() {
//      EthWrapper wrapper = new EthWrapper();
//       wrapper.incAllowanceToken();
//      Navigator.pop(context);
//  }
  _deposit(amount) {
    EthWrapper wrapper = new EthWrapper();
    wrapper.depositERC20(double.parse(amount));
    Navigator.pop(context);
  }
  _loader(){
    return SpinKitChasingDots(size: 30,color: Colors.indigo,);
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
                Navigator.of(sc).pop(true);
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

//  _buttonApprove(context){
//    return Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: RaisedButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(24),
//        ),
//        onPressed: () async {
//          setState(() {
//            loading =true;
//          });
//          EthWrapper wrapper = new EthWrapper();
//          await wrapper.checkEth().then((val){
//            BigInt wei = val;
//            if(wei<BigInt.from(1000000000000000)){
//              _asyncConfirmDialog(context);
//            }
//            else{
//               _approve();
//            }
//          });
//
//          setState(() {
//            loading =false;
//          });
//          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//              Home()), (Route<dynamic> route) => false);
//        },
//        padding: EdgeInsets.all(12),
//        color: Colors.blueAccent,
//        child: loading
//            ? SpinKitCircle(size: 10, color: Colors.black,)
//            : Text('Approve Stable Coin', style: TextStyle(color: Colors.white)),
//      ),
//    );
//  }
//  _buttonIncrease(context){
//    return Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: RaisedButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(24),
//        ),
//        onPressed: () async {
//          setState(() {
//            loading =true;
//          });
//          EthWrapper wrapper = new EthWrapper();
//          await wrapper.checkEth().then((val){
//            BigInt wei = val;
//            if(wei<BigInt.from(1000000000000000)){
//              _asyncConfirmDialog(context);
//            }
//            else{
//             _increaseAllowance();
//            }
//          });
//
//          setState(() {
//            loading =false;
//          });
//          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//              Home()), (Route<dynamic> route) => false);
//        },
//        padding: EdgeInsets.all(12),
//        color: Colors.blueAccent,
//        child: loading
//            ? SpinKitCircle(size: 10, color: Colors.black,)
//            : Text('Increase allowance', style: TextStyle(color: Colors.white)),
//      ),
//    );
//  }
//  _buttonAllow(context){
//    return Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: RaisedButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(24),
//        ),
//        onPressed: () async {
//          setState(() {
//            loading =true;
//          });
//          EthWrapper wrapper = new EthWrapper();
//          await wrapper.checkEth().then((val){
//            BigInt wei = val;
//            if(wei<BigInt.from(1000000000000000)){
//              _asyncConfirmDialog(context);
//            }
//            else{
//             _allow();
//            }
//          });
//
//          setState(() {
//            loading =false;
//          });
//          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//              Home()), (Route<dynamic> route) => false);
//        },
//        padding: EdgeInsets.all(12),
//        color: Colors.blueAccent,
//        child: loading
//            ? SpinKitCircle(size: 10, color: Colors.black,)
//            : Text('Allow Stable Coin', style: TextStyle(color: Colors.white)),
//      ),
//    );
//  }
//  _buttonDeposit(context){
//    var amount = new TextEditingController();
//    return Column(
//      children: <Widget>[
//        TextFormField(
//        keyboardType: TextInputType.number,
//          textAlign: TextAlign.center,
//          decoration: InputDecoration(
//            hintText: 'Amount',
//            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//            border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
//          ),
//          controller: amount,
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(vertical: 16.0),
//          child: RaisedButton(
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(24),
//            ),
//            onPressed: () async {
//              setState(() {
//                loading =true;
//              });
//              EthWrapper wrapper = new EthWrapper();
//              await wrapper.checkEth().then((val){
//                BigInt wei = val;
//                if(wei<BigInt.from(1000000000000000)){
//                  _asyncConfirmDialog(context);
//                }
//                else{
//                  _deposit(amount.text);
//                }
//              });
//
//              setState(() {
//                loading =false;
//              });
//              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//                  Home()), (Route<dynamic> route) => false);
//            },
//            padding: EdgeInsets.all(12),
//            color: Colors.blueAccent,
//            child: loading
//                ? SpinKitCircle(size: 10, color: Colors.black,)
//                : Text('Deposit', style: TextStyle(color: Colors.white)),
//          ),
//        ),
//      ],
//    );
//  }

}