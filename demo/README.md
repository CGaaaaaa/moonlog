# 🌙 MoonLog Demo

这个demo展示了MoonLog日志库的各种使用方式和最佳实践。

## 🚀 运行Demo

```bash
# 在项目根目录执行
moon run demo
```

**注意：** 当前demo使用默认的空Logger（没有配置Appender），所以不会看到实际的日志输出。这演示了moonlog的全局接口调用，但需要配置Appender才能看到日志内容。

## 📋 Demo内容

### 1. 基础全局日志函数 📝
演示最简单的日志使用方式：
```moonbit
@moonlog.info("应用启动成功")
@moonlog.warn("这是一个警告信息")  
@moonlog.error("模拟错误信息")
```

### 2. 结构化日志 🏗️
展示如何添加结构化字段：
```moonbit
@moonlog.info_with_fields("用户登录", [
  @moonlog.field_str("user", "alice"),
  @moonlog.field_int("user_id", 12345)
])
```

### 3. 动态配置 ⚙️
演示运行时调整日志级别：
```moonbit
@moonlog.set_global_level(@moonlog.LogLevel::Debug)
@moonlog.debug("现在debug信息会显示")
```

### 4. 模块化Logger 🎯
展示为不同模块创建专用Logger：
```moonbit
let auth_logger = @moonlog.Logger::new(@moonlog.LogLevel::Info, "auth")
let db_logger = @moonlog.Logger::new(@moonlog.LogLevel::Debug, "database")
```

### 5. 全局Logger替换 🔄
演示如何替换全局日志实现：
```moonbit
let custom_global = @moonlog.Logger::new(@moonlog.LogLevel::Trace, "app")
  .add_appender(@moonlog.StdoutAppender::new(true, true))
@moonlog.set_global_logger(custom_global)
```

### 6. 实际应用场景 🚀
包含完整的应用场景演示：
- Web服务器启动流程
- HTTP请求处理
- 错误处理和恢复

## 🎯 学习要点

1. **简单易用**：全局函数让日志记录变得极其简单
2. **结构化支持**：丰富的字段类型支持复杂的日志需求
3. **动态配置**：运行时可以灵活调整日志行为
4. **模块化设计**：不同模块可以有不同的日志配置
5. **性能优化**：零成本抽象，不影响程序性能

## 🔧 高级配置

查看 `advanced.mbt` 文件了解完整的Logger配置示例。在实际项目中，你可以：

1. **配置带输出的Logger:**
   ```moonbit
   let logger = Logger::new(LogLevel::Debug, "myapp")
     .add_appender(StdoutAppender::with_config(true, true))
   set_global_logger(logger)
   ```

2. **创建模块专用Logger:**
   ```moonbit
   let auth_logger = Logger::new(LogLevel::Info, "auth")
   let db_logger = Logger::new(LogLevel::Debug, "database")
   ```

3. **动态调整日志级别:**
   ```moonbit
   set_global_level(LogLevel::Debug)  // 显示debug信息
   set_global_level(LogLevel::Error)  // 只显示错误
   ```

## 📚 更多信息

查看主目录的README.md了解完整的API文档和设计理念。 