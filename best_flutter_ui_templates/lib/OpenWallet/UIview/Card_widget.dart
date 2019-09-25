import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
import 'package:toast/toast.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class CardWidget extends StatefulWidget{
  String cardDigit;
  String year;
  String cardId;
  CardWidget(String cardDigit,String cardId, String year){
    this.cardDigit= cardDigit;
    this.year = year;
    this.cardId = cardId;
  }
  @override
  CardWidgetUi createState() => new CardWidgetUi(cardDigit, cardId, year);
}
class CardWidgetUi extends State<CardWidget>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  String cardDigit;
  String year;
  String cardId;
  CardWidgetUi(String cardDigit,String cardId, String year){
    this.cardDigit= cardDigit;
    this.year = year;
    this.cardId = cardId;
  }
  @override
  Widget build(BuildContext context) {
    bool poc= false;
    TextEditingController _amount = new TextEditingController();
    // TODO: implement build
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(19.0,5.0,19.0,5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  "assets/images/visa.png",
                  height: 30,
                  width: 25,
                ),
                Text("Visa",style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            ),
          ),
          Text("XXXX XXXX XXXX "+cardDigit, style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(
            height: 20,
          ),
          Text("Expiry Year: "+year,),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0,0,16.0,0),
            child: Text("*It will take around 2 minutes to reflect in account", style: TextStyle(color: Colors.red),),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              obscureText: false,
              controller: _amount,
              autovalidate: true,
              validator: (val)=> val==""?null:(int.parse(val)>=20?null:"Should be at least 20"),
              style: style,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                  hintText: "DAIs to Deposit",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: ()async{
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  poc=true;
                });
                Toast.show("Processing!", context,duration: Toast.LENGTH_LONG);
                await SharedPreferences.getInstance().then((prefs){
                  MoonPayWrapper wrapper = new MoonPayWrapper();
                  var address = prefs.getString("address");
                  var jwt = prefs.getString("jwt");
                  var amount = _amount.text.toString();
                  wrapper.addMoney(jwt, amount, address, cardId).then((val){
                    if(val){
                      prefs.setString("first", "yep");
                      if(prefs.getString("first")=="yep"){
                        prefs.setBool("approve", true);
                      }else{
                        prefs.setBool("approve", true);
                        prefs.setBool("allow", true);
                      }

                      Toast.show("Done! Check Mail ", context,duration: Toast.LENGTH_LONG);
                      setState(() {
                        poc=false;
                      });
                    }
                    else{
                      Toast.show("Something went wrong :(", context,duration: Toast.LENGTH_LONG);
                      setState(() {
                        poc=false;
                      });
                    }
                  });
                });

              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: poc? SpinKitCircle(size :10, color: Colors.black,): Text('Transact', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

}