# MoonLog

**Lightweight Logging Library for MoonLang**

English | [中文](README_zh_CN.md)

MoonLog is a trait-based logging library that provides core interfaces and an extensible Appender system.

## ✨ Core Features

- **🔧 Trait-Based Design**: Built on `Appender` trait, supports user-defined implementations
- **⚡ Zero Dependencies**: Core library is completely independent
- **📊 Structured Logging**: Supports key-value field pairs
- **🌐 Global Configuration**: Provides global Logger management
- **🎯 Interface Focused**: Main package provides only core interfaces, implementations can be separated into different packages

## 🚀 Quick Start

### Run Demo
```bash
# View basic usage demonstration
moon run demo

# View complete documentation
cd demo && cat README.md
```

## 📁 Package Structure

```
moonlog/                    # Single package structure (recommended for dedicated libraries)
├── core.mbt               # Core types, traits and implementations
├── test_core.mbt          # Core functionality tests
├── test_global.mbt        # Global functionality tests
├── demo/                  # Usage examples and demonstrations
│   ├── main.mbt          # Basic demo
│   ├── advanced.mbt      # Advanced configuration examples
│   ├── moon.pkg.json     # Demo package configuration
│   └── README.md         # Demo documentation
├── moon.pkg.json          # Package configuration
├── moon.mod.json          # Project configuration
└── README.md              # Documentation
```

### 📋 **Best Practices for Package Structure**

**For dedicated libraries (like logging libraries):**
- ✅ **Flat Structure**: Simple and direct, suitable for single-purpose libraries
- ✅ **File Separation**: Separate files by functionality (core, tests, etc.)
- ✅ **Clear Naming**: File names clearly express their purpose

**For complex applications or multi-module projects:**
```
project/
├── lib/                   # Core library
├── examples/              # Example code
├── tools/                 # Utility programs
└── moon.mod.json          # Workspace configuration
```

## 🚀 Usage

### Basic Usage

```moonbit
// Create Appender
let appender = StdoutAppender::new()

// Create Logger
let logger = Logger::new(LogLevel::Info, "my_app")
  .add_appender(appender)

// Set as global logger
set_global_logger(logger)

// Use global logging functions
info("Application started")
warn("This is a warning")
error("An error occurred")
```

### Structured Logging

```moonbit
let fields = [
  field_str("user", "alice"),
  field_int("count", 42),
  field_bool("success", true)
]

info_with_fields("User operation completed", fields)
```

### Custom Appender

```moonbit
// Implement custom Appender
struct MyAppender { }

impl Appender for MyAppender with append(self, entry) {
  // Custom log processing logic
  println("Custom: " + entry.message)
}

// Use custom Appender
let my_appender = MyAppender { }
let logger = Logger::new(LogLevel::Info, "custom")
  .add_appender(my_appender)
```

## 📚 API Documentation

### Core Types

- `LogLevel`: Log level enumeration (Trace, Debug, Info, Warn, Error, Fatal)
- `LogEntry`: Log entry structure
- `LogField`: Structured field
- `Logger`: Logger

### Core Trait

- `Appender`: Log output interface, allows user-defined implementations

### Global Functions

**Basic Logging:**
- `trace(message)`, `debug(message)`, `info(message)`
- `warn(message)`, `error(message)`, `fatal(message)`

**Structured Logging:**
- `trace_with_fields(message, fields)`, `debug_with_fields(message, fields)`
- `info_with_fields(message, fields)`, `warn_with_fields(message, fields)`
- `error_with_fields(message, fields)`, `fatal_with_fields(message, fields)`

**Field Construction:**
- `field_str(key, value)`, `field_int(key, value)`
- `field_double(key, value)`, `field_bool(key, value)`

**Global Configuration:**
- `get_global_logger()`, `set_global_logger(logger)`
- `set_global_level(level)`

## 🔧 Extensibility

This interface allows for various different implementations:

- **Standard Output**: `StdoutAppender` (example implementation provided in this package)
- **File Output**: `FileAppender` can be implemented in a separate package
- **Remote Collection**: `OpenTelemetryAppender` can be implemented in a separate package
- **Custom Format**: Users can implement custom `Appender`

## 🧪 Running Tests and Building

```bash
# Run all tests
moon test

# Build library
moon build

# Format code
moon fmt

# Check code
moon check
```

## 📋 Generate Interface Documentation

```bash
# Generate latest API interface description
moon info
```

## 🏗️ Design Principles

1. **Core Focus**: Main package provides only core interfaces and basic implementations
2. **Separation of Concerns**: Different types of Appenders should be separated into different packages
3. **User Extension**: Support user-defined implementations through `Appender` trait
4. **Zero Dependencies**: Core library does not depend on external libraries

## 📄 License

MIT License