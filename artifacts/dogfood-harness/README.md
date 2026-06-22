# Dogfood Harness — skill-consistency-audit

harness-lab 메타스킬을 실제로 적용해 만든 **얇은 단일 흐름 하네스**. harness-lab가 자기 원칙대로 동작하는지 검증하는 도그푸딩 산출물.

## 산출물 지도

| 파일 | 역할 | 다음에 읽는 곳 |
| --- | --- | --- |
| `skill-consistency-audit/SKILL.md` | 작업 매뉴얼(점검 항목·절차·리포트 형식) | 점검 실행 시 |
| `skill-consistency-audit/scripts/check-consistency.sh` | 결정적 점검 스크립트 | SKILL이 호출 |
| `audit-2026-06-21.md` | 점검 리포트(최신) | 사람 |

## 실행

```bash
bash artifacts/dogfood-harness/skill-consistency-audit/scripts/check-consistency.sh \
  claude/skills/harness-lab codex/.agents/skills/harness-lab
```

## 상태
- 최신 실행: 2026-06-21, PASS 12 / FAIL 0
- 검증 생존: 결함 주입 4/4 검출 확인

## 설계 메모 (왜 얇은가)
점검이 대부분 결정적이라 Agent Team은 과설계. harness-lab의 적합성 게이트(6/6 이득) + 단일 흐름 우선 + 덜어내기 원칙대로 스크립트 1개 + 리포트로 구성. 외부 발송 없어 사람 승인 게이트도 생략.
