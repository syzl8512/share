#!/bin/bash
# Context Manager - Token Usage Checker
# 检查当前 session 的 token 占用情况

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "🧠 Token Usage Check"
echo "===================="

# 获取 session 状态
STATUS=$(openclaw session status 2>&1)

# 提取 context 信息
CONTEXT=$(echo "$STATUS" | grep -i "context:" | sed 's/.*context: //' | tr -d ' ')
PERCENT=$(echo "$STATUS" | grep -i "context:" | sed 's/.*(\([0-9]*\)%).*/\1/')

echo "Context: $CONTEXT"

# 判断
if [ -z "$PERCENT" ]; then
    echo "无法获取上下文百分比"
    exit 1
fi

echo "Percent: $PERCENT%"

if [ "$PERCENT" -ge 80 ]; then
    echo -e "${RED}⚠️  严重: 上下文占用过高 (>80%)，建议立即摘要${NC}"
    exit 2
elif [ "$PERCENT" -ge 60 ]; then
    echo -e "${YELLOW}⚠️  警告: 上下文占用较高 (>60%)${NC}"
    exit 1
elif [ "$PERCENT" -ge 35 ]; then
    echo -e "${YELLOW}💡 提示: 上下文占用中等 (>35%)，可考虑摘要${NC}"
    exit 0
else
    echo -e "${GREEN}✅ 正常: 上下文占用适中${NC}"
    exit 0
fi
