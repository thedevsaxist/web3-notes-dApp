import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3demo/app/model/note.dart';
import 'package:web_socket_channel/io.dart';

abstract class INotesService extends ChangeNotifier {
  List<Note> get notes;

  /// This gets the ABI (Application Binary Interface) which is like an API but for contracts.
  Future<void> getABI();

  /// This converts the user's private key into an [EthPrivateKey] using the [EthPrivateKey.fromHex] method
  Future<void> getCredentials();

  /// This gets the [DeployedContract] using the [EthereumAddress] and the [ContractAbi].
  /// It the uses the [DeployedContract] to get the various [ContractFunction]s associated with the [DeployedContract]
  Future<void> getDeployedContract();

  /// This fetchs all the notes in the smart contract and adds them to the [notes] list
  Future<void> fetchNotes();

  /// This deletes a single note from the smart contract using the notes' [id]
  Future<void> deleteNote(int id);

  Future<void> addNote(String title, String description);
}

class NotesService extends ChangeNotifier implements INotesService {
  final List<Note> _notes = [];

  @override
  List<Note> get notes => _notes;

  /// The RPC (Remote Procedure Call) url which allows data transfer on the blockchain
  final String _rpcURl = "http://127.0.0.1:8545";
  final _wsUrl = "ws://127.0.0.1:8545";

  final _privateKey = dotenv.env["PRIVATE_KEY"];

  late Web3Client _web3client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;

  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _contractNotes;
  late ContractFunction _noteCount;

  NotesService() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(
      _rpcURl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );

    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  @override
  Future<void> getABI() async {
    final String abiFile = await rootBundle.loadString("build/contracts/NotesContract.json");
    final jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI["abi"]), "NotesContract");
    _contractAddress = EthereumAddress.fromHex(jsonABI["networks"]["31337"]["address"]);

    print("Contract address: $_contractAddress");
    print("ABI Functions: ${_abiCode.functions.map((f) => f.name).toList()}");
  }

  @override
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privateKey!);
  }

  @override
  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function("createNote");
    _deleteNote = _deployedContract.function("deleteNote");
    _contractNotes = _deployedContract.function("notes");
    _noteCount = _deployedContract.function("noteCount");

    print("Note count name ${_noteCount.name}");
    print("Note count ${_noteCount.outputs}");

    await fetchNotes();
  }

  @override
  Future<void> deleteNote(int id) async {
    await _web3client.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
    );

    notifyListeners();
    fetchNotes();
  }

  @override
  Future<void> fetchNotes() async {
    // try {
    print("Calling noteCount...");

    final totalTaskList = await _web3client.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );

    print("noteCount returned: $totalTaskList");

    print("Total task list = $totalTaskList");
    int totalTaskLength = totalTaskList[0].toInt();
    _notes.clear();

    for (var i = 0; i < totalTaskLength; i++) {
      var temp = await _web3client.call(
        contract: _deployedContract,
        function: _contractNotes,
        params: [BigInt.from(i)],
      );

      print("Temp: $temp");

      if (temp[1] != "") {
        _notes.add(Note(id: (temp[0] as BigInt).toInt(), title: temp[1], description: temp[2]));
      }
    }

    if (_notes.isNotEmpty) {
      print(_notes[0].title);
    }

    notifyListeners();
    // } catch (e) {
    //   print("Error fetching notes: $e");
    // }
  }

  @override
  Future<void> addNote(String title, String description) async {
    await _web3client.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [title, description],
      ),
    );

    print("Note added successfully");
    notifyListeners();
    fetchNotes();
  }
}
