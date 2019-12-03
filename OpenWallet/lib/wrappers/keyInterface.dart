import 'package:bip39/bip39.dart' as bip39;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';

class KeyInterface {
  Future<String> generateKey()async {
    var mnemonic = bip39.generateMnemonic();
    var seed = bip39.mnemonicToSeed(mnemonic);
    var hdWallet = new HDWallet(seed);
    print(mnemonic);
    var creds= EthPrivateKey.fromHex(hdWallet.privKey);
    var address = await creds.extractAddress();
    print("address:"+address.toString());
    var add = EthereumAddress.fromHex(address.toString());
    print(add);
    String ppk = hdWallet.privKey;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", address.toString());
    prefs.setString("privateKey", ppk);
    return mnemonic.toString();
  }
  Future<String> fromMenmonic(mnemonic)async {
    String privatekey= bip39.mnemonicToSeedHex(mnemonic);
    print(privatekey);
    Credentials fromHex = EthPrivateKey.fromHex(privatekey);
    var address = await fromHex.extractAddress();
    print(address);
  }
}