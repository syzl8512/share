# 12306 发票下载详细指南

## 完整流程

### 第1步：确认Mail.app已配置163邮箱

```bash
# 查看已配置的邮箱账户
osascript -e 'tell application "Mail" to get accounts'
```

### 第2步：搜索发票邮件

```bash
# 搜索包含"电子发票"的邮件
osascript << 'EOF'
tell application "Mail"
    set account163 to account "163"
    set mbx to mailbox "INBOX" of account163
    set msgList to messages of mbx whose subject contains "电子发票"
    return count of msgList
end tell
EOF
```

### 第3步：读取邮件内容获取发票信息

```bash
# 读取第一封发票邮件的内容（包含发票表格）
osascript << 'EOF'
tell application "Mail"
    set mbx to mailbox "INBOX" of account "163"
    set msg to first message of mbx whose subject contains "电子发票"
    return content of msg
end tell
EOF
```

### 第4步：下载附件

```bash
# 创建目标目录
mkdir -p ~/Documents/出差报销/12306发票

# 下载所有附件
osascript << 'EOF'
tell application "Mail"
    set account163 to account "163"
    set mbx to mailbox "INBOX" of account163
    set msgList to messages of mbx whose subject contains "电子发票"
    
    set downloadPath to "Macintosh HD:Users:agent:Documents:出差报销:12306发票:"
    
    repeat with msg in msgList
        set atts to attachments of msg
        repeat with att in atts
            set attName to name of att
            save att in (downloadPath & attName)
        end repeat
    end repeat
end tell
EOF
```

### 第5步：解压并整理

```bash
cd ~/Documents/出差报销/12306发票

# 解压所有zip
for f in *.zip; do
    unzip -o "$f" -d .
    rm -f "$f"
done

# 重命名文件（按发票信息）
# 使用下方Python脚本自动重命名
```

### 第6步：自动重命名脚本

```python
#!/usr/bin/env python3
"""
12306发票自动重命名脚本
根据邮件内容解析的发票信息自动重命名文件
"""

import os
import re

# 发票信息映射表（从邮件内容获取）
INVOICE_MAP = {
    "26429121977000022247": "2026-02-27_D3288_鄂州-武汉",
    "26429165800001003061": "2026-02-27_G1521_武汉-鄂州",
    "26429165806000033058": "2026-02-06_G1052_咸宁北-武汉",
    "26429165800001003062": "2026-02-06_G1107_武汉-咸宁北",
    "26429145093000023818": "2026-01-29_D5834_天门南-汉口",
    "26429121050000774031": "2026-01-29_D5987_汉口-天门南",
    "26429165431000189389": "2026-01-28_G6838_襄阳东-汉口",
    "26429121050000774032": "2026-01-28_G3463_汉口-襄阳东",
    "26429145062000164153": "2025-12-09_D368_宜昌东-汉口",
    "26429121050000774033": "2025-12-09_D5837_汉口-宜昌东",
    "26429121050000774631": "2025-12-01_D5787_汉口-荆州",
    "26429145084000102297": "2025-12-01_D2218_荆州-汉口",
    "26429145062000164309": "2025-11-12_D5980_宜昌东-汉口",
    "26429121050000774632": "2025-11-11_G3455_汉口-兴山",
    "26429121050000774633": "2025-09-12_D5787_汉口-荆州",
    "26429145084000102298": "2025-09-12_D2270_荆州-汉川",
    "26509199033000012907": "2025-09-12_D2270_汉川-汉口",
}

def rename_files(directory):
    for filename in os.listdir(directory):
        # 提取发票号
        for inv_num, new_name in INVOICE_MAP.items():
            if inv_num in filename:
                ext = os.path.splitext(filename)[1]
                old_path = os.path.join(directory, filename)
                new_path = os.path.join(directory, f"{new_name}{ext}")
                os.rename(old_path, new_path)
                print(f"✓ {filename} -> {new_name}{ext}")
                break

if __name__ == "__main__":
    directory = os.path.expanduser("~/Documents/出差报销/12306发票")
    rename_files(directory)
```

### 第7步：生成清单

```bash
# 创建发票清单Markdown
cat > ~/Documents/出差报销/12306发票/发票清单.md << 'EOF'
# 12306 电子发票汇总

> 共 17 张发票 | 总计: ¥1,466

## 2026年2月
...（详见实际清单）
EOF
```

## 常见问题

### Q: 邮件没有附件？
A: 12306邮件只是通知，需要点击附件下载真正的发票文件（PDF/OFD）

### Q: 附件下载失败？
A: 检查Mail.app是否已同步该邮件，尝试先在Mail中打开该邮件

### Q: 文件名乱码？
A: macOS中文环境可能有问题，使用Python脚本重命名可解决

### Q: OFD格式是什么？
A: 中国标准的电子发票格式，报销需要用OFD，PDF仅供预览
