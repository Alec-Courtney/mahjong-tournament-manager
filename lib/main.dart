import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/models/column_config.dart';
import 'package:mahjong_event_score/providers/event_provider.dart';
import 'package:mahjong_event_score/providers/game_record_provider.dart';
import 'package:mahjong_event_score/providers/player_provider.dart';
import 'package:mahjong_event_score/widgets/column_config_dialog.dart';
import 'package:mahjong_event_score/widgets/event_management_dialog.dart';
import 'package:mahjong_event_score/widgets/player_management_dialog.dart';
import 'package:mahjong_event_score/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MahjongTypeAdapter());
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(TeamAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(GameRecordAdapter());
  Hive.registerAdapter(ColumnConfigAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider()..loadEvents(),
      child: MaterialApp(
        title: '麻将赛事计分',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(nextScreen: MainScreen()),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final currentEvent = eventProvider.currentEvent;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentEvent?.name ?? '麻将赛事计分系统'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const EventManagementDialog(),
              );
            },
            tooltip: '管理赛事',
          ),
        ],
      ),
      body: currentEvent == null
          ? const Center(child: Text('没有选择赛事，请通过设置创建一个。'))
          : EventDetailsContent(event: currentEvent),
    );
  }
}

class EventDetailsContent extends StatelessWidget {
  final Event event;

  const EventDetailsContent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider(event.id)),
        ChangeNotifierProvider(create: (_) => GameRecordProvider(event.id)),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GameRecordInput(event: event),
            const SizedBox(height: 20),
            PlayerRankingTable(event: event),
          ],
        ),
      ),
    );
  }
}

class GameRecordInput extends StatefulWidget {
  final Event event;
  const GameRecordInput({super.key, required this.event});

  @override
  _GameRecordInputState createState() => _GameRecordInputState();
}

