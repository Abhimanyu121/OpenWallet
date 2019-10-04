import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/wrappers/moonPayWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:best_flutter_ui_templates/wrappers/keyInterface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:best_flutter_ui_templates/wrappers/ethWrapper.dart';
import 'package:web3dart/web3dart.dart';
import 'package:best_flutter_ui_templates/OpenWallet//home.dart';
class Login_email extends StatefulWidget{
  Login_email_ui createState() => new Login_email_ui();
}
class Login_email_ui extends State<Login_email>{
  bool checking =false;
  bool email =true;
  bool otp =false;
  bool details = false;
  bool keys = false;
  bool file= false;
  bool card = false;
  bool gen= false;
  MoonPayWrapper wrapper = new MoonPayWrapper();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _email = new TextEditingController();
  var _otp = new TextEditingController();
  var _firstName = new TextEditingController();
  var _lastName = new TextEditingController();
  var _cardNo = new TextEditingController();
  var _cvv = new TextEditingController();
  var _expiry = new TextEditingController();
  var _ppk = new TextEditingController();
  var _mn = new TextEditingController();
  var _newMn = new TextEditingController();
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
      key:_scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child:  ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email? _emailui(): (otp?_otpUi(): (details?_details():(file ? _files():(card? _cards():_cards()))))
          ],
        ),
      ),
    );

  }

  _emailui(){
    _emButton(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {

            setState(() {
              checking = true;
            });
            if(EmailValidator.validate(_email.text)){
              wrapper.tokenGen(_email.text).then((status)async {
                if (status ==true){
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("email", _email.text);
                  setState(() {
                    checking = false;
                    otp = true;
                    email =false;
                  });
                }
                else{
                  setState(() {
                    checking = false;
                  });
                  Toast.show("Something went Wrong", context);
                }
              });}
            else {
              setState(() {
                checking = false;
              });
              Toast.show("Invalid Email", context);
            }
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child: checking? SpinKitCircle(size :10, color: Colors.black,):Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    final emailui = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autovalidate: true,
      validator: (val) => !EmailValidator.validate(val, true)&&val.length!=0
          ? 'Not a valid email.'
          : null,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _email,
    );


    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      children: <Widget>[
        emailui,
        SizedBox(height: 8.0),
        _emButton(),

      ],
    );
  }
  _otpUi(){
    _button(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              checking =true;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String _email = prefs.getString("email");
            wrapper.getToken(_email, _otp.text).then((value)async {
              if(value.toString()!=null){
                prefs.setString("jwt", value);
                wrapper.getDetailStatus(value).then((val){
                  if(val){
                    Navigator.pop(context);
                  }
                  else{
                    setState(() {
                      email= false;
                      otp = false;
                      details = true;
                      file =false;
                      card =false;
                      checking = false;
                      keys =false;
                    });
                  }
                });


//                await wrapper.getDetailStatus(value).then((val){
//                  if(val){
//                    setState(() {
//                      checking=false;
//                      wrapper.checkCard(value).then((boolean){
//                        if(boolean){
//                          setState(() {
//                            email= false;
//                            otp = false;
//                            details = false;
//                            file =true;
//                            card =false;
//                            checking = false;
//                          }
//                          );
//                        }
//                        else
//                          {
//                            setState(() {
//                              email= false;
//                              otp = false;
//                              details = false;
//                              card =false;
//                              keys =true;
//                              checking = false;
//                            });
//                          }
//                      });
//                    });
//                    print("skip");
//                  }
//                  else{
//                    setState(() {
//                      email= false;
//                      otp = false;
//                      details = true;
//                      checking = false;
//                    });
//                    print("no skipping");
//                    Toast.show("true", context);
//                  }
//                });
              }else{
                setState(() {
                  checking =false;
                  Toast.show("Pass", context);
                });
                Toast.show("Invalid OTP", context);
              }
            });

          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child: checking? SpinKitCircle(size :10, color: Colors.black,):Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    final otpui = TextFormField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      autovalidate: true,
      validator: (val) => (val.length==4||val.length==0) ?null:"Invalid otp",
      decoration: InputDecoration(
        hintText: 'OTP (Check Email) ',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _otp,
    );
    _back(){
      return FlatButton(
        child: Text("Go Back"),
        onPressed: (){
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            email =true;
            otp= false;
            checking = false;
          });
        },
      );
    }
    return Column(
      children: <Widget>[

        otpui,
        SizedBox(height: 8.0),
        _button(),
        SizedBox(height: 8.0),
        _back(),

      ],
    );

  }
  _details(){
    _button(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              checking =true;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String jwt = prefs.getString("jwt");
            print(jwt);
            wrapper.putDetails(jwt, _firstName.text, _lastName.text).then((val){
              if(val){
                prefs.setString("firstName", _firstName.text);
                setState(() {
                  checking=false;
                  file = true;
                  card= false;
                  details = false;
                });
              }
              else{
                setState(() {
                  checking = false;
                });
                Toast.show("Something went wrong", context);
              }
            });

          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child: checking? SpinKitCircle(size :10, color: Colors.black,):Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    final firstName = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      autofocus: false,
      validator: (val) => (val.length>1) ?null:"Invalid First Name",
      decoration: InputDecoration(
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _firstName,
    );
    final lastName = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => (val.length>4) ?null:"Invalid Last Name",
      decoration: InputDecoration(
        hintText: 'Last Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _lastName,
    );

    return Column(
      children: <Widget>[

        firstName,
        SizedBox(height: 8.0),
        lastName,
        SizedBox(height: 8.0),
        _button(),


      ],
    );

  }
  _files(){
    const text= Text("Choose your selfie with ID card in JPEG format");
    _button(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              checking =true;
            });
            SharedPreferences prefs = await  SharedPreferences.getInstance();
            String jwt = prefs.getString("jwt");
            String picker = await FilePicker.getFilePath(type: FileType.IMAGE);
            wrapper.fileUpload(picker, jwt).then((val){
              if (val){
                wrapper.fileUpload2(picker, jwt).then((val){
                  wrapper.fileUpload1(picker, jwt).then((val){
                    wrapper.createIdentity(jwt);
                    wrapper.checkCard(jwt).then((cardstat){
                      if(cardstat){
                        setState(() {
                          checking =false;
                          card= true;
                          file= false;
                        });
                      }
                      else{
                        setState(() {
                          checking =false;
                          card= false;
                          file= false;
                          keys =true;
                        });
                      }
                    });
                  });
                });

              }
            });
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child: checking? SpinKitCircle(size :10, color: Colors.black,):Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    return Column(
      children: <Widget>[

        text,
        SizedBox(height: 8.0),
        _button(),


      ],
    );
  }
  _cards(){
    _button(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              checking =true;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String jwt = prefs.getString("jwt");
            wrapper.addCard(jwt).then((boolean)async {
              print("login valeue:"+boolean.toString());
              FocusScope.of(context).requestFocus(FocusNode());
              SharedPreferences prefs= await SharedPreferences.getInstance();
              prefs.setBool("allow", false);
              prefs.setBool("approve",false);
              setState(() {
                checking = true;
              });});
            Navigator.pop(context);
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child: checking? SpinKitCircle(size :10, color: Colors.black,):Text('Continue', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    final cardNo = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => val.length!=19
          ? 'Not a valid email.'
          : null,
      decoration: InputDecoration(
        hintText: 'Card Number (XXXX XXXX XXXX XXXX)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _cardNo,
    );
    final cvv = TextFormField(
      keyboardType: TextInputType.number,
      autovalidate: true,
      validator: (val) => val.length!=3
          ? 'Invalid CVV.'
          : null,
      decoration: InputDecoration(
        hintText: 'CVV',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _cvv,
    );
    final expiry = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => val.length!=7
          ? 'Invalid Date'
          : null,
      decoration: InputDecoration(
        hintText: 'Expiry Date MM/YYYY',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _expiry,
    );
    return Column(
      children: <Widget>[

        cardNo,
        SizedBox(height: 8.0),
        cvv,
        SizedBox(height: 8.0),
        expiry,
        SizedBox(height: 8.0),
        _button(),


      ],
    );
  }

}
