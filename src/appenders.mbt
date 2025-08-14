// Appender 构造函数和辅助函数

///|
pub fn ConsoleAppender::new(formatter : SimpleFormatter) -> ConsoleAppender {
  { formatter: Simple(formatter) }
}

// 暂时简化，只支持SimpleFormatter
// pub fn ConsoleAppender::new_with_color(color_formatter : ColorFormatter) -> ConsoleAppender {
//   { formatter: Color(color_formatter) }
// }

// pub fn ConsoleAppender::new_with_json(json_formatter : JsonFormatter) -> ConsoleAppender {
//   { formatter: Json(json_formatter) }
// }

///|
pub fn FileAppender::new(
  file_path : String,
  formatter : SimpleFormatter,
  max_file_size : Int64,
  max_backup_files : Int,
) -> FileAppender {
  { file_path, formatter: Simple(formatter), max_file_size, max_backup_files }
}

// 暂时简化，只支持SimpleFormatter
// pub fn FileAppender::new_with_json(
//   file_path : String,
//   json_formatter : JsonFormatter,
//   max_file_size : Int64,
//   max_backup_files : Int
// ) -> FileAppender {
//   { file_path, formatter: Json(json_formatter), max_file_size, max_backup_files }
// }

// Multi Appender helper functions

///|
pub fn create_multi_appender() -> AnyAppender {
  Multi(Array::new())
}

///|
pub fn add_to_multi_appender(
  multi : AnyAppender,
  appender : AnyAppender,
) -> AnyAppender {
  match multi {
    Multi(appenders) => {
      appenders.push(appender)
      Multi(appenders)
    }
    _ => multi // 如果不是Multi类型，保持不变
  }
}

// Async Appender helper functions

///|
pub fn create_async_appender(
  inner : AnyAppender,
  max_buffer_size : Int,
) -> AnyAppender {
  Async(inner, Array::new(), max_buffer_size)
}

///|
pub fn flush_async_appender(async_appender : AnyAppender) -> Unit {
  match async_appender {
    Async(inner, buffer, _) => {
      for entry in buffer {
        inner.append(entry)
      }
      buffer.clear()
    }
    _ => () // 如果不是Async类型，不做任何操作
  }
}

// Filtered Appender helper functions

///|
pub fn create_filtered_appender(
  inner : AnyAppender,
  min_level : LogLevel,
) -> AnyAppender {
  Filtered(inner, min_level)
}
