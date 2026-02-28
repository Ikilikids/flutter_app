import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateManager {
  static bool? _needsUpdate;
  static bool? get needsUpdate => _needsUpdate;

  /// バージョンチェックを実行し、結果を保持する
  static Future<void> checkUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('app_setting')
          .get();

      if (!doc.exists) return;

      final minVersion = doc.data()?['min_version'] as String? ?? "0.0.0";

      if (_isUpdateRequired(currentVersion, minVersion)) {
        _needsUpdate = true;
      } else {
        _needsUpdate = false;
      }
    } catch (e) {
      debugPrint('Update check error: $e');
    }
  }

  /// セマンティックバージョニング比較
  static bool _isUpdateRequired(String current, String min) {
    final currentParts =
        current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final minParts = min.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (var i = 0; i < 3; i++) {
      final c = currentParts.length > i ? currentParts[i] : 0;
      final m = minParts.length > i ? minParts[i] : 0;
      if (c < m) return true;
      if (c > m) return false;
    }
    return false;
  }

  /// 強制アップデートダイアログを表示する
  static void showUpdateDialog(BuildContext context, String storeUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, // 枠外をタップしても閉じない
      builder: (context) {
        return PopScope(
          canPop: false, // 戻るボタンを無効化
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              l10n(context, 'updateRequiredTitle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              l10n(context, 'updateRequiredMessage'),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    final uri = Uri.parse(storeUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(l10n(context, 'updateButton')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
