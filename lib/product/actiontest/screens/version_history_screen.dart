// version_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/checker/version_checker.dart';
import 'package:tickerwatch/product/default/checker/version_info.dart';

class VersionHistoryScreen extends ConsumerStatefulWidget {
  const VersionHistoryScreen({super.key});

  @override
  ConsumerState<VersionHistoryScreen> createState() =>
      _VersionHistoryScreenState();
}

class _VersionHistoryScreenState extends ConsumerState<VersionHistoryScreen> {
  late Future<List<VersionInfo>> versionListFuture;

  @override
  void initState() {
    super.initState();
    versionListFuture = VersionChecker.getVersionHistoryFromWeb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Version History'),
      ),
      body: FutureBuilder<List<VersionInfo>>(
        future: versionListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('버전 정보가 없습니다.'));
          }

          final versionList = snapshot.data!;

          return ListView(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: const Text(
                        '버전',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: const Text(
                        '날짜 시간',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: const Text(
                        '내용',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ...versionList.map((versionInfo) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(versionInfo.version),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(versionInfo.dateTime),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(versionInfo.description),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
