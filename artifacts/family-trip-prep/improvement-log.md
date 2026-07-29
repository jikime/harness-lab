# Improvement Log — family-trip-prep

| 날짜 | 변경/발견 | 대상 | 사유/다음 조치 |
| --- | --- | --- | --- |
| 2026-07-27 | 하네스 초기 구성 (Agent 4개, Skill 4개, Orchestrator 1개) | 전체 | `harness-lab` 스킬로 청사진 승인 후 생성. |
| 2026-07-27~28 | 첫 실행: 뉴욕 여행(부부 2인) 조사→일정→검토→대시보드 완료. 중간에 사용자가 항공 스케줄을 정정(가는 편 08:30/오는 편 1/3 00:30 — 최초 입력이 실제로는 귀국편 시각이었음), 예산 500만원 증액, 새해 전야 옵션을 3차례(A안→루프탑→Trattoria) 조정 | 전체 | itinerary-planner를 v1→v2로 전면 재설계, checklist-reviewer도 재검토. 최종 승인 상태: 치명 이슈 없음, 사람 승인 3건 대기(Trattoria·QC Spa 예약, 항공 스케줄 확정) |
| 2026-07-28 | 개선 후보: 사용자가 처음 준 "새벽 00:30 탑승"이 실제로는 귀국편이었던 것처럼, 트립 브리프 수집 시 가는 편/오는 편을 분리해서 각각 명시적으로 묻지 않으면 착오가 재발할 수 있음 | `00-trip-brief.md` 입력 절차, `trip-research` 스킬 | 다음 개선 시 Orchestrator의 입력 확인 단계에 "가는 편 출발시각"과 "오는 편 출발시각"을 각각 별도 항목으로 질문하도록 보강 검토 |
| 2026-07-28 | 2차 부분 재실행: 체력(3만보)·식사 스타일(하루 2끼, 유명맛집+캐주얼, 피터루거 필수) 반영해 trip-researcher(유명맛집 9장 추가) → itinerary-planner v3(전면 재설계) → checklist-reviewer가 **중요 이슈 3건** 발견(Day7 이동시간 31분 구간 누락으로 "2시간 이내" 결론 위반, 피터루거 백업 플랜의 시간 역행 모순, 12/30 저녁 슬롯을 브로드웨이·피터루거 백업이 동시에 요구하는 우선순위 미규정) → itinerary-planner v4로 1차 수정 → checklist-reviewer 2차(최종) 재검토에서 승인 → dashboard-builder 재생성 | `itinerary-planning`, `trip-checklist-review` 스킬 | checklist-reviewer의 "자체보고 불신, 원문 직접 재계산" 원칙이 실제로 itinerary-planner의 자체보고("소화 불가능한 동선 0건")가 틀렸음을 잡아낸 사례. 이 교차검증 단계를 스킵하지 않는 것이 중요함을 재확인. 개선 후보: itinerary-planner의 요약표(예: 일자별 이동시간 합계)를 작성할 때, 구간을 부분적으로만 합산해 요약표를 만드는 실수가 반복될 수 있으니 `itinerary-planning` 스킬 절차에 "요약표 숫자는 본문 표 전체 구간을 코드처럼 나열해 합산했는지 자체 검산 후 기록" 단계를 명시적으로 추가하는 것을 검토 |
| 2026-07-28 | 실행 보조 산출물 추가: v4 일정 자체를 바꾸지 않고, 실제 예약·확인·현금 준비가 필요한 항목을 `04-execution-action-checklist.md`로 분리 | `family-trip-prep` 실행 산출물 | Claude가 전체 일정을 계속 짜고 Codex가 보조 검토자로 붙는 운영 방식에 맞춰, 도착 공항·숙소 조건·Peter Luger·Trattoria·QC NY Spa·TKTS 같은 변동성 높은 항목을 별도 체크리스트로 관리 |
