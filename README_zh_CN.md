# MoonLog ✨

[English](README.md) | **简体中文**

一个为 MoonBit 语言设计的**生产就绪**、灵活、高效的日志库。

## 🏆 **完善完成！**

经过全面的优化和完善，MoonLog 现在是一个功能完整、可立即使用的 MoonBit 日志库。

## ✨ 核心特性

- 🚀 **高性能**: 优化的日志记录性能，支持异步输出
- 📝 **结构化日志**: 完整支持多种数据类型的键值对字段（String, Int, Bool, Double等）
- 🎨 **多种格式化器**: 简单文本、JSON、彩色输出（可扩展）
- 📤 **灵活的输出器**: 控制台、文件、多重输出、异步输出、过滤输出
- 🔧 **强大的配置系统**: 便捷的一键配置方法
- 🌐 **便捷的全局接口**: 提供简化和结构化两种API风格
- 📦 **模块化设计**: 清晰的模块分离，易于扩展和维护
- 🔄 **类型安全**: 充分利用MoonBit的类型系统确保安全性
- ⚡ **即插即用**: 无需配置即可开始使用

## 安装

### 使用 moon 包管理器

将 MoonLog 添加到您的项目依赖中：

```json
{
  "deps": {
    "moonlog": "path/to/moonlog"
  }
}
```

## 快速开始

### 基本使用

```moonbit
// 导入库
import moonlog/global

fn main() {
  // 使用全局日志接口
  info_msg("应用程序启动")
  warn_msg("这是一个警告")
  error_msg("这是一个错误")
}
```

### 结构化日志

```moonbit
// 使用字段构建器
info("用户登录", [
  field_str("user_id", "12345"),
  field_str("action", "login"),
  field_bool("success", true)
])

// 或者创建自己的Logger实例
let logger = Logger::new(LogLevel::Info, "my_module")
  .add_console_appender(
    ConsoleAppender::new(
      SimpleFormatter::new(true, true)
    )
  )
logger.log(LogLevel::Info, "处理请求", [field_str("request_id", "req-789")])
```

### 格式化日志

```moonbit
// 支持 {} 占位符的格式化
infof("用户 {} 第 {} 次登录", ["Alice", "3"])
errorf("操作失败: {}, 错误代码: {}", ["timeout", "500"])
```

### 自定义日志器

```moonbit
// 创建模块专用的日志器
let logger = Logger::new(LogLevel::Info, "AuthModule")
  .add_console_appender(
    ConsoleAppender::new(
      SimpleFormatter::new(include_timestamp=true, include_module=true)
    )
  )

logger.info("认证模块初始化", [
  field_str("version", "1.0.0"),
  field_bool("enabled", true)
])
```

### 配置系统

```moonbit
// 配置控制台Logger
configure_console_logger(
  level=LogLevel::Debug,
  include_timestamp=true,
  include_module=true,
  use_colors=true
)

// 配置文件Logger
configure_file_logger(
  level=LogLevel::Info,
  file_path="logs/app.log",
  max_file_size=1024L * 1024L,  // 1MB
  max_backup_files=5,
  use_json=false
)
```

### 完整示例

```moonbit
import moonlog/global

fn main() {
  // 配置全局日志系统
  configure_console_logger(
    level=LogLevel::Debug,
    include_timestamp=true,
    include_module=true,
    use_colors=true
  )
  
  // 应用启动日志
  info_msg("应用程序启动")
  
  // 业务逻辑中的结构化日志
  info("用户操作", [
    field_str("user_id", "user123"),
    field_str("operation", "login"),
    field_bool("success", true),
    field_int("attempt", 1)
  ])
  
  // 错误处理
  error("数据库连接失败", [
    field_str("database", "users"),
    field_str("error", "connection timeout"),
    field_int("retry_count", 3)
  ])
  
  // 格式化日志
  infof("处理了 {} 个请求，耗时 {} 毫秒", ["150", "250"])
  
  // 使用模块专用日志器
  let auth_logger = Logger::new(LogLevel::Debug, "Authentication")
    .add_console_appender(
      ConsoleAppender::new(
        SimpleFormatter::new(true, true)
      )
    )
  
  auth_logger.log(LogLevel::Debug, "JWT令牌验证", [
    field_str("token_type", "Bearer"),
    field_bool("valid", true)
  ])
  
  info_msg("应用程序正常关闭")
}
```

## 日志级别

- `Trace`: 最详细的日志信息
- `Debug`: 调试信息
- `Info`: 一般信息
- `Warn`: 警告信息
- `Error`: 错误信息
- `Fatal`: 致命错误

## 格式化器

### SimpleFormatter
基本的文本格式化器，支持时间戳和模块名配置。

