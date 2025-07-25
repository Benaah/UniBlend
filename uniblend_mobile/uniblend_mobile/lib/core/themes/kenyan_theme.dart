import 'package:flutter/material.dart';

class KenyanTheme {
  // Kenyan flag and cultural colors
  static const Color kenyanRed = Color(0xFFBB0000);
  static const Color kenyanBlack = Color(0xFF000000);
  static const Color kenyanGreen = Color(0xFF006A4E);
  static const Color kenyanWhite = Color(0xFFFFFFFF);
  
  // Music genre colors
  static const Color bengaGreen = Color(0xFF4CAF50);
  static const Color gengeBlue = Color(0xFF2196F3);
  static const Color afrobeatOrange = Color(0xFFFF9800);
  static const Color gospelPurple = Color(0xFF9C27B0);
  static const Color hipHopRed = Color(0xFFF44336);
  static const Color reggaeYellow = Color(0xFFFFEB3B);
  
  // Cultural accent colors
  static const Color maasaiRed = Color(0xFFD32F2F);
  static const Color savannaBrown = Color(0xFF8D6E63);
  static const Color sunsetOrange = Color(0xFFFF6F00);
  static const Color lakeBlue = Color(0xFF1976D2);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Primary color scheme based on Kenyan flag
      colorScheme: const ColorScheme.light(
        primary: kenyanGreen,
        onPrimary: kenyanWhite,
        primaryContainer: Color(0xFF90CAF9),
        onPrimaryContainer: Color(0xFF002E63),
        
        secondary: afrobeatOrange,
        onSecondary: kenyanWhite,
        secondaryContainer: Color(0xFFFFE0B2),
        onSecondaryContainer: Color(0xFF4A2400),
        
        tertiary: gospelPurple,
        onTertiary: kenyanWhite,
        
        error: kenyanRed,
        onError: kenyanWhite,
        
        surface: kenyanWhite,
        onSurface: kenyanBlack,
        surfaceVariant: Color(0xFFF5F5F5),
        onSurfaceVariant: Color(0xFF424242),
        
        background: Color(0xFFFAFAFA),
        onBackground: kenyanBlack,
      ),
      
      // App bar theme with cultural elements
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: kenyanGreen,
        foregroundColor: kenyanWhite,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kenyanWhite,
        ),
      ),
      
      // Bottom navigation with cultural colors
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kenyanWhite,
        selectedItemColor: kenyanGreen,
        unselectedItemColor: Color(0xFF757575),
        elevation: 8,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kenyanGreen,
        foregroundColor: kenyanWhite,
      ),
      
      // Text theme with African-inspired typography
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: kenyanBlack,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: kenyanBlack,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: kenyanBlack,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: kenyanBlack,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: kenyanBlack,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: kenyanBlack,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: kenyanBlack,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kenyanGreen, width: 2),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kenyanGreen,
          foregroundColor: kenyanWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Chip theme for genre tags
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFFE8F5E8),
        labelStyle: const TextStyle(color: kenyanGreen),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: const ColorScheme.dark(
        primary: kenyanGreen,
        onPrimary: kenyanBlack,
        primaryContainer: Color(0xFF004D33),
        onPrimaryContainer: Color(0xFF90CAF9),
        
        secondary: afrobeatOrange,
        onSecondary: kenyanBlack,
        secondaryContainer: Color(0xFF8D4E00),
        onSecondaryContainer: Color(0xFFFFE0B2),
        
        tertiary: gospelPurple,
        onTertiary: kenyanWhite,
        
        error: Color(0xFFFF6B6B),
        onError: kenyanBlack,
        
        surface: Color(0xFF121212),
        onSurface: kenyanWhite,
        surfaceVariant: Color(0xFF2C2C2C),
        onSurfaceVariant: Color(0xFFE0E0E0),
        
        background: Color(0xFF0F0F0F),
        onBackground: kenyanWhite,
      ),
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: kenyanWhite,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kenyanWhite,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1F1F1F),
        selectedItemColor: kenyanGreen,
        unselectedItemColor: Color(0xFF757575),
        elevation: 8,
      ),
      
      cardTheme: CardTheme(
        elevation: 4,
        color: const Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kenyanGreen,
        foregroundColor: kenyanBlack,
      ),
    );
  }

  // Music genre color helpers
  static Color getGenreColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'benga':
        return bengaGreen;
      case 'genge':
        return gengeBlue;
      case 'afrobeat':
        return afrobeatOrange;
      case 'gospel':
        return gospelPurple;
      case 'hip hop':
        return hipHopRed;
      case 'reggae':
        return reggaeYellow;
      default:
        return kenyanGreen;
    }
  }

  // Cultural gradients for backgrounds
  static LinearGradient get kenyanSunset => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      sunsetOrange,
      kenyanRed,
      kenyanBlack,
    ],
  );

  static LinearGradient get savannaGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      afrobeatOrange,
      savannaBrown,
      kenyanGreen,
    ],
  );

  static LinearGradient get lakeVictoriaGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lakeBlue,
      Color(0xFF4FC3F7),
      kenyanWhite,
    ],
  );

  // Music player gradients
  static LinearGradient getMusicPlayerGradient(String genre) {
    switch (genre.toLowerCase()) {
      case 'benga':
        return LinearGradient(
          colors: [bengaGreen.withOpacity(0.8), kenyanBlack],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'genge':
        return LinearGradient(
          colors: [gengeBlue.withOpacity(0.8), kenyanBlack],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'afrobeat':
        return LinearGradient(
          colors: [afrobeatOrange.withOpacity(0.8), kenyanRed],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'gospel':
        return LinearGradient(
          colors: [gospelPurple.withOpacity(0.8), kenyanBlack],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [kenyanGreen.withOpacity(0.8), kenyanBlack],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
