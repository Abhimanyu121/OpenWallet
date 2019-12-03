import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
class MoonPayWrapper{
  static const baseUrl= "https://api.moonpay.io";
  Future<bool> tokenGen (String email) async {
    const url = "https://api.moonpay.io/v2/customers/email_login?apiKey=pk_test_U3wU9qqx87F9EbTVKEnLIIWrhtkeekT";
    var resp =  await http.post(
        url,
        headers: {
          "Content-Type" : "application/json"
        },
        body: json.encode({"email": email})
    );
    var js = json.decode(resp.body);
    bool stat = js["preAuthenticated"];
    print(stat.toString());
    if(stat.toString()=="true"){
      return true;
    }
    else{
      return false;
    }
  }
  Future<dynamic> getToken( email, otp) async {
    const url = "https://api.moonpay.io/v2/customers/email_login?apiKey=pk_test_U3wU9qqx87F9EbTVKEnLIIWrhtkeekT";
    var resp = await http.post(
        url,
        headers: {
          "Content-Type" : "application/json"
        },
        body: json.encode({"email": email,"securityCode":otp})

    );
    print(resp.body);
    var js = jsonDecode(resp.body);
    var token = js["token"];
    if(token.length>0){
      return token;
    }
    else
      return false;
  }
  Future<dynamic> getDetailStatus(jwt) async {
    const url = "https://api.moonpay.io/v2/customers/me";
    var resp = await http.get(
      url,
      headers: {"Authorization": "Bearer "+jwt},
    );
    print(resp.body);
    var js = jsonDecode(resp.body);
    String name = js["firstName"].toString();
    print(name);
    if(name =="null"){
      return false;
    }
    else{
      return true;
    }

  }
  Future<dynamic> putDetails(jwt, String firstName, String lastName) async {
    const url ="https://api.moonpay.io/v2/customers/me";
    print(firstName);
    Map jsonMap = {"firstName": firstName.toString(), "lastName": lastName, "dateOfBirth": "1980-01-01", "address": {"street": "14 Tottenham Court Road", "town": "London", "postCode": "W1T 1JY", "country": "GBR"}};
    String jsonString = json.encode(jsonMap);

    var resp = await http.patch(
      url,
      headers: {"Authorization": "Bearer "+jwt, "Content-Type": "application/json"},
      body: jsonString,
    );
    print(resp.body);
    var js = jsonDecode(resp.body);
    if(js["firstName"]==firstName){
      return true;
    }
    else
      return false;
  }
  Future<dynamic> fileUpload(path,jwt)async{
    const url = "https://api.moonpay.io/v2/files";
    File file = File(path);
    var length =  await file.length();
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll({"Authorization": "Bearer "+jwt});
    request.fields['type'] = 'selfie';
    request.fields['country'] = 'GBR';
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    // send
    var response = await request.send();
    print(response.statusCode);



    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if(response.statusCode==201){
      return true;
    }
    else{
      return false;
    }
  }
  Future<dynamic> fileUpload2(path,jwt)async{
    const url = "https://api.moonpay.io/v2/files";
    File file = File(path);
    var length =  await file.length();
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll({"Authorization": "Bearer "+jwt});
    request.fields['type'] = 'national_identity_card';
    request.fields['side'] = 'front';
    request.fields['country'] = 'GBR';
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    // send
    var response = await request.send();
    print(response.statusCode);



    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if(response.statusCode==201){
      return true;
    }
    else{
      return false;
    }
  }
  Future<dynamic> fileUpload1(path,jwt)async{
    const url = "https://api.moonpay.io/v2/files";
    File file = File(path);
    var length =  await file.length();
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll({"Authorization": "Bearer "+jwt});
    request.fields['country'] = 'GBR';
    request.fields['type'] = 'national_identity_card';
    request.fields['side'] = 'back';
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    // send
    var response = await request.send();
    print(response.statusCode);



    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if(response.statusCode==201){
      return true;
    }
    else{
      return false;
    }
  }
  Future<bool> createIdentity(jwt) async {
    const url = "https://api.moonpay.io/v2/identity_check";
    var resp = await http.post(
      url,
      headers: {
        "Authorization": "Bearer "+jwt,
        "Content-Type" : "application/json"
      },
    );
    print(resp.body);
    return true;
  }
  Future<dynamic> checkCard (jwt)async {
    const url ="https://api.moonpay.io/v2/cards";
    var resp = await http.get(url, headers: {"Authorization": "Bearer "+jwt});
    var js = jsonDecode(resp.body) as List;
    if(js.length==0){
      return true;
    }
    else return false;
  }
  Future<dynamic> addCard (jwt ) async {
    const url = "https://api.moonpay.io/v2/cards";
    await http.post(
      url,
      headers: {
        "Authorization": "Bearer "+jwt,
        "Content-Type": "application/json"
      },
      body: json.encode({
        "number": "4000023104662535",
        "expiryMonth": 12,
        "expiryYear": 2020,
        "cvc": "123"
      }),
    ).then((resp) async {
      print(resp.body);
      var js = jsonDecode(resp.body);
      print(js["expiryMonth"]);
      if(js["expiryMonth"]==12){
        print("here");
        return true;
      }
      else return false;
    });
  }
  Future<List<dynamic>> getCardList (jwt)async {
    const url ="https://api.moonpay.io/v2/cards";
    var resp = await http.get(url, headers: {"Authorization": "Bearer "+jwt});
    var js = jsonDecode(resp.body) as List;
    return js;
  }
  Future<bool> addMoney(String jwt, String amount, String address, String id) async {
    const url ="https://api.moonpay.io/v2/transactions";
    print(jwt);
    var resp = await http.post(
        url,
        headers:{
          "Authorization": "Bearer "+jwt,
          "Content-Type": "application/json"
        },
        body: jsonEncode({"baseCurrencyAmount": int.parse(amount), "extraFeePercentage": 0, "walletAddress": address, "baseCurrencyCode": "usd", "currencyCode": "dai", "cardId":  id,"returnUrl": "https://buy.moonpay.io"})
    );
    print(resp.body);
    return true;
  }
  Future<bool> addEth(String jwt, String address, String id) async {
    const url ="https://api.moonpay.io/v2/transactions";
    print(jwt);
    var resp = await http.post(
        url,
        headers:{
          "Authorization": "Bearer "+jwt,
          "Content-Type": "application/json"
        },
        body: jsonEncode({"baseCurrencyAmount": 20, "extraFeePercentage": 0, "walletAddress": address, "baseCurrencyCode": "usd", "currencyCode": "eth", "cardId":  id,"returnUrl": "https://buy.moonpay.io"})
    );
    print(resp.body);
    return true;
  }
  Future<dynamic> addCard2 (jwt ) async {
    const url = "https://api.moonpay.io/v2/cards";
    await http.post(
      url,
      headers: {
        "Authorization": "Bearer "+jwt,
        "Content-Type": "application/json"
      },
      body: json.encode({
        "number": "4002629798205148",
        "expiryMonth": 12,
        "expiryYear": 2020,
        "cvc": "123"
      }),
    ).then((resp) async {
      print(resp.body);
      var js = jsonDecode(resp.body);
      print(js["expiryMonth"]);
      if(js["expiryMonth"]==12){
        print("here");
        return true;
      }
      else return false;
    });
  }

}