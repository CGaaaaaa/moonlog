// 简单文本格式化器构造函数
pub fn SimpleFormatter::new(
  include_timestamp : Bool,
  include_module : Bool
) -> SimpleFormatter {
  { include_timestamp, include_module }
}

// SimpleFormatter 格式化函数
pub fn format_simple(self : SimpleFormatter, entry : LogEntry) -> String {
  let parts = Array::new()
  
  // 添加时间戳
  if self.include_timestamp {
    parts.push(format_timestamp(entry.timestamp))
  }
  
  // 添加日志级别
  parts.push("[" + entry.level.to_string() + "]")
  
  // 添加模块名
  if self.include_module && entry.module_name != "default" {
    parts.push("(" + entry.module_name + ")")
  }
  
  // 添加消息
  parts.push(entry.message)
  
  // 添加结构化字段
  if entry.fields.length() > 0 {
    let field_strings = Array::new()
    for field in entry.fields {
      field_strings.push(field.key + "=" + field.value.to_string())
    }
    parts.push("{" + join_strings(field_strings, ", ") + "}")
  }
  
  join_strings(parts, " ")
}

// JSON 格式化器
pub struct JsonFormatter {
  pretty : Bool
} derive(Show)

pub fn JsonFormatter::new(pretty : Bool) -> JsonFormatter {
  { pretty, }
}

// JsonFormatter 格式化函数
pub fn format_json(self : JsonFormatter, entry : LogEntry) -> String {
  let json_parts = Array::new()
  
  json_parts.push("\"timestamp\":" + entry.timestamp.to_string())
  json_parts.push("\"level\":\"" + entry.level.to_string() + "\"")
  json_parts.push("\"message\":\"" + escape_json_string(entry.message) + "\"")
  json_parts.push("\"module\":\"" + entry.module_name + "\"")
  
  // 添加结构化字段
  if entry.fields.length() > 0 {
    let fields_json = Array::new()
    for field in entry.fields {
      let value_str = match field.value {
        String(s) => "\"" + escape_json_string(s) + "\""
        Int(i) => i.to_string()
        Int64(l) => l.to_string()
        Double(d) => d.to_string()
        Bool(b) => if b { "true" } else { "false" }
      }
      fields_json.push("\"" + field.key + "\":" + value_str)
    }
    json_parts.push("\"fields\":{" + join_strings(fields_json, ",") + "}")
  }
  
  if self.pretty {
    "{\n  " + join_strings(json_parts, ",\n  ") + "\n}"
  } else {
    "{" + join_strings(json_parts, ",") + "}"
  }
}

// 彩色控制台格式化器
pub struct ColorFormatter {
  use_colors : Bool
} derive(Show)

pub fn ColorFormatter::new(use_colors : Bool) -> ColorFormatter {
  { use_colors, }
}

// ColorFormatter 格式化函数
pub fn format_color(self : ColorFormatter, entry : LogEntry) -> String {
  let level_str = if self.use_colors {
    colorize_level(entry.level)
  } else {
    "[" + entry.level.to_string() + "]"
  }
  
  let timestamp = format_timestamp(entry.timestamp)
  let module_part = if entry.module_name != "default" {
    " (" + entry.module_name + ")"
  } else {
    ""
  }
  
  let fields_part = if entry.fields.length() > 0 {
    let field_strings = Array::new()
    for field in entry.fields {
      field_strings.push(field.key + "=" + field.value.to_string())
    }
    " {" + join_strings(field_strings, ", ") + "}"
  } else {
    ""
  }
  
  timestamp + " " + level_str + module_part + " " + entry.message + fields_part
}

// 辅助函数：格式化时间戳
fn format_timestamp(timestamp : Int64) -> String {
  format_timestamp_iso(timestamp)
}

// 使用utils.mbt中的escape_json_string实现

// 辅助函数：为日志级别添加颜色
fn colorize_level(level : LogLevel) -> String {
  match level {
    Trace => "\u001b[37m[TRACE]\u001b[0m"  // 白色
    Debug => "\u001b[36m[DEBUG]\u001b[0m"  // 青色
    Info => "\u001b[32m[INFO]\u001b[0m"    // 绿色
    Warn => "\u001b[33m[WARN]\u001b[0m"    // 黄色
    Error => "\u001b[31m[ERROR]\u001b[0m"  // 红色
    Fatal => "\u001b[35m[FATAL]\u001b[0m"  // 紫色
  }
}

// 辅助函数：连接字符串数组
fn join_strings(arr : Array[String], separator : String) -> String {
  if arr.length() == 0 {
    return ""
  }
  
  let mut result = arr[0]
  for i = 1; i < arr.length(); i = i + 1 {
    result = result + separator + arr[i]
  }
  result
}