# 麻将赛事计分器

一个基于 Flutter 的立直麻将赛事计分系统，专为 Web 和 Windows 平台设计。

## 功能特性

- **赛事管理:** 创建和管理多个麻将锦标赛。
- **自定义规则:** 为每个赛事定义自定义规则，包括：
  - 三人麻将或四人麻将。
  - 团队赛或个人赛。
  - 自定义精算原点、总分检查和顺位pt (uma)。
- **选手和队伍管理:** 将选手添加到赛事中，并在团队赛中将他们分组。
- **分数记录:** 轻松记录每场比赛的结果。应用会根据赛事规则自动计算最终得分。
- **实时排名:** 以清晰的表格形式查看选手和队伍的排名，实时更新。
- **本地数据存储:** 所有数据都保存在您的设备本地或浏览器缓存中，因此您可以离线使用该应用。

## 技术架构

该应用使用 Flutter 构建，并遵循分层架构，以确保代码清晰、可扩展和可维护。

- **UI层:** 包含用户与之交互的所有小部件和屏幕。
- **状态管理层:** 使用 `provider` 包来管理应用的状态，并将UI与业务逻辑分离。
- **业务逻辑层:** 包括处理应用核心功能（如分数计算）的服务。
- **数据持久化层:** 使用 `Hive` 数据库在本地存储所有应用数据。

### 目录结构

```
lib/
|-- models/         # 数据模型 (Event, Player, 等)
|-- screens/        # UI 屏幕
|-- widgets/        # 可复用 UI 组件
|-- services/       # 业务逻辑服务
|-- providers/      # 状态管理 Provider
`-- main.dart       # 应用入口点
```

## 开始使用

### 环境要求

- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### 安装

1.  克隆仓库:
    ```sh
    git clone https://github.com/your-username/mahjong_event_score.git
    ```
2.  进入项目目录:
    ```sh
    cd mahjong_event_score
    ```
3.  安装依赖:
    ```sh
    flutter pub get
    ```

### 运行应用

您可以在 Windows 或 Web 上运行该应用：

- **在 Windows 上运行:**
  ```sh
  flutter run -d windows
  ```
- **在 Web 上运行:**
  ```sh
  flutter run -d chrome
  ```

## 贡献

欢迎贡献！请随时提交拉取请求或开启一个 issue。
