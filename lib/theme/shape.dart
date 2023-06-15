import "package:flutter/material.dart";

import "color.dart";

const appBarTheme = AppBarTheme(
  toolbarHeight: 70,
);

final textButtonStyle = TextButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    ),
    foregroundColor: MaterialStateProperty.all(
      colorScheme.primary,
    ),
  ),
);

final elevatedButtonStyle = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    ),
    elevation: MaterialStateProperty.all(0),
    splashFactory: NoSplash.splashFactory,
    minimumSize: MaterialStateProperty.all(
      const Size.fromHeight(50),
    ),
    backgroundColor: MaterialStateProperty.all(
      colorScheme.primary,
    ),
    foregroundColor: MaterialStateProperty.all(
      colorScheme.onPrimary,
    ),
  ),
);

final outlinedButtonStyle = OutlinedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    ),
    elevation: MaterialStateProperty.all(0),
    splashFactory: NoSplash.splashFactory,
    backgroundColor: MaterialStateProperty.all(
      Colors.white,
    ),
    minimumSize: MaterialStateProperty.all(
      const Size.fromHeight(50),
    ),
    /* side: MaterialStateProperty.all( */
    /*   const BorderSide( */
    /*     color: Color(0x00BBBBBB), */
    /*   ), */
    /* ), */
    foregroundColor: MaterialStateProperty.all(
      Colors.black,
    ),
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
