# TODO

## DCIR - mapping ANO-PSA
+ supprimer_jumeaux(TABLE_MAP_ANO_PSA)
+ recuperer_actes(TABLE_MAP_ANO_PSA, TABLE_LISTE_ACTES)
+ recuperer_diags(TABLE_MAP_ANO_PSA, TABLE_LISTE_DIAGS)
+ recuperer_meds(TABLE_MAP_ANO_PSA, TABLE_LISTE_ATC)
+ recuperer_ald(TABLE_MAP_ANO_PSA, TABLE_LISTE_ALD)
+ recuperer_consultation(TABLE_MAP_ANO_PSA, TABLE_LISTE_TYPE_CONSULTATION)

## OBJETS RDS
+ comprendre bug sur A_SEJ_INDEX => SOR_DAT perdue par passage format RDS
+ replace saveRDS par write_rds

## Rendre les projets facilement déplacables
+ Gros problème lorsque l'on transfère un projet vers un nv compte
  + Il faut un fichier dans le projet où mettre le <hard-coded-path>
  + Il faut le répertoire Path_dependent_files dans le projet en hidden
  + Il faut copier son contenu à chaque setup_project
  + Il faut depuis le projet SNDS_TOOLS un outil d'import de projet
    + qui update le <hard-coded-path> substitute