# 12306 火车票发票下载 Skill

从163邮箱下载12306电子发票并自动整理的技能。

## 功能

1. 读取163邮箱中12306发票邮件
2. 解析邮件内容获取发票信息（日期、车次、行程、金额）
3. 下载附件（PDF和OFD格式）
4. 自动重命名为"日期_车次_行程"格式
5. 生成发票清单Markdown文件

## 使用方法

```bash
# 方式1: 使用封装脚本
bash ~/Documents/出差报销/12306发票/download_invoices.sh

# 方式2: 手动执行
osascript -e '...'  # 见下方脚本
```

## 前置要求

1. Mac 已登录163邮箱（Mail.app）
2. 邮箱已配置IMAP
3. 发票邮件已同步到本地

## 技术细节

### AppleScript 关键命令

```applescript
-- 获取163邮箱账户
set account163 to account "163"

-- 获取收件箱
set mbx to mailbox "INBOX" of account163

-- 搜索包含"电子发票"的邮件
set msgList to messages of mbx whose subject contains "电子发票"

-- 读取邮件内容（包含发票表格）
set msgContent to content of msg

-- 下载附件
save att in alias "Macintosh HD:Users:xxx:Documents:发票目录:"
```

### 发票信息解析

邮件内容包含表格格式的发票信息：
- 发票号码
- 乘车日期
- 车次
- 发到站
- 发票项目
- 开票金额

### 文件命名规则

`{日期}_{车次}_{行程}.pdf`

示例：
- `2026-02-27_D3288_鄂州-武汉.pdf`
- `2026-01-28_G3463_汉口-襄阳东.pdf`

## 输出目录

```
~/Documents/出差报销/12306发票/
├── 2026-02-27_D3288_鄂州-武汉.pdf
├── 2026-02-27_D3288_鄂州-武汉.ofd
├── 2026-01-28_G3463_汉口-襄阳东.pdf
├── 2026-01-28_G3463_汉口-襄阳东.ofd
├── ...
└── 发票清单.md
```

## 注意事项

1. OFD格式是报销正式格式，PDF仅供预览
2. 邮件只是通知，附件才是真正的发票文件
3. 某些邮件可能有重复发票，注意去重
4. 批量下载后记得删除临时zip文件
