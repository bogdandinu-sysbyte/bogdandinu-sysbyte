


insert into fact_movies
select 
rownum as id_pk,DT_LOAD,GENRE,YEAR,MOVIE_TITLE,RATING_SYSTEM1,RATING_SYSTEM2,RATING_SYSTEM3,RATING_SYSTEM4,ID_SYSTEM1,ID_SYSTEM_2,ID_SYSTEM_3,ID_SYSTEM_4,IF_IS_SYSTEM1_FLG,IF_IS_SYSTEM2_FLG,IF_IS_SYSTEM3_FLG,IF_IS_SYSTEM4_FLG,ID_SOUND,ID_IMAGINE,PROCESSESED,SCORE_VOTING_S1,SCORE_VOTING_S2,SCORE_VOTING_S3,SCORE_VOTING_S4,MEASURES_SYSTEM1,MEASURES_SYSTEM2,MEASURES_SYSTEM3,MEASURES_SYSTEM4,FINAL_SC_CALCULATED
from
(
select 
----source system  1 without common records from other data sources
SYSDATE AS DT_LOAD,
s1.GENRE AS GENRE,
s1.YEAR ,
s1.TITLE AS MOVIE_TITLE,
s1.RATING as RATING_SYSTEM1,
0 as RATING_SYSTEM2,
0 as RATING_SYSTEM3,
0 as RATING_SYSTEM4,
s1.ID AS ID_SYSTEM1,
-1 as ID_SYSTEM_2,
 -1 as ID_SYSTEM_3,
 -1 as ID_SYSTEM_4  ,
'1' IF_IS_SYSTEM1_FLG, 
'0' IF_IS_SYSTEM2_FLG,
'0' IF_IS_SYSTEM3_FLG,
'0' IF_IS_SYSTEM4_FLG,
0 AS ID_SOUND,
0 AS ID_IMAGINE,
0 AS PROCESSESED,
S1.VOTES SCORE_VOTING_S1,
0 SCORE_VOTING_S2,
0 SCORE_VOTING_S3,
0 SCORE_VOTING_S4,
0 MEASURES_SYSTEM1,
0 MEASURES_SYSTEM2,
0 MEASURES_SYSTEM3,
0 MEASURES_SYSTEM4,
0 FINAL_SC_CALCULATED
 from IMDB_TMP s1
where s1.TITLE||s1.year in
(
select title||year from IMDB_TMP
minus
select keye  from
( 
select  t1.movie_nm||t1.dt_mv_produced   as keye, upper(t1.MOVIE_GEN_DESC)||','||upper(t2.MOVIE_GEN_DESC) as genre
from PLATFORM_1 t1, PLATFORM_2 t2
where t1.dt_mv_produced = t2.dt_mv_produced
and
upper(nvl(t1.movie_nm,0)) = upper(nvl(t2.movie_nm,0))
))
union all
select
----source system 2 without common records from other data sources
SYSDATE AS DT_LOAD,
s2.genre,
s2.year, 
s2.title as movie_title,
0 as RATING_SYSTEM1,
s2.total_ratings as RATING_SYSTEM2,
0 as RATING_SYSTEM3,
0 as RATING_SYSTEM4,
-1 AS ID_SYSTEM1,
 s2.id_movi  as ID_SYSTEM_2,
 -1 as ID_SYSTEM_3,
 -1 as ID_SYSTEM_4  ,
  '0' IF_IS_SYSTEM1_FLG,
  '1' IF_IS_SYSTEM2_FLG,
  '0' IF_IS_SYSTEM3_FLG,
  '0' IF_IS_SYSTEM4_FLG,
    0 AS ID_SOUND,
    0 AS ID_IMAGINE,
    0 AS PROCESSESED,
    0 SCORE_VOTING_S1,
s2.people_score as score_voting2 ,
    0 SCORE_VOTING_S3,
    0 SCORE_VOTING_S4,
    0 MEASURES_SYSTEM1,
    0 MEASURES_SYSTEM2,
    0 MEASURES_SYSTEM3,
    0 MEASURES_SYSTEM4,
    0 FINAL_SC_CALCULATED
 from ROTEN_TMP s2
where s2.TITLE||s2.year in
(
select title||year from ROTEN_TMP
minus
select keye  from
( 
select  t1.movie_nm||t1.dt_mv_produced   as keye, upper(t1.MOVIE_GEN_DESC)||','||upper(t2.MOVIE_GEN_DESC) as genre
from PLATFORM_1 t1, PLATFORM_2 t2
where t1.dt_mv_produced = t2.dt_mv_produced
and
upper(nvl(t1.movie_nm,0)) = upper(nvl(t2.movie_nm,0))
))
union all
select 
---common movies from multiple data sources 
SYSDATE AS DT_LOAD,
f_test(upper(c1.genre)||','||upper(c2.genre)),
c1.year, 
c1.title as movie_title,
c1.RATING as RATING_SYSTEM1,
c2.total_ratings as RATING_SYSTEM2,
0 as RATING_SYSTEM3,
0 as RATING_SYSTEM4,
 c1.ID AS ID_SYSTEM1,
 c2.id_movi  as ID_SYSTEM_2,
 -1 as ID_SYSTEM_3,
 -1 as ID_SYSTEM_4  ,
  '1' IF_IS_SYSTEM1_FLG,
  '1' IF_IS_SYSTEM2_FLG,
  '0' IF_IS_SYSTEM3_FLG,
  '0' IF_IS_SYSTEM4_FLG,
    0 AS ID_SOUND,
    0 AS ID_IMAGINE,
    0 AS PROCESSESED,
    c1.VOTES SCORE_VOTING_S1,
    c2.people_score as score_voting2 ,
    0 SCORE_VOTING_S3,
    0 SCORE_VOTING_S4,
    0 MEASURES_SYSTEM1,
    0 MEASURES_SYSTEM2,
    0 MEASURES_SYSTEM3,
    0 MEASURES_SYSTEM4,
    0 FINAL_SC_CALCULATED
from
(select * from IMDB_TMP) c1,
(select * from ROTEN_TMP) c2
where 
c1.title||c1.year in
(
select keye  from
( 
select  t1.movie_nm||t1.dt_mv_produced   as keye, upper(t1.MOVIE_GEN_DESC)||','||upper(t2.MOVIE_GEN_DESC) as genre
from PLATFORM_1 t1, PLATFORM_2 t2
where t1.dt_mv_produced = t2.dt_mv_produced
and
upper(nvl(t1.movie_nm,0)) = upper(nvl(t2.movie_nm,0))
)) and
c1.title||c1.year = c2.title||c2.year
)