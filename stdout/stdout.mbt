// StdoutAppender - 标准输出日志 Appender
// 这是一个简单的实现，只依赖基础的 println 函数

// 标准输出 Appender
pub struct StdoutAppender {
  show_timestamp : Bool
  show_module : Bool
}

impl @moonlog.Appender for StdoutAppender with append(self, entry : @moonlog.LogEntry) {
  let parts : Array[String] = Array::new()
  
  // 添加时间戳（如果启用）
  if self.show_timestamp {
    parts.push(entry.timestamp.to_string())
  }
  
  // 添加日志级别
  parts.push("[" + entry.level.to_string() + "]")
  
  // 添加模块名（如果启用）
  if self.show_module {
    parts.push("[" + entry.module_name + "]")
  }
  
  // 添加消息
  parts.push(entry.message)
  
  // 构建基础日志行
  let base_line = parts.join(" ")
  
  // 添加字段（如果有）
  if entry.fields.length() > 0 {
    let field_strings = entry.fields.map(fn(f) { f.to_string() })
    let fields_str = field_strings.join(", ")
    println(base_line + " {" + fields_str + "}")
  } else {
    println(base_line)
  }
}

// 便捷构造函数
pub fn StdoutAppender::new() -> StdoutAppender {
  { show_timestamp: true, show_module: true }
}

pub fn StdoutAppender::with_config(show_timestamp : Bool, show_module : Bool) -> StdoutAppender {
  { show_timestamp, show_module }
} 