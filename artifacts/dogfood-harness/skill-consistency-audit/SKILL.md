---
name: skill-consistency-audit
description: harness-lab 같은 스킬 패키지의 구조 일관성(목차·Phase 번호·병합 줄·줄수 한도·claude/codex parity)을 결정적으로 점검하고 리포트를 남기는 얇은 단일 흐름 하네스. "스킬 점검", "일관성 점검", "drift 확인", "편집 후 검증" 요청 시 사용. 내용 품질·문체 검토에는 사용하지 않는다(이건 구조 점검 전용).
---

# Skill Consistency Audit (얇은 하네스)

## 왜 얇은가

점검 항목이 대부분 결정적(존재/개수/패턴 매칭)이라 LLM 판단이 거의 필요 없다. harness-lab의 "단일 흐름 우선 + 덜어내기" 원칙에 따라 Agent Team 없이 **스크립트 1개 + 리포트**로 둔다. 외부 발송이 없어 사람 승인 게이트도 불필요.

## 점검 항목

| # | 항목 | 기준 | 방식 |
|---|---|---|---|
| C1 | SKILL.md 줄 수 | < 500줄 | 결정적 |
| C2 | 병합된 불릿 줄 | 0건 (한 줄에 불릿 2개 금지) | 결정적 |
| C3 | 참조 목차 | 100줄+ 참조는 `## 목차` 보유 | 결정적 |
| C4 | Phase 일관성 | Phase 0~7만 존재, Phase 8+ 금지 | 결정적 |
| C5 | commands 미생성 | `commands/` 디렉터리 없음 | 결정적 |
| C6 | claude/codex parity | 양쪽 SKILL.md 존재 + 참조 수 기록 | 결정적 |

## 절차

1. `scripts/check-consistency.sh`를 실행한다.
2. 출력의 FAIL 항목을 리포트에 옮긴다.
3. `artifacts/dogfood-harness/audit-{날짜}.md`에 PASS/FAIL과 근거(파일:줄)를 남긴다.
4. FAIL이 있으면 수정 후보를 제시하되, 자동 수정하지 않고 사람 확인을 받는다.

## 리포트 형식

```md
# Consistency Audit — {날짜}
| 항목 | 판정 | 근거 |
| --- | --- | --- |
요약: PASS n / FAIL m
```

## 하지 말아야 할 일

- 내용·문체 품질을 판단하지 않는다(구조 전용).
- FAIL을 자동 수정하지 않는다. 수정 후보만 제시한다.
