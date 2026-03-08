# Skill: MiniMax MCP

## 描述
MiniMax 提供的 MCP 服务，支持网络搜索和图片理解能力。

## 能力
1. **网络搜索** - 获取实时网络信息
2. **图片理解** - 分析和描述图片内容

## 配置

### 安装
```json
{
  "mcpServers": {
    "MiniMax": {
      "command": "uvx",
      "args": ["minimax-coding-plan-mcp"],
      "env": {
        "MINIMAX_API_KEY": "你的API密钥",
        "MINIMAX_MCP_BASE_PATH": "/path/to/output",
        "MINIMAX_API_HOST": "https://api.minimaxi.com",
        "MINIMAX_API_RESOURCE_MODE": "url"
      }
    }
  }
}
```

### 环境变量
| 变量 | 必填 | 说明 |
|------|------|------|
| MINIMAX_API_KEY | ✅ | API密钥 |
| MINIMAX_MCP_BASE_PATH | ✅ | 本地输出目录 |
| MINIMAX_API_HOST | | 默认 https://api.minimaxi.com |
| MINIMAX_API_RESOURCE_MODE | | url 或 local |

## 使用场景
- 网络搜索信息
- 分析/描述图片
- 从URL提取内容

## 参考
- 官网: https://platform.minimaxi.com/docs/coding-plan/mcp-guide
