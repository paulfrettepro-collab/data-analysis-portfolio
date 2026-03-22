-- =====================================================
-- REQUÊTE SQL : UNION ET FUSION DE BASES DE DONNÉES
-- =====================================================
-- 
-- Objectif : Unifier les données de contacts provenant de deux sources différentes
--            (Izilead et AC3 Contact) avec standardisation des colonnes
--
-- Compétences démontrées :
-- - CTEs (Common Table Expressions)
-- - UNION ALL pour fusion de données
-- - CASE statements pour transformations
-- - COALESCE pour gestion des valeurs nulles
-- - Casting de types de données
-- - Standardisation de formats
-- =====================================================

WITH unified_contacts AS (
  -- ============================================
  -- SOURCE 1 : IZILEAD
  -- ============================================
  SELECT
    CAST("izilead"."contact"."id" AS TEXT) AS "id",
    "izilead"."contact"."first_name" AS "first_name",
    "izilead"."contact"."last_name" AS "last_name",
    "izilead"."contact"."phone" AS "phone",
    "izilead"."contact"."email" AS "email",
    CAST("izilead"."contact"."created_at" AS TIMESTAMP) AS "created_at",
    CAST("izilead"."contact"."updated_at" AS TIMESTAMP) AS "updated_at",
    CAST("izilead"."contact"."external_id" AS TEXT) AS "external_id",
    "izilead"."contact"."type" AS "type",
    COALESCE("izilead"."contact"."gender", NULL) AS "gender",
    
    -- Transformation du genre en format lettre (M/F/U)
    CASE 
      WHEN "izilead"."contact"."gender" ILIKE 'male' THEN 'M'
      WHEN "izilead"."contact"."gender" ILIKE 'female' THEN 'F'
      ELSE 'U'
    END AS gender_letter,
    
    -- Transformation du genre en format texte (Male/Female/Unknown)
    CASE 
      WHEN "izilead"."contact"."gender" ILIKE 'male' THEN 'Male'
      WHEN "izilead"."contact"."gender" ILIKE 'female' THEN 'Female'
      ELSE 'Unknown'
    END AS gender_short,
    
    'izilead' AS source  -- Colonne pour identifier la source des données
  FROM
    "izilead"."contact"
  WHERE
    CAST("izilead"."contact"."created_at" AS DATE) >= CAST('2022-01-01' AS DATE)
    AND CAST("izilead"."contact"."created_at" AS DATE) <= CURRENT_DATE
  
  UNION ALL
  
  -- ============================================
  -- SOURCE 2 : AC3 CONTACT
  -- ============================================
  SELECT
    CAST("contacts"."contact"."id" AS TEXT) AS "id",
    "contacts"."contact"."firstname" AS "first_name",
    "contacts"."contact"."lastname" AS "last_name",
    
    -- COALESCE pour sélectionner le premier numéro de téléphone non-null
    COALESCE(
      "contacts"."contact"."phone",
      "contacts"."contact"."mobile_phone",
      "contacts"."contact"."phone1",
      "contacts"."contact"."phone2",
      "contacts"."contact"."phone3",
      "contacts"."contact"."phone4"
    ) AS "phone",
    
    "contacts"."contact"."email" AS "email",
    CAST("contacts"."contact"."created_at" AS TIMESTAMP) AS "created_at",
    CAST("contacts"."contact"."updated_at" AS TIMESTAMP) AS "updated_at",
    CAST("contacts"."contact"."orig_id" AS TEXT) AS "external_id",
    "contacts"."contact"."type_contact" AS "type",
    COALESCE("contacts"."contact"."gender", NULL) AS "gender",
    
    -- Standardisation du format genre (identique à Izilead)
    CASE 
      WHEN "contacts"."contact"."gender" ILIKE 'male' THEN 'M'
      WHEN "contacts"."contact"."gender" ILIKE 'female' THEN 'F'
      ELSE 'U'
    END AS gender_letter,
    
    CASE 
      WHEN "contacts"."contact"."gender" ILIKE 'male' THEN 'Male'
      WHEN "contacts"."contact"."gender" ILIKE 'female' THEN 'Female'
      ELSE 'Unknown'
    END AS gender_short,
    
    'ac3contact' AS source  -- Colonne pour identifier la source des données
  FROM
    "contacts"."contact"
  WHERE
    CAST("contacts"."contact"."created_at" AS DATE) >= CAST('2022-01-01' AS DATE)
    AND CAST("contacts"."contact"."created_at" AS DATE) <= CURRENT_DATE
)

-- ============================================
-- SÉLECTION FINALE AVEC INDICATEUR DE COMPLÉTUDE
-- ============================================
SELECT 
  *,
  -- Création d'un indicateur de qualité/complétude des données
  CASE 
    WHEN email IS NOT NULL AND phone IS NOT NULL AND id IS NOT NULL THEN 'Complet'
    ELSE 'Incomplet'
  END AS contact_completeness
FROM unified_contacts;

-- =====================================================
-- RÉSULTAT :
-- - Schéma unifié entre les deux sources
-- - Standardisation des formats (genre, téléphone)
-- - Colonne 'source' pour traçabilité
-- - Indicateur de complétude des données
-- - Filtrage temporel (à partir de 2022)
-- =====================================================
