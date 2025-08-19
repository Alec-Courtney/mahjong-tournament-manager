import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mahjong_event_score/models.dart';
import 'package:mahjong_event_score/models/column_config.dart';
import 'package:mahjong_event_score/providers/event_provider.dart';
import 'package:mahjong_event_score/providers/game_record_provider.dart';
import 'package:mahjong_event_score/providers/player_provider.dart';
import 'package:mahjong_event_score/theme/app_theme.dart';
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
        title: '立直麻将赛事计分系统',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
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
      body: CustomScrollView(
        slivers: [
          // 自定义AppBar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  currentEvent?.name ?? '立直麻将赛事计分系统',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const EventManagementDialog(),
                    );
                  },
                  tooltip: '管理赛事',
                ),
              ),
            ],
          ),
          
          // 主要内容
          SliverToBoxAdapter(
            child: currentEvent == null
                ? _buildEmptyState(context)
                : EventDetailsContent(event: currentEvent),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(
              Icons.event_note,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '欢迎使用立直麻将计分系统',
            style: AppStyles.sectionTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '还没有创建赛事，点击右上角设置按钮开始创建您的第一个赛事',
            style: AppStyles.cardSubtitle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const EventManagementDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('创建赛事'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题区域
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '比赛结果输入',
                          style: AppStyles.cardTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '请选择选手并输入结算分数',
                          style: AppStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // 选手输入区域
              if (players.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.light,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '还没有选手',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '请先添加选手才能开始记录比赛',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PlayerManagementDialog(eventId: widget.event.id),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('添加选手'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(playerCount, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.light,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        // 位置指示器
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // 选手选择
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<Player>(
                            value: _selectedPlayers[index],
                            hint: Text('选择第 ${index + 1} 位选手'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: players.map((player) {
                              return DropdownMenuItem(
                                value: player,
                                child: Text(player.name),
                              );
                            }).toList(),
                            onChanged: (player) {
                              setState(() {
                                _selectedPlayers[index] = player;
                              });
                            },
                            validator: (value) => value == null ? '请选择选手' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // 分数输入
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _scoreControllers[index],
                            decoration: InputDecoration(
                              labelText: '结算分数',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty ? '请输入分数' : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              
              if (players.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveRecord,
                    icon: const Icon(Icons.calculate),
                    label: const Text('计算并更新'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题区域
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.leaderboard,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '选手数据榜',
                        style: AppStyles.cardTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '实时更新的选手排名和统计数据',
                        style: AppStyles.cardSubtitle,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.light,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings_applications,
                      color: AppTheme.primary,
                    ),
                    tooltip: '配置表格列',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ColumnConfigDialog(event: event),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Consumer2<PlayerProvider, GameRecordProvider>(
              builder: (context, playerProvider, gameRecordProvider, child) {
                if (playerProvider.players.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '还没有选手数据',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '添加选手并开始记录比赛后，这里将显示排名统计',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
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
                final columns = visibleColumns.map((c) => DataColumn(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      c.columnName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                )).toList();

                // 4. Build dynamic rows
                final rows = sortedPlayers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  final stats = playerStats[player.id]!;
                  final cells = visibleColumns.map((col) {
                    final value = _getCellData(col.dataKey, player, stats, index);
                    return DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          value,
                          style: TextStyle(
                            fontWeight: col.dataKey == 'name' ? FontWeight.w500 : FontWeight.normal,
                            color: col.dataKey == 'rank' && index < 3 
                                ? _getRankColor(index)
                                : AppTheme.dark,
                          ),
                        ),
                      ),
                    );
                  }).toList();
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (index < 3) {
                          return _getRankColor(index).withOpacity(0.05);
                        }
                        return null;
                      },
                    ),
                    cells: cells,
                  );
                }).toList();

                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.light,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: columns,
                      rows: rows,
                      headingRowHeight: 56,
                      dataRowHeight: 60,
                      columnSpacing: 24,
                      decoration: const BoxDecoration(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 0:
        return const Color(0xFFFFD700); // 金色
      case 1:
        return const Color(0xFFC0C0C0); // 银色
      case 2:
        return const Color(0xFFCD7F32); // 铜色
      default:
        return AppTheme.primary;
    }
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
