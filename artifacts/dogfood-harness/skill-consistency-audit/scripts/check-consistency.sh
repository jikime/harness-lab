#!/usr/bin/env bash
# Skill Consistency Audit — 결정적 점검 스크립트
# 사용법: bash check-consistency.sh <skill-dir1> [<skill-dir2> ...]
set -u

PASS=0; FAIL=0
log_pass(){ echo "PASS | $1"; PASS=$((PASS+1)); }
log_fail(){ echo "FAIL | $1"; FAIL=$((FAIL+1)); }

for dir in "$@"; do
  skill="$dir/SKILL.md"
  echo "==== $dir ===="

  # C1: SKILL.md < 500줄
  if [ -f "$skill" ]; then
    n=$(wc -l < "$skill")
    if [ "$n" -lt 500 ]; then log_pass "C1 SKILL.md ${n}줄 (<500)"; else log_fail "C1 SKILL.md ${n}줄 (>=500)"; fi
  else
    log_fail "C1 SKILL.md 없음: $skill"
  fi

  # C2: 병합된 불릿 줄 (한국어 종결 + .- / )- 패턴)
  merged=$(grep -rEn '[가-힣]\.- |[가-힣]\)- |[가-힣]다\.-' "$dir" --include=*.md 2>/dev/null | grep -vE '^\s*[0-9]+:\s*\|' || true)
  if [ -z "$merged" ]; then log_pass "C2 병합 불릿 0건"; else log_fail "C2 병합 불릿 발견:"; echo "$merged" | sed 's/^/        /'; fi

  # C3: 100줄+ 참조에 ## 목차
  if [ -d "$dir/references" ]; then
    miss=""
    for f in "$dir"/references/*.md; do
      [ -f "$f" ] || continue
      ln=$(wc -l < "$f")
      if [ "$ln" -gt 100 ] && ! grep -q '^## 목차' "$f"; then miss="$miss $(basename "$f")(${ln}줄)"; fi
    done
    if [ -z "$miss" ]; then log_pass "C3 100줄+ 참조 목차 전부 보유"; else log_fail "C3 목차 누락:$miss"; fi
  fi

  # C4: Phase 0~7만, Phase 8+ 금지
  bad=$(grep -rohE 'Phase [0-9]+' "$dir" --include=*.md 2>/dev/null | grep -vE 'Phase [0-7]' || true)
  if [ -z "$bad" ]; then log_pass "C4 Phase 0~7 일관"; else log_fail "C4 범위 밖 Phase: $(echo "$bad" | sort -u | tr '\n' ' ')"; fi

  # C5: commands/ 미생성
  if [ -d "$dir/commands" ] || [ -d "$dir/../commands" ]; then log_fail "C5 commands/ 존재"; else log_pass "C5 commands/ 없음"; fi

  # C6: 참조 수 기록
  rc=$(ls "$dir"/references/*.md 2>/dev/null | wc -l | tr -d ' ')
  log_pass "C6 참조 ${rc}개 (parity 기록용)"
  echo ""
done

echo "==== 요약 ===="
echo "PASS $PASS / FAIL $FAIL"
[ "$FAIL" -eq 0 ]
