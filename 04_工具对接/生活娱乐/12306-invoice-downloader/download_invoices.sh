#!/bin/bash
#
# 12306 发票下载脚本
# 从163邮箱下载12306电子发票并整理
#

DEST_DIR="$HOME/Documents/出差报销/12306发票"
TEMP_DIR="$HOME/Downloads/12306_temp"

# 创建目录
mkdir -p "$DEST_DIR"
mkdir -p "$TEMP_DIR"

echo "📥 开始下载12306发票..."

# 使用AppleScript获取邮件内容并下载附件
osascript << 'EOF'
set downloadPath to "$HOME/Documents/出差报销/12306发票:"
set tempPath to "$HOME/Downloads/12306_temp:"

tell application "Mail"
    set account163 to account "163"
    set mbx to mailbox "INBOX" of account163
    set msgList to messages of mbx whose subject contains "电子发票"
    
    repeat with msg in msgList
        set subj to subject of msg
        try
            set atts to attachments of msg
            repeat with att in atts
                set attName to name of att
                -- 保存到临时目录
                save att in (tempPath & attName)
            end repeat
        on error
            log "Skip: " & subj
        end try
    end repeat
end tell
EOF

# 解压zip文件
echo "📦 解压附件..."
cd "$TEMP_DIR"
for f in *.zip; do
    if [ -f "$f" ]; then
        unzip -o "$f" -d "$DEST_DIR/"
        rm -f "$f"
    fi
done

# 删除不需要的zip文件
cd "$DEST_DIR"
rm -f *.zip

echo "✅ 下载完成！"
echo "📁 发票位置: $DEST_DIR"
echo "📊 文件数量: $(ls -1 *.pdf 2>/dev/null | wc -l)"
