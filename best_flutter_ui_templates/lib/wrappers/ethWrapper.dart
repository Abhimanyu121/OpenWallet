import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
class EthWrapper{
  Map json;
  final rootChainAddress = "0x60e2b19b9a87a3f37827f2c8c8306be718a5f9b4";
  final moonRopsten = "0x48b0c1d90c3058ab032c44ec52d98633587ee711";
  Future<String> checkBalanceRopsten()async{
    double retbal;
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/json/StandardToken.json').then((abi)async{
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex("0x48b0c1d90c3058ab032c44ec52d98633587ee711"));
        var balance = contract.function('balanceOf');
        await client.call(
          contract: contract,
          function: balance ,
          params: [address],
        ).then((balance){
          print(balance);
          print(balance.first);
          BigInt vr = BigInt.from(balance.first/BigInt.from(1000000000000000));

          double bal = vr.toDouble()/1000.0;
          print("bal:"+bal.toString());
          retbal=bal;
        });
      });
    });
    await client.dispose();
    return retbal.toString();

  }
  Future<String> checkBalanceMatic()async{
    double retbal;
    var apiUrl = "https://testnet2.matic.network";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/json/StandardToken.json').then((abi)async{
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex("0xb35456a9b634cf85569154321596ee2d62e215ba"));
        var balance = contract.function('balanceOf');
        await client.call(
          contract: contract,
          function: balance ,
          params: [address],
        ).then((balance){
          print(balance);
          print(balance.first);
          BigInt vr = BigInt.from(balance.first/BigInt.from(1000000000000000));

          double bal = vr.toDouble()/1000.0;
          print("bal:"+bal.toString());
          retbal=bal;
        });
      });
    });
    await client.dispose();
    return retbal.toString();

  }
  Future<bool> transferToken(String recipient, double amount)async{
    const apiUrl = "https://testnet2.matic.network";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString("assets/json/StandardToken.json").then((abi)async{
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex("0xb35456a9b634cf85569154321596ee2d62e215ba"));
        var transfer = contract.function('transfer');
        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: transfer,
              parameters: [EthereumAddress.fromHex(recipient),BigInt.from(amount*1000)*BigInt.from(1000000000000000)]
          ),
          chainId: 8995,

        ).then((hash){
          print(BigInt.from(amount)*BigInt.from(1000000000000000000));
          print("tx hash: "+ hash);

        });
      });
    });
    await client.dispose();
    return true;
  }
  Future<dynamic> approveToken(double amount,) async {
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/json/StandardToken.json').then((abi)async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        print(BigInt.from(amount*1000)*BigInt.from(1000000000000000));
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(moonRopsten));
        print(contract.abi.toString());
        print(contract.address);
        var appr = contract.function('approve');

        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: appr,
              //nonce: int.parse(nonce),
              //nonce: Random.secure().nextInt(100),
              gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
              maxGas: 4000000,
              parameters: [EthereumAddress.fromHex(rootChainAddress),BigInt.from(amount*1000)*BigInt.from(1000000000000)]
          ),
          chainId: 3,

        ).then((hash)async{
          print("completing approve:"+hash );
          await client.dispose().then((vod)async {
            prefs.setString("hash", hash);
            prefs.setBool("transacting", true);
            return hash;

          });
        });
        // await client.dispose();

      });

    });

  }
  Future<dynamic> allowanceToken() async {
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/json/StandardToken.json').then((abi)async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(moonRopsten));
        print(contract.abi.toString());
        print(contract.address);
        var allow = contract.function('allowance');

        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: allow,
              //nonce: int.parse(nonce),
              //nonce: Random.secure().nextInt(100),
              gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
              maxGas: 4000000,
              parameters: [EthereumAddress.fromHex(rootChainAddress),address]
          ),
          chainId: 3,

        ).then((hash)async{
          print("completing approve:"+hash );
          await client.dispose().then((vod)async {
            prefs.setString("hash", hash);
            prefs.setBool("transacting", true);
            return hash;

          });
        });


      });

    });

  }
  Future<dynamic> incAllowanceToken() async {
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await rootBundle.loadString('assets/json/StandardToken.json').then((abi)async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(moonRopsten));
        print(contract.abi.toString());
        print(contract.address);
        var allow = contract.function('increaseAllowance');

        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: allow,
              //nonce: int.parse(nonce),
              //nonce: Random.secure().nextInt(100),
              gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
              maxGas: 4000000,
              parameters: [EthereumAddress.fromHex(rootChainAddress),BigInt.from(9999 * 1000) * BigInt.from(1000000000000000)]
          ),
          chainId: 3,

        ).then((hash)async{
          print("completing approve:"+hash );
          await client.dispose().then((vod)async {
            prefs.setString("hash", hash);
            prefs.setBool("transacting", true);
            return hash;
          });
        });


      });

    });

  }
  Future<dynamic> depositERC20 (double amount,)async {

    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client(), enableBackgroundIsolate: true);
    rootBundle.loadString('assets/json/RootChain.json').then((abi) async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract = DeployedContract(
            ContractAbi.fromJson(abi, "RootChain"),
            EthereumAddress.fromHex(rootChainAddress));
        var deposit = contract.function('deposit');
        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: deposit,
              // nonce: Random.secure().nextInt(100),
              gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
              maxGas: 4000000,
              //nonce: int.parse(nonce),
              parameters: [
                EthereumAddress.fromHex(moonRopsten),
                address,
                BigInt.from(amount * 1000) * BigInt.from(1000000000000000)
              ]
          ),

          chainId: 3,

        ).then((hash)async{
          print("completing approve:"+hash );
          prefs.setString("hash", hash);
          prefs.setBool("transacting", true);
          await client.dispose().then((vod)async {

          });
          return hash;
        });
        // await client.dispose();

      });

    });

  }
  Future<BigInt> checkEth()async{
    BigInt retbal;
    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    await SharedPreferences.getInstance().then((prefs)async {
      String privateKey = prefs.getString("privateKey");
      Credentials credentials = EthPrivateKey.fromHex(privateKey);
      final address = await credentials.extractAddress();
      print(address);
      var bal =await client.getBalance(address);
      BigInt abc = bal.getInWei;
      retbal = abc;
    });
    await client.dispose();
    return retbal;

  }
  Future<dynamic> withdrawErc20 (double amount,)async {

    var apiUrl = "https://testnet2.matic.network";
    final client = Web3Client(apiUrl, http.Client(), enableBackgroundIsolate: true);
    rootBundle.loadString('assets/json/ChildERC20.json').then((abi) async {
      await SharedPreferences.getInstance().then((prefs)async {
        String privateKey = prefs.getString("privateKey");
        Credentials credentials = EthPrivateKey.fromHex(privateKey);
        final address = await credentials.extractAddress();
        print(address);
        final contract = DeployedContract(
            ContractAbi.fromJson(abi, "ChildERC20"),
            EthereumAddress.fromHex("0xb35456a9b634cf85569154321596ee2d62e215ba"));
        var withdraw = contract.function('withdraw');
        await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: withdraw,
              // nonce: Random.secure().nextInt(100),
              gasPrice: EtherAmount.inWei(BigInt.from(0 )),
              maxGas: 4000000,
              //nonce: int.parse(nonce),
              parameters: [

                BigInt.from(1 * 1000) * BigInt.from(1000000000000000)
              ]
          ),

          chainId: 8995,

        ).then((hash)async{
          print("completing approve:"+hash );
          prefs.setString("bghash", hash);
          prefs.setBool("transacting", true);
          await client.dispose().then((vod)async {

          });
          return hash;
        });
        // await client.dispose();

      });

    });

  }
  Future<int> ropstenTransactionNumber() async{;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final String key = (prefs.getString('privateKey');

    var apiUrl = "https://ropsten.infura.io/v3/311ef590f7e5472a90edfa1316248cff";
    final client = Web3Client(apiUrl, http.Client());
    final credentials = await client.credentialsFromPrivateKey("6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0");
    final address = await credentials.extractAddress();
    print(address);
    int num = await client.getTransactionCount(address);
    print("count ="+num.toString());
    return num;

  }
}