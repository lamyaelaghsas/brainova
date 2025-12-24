@echo off
echo.
echo ========================================
echo Installation du package DTO pour Brainova
echo ========================================
echo.

if not exist "dto\" (
    echo Erreur: Lance ce script depuis le dossier 'code\'
    pause
    exit /b 1
)

echo Etape 1: Installation des dependances du package dto...
cd dto
call flutter pub get
echo Dependances installees
echo.

echo Etape 2: Generation du code ODM (peut prendre 1-2 minutes)...
call dart run build_runner build --delete-conflicting-outputs
echo Code genere
echo.

echo Etape 3: Installation des dependances de brainova...
cd ..\brainova
call flutter pub get
echo Dependances installees
echo.

echo ========================================
echo INSTALLATION TERMINEE AVEC SUCCES !
echo ========================================
echo.
echo Tu peux maintenant utiliser:
echo   import 'package:dto/dto.dart';
echo.
echo Prochaine etape: Creer le seeder
echo.
pause