class _GameRecordInputState extends State<GameRecordInput> {
  final _formKey = GlobalKey<FormState>();
  late List<Player?> _selectedPlayers;
  late List<TextEditingController> _scoreControllers;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final playerCount = widget.event.mahjongType == MahjongType.fourPlayer ? 4 : 3;
    _selectedPlayers = List.filled(playerCount, null);
    _scoreControllers = List.generate(playerCount, (_) => TextEditingController());
  }

  @override
  void didUpdateWidget(covariant GameRecordInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.event != oldWidget.event) {
      _initializeFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<PlayerProvider>(context).players;
    final playerCount = widget.event.mahjongType == MahjongType.fourPlayer ? 4 : 3;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('比赛结果输入', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...List.generate(playerCount, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<Player>(
                          value: _selectedPlayers[index],
                          hint: Text('选择第 ${index + 1} 位选手'),
                          items: players.map((player) {
                            return DropdownMenuItem(value: player, child: Text(player.name));
                          }).toList(),
                          onChanged: (player) {
                            setState(() {
                              _selectedPlayers[index] = player;
                            });
                          },
                          validator: (value) => value == null ? '请选择选手' : null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _scoreControllers[index],
                          decoration: const InputDecoration(labelText: '结算分数'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty ? '请输入分数' : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecord,
                child: const Text('计算并更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecord() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final playerCount = widget.event.mahjongType == MahjongType.fourPlayer ? 4 : 3;
    final List<Map<String, dynamic>> playerScores = [];
    for (int i = 0; i < playerCount; i++) {
      playerScores.add({
        'player': _selectedPlayers[i]!,
        'score': int.parse(_scoreControllers[i].text),
      });
    }
    playerScores.sort((a, b) => b['score'].compareTo(a['score']));

    final gameRecordProvider = Provider.of<GameRecordProvider>(context, listen: false);
    for (int i = 0; i < playerScores.length; i++) {
      final placement = i + 1;
      final playerScore = playerScores[i];
      final player = playerScore['player'] as Player;
      final score = playerScore['score'] as int;
      final calculatedScore = (score - widget.event.originPoint) / 1000 + (widget.event.positionPoints[placement] ?? 0);

      final record = GameRecord(
        timestamp: DateTime.now(),
        score: score,
        placement: placement,
        calculatedScore: calculatedScore,
        playerId: player.id,
        eventId: widget.event.id,
      );
      gameRecordProvider.addGameRecord(record);
    }

    _formKey.currentState?.reset();
    _initializeFields();
    setState(() {});
  }
}

class PlayerRankingTable extends StatelessWidget {
  final Event event;
  const PlayerRankingTable({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('选手数据榜', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.settings_applications),
                  tooltip: '配置表格列',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ColumnConfigDialog(event: event),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Consumer2<PlayerProvider, GameRecordProvider>(
              builder: (context, playerProvider, gameRecordProvider, child) {
                if (playerProvider.players.isEmpty) {
                  return const Center(child: Text('还没有选手，请先添加选手。'));
                }

                // 1. Calculate stats
                final playerStats = <String, _PlayerStats>{};
                for (var player in playerProvider.players) {
                  playerStats[player.id] = _PlayerStats();
                }

                for (var record in gameRecordProvider.gameRecords) {
                  final stats = playerStats[record.playerId];
                  if (stats != null) {
                    stats.totalScore += record.calculatedScore;
                    stats.gamesPlayed++;
                    switch (record.placement) {
                      case 1:
                        stats.rank1++;
                        break;
                      case 2:
                        stats.rank2++;
                        break;
                      case 3:
                        stats.rank3++;
                        break;
                      case 4:
                        stats.rank4++;
                        break;
                    }
                  }
                }

                // 2. Sort players by total score
                final sortedPlayers = List<Player>.from(playerProvider.players);
                sortedPlayers.sort((a, b) => (playerStats[b.id]?.totalScore ?? 0).compareTo(playerStats[a.id]?.totalScore ?? 0));

                // 3. Build dynamic columns
                final visibleColumns = event.playerColumns.where((c) => c.isVisible).toList();
                final columns = visibleColumns.map((c) => DataColumn(label: Text(c.columnName))).toList();

                // 4. Build dynamic rows
                final rows = sortedPlayers.map((player) {
                  final stats = playerStats[player.id]!;
                  final cells = visibleColumns.map((col) {
                    final value = _getCellData(col.dataKey, player, stats, sortedPlayers.indexOf(player));
                    return DataCell(Text(value));
                  }).toList();
                  return DataRow(cells: cells);
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: columns,
                    rows: rows,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getCellData(String dataKey, Player player, _PlayerStats stats, int rank) {
    final gamesPlayed = stats.gamesPlayed;
    if (gamesPlayed == 0 && dataKey != 'name' && dataKey != 'rank') {
      return '0';
    }

    switch (dataKey) {
      case 'rank':
        return (rank + 1).toString();
      case 'name':
        return player.name;
      case 'totalScore':
        return stats.totalScore.toStringAsFixed(1);
      case 'gamesPlayed':
        return gamesPlayed.toString();
      case 'rank1Rate':
        return '${(stats.rank1 / gamesPlayed * 100).toStringAsFixed(1)}%';
      case 'rank2Rate':
        return '${(stats.rank2 / gamesPlayed * 100).toStringAsFixed(1)}%';
      case 'rank3Rate':
        return '${(stats.rank3 / gamesPlayed * 100).toStringAsFixed(1)}%';
      case 'rank4Rate':
        return '${(stats.rank4 / gamesPlayed * 100).toStringAsFixed(1)}%';
      case 'avoidFourthRate':
        final rate = (stats.rank1 + stats.rank2 + stats.rank3) / gamesPlayed * 100;
        return '${rate.toStringAsFixed(1)}%';
      case 'consecutiveTopTwoRate':
        final rate = (stats.rank1 + stats.rank2) / gamesPlayed * 100;
        return '${rate.toStringAsFixed(1)}%';
      case 'averageRank':
        final avg = (stats.rank1 * 1 + stats.rank2 * 2 + stats.rank3 * 3 + stats.rank4 * 4) / gamesPlayed;
        return avg.toStringAsFixed(2);
      default:
        return '';
    }
  }
}

class _PlayerStats {
  double totalScore = 0.0;
  int gamesPlayed = 0;
  int rank1 = 0;
  int rank2 = 0;
  int rank3 = 0;
  int rank4 = 0;
}
