# 📝 Code Snippets - Techniques Avancées en Pandas & Data Analysis

Ce document présente des snippets de code réutilisables extraits du projet, démontrant des techniques avancées en analyse de données.

---

## 📊 Table des Matières

1. [Nettoyage de Données](#nettoyage-de-données)
2. [Validation de Données](#validation-de-données)
3. [Transformation de Colonnes](#transformation-de-colonnes)
4. [Analyse de Qualité](#analyse-de-qualité)
5. [Visualisations](#visualisations)
6. [Fonctions Réutilisables](#fonctions-réutilisables)

---

## 🧹 Nettoyage de Données

### Renommage Automatique de Colonnes

Standardisation des noms de colonnes (minuscules, underscores).

```python
import pandas as pd
import re

def clean_column_name(column_name):
    """
    Nettoie les noms de colonnes en remplaçant les caractères spéciaux
    et les espaces par des underscores, puis convertit en minuscules.
    """
    # Remplacer les caractères spéciaux et les espaces par des underscores
    cleaned_name = re.sub(r"[^a-zA-Z0-9]", "_", column_name)
    # Convertir en minuscules
    cleaned_name = cleaned_name.lower()
    return cleaned_name

# Appliquer sur toutes les colonnes
new_column_names = {old_name: clean_column_name(old_name) for old_name in df.columns}
df = df.rename(columns=new_column_names)
```

**Cas d'usage** : Uniformiser les colonnes provenant de sources différentes.

---

### Conversion de Types avec Gestion d'Erreurs

Conversion robuste des types de données avec gestion des erreurs.

```python
import pandas as pd

# Convertir en entiers nullables (accepte les NaN)
df['id'] = pd.to_numeric(df['id'], errors='coerce').astype('Int64')
df['external_id'] = pd.to_numeric(df['external_id'], errors='coerce').astype('Int64')

# Convertir en datetime
df['created_at'] = pd.to_datetime(df['created_at'], errors='coerce')
df['updated_at'] = pd.to_datetime(df['updated_at'], errors='coerce')

# Convertir en catégories (pour économiser de la mémoire)
df['type'] = df['type'].astype('category')
df['gender'] = df['gender'].astype('category')

# Convertir en string
df['first_name'] = df['first_name'].astype(str)
df['last_name'] = df['last_name'].astype(str)
```

**Avantages** :
- `errors='coerce'` : convertit les valeurs invalides en NaN
- `Int64` : permet les valeurs nulles (contrairement à `int64`)
- `category` : réduit l'empreinte mémoire pour les colonnes répétitives

---

## ✅ Validation de Données

### Validation d'Emails avec Regex

```python
import re

def is_valid_email(email):
    """
    Vérifie si un email est valide selon un format standard.
    """
    regex = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return bool(re.match(regex, email))

# Compter les emails invalides
email_invalid = (~df['email'].apply(is_valid_email)).sum()
print(f"Nombre d'emails invalides : {email_invalid}")

# Filtrer les emails valides
df_valid_emails = df[df['email'].apply(is_valid_email)]
```

---

### Validation de Numéros de Téléphone

```python
import re

def is_valid_phone(phone):
    """
    Vérifie si un numéro de téléphone est valide (10 chiffres).
    Adapter selon le format souhaité.
    """
    regex = r"^\d{10}$"  # 10 chiffres exactement
    return bool(re.match(regex, str(phone)))

# Compter les téléphones invalides
phone_invalid = (~df['phone'].apply(is_valid_phone)).sum()
print(f"Nombre de téléphones invalides : {phone_invalid}")
```

---

### Sélection du Téléphone le Plus Probable

Lorsque plusieurs colonnes de téléphone existent, sélectionner la première valide.

```python
import re

def get_most_probable_phone(row):
    """
    Parcourt les colonnes de téléphone et retourne le premier numéro valide trouvé.
    """
    phone_columns = ['Phone', 'Mobile Phone', 'Phone1', 'Phone2', 'Phone3', 'Phone4']
    probable_phone = None
    for column in phone_columns:
        if isinstance(row[column], str) and re.search(r'\d{10}', row[column]):
            probable_phone = row[column]
            break  # Arrêt dès qu'un numéro valide est trouvé
    return probable_phone

df['most_probable_phone'] = df.apply(get_most_probable_phone, axis=1)
```

---

## 🔄 Transformation de Colonnes

### Suppression de Colonnes Multiples

```python
# Définir les colonnes à supprimer
columns_to_drop = [
    'phone', 'mobile_phone', 'phone1', 'phone2', 'phone3', 'phone4',
    'stop_sms1', 'stop_sms2', 'stop_sms3', 'stop_sms4',
    'contact_admin___admin___id', 'contact_admin___admin___orig_id',
    # ... autres colonnes inutiles
]

# Supprimer les colonnes
df = df.drop(columns=columns_to_drop)
```

---

### Extraction de Domaines d'Emails

```python
# Extraire le domaine de l'email
df['email_domain'] = df['email'].str.extract(r'@(.*)')

# Analyser la distribution des domaines
print(df['email_domain'].value_counts())
```

---

### Création de Segments avec np.select()

Créer des catégories conditionnelles complexes.

```python
import numpy as np

# Définir les conditions
conditions = [
    (df['nb_telephone'] == 1),
    (df['nb_telephone'] > 1) & (df['nb_telephone'] < 10),
    (df['nb_telephone'] >= 10) & (df['nb_telephone'] < 25),
    (df['nb_telephone'] >= 25)
]

# Définir les catégories correspondantes
categories = ['1er contact', 'tiède', 'chaud', 'très chaud']

# Créer la nouvelle colonne
df['niveau_chaleur'] = np.select(conditions, categories, default='aucun')
```

**Avantage** : Plus lisible et performant que plusieurs `if/elif`.

---

## 📈 Analyse de Qualité

### Calcul du Taux de Complétude

Calculer le pourcentage de valeurs non-nulles pour chaque colonne.

```python
import pandas as pd

# Calculer le taux de complétude
completeness = df.notna().sum() / len(df)

# Créer un DataFrame de présentation
presentation_df = pd.DataFrame({
    'Colonne': completeness.index,
    'Type de données': df.dtypes,
    'Taux de complétude (%)': completeness.apply(lambda x: f'{x:.2%}'),
    'Valeurs non nulles': df.notna().sum(),
    'Valeurs nulles': df.isnull().sum()
})

print(presentation_df)
```

---

### Détection de Doublons

```python
# Compter les doublons dans 'phone' et 'email'
phone_duplicates = df['phone'].duplicated(keep=False).sum()
email_duplicates = df['email'].duplicated(keep=False).sum()

print(f"Doublons dans 'phone' : {phone_duplicates}")
print(f"Doublons dans 'email' : {email_duplicates}")

# Filtrer les lignes uniques par email
df_unique = df.drop_duplicates("email")
```

---

### Comptage par Groupe avec Transform

Créer une colonne avec le nombre d'occurrences par groupe.

```python
# Créer une copie pour éviter les warnings
df_filtered = df_filtered.copy()

# Compter le nombre d'occurrences de chaque téléphone
df_filtered.loc[:, 'nb_telephone'] = df_filtered.groupby('telephone')['telephone'].transform('count')

# Trier par nombre d'occurrences
df_sorted = df_filtered.sort_values(by='nb_telephone', ascending=False)
```

---

## 📊 Visualisations

### Graphiques de Distribution Catégorielle

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Sélectionner les colonnes catégorielles
categorical_columns = df.select_dtypes(include=['category']).columns

for column in categorical_columns:
    print(f"Analyse de '{column}':")
    print(df[column].value_counts())
    print(df[column].value_counts(normalize=True) * 100)
    
    # Graphique en barres
    plt.figure(figsize=(10, 5))
    sns.countplot(x=column, data=df, order=df[column].value_counts().index)
    plt.title(f"Distribution de '{column}'")
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.show()
    
    # Diagramme circulaire
    plt.figure(figsize=(8, 8))
    df[column].value_counts().plot.pie(autopct='%1.1f%%', startangle=90)
    plt.title(f"Proportion de '{column}'")
    plt.ylabel('')
    plt.show()
```

---

### Boxplot pour Détection d'Outliers

```python
import matplotlib.pyplot as plt

plt.figure(figsize=(6, 6))
plt.boxplot(df["nb_telephone"], vert=True, patch_artist=True, 
            boxprops=dict(facecolor="skyblue"))
plt.ylabel("Nombre de téléphones")
plt.title("Détection des outliers")
plt.show()
```

---

### Graphique de Complétude

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Calculer la complétude
completeness = df.notna().sum() / len(df)

presentation_df = pd.DataFrame({
    'Colonne': completeness.index,
    'Taux de complétion (%)': completeness * 100
})

# Créer le graphique
plt.figure(figsize=(12, 6))
sns.barplot(x='Colonne', y='Taux de complétion (%)', data=presentation_df)
plt.xticks(rotation=90)
plt.title('Taux de complétion par colonne')
plt.tight_layout()
plt.show()
```

---

## 🛠️ Fonctions Réutilisables

### Chargement Robuste de CSV

```python
import pandas as pd

def load_csv_robust(filepath, delimiter=",", encoding="utf-8"):
    """
    Charge un CSV en gérant les erreurs courantes.
    """
    try:
        df = pd.read_csv(
            filepath,
            delimiter=delimiter,
            encoding=encoding,
            on_bad_lines="skip",  # Ignore les lignes corrompues
            low_memory=False      # Évite les warnings de dtype mixtes
        )
        print(f"✅ Fichier chargé : {df.shape[0]} lignes, {df.shape[1]} colonnes")
        return df
    except FileNotFoundError:
        print(f"❌ Erreur : Fichier '{filepath}' non trouvé.")
        return None
    except Exception as e:
        print(f"❌ Erreur : {e}")
        return None

# Utilisation
df = load_csv_robust("data.csv")
```

---

### Filtrage Temporel

```python
import pandas as pd

def filter_by_date_range(df, date_column, start_date, end_date):
    """
    Filtre un DataFrame selon une plage de dates.
    """
    # Convertir la colonne en datetime si nécessaire
    df[date_column] = pd.to_datetime(df[date_column], errors='coerce')
    
    # Filtrer
    df_filtered = df[(df[date_column] >= start_date) & (df[date_column] <= end_date)]
    
    print(f"Lignes avant filtrage : {len(df)}")
    print(f"Lignes après filtrage : {len(df_filtered)}")
    
    return df_filtered

# Utilisation
df_filtered = filter_by_date_range(df, 'created_at', '2022-01-01', '2024-12-31')
```

---

## 🎯 Bonnes Pratiques

### 1. Éviter les SettingWithCopyWarning

```python
# ❌ Mauvais
df_filtered['new_column'] = ...

# ✅ Bon
df_filtered = df_filtered.copy()
df_filtered.loc[:, 'new_column'] = ...
```

### 2. Utiliser .loc[] pour les Affectations

```python
# ❌ Éviter
df['column'][df['condition']] = value

# ✅ Préférer
df.loc[df['condition'], 'column'] = value
```

### 3. Chaînage de Méthodes

```python
# Chaînage propre et lisible
df_result = (df
    .dropna(subset=['email'])
    .drop_duplicates('id')
    .sort_values('created_at', ascending=False)
    .reset_index(drop=True)
)
```

---

## 📌 Résumé des Librairies Utilisées

| Librairie | Usage Principal |
|-----------|----------------|
| `pandas` | Manipulation et analyse de données |
| `numpy` | Calculs numériques, conditions multiples |
| `matplotlib` | Visualisations de base |
| `seaborn` | Visualisations statistiques avancées |
| `re` | Regex pour validation et extraction |

---

*Ces snippets sont extraits de projets réels d'analyse de données et peuvent être adaptés à vos besoins spécifiques.*
