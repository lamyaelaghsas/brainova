// Valeurs par défaut
const int kDefaultCount = 0;                     // Compteur par défaut
const String kEmptyString = ''; 

// Time conversions
const int kMinutesPerHour = 60;              // Minutes dans une heure
const int kDaysInWeek = 7;                   // Jours dans une semaine
const int kOneDay = 1;
const int kOneDayAgo = 1;                        // Un jour en arrière (hier)

// Bottom navigation bar indices
const int kNavIndexNotifications = 0;            // Index page Notifications
const int kNavIndexGroups = 1;                   // Index page Groupes (actuelle)
const int kNavIndexProfile = 2;                  // Index page Profil

// ==========================================
// AJOUT POUR GROUPELIST SCREEN :
// ==========================================
// Formatting
const int kTimePadLength = 2;                // Longueur du padding pour l'heure/minute
const String kTimePadCharacter = '0';        // Caractère de remplissage pour le padding

// Icon multipliers
const double kIconMultiplierDouble = 2.0;    // Multiplicateur pour doubler une taille d'icône
const double kIconMultiplierUnEtDemi = 1.5;    // Multiplicateur pour doubler une taille d'icône

const int kHexadecimalRadix = 16;                // Base hexadécimale (16)

const String kDefaultGroupColorHex = '#FFD700';  // Couleur jaune par défaut

// ==========================================
// AJOUT POUR GROUPE_DETAIL SCREEN :
// ==========================================
// Time conversions (secondes)
const int kSecondsPerHour = 3600;            // Secondes dans une heure
const int kSecondsPerMinute = 60;            // Secondes dans une minute
const int kHoursPerDay = 24;                 // Heures dans une journée

// Ranking
const int kFirstRank = 1;                    // Premier rang (or)
const int kSecondRank = 2;                   // Deuxième rang (argent)
const int kThirdRank = 3;                    // Troisième rang (bronze)
const int kTopThreeRanks = 3;                // Les 3 premiers rangs (podium)

const int kSnackBarDurationSeconds = 3;      // Durée d'affichage des SnackBar


// ==========================================
// AJOUT POUR CREER GROUPE SCREEN :
// ==========================================
// Groupe code
const int kGroupCodeLength = 6;              // Longueur du code groupe (6 caractères)
const String kGroupCodeCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // Caractères valides pour le code

// Validation
const int kGroupNameMaxLength = 30;          // Longueur max du nom de groupe
const int kGroupNameMinLength = 3;           // Longueur min du nom de groupe

// UI durations
const int kSnackBarCopyDurationSeconds = 2;  // Durée SnackBar après copie

// ==========================================
// AJOUT POUR REJOINDRE GROUPE SCREEN :
// ==========================================
// Timer
const int kTimerIntervalSeconds = 1;         // Intervalle du timer (1 seconde)

// Boolean defaults
const bool kDefaultBoolTrue = true;          // Valeur booléenne true par défaut

// Progress values
const double kProgressMin = 0.0;             // Progression minimale (0%)
const double kProgressMax = 1.0;             // Progression maximale (100%)

// Badge thresholds (seuils de déblocage)
const int kBadgeNovaSessionsRequired = 10;        // 10 sessions pour Nova Brillante
const int kBadgeStudieuxSessionsRequired = 5;     // 5 sessions pour Studieux
const int kBadgeMarathonSecondsRequired = 7200;   // 2 heures (7200s) pour Marathon
const int kBadgeSocialGroupesRequired = 3;        // 3 groupes pour Social


// Types de notifications
class NotificationType {
  static const String nouvelleSession = 'nouvelle_session';
  static const String sessionEnCours = 'session_en_cours';
  static const String membreRejoint = 'membre_rejoint';
}

// Valeurs par défaut
const String kDefaultGroupName = 'un groupe';
const String kDefaultMemberName = 'Un membre';
const String kDefaultNewMemberName = 'Un nouveau membre';