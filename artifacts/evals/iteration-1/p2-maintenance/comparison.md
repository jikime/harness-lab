# Benchmark Comparison — P2 (운영/유지보수: 덜어내기)

- eval name: p2-maintenance
- winner: with-harness
- verdict: 신규 P2(하네스 덜어내기 진단)가 with-harness에서 구조화된 절차로 떠올랐다. baseline도 "에이전트 줄여라"라는 결론에는 독립적으로 도달했으나, **남길/덜어낼 신호 표 + 한 번에 하나씩 with/without 검증 + 제거 사유 기록(되살릴 근거)**이라는 규율은 with-harness에만 있다.

## Assertion 판정

| # | Assertion | with | without | 차별력 | 증거 |
| --- | --- | --- | --- | --- | --- |
| B1 | 추가가 아니라 제거 후보를 찾는 진단으로 프레이밍 | 통과 | 부분 | 중 | with: "추가가 아니라 불필요해진 조각 식별 + 통과만 하는 검증의 재설계". without: "에이전트 수를 줄인다"는 결론엔 도달 |
| B2 | 조각별 남길/덜어낼 신호 표 사용 | 통과 | 미통과 | 높음 | with: "남길 신호/덜어낼 신호" 표로 Agent·Skill·검증·지시 분류. without: 표/체계 없음(서술형 조언) |
| B3 | 한 번에 하나씩 빼고 light with/without로 검증 | 통과 | 미통과 | 높음 | with: "각 제거는 light with/without 비교로 검증한 뒤에만 확정", "한 번에 하나씩". without: 단계적 제거 검증 절차 없음 |
| B4 | always-pass 검증 = 차별력 0 → 더 도전적 항목으로 교체 | 통과 | 부분 | 중 | with: "양쪽 항상 통과 → 차별력 없음 → 경계면 교차 검증으로 교체". without: "반려 우선 프롬프트로 날카롭게"(좋은 대안이나 차별력 프레이밍은 없음) |
| B5 | 제거 사유를 기록해 되살릴 근거로 보존 | 통과 | 미통과 | 높음 | with: "제거 조각·사유를 improvement-log.md와 변경 이력에 남겨 되살릴 근거로 보존". without: 없음 |
| B6 | 점검을 추측이 아니라 실제 파일 확인으로 (사람 승인 게이트) | 통과 | 통과 | 낮음 | 양쪽 모두 "실제 파일/로그를 달라"로 멈춤. 차별력 낮음 |

## 관찰: baseline의 강점

baseline은 **결함 주입 테스트(fault injection)**를 가장 빠른 진단으로 강조했다. with-harness도 테스트 3종에 "수치 오류·금지 표현 심은 원고"로 포함하나, baseline이 이 기법을 더 전면에 내세웠다. → 개선 후보: 신규 회귀 세트/결함 주입을 testing 참조에 더 또렷이 넣을 수 있음.

## Cost

| 항목 | with | without | 차이 |
| --- | --- | --- | --- |
| subagent_tokens | 60,171 | 22,392 | +37,779 (2.7x) |
| duration_ms | 53,960 | 50,100 | +3,860 |

## Next Changes

- 유지: P2의 신호 표·단계적 검증·기록 규율(B2/B3/B5)은 baseline에 전무 → 높은 차별력. 유지.
- 교체 후보: B6(파일 확인 후 멈춤)은 baseline도 도달 → 차별력 항목에서 제외.
- 추가 후보(다음 iteration): 결함 주입/회귀 세트를 testing-qa-evolution.md에 더 명시(baseline이 더 강했던 유일한 영역). → iteration 2에서 반영 완료(2026-06-21): testing-qa-evolution.md / testing-improvement.md에 "결함 주입과 회귀 세트" 절 추가.
