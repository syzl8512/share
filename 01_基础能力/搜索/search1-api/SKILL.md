# Skill: Search1API

## 描述
多引擎搜索API，支持Google、Bing等，提供搜索、新闻、深度搜索功能。

## 触发
用户说"用Search1搜索"、"deep search"。

## API信息
- 官网: https://www.search1api.com
- 文档: https://www.search1api.com/docs
- 价格: $19/月起，25000次/月

## 使用方式
```bash
# 搜索API
curl -X POST "https://www.search1api.com/api/search" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "关键词", "max_results": 10, "language": "zh"}'
```

## 参数
| 参数 | 说明 |
|------|------|
| query | 搜索关键词 |
| max_results | 返回结果数 |
| language | 语言(zh/en) |
| search_service | 搜索引擎(google/bing) |

## 已配置
- API Key: 5CE53A87-43B6-4B4C-BC27-148AF20D8B75 (当前使用)
- API Key: AA650CD6-260C-482C-A56F-79F6094E24F9 (已过期)

## 注意
- 需要有效的API Key
- 调用失败需检查密钥是否过期或服务状态
