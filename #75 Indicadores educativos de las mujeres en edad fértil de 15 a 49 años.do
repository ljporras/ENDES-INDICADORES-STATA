*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Descargar, descomprimir los sgtes archivos y pasarlos a Stata:
*Modulo66\rec0111, 
*Modulo66\rec91,

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
label define sino 0"No" 1"Si"
*Factor de expansion
gen wt=v005/1000000

*Educacion
//Nivel de educación 1/
tab v025 v149 [iweight=wt]  if v012>14, nofreq row
tab v190 v149 [iweight=wt]  if v012>14, nofreq row
	
//Alfabetismo
gen rc_litr_cats=v155
replace rc_litr_cats=5 if v106>1
label define rc_litr_cats 0 "No puede leer" 1 "Lee con dificultad 1/" 2 "Lee fácilmente" ///
3 "No hay tarjeta" 4"Prob visuales" 5 "Con Edu. secundaria o más"
label values rc_litr_cats rc_litr_cats
label var rc_litr_cats	"Nivel de Alfabetismo"
tab v025 rc_litr_cats [iweight=wt]  if v012>14, nofreq row
tab sregion rc_litr_cats [iweight=wt]  if v012>14, nofreq row

//No sigue estudiando
recode s112 (1 2=1 "Embarazo, matrimonio") ///
 (3 4 5 7=2 "Razones economicas, familiares") ///
 (8 9 13 =3 "Se gradúo/estudia en academia") ///
 (10 11=4 "No quiso estudiar") ///
 (6 12 96 98=5 "Otra"), gen(razon)
tab v025 razon [iweight=wt]  if v012>14, nofreq row


*Medio de comunicación: por lo menos una vez por semana
//Periódico o revista
recode v157 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_newsp)
label var rc_media_newsp "Periódico o revista"

//Televisión
recode v159 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_tv)
label var rc_media_tv "Televisión"

//Radio
recode v158 (2/3=1 "Yes") (0/1=0 "No"), gen(rc_media_radio)
label var rc_media_radio "Radio"

//Los 3 medios
gen rc_media_allthree=0
replace rc_media_allthree=1 if inlist(v157,2,3) & inlist(v158,2,3) & inlist(v159,2,3) 
label values rc_media_allthree sino
label var rc_media_allthree "Los 3 medios"

//Ningún medio de comunicación
gen rc_media_none=0
replace rc_media_none=1 if (v157!=2 & v157!=3) & (v158!=2 & v158!=3) & (v159!=2 & v159!=3) 
label values rc_media_none sino
label var rc_media_none "Ningún medio de comunicación"

tab v025 rc_media_newsp    [iweight=wt]  if v012>14, nofreq row
tab v025 rc_media_tv       [iweight=wt]  if v012>14, nofreq row
tab v025 rc_media_radio    [iweight=wt]  if v012>14, nofreq row
tab v025 rc_media_allthree [iweight=wt]  if v012>14, nofreq row
tab v025 rc_media_none     [iweight=wt]  if v012>14, nofreq row
