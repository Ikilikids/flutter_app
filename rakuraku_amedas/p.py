import csv
import json

# CSV ファイルと対応するフィールド名
csv_files = [
    ('assets/data/sm_p.csv', 'rain'),
    ('assets/data/av_at.csv', 'temp'),
    ('assets/data/sm_s.csv', 'sun'),
    ('assets/data/av_ht.csv', 'maxTemp'),
    ('assets/data/av_lt.csv', 'minTemp'),
    ('assets/data/sm_ky.csv', 'snow'),
    ('assets/data/av_w.csv', 'wind'),
    ('assets/data/ht_35.csv', 'ht35'),
    ('assets/data/ht_30.csv', 'ht30'),
    ('assets/data/ht_25.csv', 'ht25'),
    ('assets/data/ht_0.csv', 'ht0'),
    ('assets/data/lt_0.csv', 'lt0'),
    ('assets/data/lt_25.csv', 'lt25'),
    ('assets/data/ky_3.csv', 'ky3'),
    ('assets/data/ky_5.csv', 'ky5'),
    ('assets/data/ky_10.csv', 'ky10'),
    ('assets/data/ky_20.csv', 'ky20'),
    ('assets/data/ky_50.csv', 'ky50'),
    ('assets/data/p_1.csv', 'p1'),
    ('assets/data/p_10.csv', 'p10'),
    ('assets/data/p_30.csv', 'p30'),
    ('assets/data/p_50.csv', 'p50'),
    ('assets/data/p_70.csv', 'p70'),
    ('assets/data/p_100.csv', 'p100'),
    ('assets/data/sy_5.csv', 'sy5'),
    ('assets/data/sy_10.csv', 'sy10'),
    ('assets/data/sy_20.csv', 'sy20'),
    ('assets/data/sy_50.csv', 'sy50'),
    ('assets/data/sy_100.csv', 'sy100'),
    ('assets/data/w_10.csv', 'w10'),
    ('assets/data/w_15.csv', 'w15'),
    ('assets/data/w_20.csv', 'w20'),
    ('assets/data/w_30.csv', 'w30')
]

# 観測所マスター読み込み
with open('assets/amedas_location.csv', encoding='utf-8') as f:
    reader = csv.reader(f)
    master = [row for row in reader][1:]  # ヘッダー除く

# ポイント初期化
points = []
for row in master:
    points.append({
        "number": int(row[0]),
        "name": row[1],
        "kana": row[2],
        "lat": float(row[3]),
        "lng": float(row[4]),
        "elevation": float(row[5]),
        "officialName": row[6],
        "prefecture": row[7],
        "city": row[8],
        "monthlyData": {}
    })

# CSV データを読み込み、ランキング付きで monthlyData に追加
for path, field in csv_files:
    with open(path, encoding='utf-8') as f:
        reader = list(csv.reader(f))
        data_rows = reader[1:]  # ヘッダー除く

    # 各月の値をまとめる（0=通年, 1～12=1月～12月）
    month_values = [[] for _ in range(13)]
    for row in data_rows:
        number = int(row[0])
        idx = next((i for i, p in enumerate(points) if p['number'] == number), None)
        if idx is None:
            print(f"警告: 観測所番号 {number} がマスターに存在しません。スキップします。")
            continue
        values = list(map(int, row[6:19]))  # 6列目以降が1月～12月＋通年
        for m in range(13):
            month_values[m].append((idx, values[m]))

    # 各月で降順ソートしてランキング計算
    for m in range(13):
        entries = sorted(month_values[m], key=lambda x: -x[1])
        rank = 1
        skip = 0
        last_val = None
        for i, (idx, val) in enumerate(entries):
            if last_val is not None and val == last_val:
                skip += 1
            else:
                rank += skip
                skip = 1
            last_val = val
            points[idx]['monthlyData'].setdefault(field, []).append([val, rank])

# JSON 出力
with open('assets/amedas_data.json', 'w', encoding='utf-8') as f:
    json.dump(points, f, ensure_ascii=False, indent=2)

print("JSON 変換完了: assets/amedas_data.json")
