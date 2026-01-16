import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rakuraku_amedas/detailpage.dart';
import 'package:rakuraku_amedas/formula.dart';
import 'package:rakuraku_amedas/ranking.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';
import 'package:flutter/foundation.dart'; // ← kIsWebを使う場合必須

// データモデル
class ObservationPoint {
  final int number;
  final String name;
  final String kana;
  final LatLng latlng;
  final double elevation;
  final String officialName;
  final String prefecture;
  final String city;
  final Map<String, List<List<int>>> monthlyData;

  ObservationPoint({
    required this.number,
    required this.name,
    required this.kana,
    required this.latlng,
    required this.elevation,
    required this.officialName,
    required this.prefecture,
    required this.city,
    Map<String, List<List<int>>>? monthlyData,
  }) : monthlyData = monthlyData ?? {};
}

class JapanMapPage extends StatefulWidget {
  final List<ObservationPoint> points;
  const JapanMapPage({super.key, required this.points});

  @override
  JapanMapPageState createState() => JapanMapPageState();
}

class JapanMapPageState extends State<JapanMapPage> {
  String? _mapStyle;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    if (Theme.of(context).brightness == Brightness.dark) {
      _mapStyle = await rootBundle.loadString('assets/map_style_dark.json');
    } else {
      _mapStyle = null;
    }
    setState(() {}); // 再描画して GoogleMap に反映
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            style: _mapStyle, // ← 新しい書き方！
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.5, 138.0),
              zoom: 5,
            ),
            mapToolbarEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(4, 11),
            zoomControlsEnabled: false,
            markers: widget.points
                .map(
                  (p) => Marker(
                    markerId: MarkerId(p.officialName),
                    position: LatLng(
                      p.latlng.latitude + 0.0002,
                      p.latlng.longitude + 0.0012,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      colorToHue(getMarkerColor(p.officialName)),
                    ),
                    onTap: () {
                      // _selectedPoint にセットする代わりに ModalBottomSheet を表示
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          String tempDisplay = p.monthlyData["temp"] != null
                              ? "${(p.monthlyData["temp"]![12][0] / 10.0).toStringAsFixed(1)}℃"
                              : "-- ℃";
                          String rainDisplay = p.monthlyData["rain"] != null
                              ? "${(p.monthlyData["rain"]![12][0] / 10.0).toStringAsFixed(1)}mm"
                              : "-- mm";
                          String sunDisplay = p.monthlyData["sun"] != null
                              ? "${(p.monthlyData["sun"]![12][0] / 10.0).toStringAsFixed(1)}時間"
                              : "-- 時間";
                          String maxTempDisplay =
                              p.monthlyData["maxTemp"] != null
                              ? "${(p.monthlyData["maxTemp"]![12][0] / 10.0).toStringAsFixed(1)}℃"
                              : "-- ℃";
                          String snowDisplay = p.monthlyData["snow"] != null
                              ? "${(p.monthlyData["snow"]![12][0]).toStringAsFixed(1)}cm"
                              : "-- cm";
                          final lines = [
                            "・ 平均気温 : $tempDisplay",
                            "・ 平均最高気温 : $maxTempDisplay",
                            "・ 年降水量 : $rainDisplay",
                            "・ 年降雪量 : $snowDisplay",
                            "・ 年日照時間 : $sunDisplay",
                          ];
                          final textStyle = const TextStyle(fontSize: 16);

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getRegionColor(
                                      p.prefecture,
                                    ), // タイトル部分の背景色
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      topRight: Radius.circular(28),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        geticon(p.officialName), // ←引数必須,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ), // アイコンとテキストの間の余白
                                      Text(
                                        p.officialName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...lines.map(
                                  (line) => Text(line, style: textStyle),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // シートを閉じる
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPage(point: p),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: getRegionColor(
                                        p.prefecture,
                                      ),
                                    ),
                                    child: const Text(
                                      "詳細データ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
                .toSet(),
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeChanged;

  const MainPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<ObservationPoint> points = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final jsonString = await rootBundle.loadString('assets/amedas_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final loadedPoints = jsonData.map((item) {
      final lat = item['lat'] as double;
      final lng = item['lng'] as double;
      final monthlyDataRaw = item['monthlyData'] as Map<String, dynamic>;

      final monthlyData = monthlyDataRaw.map((key, value) {
        // value は List<List<int>> のはず
        final list = (value as List<dynamic>)
            .map((e) => [(e[0] as int), (e[1] as int)])
            .toList();
        return MapEntry(key, list);
      });

      return ObservationPoint(
        number: item['number'],
        name: item['name'],
        kana: item['kana'],
        latlng: LatLng(lat, lng),
        elevation: item['elevation'].toDouble(),
        officialName: item['officialName'],
        prefecture: item['prefecture'],
        city: item['city'],
        monthlyData: monthlyData,
      );
    }).toList();

    setState(() {
      points = loadedPoints;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text("データダウンロード中..."),
              Text("少々お待ちください"),
            ],
          ),
        ),
      );
    }

    final pages = [JapanMapPage(points: points), RankingPage(points: points)];

    return Scaffold(
      appBar: kIsWeb
          ? null // ← WebのときはAppBarなし
          : AppBar(
              title: _selectedIndex == 0
                  ? const Text("アメダスマップ")
                  : const Text("ランキング"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("テーマを選択"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.light_mode),
                                title: const Text("ライトモード"),
                                onTap: () async {
                                  Navigator.pop(context); // ダイアログを閉じる
                                  setState(() => _loading = true); // くるくる表示

                                  // テーマ変更
                                  widget.onThemeChanged(ThemeMode.light);

                                  // 少し待つと描画が安定する（必須ではない）
                                  await Future.delayed(
                                    const Duration(milliseconds: 100),
                                  );

                                  setState(() => _loading = false); // 元の画面に戻る
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.dark_mode),
                                title: const Text("ダークモード"),
                                onTap: () async {
                                  Navigator.pop(context); // ダイアログを閉じる
                                  setState(() => _loading = true); // くるくる表示

                                  // テーマ変更
                                  widget.onThemeChanged(ThemeMode.dark);

                                  // 少し待つと描画が安定する（必須ではない）
                                  await Future.delayed(
                                    const Duration(milliseconds: 100),
                                  );

                                  setState(() => _loading = false); // 元の画面に戻る
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBar(
            elevation: 1, // ← 影を消す
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? null
                : const Color.fromARGB(255, 238, 238, 238),
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.map), label: "アメダスマップ"),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: "ランキング",
              ),
            ],
          ),
          if (!kIsWeb) SizedBox(height: 50, child: const BannerAdWidget()),
        ],
      ),
    );
  }
}
