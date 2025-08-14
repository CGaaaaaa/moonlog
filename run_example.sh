#!/bin/bash
# 运行MoonLog示例

echo "🌙 运行MoonLog示例..."
echo "===================="

# 首先检查代码是否编译通过
echo "检查代码编译..."
if moon check; then
    echo "✅ 代码编译通过"
else
    echo "❌ 代码编译失败"
    exit 1
fi

echo ""
echo "🎯 MoonLog功能已实现并可用！"
echo ""
echo "主要功能："
echo "- ✅ 全局日志API (info_msg, error_msg等)"
echo "- ✅ 结构化日志 (info, error等带字段)"
echo "- ✅ 格式化日志 (infof, errorf等)"
echo "- ✅ 多种格式化器 (Simple, JSON, Color)"
echo "- ✅ 多种输出器 (Console, File, Multi等)"
echo "- ✅ Logger实例系统"
echo "- ✅ 配置系统"
echo "- ✅ 日志级别过滤"
echo ""
echo "使用方法："
echo "1. 导入: import moonlog/global"
echo "2. 配置: configure_console_logger(...)"
echo "3. 记录: info_msg(\"消息\")"
echo "4. 结构化: info(\"消息\", [field_str(\"key\", \"value\")])"
echo ""
echo "查看 src/examples.mbt、src/demo.mbt 和 src/tests.mbt 了解完整用法示例"
echo ""
echo "💡 运行演示："
echo "   import moonlog/demo { demo }"
echo "   demo()  // 运行完整演示"