*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar, descomprimir los sgtes modulos y pasar los siguientes archivos a Stata:
*Modulo66\REC0111.dbf
*Modulo66\REC91.dbf
*Modulo67\RE223132.dbf
*Modulo70\REC42.dbf
*Modulo71\re516171.dbf

	
use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re223132", nogen
merge 1:1 caseid using "rec42", nogen
merge 1:1 caseid using "re516171", nogen

/*
V012 Edad actual
V013 Edad actual por grupos de 5 años
V213 Esta actualmente embarazada
V226 Tiempo calculado desde el último período menstrual: 994 "En la menopausia" 
  995 "Antes del último nacimiento" 996 "Nunca menstruado" 997 "Inconsistente" 998 "No sabe"
V405 Actualmente amenorreico
V613 Número ideal de niños
*/


*Factor de expansion
gen wt=v005/1000000


**Número ideal de hijas y/o hijos
recode v613 (0=0 "0") (1=1 "1") (2=2 "2") (3=3 "3") (4=4 "4")(5/94=5 "5 y más") ///
 (95/99=9 "No especificado"), gen(ff_ideal_num) 
label var ff_ideal_num "Número ideal de hijas y/o hijos"

tab ff_ideal_num [iweight=wt] if v012>14

//Promedio ideal de hijas y/o hijos para todas las mujeres
table v025    v013 [iw=wt] if v613<95  & v012>14 , contents(mean v613) format(%9.1f) col row
table sregion v013 [iw=wt] if v613<95  & v012>14 , contents(mean v613) format(%9.1f) col row


**Menopausia: mujeres que no están embarazadas, y no están en amenorrea postparto 
*cuya última menstruación ocurrió 6 meses o más antes de la encuesta
//Mujeres 30-49 con Menopausia
label define sino 0 "No" 1 "Si"
gen       fe_meno = 0 if  v013>3
replace   fe_meno = 1 if (v226>5 & v226<997) & v213==0 & v405==0  & v013>3
label val fe_meno sino 
label var fe_meno "Mujeres menopáusicas"


//Mujeres menopáusicas por grupo de edad, 30-49, intervalo de 2 ahnos luego de los 40
egen         fe_meno_age = cut(v012), at(0 30 35 40 42 44 46 48 50)
label define fe_meno_age 30 "30-34" 35 "35-39" 40 "40-41" 42 "42-43" 44 "44-45" 46 "46-47" 48 "48-49"
label val    fe_meno_age fe_meno_age
label var    fe_meno_age "Mujeres menopáusicas por grupo de edad"
tab          fe_meno_age fe_meno [iweight=wt] if v012>29, nofreq row
	
