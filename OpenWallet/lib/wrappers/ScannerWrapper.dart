import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class ScannerWrapper{
  Future<Map> getDetails(String hash)async {
    print(hash);
    var url = "https://api-ropsten.etherscan.io/api?module=transaction&action=gettxreceiptstatus&txhash="+hash+"&apikey=ZE2QGS32E2DTA2P37IXQG9Z5DT81QQV5C8";
    var resp =await http.get(url);
    print(resp.body);
    var jss= jsonDecode(resp.body);
    print("api:"+jss.toString());
    return jss;


  }
  Future<List> maticTransactions()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var address = prefs.getString("address").substring(2);
    var url = "https://matic-syncer2.api.matic.network/api/v1/transactions/"+address;
    var resp =await http.get(url);
    print(resp.body);
    var jss= jsonDecode(resp.body)["transactionList"] as List;
    print("api:"+jss.toString());
    return jss;

  }
  Future<dynamic> getTransactions()async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var url = "http://api-ropsten.etherscan.io/api?module=account&action=txlist&address="+prefs.get("address")+"&startblock=0&endblock=99999999&sort=asc&apikey=ZE2QGS32E2DTA2P37IXQG9Z5DT81QQV5C8";
    var resp= await http.get(url);
    var js= jsonDecode(resp.body)["result"] as List;
    print(resp.body);
    print(js);
    return js;
  }
  Future<dynamic> getTxList(String address)async {
    var url = "http://api-ropsten.etherscan.io/api?module=account&action=txlist&address="+address+"&startblock=0&endblock=99999999&sort=asc&apikey=ZE2QGS32E2DTA2P37IXQG9Z5DT81QQV5C8";
    var resp= await http.get(url);
    var js= jsonDecode(resp.body)["result"] as List;
    print(resp.body);
    print(js);
    return js;
  }


}