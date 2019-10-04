import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/wrappers/ScannerWrapper.dart';
import 'loader.dart';
import 'package:best_flutter_ui_templates/OpenWallet/walletTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:toast/toast.dart';
class MaticTransactionsList extends StatefulWidget{
  MaticTransactionsLIstState createState() => new MaticTransactionsLIstState();
}
class MaticTransactionsLIstState extends State<MaticTransactionsList>{
  List json;
  String address;
  int loading =0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _transactionList();
  }
  @override
  void initState(){
    _getAddress();
    _getTransactions();
  }
  _getAddress()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address= prefs.getString("address");
      loading = loading+1;
    });
  }
  _getTransactions() async{
    ScannerWrapper wrapper = new ScannerWrapper();
    var js =  await wrapper.maticTransactions();
    setState((){
      json = js;
      loading =loading +1;
    });
  }
  _transactionList(){
    double c_width = MediaQuery.of(context).size.width*0.7;
    return Scaffold(
      backgroundColor: WalletAppTheme.background,
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 20,
          top: 70,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Transactions on Matic",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Back",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),

          loading!=2?whiteLoader():ListView.builder(
            shrinkWrap: true,
            itemCount: json.length,
            itemBuilder: (context, position){
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        json[position]["from"]=="0x000000000000000000000000"+address.substring(2).toLowerCase()?Icons.call_made:Icons.call_received,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text("From: "),
                          FlatButton(
                            onPressed:(){
                              ClipboardManager.copyToClipBoard(json[position]["from"]);
                              Toast.show("Address Copied", context);
                            },
                            child: Container(
                              width:c_width,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                child: Text(json[position]["topics"][1],textAlign: TextAlign.left),
                              ),
                            ),
                          ),
                          Text("To: "),
                          FlatButton(
                            onPressed:(){
                              ClipboardManager.copyToClipBoard(json[position]["to"]);
                              Toast.show("Address Copied", context);
                            },
                            child: Container(
                              width:c_width,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                child: Text(json[position]["topics"][2],textAlign: TextAlign.left),
                              ),
                            ),
                          ),
//                          Text("Amount:"),
//                          Padding(
//                            padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
//                            child: Text((int.parse(json[position]["value"])/1000000000000000000).toString()),
//                          )
                        ],
                      ),
                    )

                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}