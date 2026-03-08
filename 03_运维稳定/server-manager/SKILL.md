---
name: server-manager
description: 服务器管理 - SSH连接和远程命令执行
metadata:
  openclaw:
    requires:
      exec: true
---

# 服务器管理器

统一管理并连接各类服务器。支持两种连接方式：**外网（WAN）**和**内网/ZeroTier（LAN）**。

## 功能列表

| 功能 | 命令示例 |
|------|----------|
| 列出服务器 | `服务器列表` |
| 连接服务器 | `连接到群晖` |
| 执行命令 | `在 群晖 执行 ls -la` |
| 添加服务器 | `添加服务器 飞牛` |

## 服务器配置

### 群晖 (synology) - DS1821+

| 连接方式 | 地址 | 端口 | 用户 | 认证 |
|---------|------|------|------|------|
| 外网WAN | ximi.space | 2211 | syzl8512 | 密钥 |
| 内网LAN | 192.168.1.4 | 22 | syzl8512 | 密钥 |
| ZeroTier | 192.168.1.4 | 22 | syzl8512 | 密钥 |

**别名**: synology, nas, 群晖

### 小爱 (xiaoai) - Macbook

| 连接方式 | 地址 | 端口 | 用户 | 认证 |
|---------|------|------|------|------|
| ZeroTier | 10.147.17.177 | 22 | mia | 密码: 123457 |

**别名**: xiaoai, macbook, 小爱

**说明**: 只能通过 ZeroTier 访问

### Ubuntu 节点 (备用OpenClaw)

| 连接方式 | 地址 | 端口 | 用户 | 认证 |
|---------|------|------|------|------|
| 外网WAN | ximi.space | 2221 | apple | 密码: 123457 |
| 内网LAN | 192.168.1.118 | 22 | apple | 密码: 123457 |

**别名**: ubuntu, 备用节点

### Mini - Mac mini (单位)

| 连接方式 | 地址 | 端口 | 用户 | 认证 |
|---------|------|------|------|------|
| ZeroTier | 10.147.17.244 | 22 | agent | 密钥 |

**别名**: mini, macmini, agent

**说明**: 只能通过 ZeroTier 访问

### iStoreOS - 软路由

| 连接方式 | 地址 | 端口 | 用户 | 认证 |
|---------|------|------|------|------|
| 外网WAN | ximi.space | 9998 | root | 密码: Sy135790@ |
| 内网LAN | 192.168.1.1 | 22 | root | 密码: Sy135790@ |

**别名**: istore, 软路由, router, 爱速

### 飞牛 (fnos) - 威联通/其他

| 连接方式 | 地址 | 端口 | 用户 | 认证 |
|---------|------|------|------|------|
| 外网WAN | (待配置) | 22 | - | - |
| 内网LAN | (待配置) | 22 | - | - |

**别名**: fnos, 飞牛, 威联通

## 连接方式选择

默认优先使用**内网/ZeroTier**（更快更稳定），如失败则回退到外网。

### SSH 配置示例

```bash
# 群晖外网
ssh -i ~/.ssh/id_rsa_maintenance syzl8512@ximi.space -p 2211

# 群晖内网
ssh -i ~/.ssh/id_rsa_maintenance syzl8512@192.168.1.4

# 小爱外网
sshpass -p '123457' ssh -o StrictHostKeyChecking=no apple@ximi.space -p 2221
```

## 使用示例

### 列出所有服务器

```
服务器列表
```

### SSH 连接到群晖

```
连接到群晖
```

### 在服务器上执行命令

```
在群晖上执行 df -h
在xiaoai上执行 ps aux | grep openclaw
在istore上执行 ls -la /etc/config
```

### 检查服务器状态

```
检查 群晖 状态
检查 小爱 健康
```

## 实现逻辑

当用户请求连接服务器或执行命令时：

1. **确定服务器**：根据用户输入匹配服务器别名
2. **选择连接方式**：
   - 默认尝试内网/ZeroTier（192.168.1.x / 10.147.17.x）
   - 如连接失败，回退到外网（ximi.space）
3. **构建命令**：
   - 密钥连接：`ssh -i ~/.ssh/id_rsa_maintenance -o StrictHostKeyChecking=no user@host -p port`
   - 密码连接：`sshpass -p 'password' ssh -o StrictHostKeyChecking=no user@host -p port`
4. **执行并返回结果**

## 配置存储

服务器配置保存在：`~/.openclaw/skill-data/server-manager/servers.json`
