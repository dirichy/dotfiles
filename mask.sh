#!/usr/bin/env bash
# 用法：
# ./mask.sh mask < config.yaml > config_masked.yaml
# ./mask.sh restore < config_masked.yaml > config_restored.yaml
# 第二个参数可指定注释符，默认 #

MODE="$1"
COMMENT="#"       # 默认注释符
MAP_FILE="${2:-secrets.txt}"
MATCH="MASK_ME"

if [[ ! -f "$MAP_FILE" ]]; then
  echo "Secrets file '$MAP_FILE' not found" >&2
  exit 1
fi

declare -A map
while IFS= read -r line; do
  map["${line%%=*}"]="${line#*=}"
done < "$MAP_FILE"

case "$MODE" in
  init)
    git config filter.mask.clean "bash -c 'cd $(git rev-parse --show-toplevel) && ./mask.sh mask'"
    git config filter.mask.smudge "bash -c 'cd $(git rev-parse --show-toplevel) && ./mask.sh restore'"
    git config filter.mask.required true
    ;;
  mask)
    IFS= read -r line;
    echo $line
    regex="([^[:space:]]*)[[:space:]]*COMMENT_STRING[[:space:]]*([^[:space:]]*)"
    if [[ $line =~ $regex ]]; then
      if [[ "${BASH_REMATCH[1]}" == "${BASH_REMATCH[2]}" ]]; then
        COMMENT="${BASH_REMATCH[1]}"
      fi
    fi
    while IFS= read -r line; do
      # 匹配行尾的注释符 + ${MATCH} 占位符
      regex="([[:space:]]*).*${COMMENT}[[:space:]]*${MATCH}[[:space:]]*([a-zA-Z0-9_]+)"
      if [[ $line =~ $regex ]]; then
        placeholder="${BASH_REMATCH[2]}"
        line="${BASH_REMATCH[1]}${COMMENT} ${placeholder} ${COMMENT} ${MATCH} ${placeholder}"
      fi
      echo "$line"
    done
    ;;
  restore)
    IFS= read -r line;
    echo $line
    regex="([^[:space:]]*)[[:space:]]*COMMENT_STRING[[:space:]]*([^[:space:]]*)"
    if [[ $line =~ $regex ]]; then
      if [[ "${BASH_REMATCH[1]}" == "${BASH_REMATCH[2]}" ]]; then
        COMMENT="${BASH_REMATCH[1]}"
      fi
    fi
    while IFS= read -r line; do
      # 匹配行尾的注释符 + ${MATCH} 占位符
      regex="([[:space:]]*).*${COMMENT}[[:space:]]*${MATCH}[[:space:]]*([a-zA-Z0-9_]+)"
      if [[ $line =~ $regex ]]; then
        placeholder="${BASH_REMATCH[2]}"
        if [[ -n "${map[$placeholder]}" ]]; then
          line="${BASH_REMATCH[1]}${map[$placeholder]} ${COMMENT} ${MATCH} ${placeholder}"
        fi
      fi
      echo "$line"
    done
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    exit 1
    ;;
esac
