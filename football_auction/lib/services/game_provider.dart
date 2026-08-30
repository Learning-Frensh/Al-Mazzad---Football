import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/player.dart';
import '../models/team.dart';

class GameProvider extends ChangeNotifier {
  io.Socket? _socket;
  
  // Game state
  bool _isConnected = false;
  String _roomCode = '';
  String _playerId = '';
  bool _isHost = false;
  
  // Teams
  Team? _myTeam;
  Team? _opponentTeam;
  List<Player> _auctionPlayers = [];
  
  // Current auction state
  Player? _currentPlayer;
  int _currentBid = 0;
  int _timer = 30;
  bool _isMyTurn = false;
  bool _auctionActive = false;
  int _currentPlayerIndex = 0;
  
  // Match state
  String _selectedFormation = '4-3-3';
  Map<String, dynamic>? _matchResult;
  
  // Getters
  bool get isConnected => _isConnected;
  String get roomCode => _roomCode;
  String get playerId => _playerId;
  bool get isHost => _isHost;
  Team? get myTeam => _myTeam;
  Team? get opponentTeam => _opponentTeam;
  List<Player> get auctionPlayers => _auctionPlayers;
  Player? get currentPlayer => _currentPlayer;
  int get currentBid => _currentBid;
  int get timer => _timer;
  bool get isMyTurn => _isMyTurn;
  bool get auctionActive => _auctionActive;
  int get currentPlayerIndex => _currentPlayerIndex;
  String get selectedFormation => _selectedFormation;
  Map<String, dynamic>? get matchResult => _matchResult;

  // Connect to server
  void connect(String serverUrl) {
    _socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      _isConnected = true;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
    });

    _socket!.on('player_joined', (data) {
      notifyListeners();
    });

    _socket!.on('auction_started', (data) {
      _auctionActive = true;
      _auctionPlayers = (data['players'] as List)
          .map((p) => Player.fromJson(p))
          .toList();
      _currentPlayerIndex = 0;
      _currentBid = data['startingBid'] ?? 0;
      _timer = data['timer'] ?? 30;
      notifyListeners();
    });

    _socket!.on('bid_placed', (data) {
      _currentBid = data['amount'];
      _timer = data['timer'];
      notifyListeners();
    });

    _socket!.on('timer_tick', (data) {
      _timer = data['timer'];
      notifyListeners();
    });

    _socket!.on('round_end', (data) {
      // Handle round end
      notifyListeners();
    });

    _socket!.on('auction_complete', (data) {
      _auctionActive = false;
      if (data['player1'] != null) {
        _myTeam = Team.fromJson(data['player1']);
      }
      if (data['player2'] != null) {
        _opponentTeam = Team.fromJson(data['player2']);
      }
      notifyListeners();
    });

    _socket!.connect();
  }

  // Create room
  Future<bool> createRoom({
    required String playerName,
    required String auctionType,
    required bool vsAI,
    String aiDifficulty = 'medium',
    required String serverUrl,
  }) async {
    connect(serverUrl);
    
    try {
      final response = await _socket!.emitWithAck('create_room', {
        'playerName': playerName,
        'auctionType': auctionType,
        'vsAI': vsAI,
        'aiDifficulty': aiDifficulty,
      }, ack: (data) {
        if (data['success']) {
          _roomCode = data['roomCode'];
          _playerId = data['playerId'];
          _isHost = true;
          notifyListeners();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Join room
  Future<bool> joinRoom({
    required String roomCode,
    required String playerName,
    required String serverUrl,
  }) async {
    connect(serverUrl);
    
    try {
      final response = await _socket!.emitWithAck('join_room', {
        'roomCode': roomCode,
        'playerName': playerName,
      }, ack: (data) {
        if (data['success']) {
          _roomCode = data['roomCode'];
          _playerId = data['playerId'];
          _isHost = false;
          notifyListeners();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Start auction
  void startAuction() {
    _socket?.emit('start_auction', {
      'roomCode': _roomCode,
      'playerId': _playerId,
    });
  }

  // Place bid
  void placeBid(int amount) {
    _socket?.emit('place_bid', {
      'roomCode': _roomCode,
      'playerId': _playerId,
      'amount': amount,
    });
  }

  // Pass turn
  void passTurn() {
    _socket?.emit('pass_turn', {
      'roomCode': _roomCode,
      'playerId': _playerId,
    });
  }

  // Set formation
  void setFormation(String formation) {
    _selectedFormation = formation;
    notifyListeners();
  }

  // Disconnect
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
