# 📦 安装指南

## 环境要求

- macOS（Linux 类似）
- OpenClaw 已安装并运行
- 有 LaunchAgent 权限

## 安装步骤

### 步骤 1：复制脚本

```bash
# 创建维护目录（如果不存在）
mkdir -p /Users/mia/maintenance/

# 复制 Sentinel 脚本
cp openclaw-sentinel.sh /Users/mia/maintenance/

# 赋予执行权限
chmod +x /Users/mia/maintenance/openclaw-sentinel.sh
```

### 步骤 2：配置 LaunchAgent

```bash
# 复制 LaunchAgent 配置
cp ai.openclaw.sentinel.plist ~/Library/LaunchAgents/

# 加载服务（开机自启）
launchctl load ~/Library/LaunchAgents/ai.openclaw.sentinel.plist

# 验证加载成功
launchctl list | grep sentinel
```

### 步骤 3：创建必要目录

```bash
# 创建备份目录
mkdir -p ~/.openclaw/backups

# 创建日志目录
mkdir -p ~/.openclaw/logs
```

### 步骤 4：验证安装

```bash
# 检查进程是否运行
ps aux | grep sentinel

# 查看日志
tail -f ~/.openclaw/logs/sentinel.log
```

应看到类似输出：
```
[2026-03-01 12:00:00] Sentinel 启动，监控模式已开启...
```

## 卸载

```bash
# 停止服务
launchctl unload ~/Library/LaunchAgents/ai.openclaw.sentinel.plist

# 删除脚本
rm /Users/mia/maintenance/openclaw-sentinel.sh

# 删除配置
rm ~/Library/LaunchAgents/ai.openclaw.sentinel.plist
```

## 多机器部署

如果有多台机器，可以打包部署：

```bash
# 在每台机器上执行
scp openclaw-sentinel.sh user@host:/Users/mia/maintenance/
scp ai.openclaw.sentinel.plist user@host:~/Library/LaunchAgents/
ssh user@host "launchctl load ~/Library/LaunchAgents/ai.openclaw.sentinel.plist"
```

---

*安装指南 - 最后更新：2026-03-01*
