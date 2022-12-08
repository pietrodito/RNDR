define([add_month], [define([year],  substr([$1], [0], [4]))dnl
define([month], substr([$1], [4], [2]))dnl
define([new_year],  ifelse(month, [12], incr(year), [year]))dnl
define([new_month],  [00])dnl
define([new_month], ifelse(month, [01], [02], [new_month]))dnl
define([new_month], ifelse(month, [02], [03], [new_month]))dnl
define([new_month], ifelse(month, [03], [04], [new_month]))dnl
define([new_month], ifelse(month, [04], [05], [new_month]))dnl
define([new_month], ifelse(month, [05], [06], [new_month]))dnl
define([new_month], ifelse(month, [06], [07], [new_month]))dnl
define([new_month], ifelse(month, [07], [08], [new_month]))dnl
define([new_month], ifelse(month, [08], [09], [new_month]))dnl
define([new_month], ifelse(month, [09], [10], [new_month]))dnl
define([new_month], ifelse(month, [10], [11], [new_month]))dnl
define([new_month], ifelse(month, [11], [12], [new_month]))dnl
define([new_month], ifelse(month, [12], [01], [new_month]))dnl
new_year[]new_month[]01])dnl

define([add_months], [define([current_month], $1)dnl
forloop([i], [1], [$2], [define([current_month], add_month(current_month))])dnl
current_month])

define([ARC_from_FLX], [define([ARCV], [ifelse(eval($1 <= DCIR_AN1), [1], substr($1, [0], [4]), 0)])dnl
ifelse(len(ARCV), 4, [define([ARCV], ifelse(substr($1, [4], [2]), [01], decr(ARCV), ARCV))])dnl
ifelse(ARCV, [0], , _[]ARCV)])dnl

define([FLX_LOOP],
  dnl ##########################################################
  dnl # Usage: this macro will define two variables for you    #
  dnl # ARC and FLX_IDX that you can use in your query...      #
  dnl # ------------------------------------------------------ #
  dnl # define([beginning_date], 20080101)                     #
  dnl # define([nb_month_flx],   24)                           #
  dnl # FLX_LOOP(begininnig_date, nb_month_flx,[dnl            #
  dnl # insert into COLLECTING_TABLE                           #
  dnl # select *                                               #
  dnl # from ER_PRS_R[]ARC prs                                 # 
  dnl # where prs.FLX_IDX])                                    #
  dnl ##########################################################
[forloop([NM_FLX], [1], [$2], [define([FLX_YYYYMMDD], [add_months($1, NM_FLX)])dnl
define([ARC], ARC_from_FLX(FLX_YYYYMMDD))dnl
define([FLX_IDX], [FLX_DIS_DTD = to_date(FLX_YYYYMMDD, 'YYYYMMDD')])
$3
/])])dnl 

define([j9k], [dnl
$1.DCT_ORD_NUM=$2.DCT_ORD_NUM
and $1.FLX_DIS_DTD=$2.FLX_DIS_DTD
and $1.FLX_EMT_ORD=$2.FLX_EMT_ORD
and $1.FLX_EMT_NUM=$2.FLX_EMT_NUM
and $1.FLX_EMT_TYP=$2.FLX_EMT_TYP
and $1.FLX_TRT_DTD=$2.FLX_TRT_DTD
and $1.ORG_CLE_NUM=$2.ORG_CLE_NUM
and $1.PRS_ORD_NUM=$2.PRS_ORD_NUM
and $1.REM_TYP_AFF=$2.REM_TYP_AFF])

