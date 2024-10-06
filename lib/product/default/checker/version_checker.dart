// version_checker.dart

import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:tickerwatch/product/default/checker/version_info.dart';

class VersionChecker {
  static String urlString = 'https://icaruswhale.tistory.com/2';
  // pre.text 포맷 : 버전 # 일시

  /// 웹 페이지에서 버전 정보를 가져오는 함수
  static Future<List<VersionInfo>> getVersionHistoryFromWeb() async {
    final url = Uri.parse(urlString);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      // <pre> 태그에서 버전 정보 찾기
      var preTags = document.getElementsByTagName('pre');

      List<VersionInfo> versionList = [];

      for (var pre in preTags) {
        var versions = pre.text.trim().split('\n');

        for (var version in versions) {
          if (version.split(' | ').first != ' 버전 ') {
            var versionInfo = VersionInfo(
              version.split(' | ').first,
              version.split(' | ').last.split(' || ').first,
              version.split(' || ').last,
            );
            versionList.add(versionInfo);
          }
        }
      }
      return versionList;
    } else {
      throw Exception('웹 페이지를 불러오지 못했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  /// 웹 페이지에서 버전 정보를 가져오는 함수
  static Future<String> getLastVersionFromWeb() async {
    final url = Uri.parse(urlString);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      // <pre> 태그에서 버전 정보 찾기
      var preTags = document.getElementsByTagName('pre');

      for (var pre in preTags) {
        String minRecommandedVersion = pre.text.trim().split(' | ').first;

        if (_isValidVersion(minRecommandedVersion)) {
          return minRecommandedVersion;
        }
      }

      // <meta> 태그에서 "description" 속성 확인
      var metaDescription = document
          .querySelector('meta[name="description"]')
          ?.attributes['content']
          ?.trim();

      if (metaDescription != null && _isValidVersion(metaDescription)) {
        return metaDescription;
      }

      // 찾지 못한 경우 기본 버전 반환
      return '0.0.0';
    } else {
      throw Exception('웹 페이지를 불러오지 못했습니다. 상태 코드: ${response.statusCode}');
    }
  }

  /// 버전 형식 체크 (예: 1.0.1)
  static bool _isValidVersion(String version) {
    final versionRegex = RegExp(r'^\d+\.\d+\.\d+$');
    return versionRegex.hasMatch(version);
  }

  /// 현재 앱 버전과 fetched 버전을 비교하여 fetched가 더 높은지 확인
  static Future<bool> isUpdateRequired() async {
    try {
      // 현재 앱의 버전 정보 가져오기
      final String currentVersion = '1.0.0';
      log('현재 앱 버전: $currentVersion');

      // 웹 페이지에서 버전 정보 크롤링
      final String fetchedVersion = await getLastVersionFromWeb();
      log('업데이트 권고 최소 버전: $fetchedVersion - $urlString');

      // 버전 비교
      return _isVersionBelow(currentVersion, fetchedVersion);
    } catch (e) {
      log('버전 체크 오류: $e');
      // 오류 발생 시 업데이트가 필요하지 않은 것으로 간주
      return false;
    }
  }

  /// 두 버전을 비교하여 fetched 버전이 더 높은지 확인
  static bool _isVersionBelow(String current, String fetched) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> fetchedParts = fetched.split('.').map(int.parse).toList();

    for (int i = 0; i < fetchedParts.length; i++) {
      if (currentParts.length > i) {
        if (currentParts[i] < fetchedParts[i]) {
          return true;
        } else if (currentParts[i] > fetchedParts[i]) {
          return false;
        }
      } else {
        // 현재 버전의 부분이 fetched 버전보다 적으면
        return true;
      }
    }

    // 버전이 동일하거나 fetched 버전이 더 낮은 경우
    return false;
  }
}
