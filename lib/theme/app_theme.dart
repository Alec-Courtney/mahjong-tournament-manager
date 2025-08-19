import 'package:flutter/material.dart';

class AppTheme {
  // 颜色定义 - 基于HTML设计
  static const Color primary = Color(0xFF3A0CA3);
  static const Color secondary = Color(0xFF4361EE);
  static const Color accent = Color(0xFFF72585);
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark = Color(0xFF212529);
  static const Color background = Color(0xFFF5F7FF);
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  
  // 阴影
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 10),
      blurRadius: 20,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 6),
      blurRadius: 6,
    ),
  ];
  
  static const List<BoxShadow> hoverShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 14),
      blurRadius: 28,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 10),
      blurRadius: 10,
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: Colors.white,
        background: background,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'NotoSansSC',
      
      // AppBar主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      
      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // 数据表格主题
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(primary.withOpacity(0.1)),
        headingTextStyle: const TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        dataTextStyle: const TextStyle(
          color: dark,
          fontSize: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: cardShadow,
        ),
      ),
    );
  }
}

// 自定义组件样式
class AppStyles {
  static const TextStyle heroTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  
  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppTheme.primary,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppTheme.primary,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}
