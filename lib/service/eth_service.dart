import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:travel_explorer/service/contract_parser.dart';
import 'package:travel_explorer/api/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EthService {
  static final EthService _instance = new EthService._internal();
  final String _contractAddress = dotenv.env['CONTRACT_ADDRESS'];
  final String _mode = dotenv.env['MODE'];
  final String _infuraApiKey = dotenv.env['INFURA_PROJECT_ID'];
  final String _chainId = dotenv.env['CHAIN_ID'];
  Web3Client _ethClient;
  DeployedContract _contract;
  String userAddress;

  factory EthService() {
    return _instance;
  }

  EthService._internal() {
    _ethClient = Web3Client(getServerURL(), Client());
    this._parseContract();
  }

  String getServerURL() {
    if (_mode == "DEV") {
      return "http://127.0.0.1:9545";
    }

    return "https://$_chainId.infura.io/v3/$_infuraApiKey";
  }

  Future<void> _parseContract() async {
    try {
      _contract = await ContractParser.fromAssets(
          dotenv.env['CONTRACT_FILE'], _contractAddress);
    } catch (e) {
      InvalidContractFileException('Invalid contract file');
    }
  }

  void setUserAddress(String userAddress) {
    this.userAddress = userAddress;
  }

  String getUserAddress() {
    return this.userAddress;
  }

  Future<EtherAmount> getBalance() async {
    try {
      return await this
          ._ethClient
          .getBalance(EthereumAddress.fromHex(this.userAddress));
    } catch (ex) {
      EtheriumClientException('Failed to fetch account balance $ex');
    }
  }

  // TODO Check if token id exist
  Future<String> ownerOfTokenId(BigInt tokenId) async {
    try {
      print(this._ethClient);
      final response = await this._ethClient.call(
        contract: this._contract,
        function: this._contract.function('ownerOf'),
        params: [tokenId],
      );
      print(response);
      return response as String;
    } catch (ex) {
      EtheriumClientException('Failed to get the owner of token $ex');
      print(ex);
    }
  }
}
