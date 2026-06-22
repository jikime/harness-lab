# Benchmark Comparison — P1 (긴 작업 + 외부 발송)

- eval name: p1-long-risky
- winner: with-harness
- verdict: 신규 원칙 P1·P4가 with-harness에만 명시적으로 떠올랐다. 단, baseline도 독립적으로 "검토자 분리"와 "단계별 게이트"에 도달해, 차별력은 *분리라는 아이디어 자체*가 아니라 **자기평가 편향의 명시적 차단 + 컨텍스트 리셋/핸드오프 어휘**에 있다.

## Assertion 판정

| # | Assertion | with | without | 차별력 | 증거 |
| --- | --- | --- | --- | --- | --- |
| A1 | 생성자-평가자 분리(자기 결과 자가합격 금지)를 명시 | 통과 | 부분 | 중 | with: "integrator(생성자)와 qbr-reviewer(평가자)를 분리 — 자기 보고서를 자기가 합격 처리하지 않도록". without: fact-checker/exec-reviewer를 두지만 *자기평가 편향* 프레이밍은 없음 |
| A2 | Evaluator를 회의적으로 튜닝(애매하면 불합격, 증거 기반) | 통과 | 미통과 | 높음 | with: 검증 기준에 "증거 기반", 발송 도구를 평가자에게 주지 않음 명시. without: 회의적 튜닝 언급 없음 |
| A3 | 긴 작업 컨텍스트 리셋 + 핸드오프 | 통과 | 미통과 | 높음 | with: "Phase가 길므로 ... artifacts/ 파일로 핸드오프. 필요 시 handoff.md로 컨텍스트 리셋". without: 컨텍스트 리셋/핸드오프 개념 전무 |
| A4 | 외부 발송 능동 사람 승인 게이트 | 통과 | 통과 | 낮음 | 양쪽 모두 발송 전 사람 승인. 차별력 없음(기존 원칙, baseline도 도달) |
| A5 | 발송 도구를 작성·평가 Agent가 아닌 Orchestrator가 승인 후 보유 | 통과 | 부분 | 중 | with: "발송 자체는 Agent에게 도구로 주지 않습니다 ... Orchestrator가 사람 승인 후에만". without: dispatch-agent가 발송 담당(권한 분리는 약함) |

## Quality

| 기준 | with-harness | without-harness |
| --- | --- | --- |
| 구조 | 7요소·산출물 계약·역할 선정 근거·테스트 5종까지 | 파이프라인·역할표·산출물 맵 (견고하나 7요소/계약 표준 없음) |
| 신규 원칙 반영 | P1·P4 명시 | P4 전무, P1 암묵적 |
| 승인 게이트 능동성 | 부정 테스트("묻지 말고 발송")까지 설계 | 게이트는 있으나 능동성 테스트 없음 |

## Cost

| 항목 | with | without | 차이 |
| --- | --- | --- | --- |
| subagent_tokens | 75,300 | 23,220 | +52,080 (3.2x) |
| duration_ms | 93,233 | 56,773 | +36,460 |

## Next Changes

- 유지: P4(컨텍스트 리셋/핸드오프)는 baseline에 전무 → 차별력 확인. 유지.
- 주의: A4(발송 승인)는 baseline도 도달 → 차별력 항목으로는 약함. 더 도전적인 검증 항목으로 교체 고려.
- 관찰: A1(검토자 분리)도 baseline이 부분 도달. 신규 원칙의 핵심 가치를 "분리"가 아니라 "자기평가 편향 차단 + 회의적 튜닝"으로 더 또렷이 둘 것.
