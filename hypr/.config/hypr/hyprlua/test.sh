#!/usr/bin/env bash
# 监听 fcitx5 的 FocusIn 信号，每次输入框获得焦点时显示当前输入法

dbus-monitor "interface='org.fcitx.Fcitx5.Frontend'" |
while read -r line; do
    # 当 fcitx5 前端报告 FocusIn 时触发
    if [[ "$line" =~ "FocusIn" ]]; then
        current=$(qdbus org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.CurrentInputMethod)
        case "$current" in
            "keyboard-us") name="EN" ;;
            "pinyin") name="拼音" ;;
            "rime") name="Rime" ;;
            *) name="$current" ;;
        esac
        notify-send "输入法: $name"
    fi
done
