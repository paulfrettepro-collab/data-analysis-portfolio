# Notes Techniques - Projet d'Analyse de Données

## Contexte du Projet

Ce projet a été réalisé dans le cadre d'une mission de consolidation de bases de données clients. L'objectif était de fusionner et harmoniser des données provenant de trois sources différentes :

1. **Izilead** - Plateforme de gestion de leads
2. **AC3 Contact** - CRM interne
3. **Base Mandats** - Base de données de mandats immobiliers

## Défis Techniques Rencontrés

### 1. Hétérogénéité des Schémas

**Problème** : Chaque source avait sa propre structure de colonnes et conventions de nommage.

**Solution** : 
- Création d'un mapping de colonnes pour standardiser les noms
- Utilisation de dictionnaires Python pour transformer les colonnes
- Requête SQL avec UNION ALL pour fusionner les données

### 2. Données de Téléphone Multiples

**Problème** : AC3 Contact contenait jusqu'à 6 colonnes de téléphone différentes.

**Solution** :
- Fonction `get_most_probable_phone()` avec logique de priorité
- Utilisation de COALESCE en SQL pour sélectionner la première valeur non-null
- Regex pour valider le format des numéros

### 3. Formats de Genre Incohérents

**Problème** : 'male'/'female' vs 'M'/'F' vs valeurs manquantes.

**Solution** :
- CASE statements SQL pour standardiser
- Création de colonnes dérivées (`gender_letter`, `gender_short`)
- Gestion explicite des valeurs nulles avec COALESCE

### 4. Performance et Mémoire

**Problème** : DataFrame de 200K+ lignes avec 70+ colonnes.

**Solution** :
- Conversion de colonnes en type `category` pour réduire la mémoire
- Utilisation de `low_memory=False` lors du chargement CSV
- Suppression des colonnes inutiles en amont

## Choix Techniques

### Pourquoi Pandas ?

- **Manipulation flexible** : Idéal pour l'exploration de données
- **Intégration Excel/CSV** : Compatibilité avec les sources métier
- **Visualisation** : Intégration native avec matplotlib/seaborn
- **Prototypage rapide** : Notebooks Jupyter pour itération rapide

### Pourquoi SQL + Python ?

- **SQL** : Fusion initiale des données (plus performant pour les joins)
- **Python** : Analyses approfondies, nettoyage fin, visualisations
- **Complémentarité** : Chaque outil pour ce qu'il fait de mieux

## Métriques de Qualité

### Taux de Complétude (Izilead)
- Email : ~98%
- Téléphone : ~99%
- Genre : ~98%

### Taux de Complétude (AC3 Contact)
- Email : ~85%
- Téléphone (après COALESCE) : ~92%
- Genre : ~75%

### Doublons
- ~5% de doublons d'emails détectés
- ~8% de doublons de téléphones détectés

## Améliorations Futures

1. **Déduplication avancée** : Algorithme de matching fuzzy pour détecter les doublons phonétiques
2. **Pipeline ETL** : Automatiser le processus avec Airflow ou Prefect
3. **Data Quality Dashboard** : Tableau de bord temps réel avec Streamlit
4. **Tests unitaires** : Validation automatique des règles métier
5. **Documentation API** : Si transformation en service web

## Outils Utilisés

- **Jupyter Notebook** : Analyse exploratoire
- **DBeaver** : Requêtes SQL sur PostgreSQL
- **Git** : Versionnement du code
- **VS Code** : Édition de code et notebooks

## Temps Estimé

- Analyse exploratoire : 3 jours
- Développement requêtes SQL : 1 jour
- Nettoyage Python : 2 jours
- Visualisations : 1 jour
- Documentation : 1 jour

**Total** : ~8 jours de travail

---

*Document technique rédigé pour accompagner le portfolio GitHub.*
