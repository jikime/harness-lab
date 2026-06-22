# Eval Run Config — 1·2순위 추가 검증 (적합성 게이트 + 반복 루프)

- eval name: tier1-2-improvements-iter2
- iteration: 2
- benchmark thickness: targeted
- 목적: 적합성 게이트 / 반복 검증 루프(+종료계약·best롤백·에스컬레이션) / 외부 신호 결합이 실제 산출물에 떠오르는지, baseline 대비 차별력이 있는지
- 대상 버전: claude/skills/harness-lab (post tier1-2)
- with-harness 허용: harness-lab SKILL + 해당 references 읽고 처리
- without-harness 금지: harness-lab 미사용, 일반 지식만
- 모델 정책: Agent frontmatter `model` 생략. general-purpose subagent.

## 측정값(완료 알림 기준)

| 실행 | subagent_tokens | duration_ms |
| --- | --- | --- |
| P3 적합성 with | 48,125 | 38,707 |
| P3 적합성 without | 22,484 | 55,249 |
| P4 반복루프 with | 73,399 | 124,789 |
| P4 반복루프 without | 24,172 | 78,951 |

## 핵심 발견 (요약)
두 주제 모두 **with-harness가 추가 내용을 완전히 반영**했다(적합성 게이트 6차원, 반복 루프 종료계약·best롤백·에스컬레이션·외부신호). 그러나 **baseline(강한 모델)도 핵심 결론에 독립적으로 도달**했다 — 패턴 자체의 차별력은 낮고, 차별력은 "하네스 포장"(artifacts 계약·상태관리·승인게이트·트리거검증·재실행·진화)에 집중됨. 테스트 프롬프트가 다소 유도적이었던 한계도 있음(아래 comparison 참조).
