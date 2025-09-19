// 核心功能测试

test "LogLevel to_int conversion" {
  inspect!(LogLevel::Trace.to_int(), content="0")
  inspect!(LogLevel::Debug.to_int(), content="1") 
  inspect!(LogLevel::Info.to_int(), content="2")
  inspect!(LogLevel::Warn.to_int(), content="3")
  inspect!(LogLevel::Error.to_int(), content="4")
  inspect!(LogLevel::Fatal.to_int(), content="5")
}

test "LogLevel to_string" {
  inspect!(LogLevel::Trace.to_string(), content="TRACE")
  inspect!(LogLevel::Debug.to_string(), content="DEBUG")
  inspect!(LogLevel::Info.to_string(), content="INFO") 
  inspect!(LogLevel::Warn.to_string(), content="WARN")
  inspect!(LogLevel::Error.to_string(), content="ERROR")
  inspect!(LogLevel::Fatal.to_string(), content="FATAL")
}

test "LogValue to_string" {
  let str_val = LogValue::String("test")
  let int_val = LogValue::Int(42)
  let bool_val = LogValue::Bool(true)
  let double_val = LogValue::Double(3.14)
  
  inspect!(str_val.to_string(), content="test")
  inspect!(int_val.to_string(), content="42")
  inspect!(bool_val.to_string(), content="true")
  inspect!(double_val.to_string(), content="3.14")
}

test "field constructor functions" {
  let str_field = field_str("name", "alice")
  let int_field = field_int("count", 10)
  let bool_field = field_bool("enabled", false)
  let double_field = field_double("ratio", 0.75)
  
  inspect!(str_field.key, content="name")
  inspect!(str_field.to_string(), content="name=alice")
  inspect!(int_field.key, content="count")
  inspect!(int_field.to_string(), content="count=10")
  inspect!(bool_field.key, content="enabled")
  inspect!(bool_field.to_string(), content="enabled=false")
  inspect!(double_field.key, content="ratio")
  inspect!(double_field.to_string(), content="ratio=0.75")
}

test "LogEntry creation" {
  let fields = [field_str("user", "bob"), field_int("session", 123)]
  let entry = LogEntry::new(LogLevel::Info, "test message", fields, "test_module")
  
  inspect!(entry.message, content="test message")
  inspect!(entry.module_name, content="test_module")
  inspect!(entry.fields.length(), content="2")
} 