# Eval Run Config — harness-lab P1/P2/P4 개선 검증

- eval name: harness-lab-improvements-iter1
- iteration: 1
- benchmark thickness: targeted
- 목적: 2026-06-21 추가한 설계 원칙(P1 생성자-평가자 분리, P2 하네스 덜어내기 진단, P4 컨텍스트 리셋·핸드오프)이 실제 청사진 산출물에 떠오르는지 with/without 비교
- 대상 버전: claude/skills/harness-lab (post-edit)
- 공통 입력: 각 프롬프트의 prompt.md
- with-harness 허용: harness-lab SKILL.md + references 읽고 청사진 생성
- without-harness 금지: harness-lab 스킬/참조 미사용, 일반 지식만으로 설계
- 모델 정책: Agent frontmatter `model` 생략(기본). 실행은 general-purpose subagent.
- 평가 방식: assertion 기반 + 산출물 인용 증거. (description 미변경이라 트리거는 회귀 sanity 수준)

## 측정값(완료 알림 기준)

| 실행 | subagent_tokens | duration_ms |
| --- | --- | --- |
| P1 with-harness | 75,300 | 93,233 |
| P1 without-harness | 23,220 | 56,773 |
| P2 with-harness | 60,171 | 53,960 |
| P2 without-harness | 22,392 | 50,100 |

비용 해석: with-harness가 참조 문서를 읽어 토큰을 2.7~3.2배 더 썼다. 청사진 품질·구조·승인 게이트 강화가 그 비용을 정당화하는지는 각 comparison.md 판정 참조.
