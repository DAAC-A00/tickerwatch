# tickerwatch

- provider 함수명 규칙
1. insert : provider 상태관리 데이터만 추가
2. insertBox : provider 상태관리 데이터 추가와 함께 Hive Box 데이터 추가
3. update : provider 상태관리 데이터만 수정
4. updateBox : provider 상태관리 데이터 수정과 함께 Hive Box 데이터 수정
5. delete : provider 상태관리 데이터만 삭제
6. deleteBox : provider 상태관리 데이터 삭제와 함께 Hive Box 데이터 삭제

- log 규칙
1. [INFO] : 정보성 데이터 출력, 대응 불필요
2. [WARN] : 주의성 데이터 출력, 대응 안해도 문제없을 수 있지만 확인 요망
3. [ERROR] : 오류 감지 데이터 출력, 즉시 대응해야하는 문제 발생
4. 예시 : log('[WARN][$className.$funcName] 내용');
5. log('[WARN][TickerSettingNotifier.updateCandleColor] upColorString or downColorString is null. So BoxSetting not updated.');

- 설정값
1. isDevMode : 개발자모드로, 클라이언트에게는 공개되지 않는 데이터를 확인할 수 있는 메뉴 하단 가장 우측에 개발자용 화면으로 진입할 수 있는 메뉴탭이 활성화된다.
2. 