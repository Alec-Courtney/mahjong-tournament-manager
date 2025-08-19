import 'package:flutter/foundation.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/services/database_service.dart';

class PlayerProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final String eventId;
  List<Player> _players = [];

  List<Player> get players => _players;

  PlayerProvider(this.eventId) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    final box = await _databaseService.playersBox;
    // In a real app, you'd filter players by eventId.
    // For now, we load all players. A more robust solution would involve
    // linking players to events more directly in the database.
    _players = box.values.toList();
    notifyListeners();
  }

  Future<void> addPlayer(Player player) async {
    final box = await _databaseService.playersBox;
    await box.put(player.id, player);
    _players.add(player);
    notifyListeners();
  }

  Future<void> updatePlayer(Player player) async {
    final box = await _databaseService.playersBox;
    await box.put(player.id, player);
    final index = _players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      _players[index] = player;
      notifyListeners();
    }
  }

  Future<void> deletePlayer(String playerId) async {
    final box = await _databaseService.playersBox;
    await box.delete(playerId);
    _players.removeWhere((player) => player.id == playerId);
    notifyListeners();
  }
}
