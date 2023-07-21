import "package:flutter/material.dart";

import "color.dart";

final appBarTheme = AppBarTheme(
  elevation: 0,
  toolbarHeight: 70,
  centerTitle: true,
  backgroundColor: colorScheme.surface,
  foregroundColor: colorScheme.onSurface,
);

final textButtonStyle = TextButtonThemeData(
  style: TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    minimumSize: const Size.fromHeight(60),
    foregroundColor: colorScheme.primary,
  ),
);

final elevatedButtonStyle = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    disabledBackgroundColor: colorScheme.primary.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    splashFactory: NoSplash.splashFactory,
    minimumSize: const Size.fromHeight(60),
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
  ),
);

final outlinedButtonStyle = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    elevation: 0,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: Colors.white,
    minimumSize: const Size.fromHeight(60),
    foregroundColor: Colors.black,
    /* side: MaterialStateProperty.all( */
    /*   const BorderSide( */
    /*     color: Color(0x00BBBBBB), */
    /*   ), */
    /* ), */
  ),
);

/* final buttonStyle = ButtonStyle( */
/*   shape: MaterialStateProperty.all( */
/*     const RoundedRectangleBorder( */
/*       borderRadius: BorderRadius.all( */
/*         Radius.circular(4), */
/*       ), */
/*     ), */
/*   ), */
/* ); */
