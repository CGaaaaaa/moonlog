// 核心功能测试

test "LogLevel to_int conversion" {
  inspect(LogLevel::Trace.to_int(), content="0")
  inspect(LogLevel::Debug.to_int(), content="1")
  inspect(LogLevel::Info.to_int(), content="2")
  inspect(LogLevel::Warn.to_int(), content="3")
  inspect(LogLevel::Error.to_int(), content="4")
  inspect(LogLevel::Fatal.to_int(), content="5")
}

test "LogLevel to_string" {
  inspect(LogLevel::Trace.to_string(), content="TRACE")
  inspect(LogLevel::Debug.to_string(), content="DEBUG")
  inspect(LogLevel::Info.to_string(), content="INFO") 
  inspect(LogLevel::Warn.to_string(), content="WARN")
  inspect(LogLevel::Error.to_string(), content="ERROR")
  inspect(LogLevel::Fatal.to_string(), content="FATAL")
}

test "LogValue to_string" {
  let str_val = LogValue::String("test")
  let int_val = LogValue::Int(42)
  let bool_val = LogValue::Bool(true)
  let double_val = LogValue::Double(3.14)
  
  inspect(str_val.to_string(), content="test")
  inspect(int_val.to_string(), content="42")
  inspect(bool_val.to_string(), content="true")
  inspect(double_val.to_string(), content="3.14")
}

test "field constructor functions" {
  let str_field = field_str("name", "alice")
  let int_field = field_int("count", 10)
  let bool_field = field_bool("enabled", false)
  let double_field = field_double("ratio", 0.75)
  
  inspect(str_field.key, content="name")
  inspect(str_field.to_string(), content="name=alice")
  inspect(int_field.key, content="count")
  inspect(int_field.to_string(), content="count=10")
  inspect(bool_field.key, content="enabled")
  inspect(bool_field.to_string(), content="enabled=false")
  inspect(double_field.key, content="ratio")
  inspect(double_field.to_string(), content="ratio=0.75")
}

test "LogEntry creation" {
  let fields = [field_str("key1", "value1"), field_int("key2", 42)]
  let entry = LogEntry::new(LogLevel::Info, "test message", fields, "test_module")
  
  inspect(entry.message, content="test message")
  inspect(entry.module_name, content="test_module")
  inspect(entry.fields.length(), content="2")
}

// StdoutAppender 测试
test "StdoutAppender creation" {
  let appender = StdoutAppender::new()
  inspect(appender.show_timestamp, content="true")
  inspect(appender.show_module, content="true")
  
  let custom_appender = StdoutAppender::with_config(false, true)
  inspect(custom_appender.show_timestamp, content="false")
  inspect(custom_appender.show_module, content="true")
}

test "Integration - Logger with StdoutAppender" {
  let appender = StdoutAppender::new()
  let logger = Logger::new(LogLevel::Info, "test_app")
    .add_appender(appender)
  
  // 设置为全局 logger
  set_global_logger(logger)
  
  // 测试全局日志函数
  info("测试消息")
  warn_with_fields("带字段的警告", [field_str("user", "alice"), field_int("count", 3)])
} 