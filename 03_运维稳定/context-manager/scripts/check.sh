#!/bin/bash
# Context Manager - Session Summarization Script

# 配置
TOKEN_THRESHOLD=35
SESSION_KEY="agent:main:main"
MEMORY_DIR="$HOME/.openclaw/workspace/memory"
TODAY=$(date +%Y-%m-%d)

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🧠 Context Manager - Session Summarization"
echo "========================================"

# 1. 获取当前 session 状态
echo -e "\n${YELLOW}1. 检查当前上下文占用...${NC}"
STATUS_OUTPUT=$(openclaw session status 2>&1)
echo "$STATUS_OUTPUT"

# 2. 解析 context 百分比
CONTEXT_LINE=$(echo "$STATUS_OUTPUT" | grep -i "context:")
if [ -z "$CONTEXT_LINE" ]; then
    echo -e "${RED}无法获取上下文信息${NC}"
    exit 1
fi

# 提取百分比 (例如 "172k/200k (86%)" -> 86)
PERCENT=$(echo "$CONTEXT_LINE" | grep -oP '\(\K[0-9]+(?=%\)')
echo -e "当前上下文: ${PERCENT}%"

# 3. 检查是否需要触发摘要
if [ "$PERCENT" -lt "$TOKEN_THRESHOLD" ]; then
    echo -e "${GREEN}上下文占用低于 ${TOKEN_THRESHOLD}%，无需摘要${NC}"
    exit 0
fi

echo -e "${YELLOW}⚠️  上下文超过 ${TOKEN_THRESHOLD}%，触发摘要提取${NC}"

# 4. 获取会话历史
echo -e "\n${YELLOW}2. 获取会话历史...${NC}"
HISTORY=$(openclaw sessions history "$SESSION_KEY" --limit 50 2>&1)
echo "获取到 $(echo "$HISTORY" | wc -l) 条记录"

# 5. 调用 LLM 摘要（这里只是演示，实际可以用 tool call）
echo -e "\n${YELLOW}3. 准备摘要提取...${NC}"
echo "请手动调用 LLM 进行摘要，或使用以下提示词："
echo "---"
echo "请总结以下会话记录，提取："
echo "1. 关键决策（用户偏好、系统配置、禁止事项）"
echo "2. 待办事项（未完成的任务）"
echo "3. 当前上下文（项目背景、进度）"
echo "4. 重要结论（最终答案、方案）"
echo ""
echo "会话记录："
echo "$HISTORY" | head -100
echo "---"

# 6. 提示用户
echo -e "\n${GREEN}✅ 上下文检查完成${NC}"
echo "当前占用: ${PERCENT}%"
echo "阈值: ${TOKEN_THRESHOLD}%"
echo ""
echo "如需自动摘要，建议："
echo "1. 使用 heartbeat 定期检查"
echo "2. 调用 LLM 手动摘要"
echo "3. 摘要后写入 memory/$(date +%Y-%m-%d).md"