### JsonFormatter
JSON 格式输出，支持美化输出。

### ColorFormatter
彩色控制台输出，不同日志级别使用不同颜色。

## 输出器

### ConsoleAppender
输出到控制台。

### FileAppender
输出到文件，支持文件轮转。

### MultiAppender
同时输出到多个目标。

### AsyncAppender
异步输出，提高性能。

### FilteredAppender
带过滤功能的输出器。

## API 文档

### 全局函数 (import moonlog/global)

#### 简化接口
- `info_msg(message)`: 记录简单信息日志
- `debug_msg(message)`: 记录简单调试日志
- `warn_msg(message)`: 记录简单警告日志
- `error_msg(message)`: 记录简单错误日志
- `trace_msg(message)`: 记录简单跟踪日志
- `fatal_msg(message)`: 记录简单致命错误日志

#### 结构化日志
- `info(message, fields)`: 记录结构化信息日志
- `debug(message, fields)`: 记录结构化调试日志
- `warn(message, fields)`: 记录结构化警告日志
- `error(message, fields)`: 记录结构化错误日志
- `trace(message, fields)`: 记录结构化跟踪日志
- `fatal(message, fields)`: 记录结构化致命错误日志

#### 格式化函数
- `infof(template, args)`: 格式化信息日志
- `errorf(template, args)`: 格式化错误日志
- `warnf(template, args)`: 格式化警告日志
- `debugf(template, args)`: 格式化调试日志

#### 字段构建器 (import moonlog/types)
- `field_str(key, value)`: 创建字符串字段
- `field_int(key, value)`: 创建整数字段
- `field_bool(key, value)`: 创建布尔字段
- `field_double(key, value)`: 创建浮点数字段
- `field_int64(key, value)`: 创建64位整数字段

#### 配置函数
- `configure_console_logger(level, include_timestamp, include_module, use_colors)`: 配置控制台Logger
- `configure_file_logger(level, file_path, max_file_size, max_backup_files, use_json)`: 配置文件Logger
- `set_global_level(level)`: 设置全局日志级别
- `add_global_console_appender(formatter)`: 添加全局控制台输出器
- `add_global_file_appender(file_path, formatter, max_file_size, max_backup_files)`: 添加全局文件输出器

### Logger 类 (import moonlog/logger)

- `Logger::new(min_level, module_name)`: 创建新的Logger实例
- `add_appender(logger, appender)`: 添加输出器
- `add_console_appender(logger, appender)`: 添加控制台输出器
- `add_file_appender(logger, appender)`: 添加文件输出器
- `set_level(logger, level)`: 设置日志级别
- `set_module(logger, module_name)`: 设置模块名

### Logger 方法

- `logger.log(level, message, fields)`: 记录日志
- `logger.info(message, fields)`: 记录信息日志
- `logger.debug(message, fields)`: 记录调试日志
- `logger.warn(message, fields)`: 记录警告日志
- `logger.error(message, fields)`: 记录错误日志
- `logger.infof(template, args)`: 格式化信息日志
- `logger.debugf(template, args)`: 格式化调试日志

### 输出器和格式化器

- `ConsoleAppender::new(formatter)`: 创建控制台输出器
- `FileAppender::new(file_path, formatter, max_file_size, max_backup_files)`: 创建文件输出器
- `SimpleFormatter::new(include_timestamp, include_module)`: 创建简单格式化器
- `JsonFormatter::new(pretty)`: 创建JSON格式化器
- `ColorFormatter::new(use_colors)`: 创建彩色格式化器

## 演示

查看 `src/examples.mbt` 文件来了解 MoonLog 的完整功能演示，包括：

- 基本全局日志记录
- 全局Logger配置
- 自定义Logger实例
- 不同格式化器的使用
- 结构化日志
- 日志级别过滤

演示包含了所有主要功能的使用方法，包括基础日志、结构化日志、格式化日志和自定义日志器。

## 项目结构

```
moonlog/
├── src/
│   ├── types.mbt          # 核心类型定义（LogLevel, LogValue, LogField等）
│   ├── logger.mbt         # Logger 实现，支持多种输出器
│   ├── global.mbt         # 全局日志器和便捷API ⭐
│   ├── formatters.mbt     # 多种格式化器（Simple, JSON, Color）
│   ├── appenders.mbt      # 输出器辅助函数
│   ├── utils.mbt          # 实用工具函数（时间戳、文件I/O等）
│   ├── config.mbt         # 配置系统
│   ├── examples.mbt       # 详细使用示例
│   ├── demo.mbt           # 快速演示
│   └── tests.mbt          # 功能测试

├── moon.pkg.json          # 包配置
└── README.md              # 文档
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License