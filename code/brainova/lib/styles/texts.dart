import 'package:flutter/material.dart';
import 'package:brainova/styles/colors.dart';

const double kBaseFontSize = 16.0;

const double kFontSizeXSmall = 12.0;   // Pour labels, captions
const double kFontSizeSmall = 14.0;    // Pour texte secondaire
const double kFontSizeMedium = 15.0;   // Pour liens
const double kFontSizeRegular = 16.0;  // kBaseFontSize
const double kFontSizeLarge = 18.0;    // Pour boutons
const double kFontSizeXLarge = 24.0;   // Pour titres moyens
const double kFontSizeXXLarge = 28.0;  // Pour stats/nombres
const double kFontSizeHuge = 32.0;     // Pour grand titre


const TextStyle kTitleLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: kTextPrimary,
  letterSpacing: -0.5,
);

const TextStyle kTitleMedium = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextPrimary,
);

const TextStyle kBodyMedium = TextStyle(
  fontSize: 16,
  color: kTextPrimary,
);

const TextStyle kButtonText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: kButtonTextLight,
);

const TextStyle kAccentText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: kAccentColor,
);
