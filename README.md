# 📊 Projet d'Analyse de Données - Data Quality & Customer Insights

## 🎯 Présentation du Projet

Ce projet présente une série d'analyses de données réalisées dans le cadre d'un projet de **fusion et de nettoyage de bases de données clients** provenant de multiples sources. L'objectif principal était d'unifier, nettoyer et analyser des données de contacts et de clients pour améliorer la qualité des données et générer des insights business.

### Contexte

- **Problématique** : Consolidation de données clients provenant de 27 bases de données postgre SQL, avec des schémas hétérogènes et des problèmes de qualité
- **Objectifs** :
  - Unifier les schémas de données hétérogènes
  - Nettoyer et valider les données (emails, téléphones)
  - Analyser la qualité et la complétude des données
  - Identifier les doublons et les incohérences
  - Créer des segments clients basés sur l'engagement

## 🛠️ Stack Technique

### Langages & Outils
- **Python 3** - Langage principal d'analyse
- **SQL (PostgreSQL)** - Requêtes d'agrégation et de fusion de données
- **Jupyter Notebook** - Environnement de développement et documentation

### Bibliothèques Python
- **pandas** - Manipulation et analyse de données
- **numpy** - Calculs numériques et statistiques
- **matplotlib** - Visualisation de données
- **seaborn** - Visualisations statistiques avancées
- **re** (regex) - Validation et nettoyage de données textuelles

## 📁 Structure du Projet

```
data-analysis-portfolio/
│
├── README.md                          # Documentation principale
├── SNIPPETS.md                        # Snippets de code réutilisables
│
├── notebooks/                         # Notebooks Jupyter d'analyse
│   ├── analyse_ac3_contact.ipynb      # Analyse source AC3 Contact
│   ├── analyse_izilead_contact.ipynb  # Analyse source Izilead
│   ├── exploration_fusion_donnees.ipynb  # Exploration et fusion des sources
│   └── analyse_engagement_clients.ipynb  # Segmentation clients
│
├── sql/                               # Requêtes SQL
│   └── union_databases.sql            # Fusion des bases de données
│
└── docs/                              # Documentation supplémentaire
    └── technical_notes.md             # Notes techniques
```

## 🔍 Analyses Réalisées

### 1. **Analyse de la Qualité des Données** (`analyse_ac3_contact.ipynb`, `analyse_izilead_contact.ipynb`)
- Calcul des taux de complétude par colonne
- Identification des valeurs manquantes et aberrantes
- Validation des emails avec regex
- Validation des numéros de téléphone
- Analyse des distributions catégorielles (genre, type de contact)

### 2. **Fusion et Harmonisation des Sources** (`exploration_fusion_donnees.ipynb`)
- Mapping des colonnes entre différentes sources
- Standardisation des formats (dates, genres, types)
- Création d'une vue unifiée avec SQL UNION ALL
- Gestion des conflits de données (téléphones multiples, emails en doublon)

### 3. **Segmentation et Analyse d'Engagement** (`analyse_engagement_clients.ipynb`)
- Création d'un score d'engagement basé sur la fréquence de contact
- Segmentation clients : "1er contact", "tiède", "chaud", "très chaud"
- Analyse temporelle (filtrage 2022-2024)
- Détection d'outliers avec boxplots
- Visualisations de distributions

## 💡 Compétences Démontrées

### Data Wrangling
- ✅ Nettoyage de colonnes (renommage automatique, conversion de types)
- ✅ Gestion des valeurs manquantes et nullables (`Int64`, `errors='coerce'`)
- ✅ Transformation de données (extraction de domaines emails, parsing de dates)
- ✅ Dédoublonnage et gestion des duplicatas

### Analyse & Statistiques
- ✅ Statistiques descriptives (`describe()`, `value_counts()`)
- ✅ Analyse de complétude et de qualité
- ✅ Détection d'anomalies et d'outliers
- ✅ Segmentation et création de features

### Visualisation
- ✅ Graphiques en barres (distributions catégorielles)
- ✅ Boxplots (détection d'outliers)
- ✅ Diagrammes circulaires (proportions)
- ✅ Graphiques temporels

### SQL
- ✅ Requêtes complexes avec UNION ALL
- ✅ CTEs (Common Table Expressions)
- ✅ CASE statements pour transformations
- ✅ COALESCE pour gestion des nulls
- ✅ Casting et conversions de types

### Bonnes Pratiques
- ✅ Code documenté et commenté
- ✅ Utilisation de fonctions réutilisables
- ✅ Gestion d'erreurs (`try/except`, `errors='coerce'`)
- ✅ Notebooks structurés avec sections Markdown
- ✅ Approche itérative et exploratoire

## 🚀 Résultats Clés

- **+3 sources de données** consolidées en un schéma unifié
- **Taux de complétude** : Analyse détaillée pour chaque source (emails, téléphones)
- **Validation** : Mise en place de regex pour valider emails et téléphones
- **Segmentation** : Création de 4 segments clients basés sur l'engagement
- **Visualisations** : Graphiques clairs pour la prise de décision

## 📝 Comment Utiliser ce Projet

### Prérequis
```bash
pip install pandas numpy matplotlib seaborn jupyter
```

### Lancer les Notebooks
```bash
jupyter notebook notebooks/
```

### Exécuter les Requêtes SQL
Les requêtes SQL dans `sql/union_databases.sql` peuvent être exécutées sur PostgreSQL.

## 📌 Notes

- Les données réelles ont été anonymisées pour respecter la confidentialité
- Les chemins de fichiers ont été généralisés
- Les noms de clients et informations sensibles ont été retirés

## 📧 Contact

Pour toute question sur ce projet, n'hésitez pas à me contacter.

---

*Ce projet démontre une maîtrise complète du cycle de vie de l'analyse de données : de l'extraction et du nettoyage à la visualisation et aux insights business.*
