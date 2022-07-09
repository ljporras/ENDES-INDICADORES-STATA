*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"


*Bajar, descomprimir los sgtes modulos y pasar los siguientes archivos a Stata:
*Modulo66\REC0111.dbf
*Modulo66\REC91.dbf
*Modulo71\re516171.dbf

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re516171", nogen

/*
V012 Edad actual
V013 Edad actual por grupos de 5 años
V501 Estado civil actual
V511 Edad al primer matrimonio
*/


*Factor de expansion
gen wt=v005/1000000

			
//Estado Marital
recode v501 (0=0 "Soltera") (1=1 "Casada") (2=2 "Conviviente") ///
(3 4 5=3 "Otro 1/"), gen(ms_mar_stat)
label var ms_mar_stat "Estado conyugal actual"

gen       ms_mar_never = 0
replace   ms_mar_never = 1 if v501==0
label var ms_mar_never "Nunca en unión"

tab  v025    ms_mar_stat [iweight=wt] if v012>14, nofreq row

tab  sregion ms_mar_stat [iweight=wt] if v012>14, nofreq row


**SE UNIERON ANTES DE CUMPLIR EDADES EXACTAS
recode v511 (.=0) (0/14 = 1 "si") (15/49 = 0 "no"), gen (ms_afm_15)
label var ms_afm_15 "Primera union antes de cumplir 15"

recode v511 (.=0) (0/17 = 1 "si") (18/49 = 0 "no"), gen (ms_afm_18)
replace ms_afm_18 = . if v012<18
label var ms_afm_18 "Primera union antes de cumplir 18"

recode v511 (.=0) (0/19 = 1 "si") (20/49 = 0 "no"), gen (ms_afm_20)
replace ms_afm_20 = . if v012<20
label var ms_afm_20 "Primera union antes de cumplir 20"

recode v511 (.=0) (0/21 = 1 "si") (22/49 = 0 "no"), gen (ms_afm_22)
replace ms_afm_22 = . if v012<22
label var ms_afm_22 "Primera union antes de cumplir 22"

recode v511 (.=0) (0/24 = 1 "si") (25/49 = 0 "no"), gen (ms_afm_25)
replace ms_afm_25 = . if v012<25
label var ms_afm_25 "Primera union antes de cumplir 25"

tab v013 ms_afm_15  [iweight=wt] if v012>14, nofreq row 
tab v013 ms_afm_18  [iweight=wt] if v012>14, nofreq row 
tab v013 ms_afm_20  [iweight=wt] if v012>14, nofreq row 
tab v013 ms_afm_22  [iweight=wt] if v012>14, nofreq row 
tab v013 ms_afm_25  [iweight=wt] if v012>14, nofreq row 

tab v013 ms_mar_never  [iweight=wt] if v012>14, nofreq row 
