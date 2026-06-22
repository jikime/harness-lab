# Benchmark Comparison — P4 (반복 검증 루프)

- eval name: p4-iterative-loop
- winner: with-harness (하네스 완성도) / 루프 역학은 tie
- verdict: with-harness는 반복 루프의 모든 추가 요소를 완전히 반영(종료계약 4출구·라운드상한 3·수렴정체·예산·best롤백·미통과 시 에스컬레이션·2층 외부신호검증·결함주입 회귀세트). **그러나 baseline도 매우 강한 루프를 설계**(MAX_ATTEMPTS 5·수렴감지·회귀방지·의미보존·사람게이트·deterministic vs llm_judge 분리·생성자/평가자 분리). 즉 강한 모델은 "bounded loop" 패턴을 이미 안다. **차별력은 루프 역학이 아니라 "하네스 포장"에 있다.**

## Assertion 판정

| # | Assertion | with | without | 차별력 | 증거 |
| --- | --- | --- | --- | --- | --- |
| A1 | 반복 루프 + 종료 계약(상한·수렴·예산·통과) | 통과 | 통과 | 낮음 | 양쪽 모두 상한·수렴·통과 출구. without도 MAX_ATTEMPTS·수렴감지 |
| A2 | best 보존·롤백(단조개선 가정 안 함) | 통과 | 부분 | 중 | with: 명시적 best 롤백. without: "회귀 방지"로 유사하나 best 롤백 명시 약함 |
| A3 | 미통과 시 사람 승인 에스컬레이션 | 통과 | 통과 | 낮음 | 양쪽 모두 에스컬레이션 |
| A4 | 외부 신호 결합(결정적 vs LLM 판단 분리) | 통과 | 통과 | 낮음 | 양쪽 deterministic/llm_judge 분리 |
| A5 | 결함 주입 회귀 세트로 검증 생존 확인 | 통과 | 통과 | 낮음 | 양쪽 회귀 테스트 셋 언급 |
| A6 | **하네스 포장**: artifacts 계약·README 상태/stale·승인게이트·트리거검증·부분재실행·진화 | 통과 | 미통과 | **높음** | with: artifacts 지도·stale·trigger evals·CLAUDE.md 라우팅·improvement-log 전부. without: 좋은 설계지만 재실행 가능한 파일 하네스·상태관리 없음 |

## 핵심 결론 (정직)
추가한 루프 내용은 **완전히 반영됨(검증 성공)**. 하지만 **패턴 역학(loop·종료·검증분리)은 강한 baseline도 알고 있어 차별력이 낮다.** 진짜 차별력은 A6 — **재실행 가능한 하네스 구조**(artifacts·상태·승인·트리거·진화)에 집중. 이는 앞선 연구 결론("효율은 패턴이 아니라 구조화·검증·승인에서")을 재확인.

## Next Changes
- 루프 내용 유지(반영 정상).
- 차별력 항목(A1·A4·A5)은 baseline도 통과 → 더 도전적 검증 항목으로 교체 후보.
- 강조 이동: 패턴 자랑보다 "하네스 포장(상태·승인·재실행·진화)"이 실제 가치임을 SKILL이 더 또렷이 말하면 좋음.