define([ano_psa], 
  dnl ##########################################################
  dnl # Cette macro produit une nouvelle table faisant         #
  dnl # correspondre les BEN_NIR_PSA aux BEN_NIR_ANO.          #
  dnl #                                                        #
  dnl # Dans cette nouvelle table on trouvera deux autres      #
  dnl # colonnes :                                             #
  dnl #   - PSA_AMB non NULL si BEN_NIR_PSA est lié à plus     #
  dnl #     d'un ANO distinct, c'est le cas pour des jumeaux   #
  dnl #     de même sexe ayants-droits du même assuré          #
  dnl #   - MUL_NAI valant le nombre de jumeaux de même sexe   #
  dnl #     trouvé ainsi dans le SNDS (NULL sinon)             #
  dnl # ------------------------------------------------------ #
  dnl #                                                        #
  dnl # Cette macro peut être appelé avec 2 ou 3 arguments :   #
  dnl #                                                        #
  dnl #                                                        #
  dnl # ano_psa(TABLE_WITH_BEN_NIR_PSA_LIST,                   #
  dnl #         OUTPUT_TABLE_NAME)                             #
  dnl #                                                        #
  dnl #                                                        #
  dnl # ano_psa(TABLE_WITH_BEN_NIR_PSA_LIST,                   #
  dnl #         OUTPUT_TABLE_NAME,                             #
  dnl #         TABLE_WITH_BEN_NIR_ANO_LIST)                   #
  dnl #                                                        # 
  dnl #                                                        #
  dnl ##########################################################
[dnl 
define([table_psa],         $1)dnl
define([table_map_ano_psa], $2)dnl
define([table_ano_vide], [IR_BEN_R where BEN_NIR_ANO = 'notexists'])dnl
define([table_ano], ifelse($#, 3, $3, table_ano_vide))dnl

create_table(ANO_PSA_TOUS_LES_ANO)
  select b.BEN_NIR_ANO
  from       IR_BEN_R b
  inner join table_psa p
    on       b.BEN_NIR_PSA = p.BEN_NIR_PSA
    and      BEN_NIR_ANO is not null
  
 union
  
  select b.BEN_NIR_ANO
  from       IR_BEN_R_ARC b
  inner join table_psa p
    on       b.BEN_NIR_PSA = p.BEN_NIR_PSA
    and      BEN_NIR_ANO is not null
    
 union
 
  select BEN_NIR_ANO from table_ano
/

create_table(ANO_PSA_TOUS_LES_ANO_PSA)
  select distinct b.BEN_NIR_ANO
    ,             b.BEN_NIR_PSA
  from            IR_BEN_R b
  inner join      ANO_PSA_TOUS_LES_ANO t
    on            b.BEN_NIR_ANO = t.BEN_NIR_ANO

 union

  select distinct b.BEN_NIR_ANO
    ,             b.BEN_NIR_PSA
  from            IR_BEN_R_ARC b
  inner join      ANO_PSA_TOUS_LES_ANO t
    on            b.BEN_NIR_ANO = t.BEN_NIR_ANO
/

create_table(ANO_PSA_PSA_AMBIGUS)
select BEN_NIR_PSA
  ,    N_ANO
from
  (select BEN_NIR_PSA
    ,    count(BEN_NIR_ANO) as N_ANO
  from ANO_PSA_TOUS_LES_ANO_PSA
  group by BEN_NIR_PSA)
where N_ANO > 1
/

create_table(ANO_PSA_TOUS_LES_ANO_PSA_TMP)
select     ap.*
  ,        pa.N_ANO as PSA_AMB 
from       ANO_PSA_TOUS_LES_ANO_PSA ap
left join  ANO_PSA_PSA_AMBIGUS pa
  on       pa.BEN_NIR_PSA = ap.BEN_NIR_PSA
/

rename_table(ANO_PSA_TOUS_LES_ANO_PSA_TMP, ANO_PSA_TOUS_LES_ANO_PSA)

create_table(ANO_PSA_ANO_MUL_NAI)
select distinct ap.BEN_NIR_ANO
  ,             pa.N_ANO as MUL_NAI
from            ANO_PSA_TOUS_LES_ANO_PSA ap
inner join      ANO_PSA_PSA_AMBIGUS pa
  on            pa.BEN_NIR_PSA = ap.BEN_NIR_PSA
/

create_table(ANO_PSA_TOUS_LES_ANO_PSA_TMP)
select     ap.*
  ,        mn.MUL_NAI
from       ANO_PSA_TOUS_LES_ANO_PSA ap
left join  ANO_PSA_ANO_MUL_NAI mn
  on       mn.BEN_NIR_ANO = ap.BEN_NIR_ANO
/

drop_table(ANO_PSA_ANO_MUL_NAI)
drop_table(ANO_PSA_PSA_AMBIGUS)
drop_table(ANO_PSA_TOUS_LES_ANO)
drop_table(ANO_PSA_TOUS_LES_ANO_PSA)
rename_table(ANO_PSA_TOUS_LES_ANO_PSA_TMP, table_map_ano_psa)
/
])