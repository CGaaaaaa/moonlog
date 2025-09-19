# MoonLog

**轻量级 MoonLang 日志库**

MoonLog 是一个基于 trait 设计的日志库，提供核心接口和可扩展的 Appender 系统。

## ✨ 核心特性

- **🔧 Trait 设计**: 基于 `Appender` trait，支持用户自定义实现
- **⚡ 零依赖**: 核心库完全独立
- **📊 结构化日志**: 支持键值对字段
- **🌐 全局设置**: 提供全局 Logger 管理
- **🎯 专注接口**: 主包只提供核心接口，具体实现可分离到不同包

## 📁 架构设计

```
moonlog/                    # 主包 - 核心接口和 trait 定义
├── core.mbt               # 核心类型和 trait
├── stdout_appender.mbt    # StdoutAppender 示例实现
├── test_*.mbt            # 测试文件
└── demo_package/         # 独立的示例包
    ├── moon.pkg.json     # 导入主包
    └── demo.mbt          # 使用示例
```

## 🚀 快速开始

### 基础使用

```moonbit
// 创建 Appender
let appender = StdoutAppender::new()

// 创建 Logger
let logger = Logger::new(LogLevel::Info, "my_app")
  .add_appender(appender)

// 设置为全局 logger
set_global_logger(logger)

// 使用全局日志函数
info("应用启动")
warn("这是一条警告")
error("发生错误")
```

### 结构化日志

```moonbit
let fields = [
  field_str("user", "alice"),
  field_int("count", 42),
  field_bool("success", true)
]

info_with_fields("用户操作完成", fields)
```

### 自定义 Appender

```moonbit
// 实现自定义 Appender
struct MyAppender { }

impl Appender for MyAppender with append(self, entry) {
  // 自定义日志处理逻辑
  println("Custom: " + entry.message)
}

// 使用自定义 Appender
let my_appender = MyAppender { }
let logger = Logger::new(LogLevel::Info, "custom")
  .add_appender(my_appender)
```

## 📚 API 文档

### 核心类型

- `LogLevel`: 日志级别枚举 (Trace, Debug, Info, Warn, Error, Fatal)
- `LogEntry`: 日志条目结构
- `LogField`: 结构化字段
- `Logger`: 日志记录器

### 核心 Trait

- `Appender`: 日志输出器接口，允许用户自定义实现

### 全局函数

**基础日志记录:**
- `trace(message)`, `debug(message)`, `info(message)`
- `warn(message)`, `error(message)`, `fatal(message)`

**结构化日志记录:**
- `trace_with_fields(message, fields)`, `debug_with_fields(message, fields)`
- `info_with_fields(message, fields)`, `warn_with_fields(message, fields)`
- `error_with_fields(message, fields)`, `fatal_with_fields(message, fields)`

**字段构造:**
- `field_str(key, value)`, `field_int(key, value)`
- `field_double(key, value)`, `field_bool(key, value)`

**全局设置:**
- `get_global_logger()`, `set_global_logger(logger)`
- `set_global_level(level)`

## 🔧 扩展性

该接口允许多种不同的实现：

- **标准输出**: `StdoutAppender` (本包提供示例实现)
- **文件输出**: 可在独立包中实现 `FileAppender`
- **远程收集**: 可在独立包中实现 `OpenTelemetryAppender`
- **自定义格式**: 用户可实现自定义的 `Appender`

## 🧪 运行示例

```bash
# 构建并运行示例
cd demo_package
moon run main
```

## 📋 生成接口文档

```bash
# 生成最新的 API 接口描述
moon info
```

## 🏗️ 设计原则

1. **核心专注**: 主包只提供核心接口和基础实现
2. **职责分离**: 不同类型的 Appender 应分离到不同包
3. **用户扩展**: 通过 `Appender` trait 支持用户自定义实现
4. **零依赖**: 核心库不依赖外部库

## 📄 许可证

MIT License