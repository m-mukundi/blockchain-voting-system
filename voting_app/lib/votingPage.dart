import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' show Client;

class VotingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VotingPage(),
    );
  }
}

class VotingPage extends StatefulWidget {
  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  // Infura URL with your API key
  final infuraUrl = 'https://mainnet.infura.io/v3/d6daa3c4e3af4b7db5ff60515624339d';

  List<Candidate> candidates = [
    Candidate(name: 'Candidate A'),
    Candidate(name: 'Candidate B'),
    Candidate(name: 'Candidate C'),
    Candidate(name: 'Candidate D'),
  ];

  Candidate? selectedCandidate;

  // Ethereum client
  late Web3Client ethClient;

  @override
  void initState() {
    super.initState();
    connectToEthereumNode();
  }

  Future<void> connectToEthereumNode() async {
    ethClient = Web3Client(infuraUrl, Client());
    // You can now use 'ethClient' to interact with the Ethereum node
    // For example, you can check the balance of an Ethereum address
    EthereumAddress address = EthereumAddress.fromHex('0x95C88D5E1295515918eb2D848dCe89C561CCf470');
    EtherAmount balance = await ethClient.getBalance(address);
    print('Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH');
  }

  void vote() {
    if (selectedCandidate != null) {
      selectedCandidate!.votes++;
      candidates.sort((a, b) => b.votes.compareTo(a.votes));
      setState(() {
        selectedCandidate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text('Voting App', style: TextStyle(color: Colors.blueAccent),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Voting App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 16),
            Center(child: Text('Voting Rules:', style: TextStyle(color: Colors.white, fontSize: 18))),
            Center(child: Text('1. Select a candidate from the list.', style: TextStyle(color: Colors.white))),
            Center(child: Text('2. Press the "Vote" button to cast your vote.', style: TextStyle(color: Colors.white))),
            Center(child: Text('3. You can only vote once.', style: TextStyle(color: Colors.white))),
            Center(child: Text('4. The results will be displayed after voting.', style: TextStyle(color: Colors.white))),
            SizedBox(height: 16),
            Text('Candidates:', style: TextStyle(color: Colors.blueAccent)),
            Expanded(
              child: ListView.builder(
                itemCount: candidates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(candidates[index].name, style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        selectedCandidate = candidates[index];
                      });
                    },
                    tileColor: selectedCandidate == candidates[index]
                        ? Colors.blue.withOpacity(0.3)
                        : null,
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent)),
              onPressed: vote,
              child: Text('Vote', style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 16),
            Text('Results:', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: candidates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(candidates[index].name, style: TextStyle(color: Colors.white)),
                    subtitle: Text('Votes: ${candidates[index].votes}', style: TextStyle(color: Colors.blueAccent)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Candidate {
  String name;
  int votes;

  Candidate({required this.name, this.votes = 0});
}
