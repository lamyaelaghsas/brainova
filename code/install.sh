#!/bin/bash

echo "🚀 Installation du package DTO pour Brainova"
echo "============================================="
echo ""

# Vérifier qu'on est dans le bon dossier
if [ ! -d "dto" ]; then
    echo "❌ Erreur: Lance ce script depuis le dossier 'code/'"
    exit 1
fi

echo "📦 Étape 1: Installation des dépendances du package dto..."
cd dto
flutter pub get
echo "✅ Dépendances installées"
echo ""

echo "⚙️ Étape 2: Génération du code ODM (peut prendre 1-2 minutes)..."
dart run build_runner build --delete-conflicting-outputs
echo "✅ Code généré"
echo ""

echo "📦 Étape 3: Installation des dépendances de brainova..."
cd ../brainova
flutter pub get
echo "✅ Dépendances installées"
echo ""

echo "✅ ====================================="
echo "✅ INSTALLATION TERMINÉE AVEC SUCCÈS !"
echo "✅ ====================================="
echo ""
echo "Tu peux maintenant utiliser:"
echo "  import 'package:dto/dto.dart';"
echo ""
echo "Prochaine étape: Créer le seeder 🎯"
