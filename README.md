# **A. Service**

> ## **설정값**
1. **isAdminMode** : 관리자 모드로, 클라이언트에게는 공개되지 않는 데이터를 확인할 수 있는 메뉴 하단 가장 우측에 개발자용 화면으로 진입할 수 있는 메뉴탭이 활성화됩니다.
2. **isSuperMode** : 무제한 데이터 요금제 사용자를 위한 슈퍼모드로, 네트워크가 느린 환경에서 사용시 앱이 정상작동하지않을 수 있습니다. 대신 슈퍼모드를 활성화할 경우, 해당 앱을 켜둔 동안에는 백그라운드로 모든 ticker 정보들을 수집하여 최신화 상태를 유지합니다.

---

> ## **디자인 가이드**
1. ### **화면 우측 상단 ActionButton**
    1. 최대 3개만 배치합니다.
    2. 기본적으로는 왼쪽부터 오른쪽으로 다음 순서대로 배치를 합니다. {main action} {유의사항} {sub action} {main action}
    3. 4개 이상의 action button 배치를 희망할 경우, {더보기 버튼}을 배치하며, 그의 위치는 기본적으로 {sub action} 위치로 둡니다. 단 필요에 따라 {main action} 위치로 둘 수 있습니다.
2. ### **스낵바 SnackBar**
    1. title의 이모티콘 후보 : ✅ 🎉 🎊 🎇 🥳 🎁
3. ### **상태 정보 이모티콘 공통 규칙**
    1. 비활성화, off, disabled, 미설정, 비실시간, 지연 : ⚫ ⚪
    2. 활성화, on, enabled, 설정완료, 실시간 : 🟢
    3. 오류 : 🔴
    4. 경고 : 🟡






# **B. Dev**

> ## **provider 함수명 규칙**
1. **insert** : provider 상태관리 데이터만 추가.
2. **insertBox** : provider 상태관리 데이터 추가와 함께 Hive Box 데이터 추가.
3. **update** : provider 상태관리 데이터만 수정.
4. **updateBox** : provider 상태관리 데이터 수정과 함께 Hive Box 데이터 수정.
5. **delete** : provider 상태관리 데이터만 삭제.
6. **deleteBox** : provider 상태관리 데이터 삭제와 함께 Hive Box 데이터 삭제.

---

> ## **log 규칙**
1. **[INFO]** : 정보성 데이터 출력, 대응 불필요.
2. **[WARN]** : 주의성 데이터 출력, 대응 안해도 문제없을 수 있지만 확인 요망.
3. **[ERROR]** : 오류 감지 데이터 출력, 즉시 대응해야하는 문제 발생.
4. **예시**
    1. log('[WARN][$className.$funcName] 내용');
    2. log('[WARN][TickerSettingNotifier.updateCandleColor] upColorString or downColorString is null. So BoxSetting not updated.');

---

> ## **ticker**
1. ### **price**
    1. double.tryParse가 정상 처리되도록 ,를 미포함한 String으로 저장.
    2. 단 노출시 ,를 추가해서 노출.
2. ### **changePercent**
    1. 양인 경우 +기호를 포함해 저장.
    2. 0.00인 경우 +0.00으로 표기.
3. ### **isUpdatedRecently**
    1. 해당 값을 기준으로 해당 ticker의 border 활성화됨. 즉, View에서 따로 ticker의 border를 따로 체크하지 않음.