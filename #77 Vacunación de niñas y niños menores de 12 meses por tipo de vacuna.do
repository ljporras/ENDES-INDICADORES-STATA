
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
*Modulo66\REC0111.dbf
*Modulo67\REC21.dbf
*Modulo70\REC43.dbf

use rec21, clear
merge 1:1 caseid midx using "rec43", nogen
save rec21_rec43.dta, replace

use rec0111.dta, clear
merge 1:m caseid using "rec21_rec43", nogen

*Factor de expansion
gen wt=v005/1000000

*Edad
gen age=v008-b3

*Fuente de información
recode h1 (1=1 "tarjeta") (else=2 "madre"), gen(source)

*Etiqueta
label define sino 1 "Si" 0 "No"


*Vacunación menores de 12 meses
*** BCG
//BCG -cualquier fuente
recode h2 (1 2 3=1) (else=0), gen(ch_bcg_either)

//BCG -reportada por la madre
gen     ch_bcg_moth=ch_bcg_either 
replace ch_bcg_moth=0 if source==1

//BCG -tarjeta de vacunación
gen     ch_bcg_card=ch_bcg_either
replace ch_bcg_card=0 if source==2

label values ch_bcg* sino

label var ch_bcg_card	"BCG -tarjeta de vacunación"
label var ch_bcg_moth	"BCG -reportada por la madre"
label var ch_bcg_either	"BCG -cualquier fuente"

tab ch_bcg_card [iweight=wt] if v012>14 & age<12 & b5==1
tab ch_bcg_moth [iweight=wt] if v012>14 & age<12 & b5==1
tab ch_bcg_either [iweight=wt] if v012>14 & age<12 & b5==1



*Vacunas que requieren mas de una dosis
gen dosis1=age>2
gen dosis2=age>4
gen dosis3=age>6

*** Pentavalente
//DPT 1, 2, 3 -cualquier fuente
recode h3 (1 2 3=1) (else=0), gen(dpt1)
recode h5 (1 2 3=1) (else=0), gen(dpt2)
recode h7 (1 2 3=1) (else=0), gen(dpt3)
gen dptsum= dpt1+dpt2+dpt3

*Este paso se realiza para vacunas que requieren mas de una dosis para 
*considerar cualquier vacio en la historia de vacunacion
gen ch_pent1_either=dptsum>=1 if  dosis1==1
gen ch_pent2_either=dptsum>=2 if  dosis2==1
gen ch_pent3_either=dptsum>=3 if  dosis3==1

//DPT 1, 2, 3 -reportada por la madre
gen     ch_pent1_moth=ch_pent1_either
replace ch_pent1_moth=0 if source==1 & dosis1==1

gen     ch_pent2_moth=ch_pent2_either
replace ch_pent2_moth=0 if source==1 & dosis2==1

gen     ch_pent3_moth=ch_pent3_either
replace ch_pent3_moth=0 if source==1 & dosis3==1

//DPT 1, 2, 3 -tarjeta de vacunacion
gen     ch_pent1_card=ch_pent1_either
replace ch_pent1_card=0 if source==2 & dosis1==1

gen     ch_pent2_card=ch_pent2_either
replace ch_pent2_card=0 if source==2 & dosis2==1

gen     ch_pent3_card=ch_pent3_either
replace ch_pent3_card=0 if source==2 & dosis3==1

drop dpt1 dpt2 dpt3 dptsum
label values ch_pent* sino

label var ch_pent1_card	  "Pentavalente 1ra dosis vacuna -tarjeta de vacunacion"
label var ch_pent1_moth	  "Pentavalente 1ra dosis vacuna -reportada por la madre"
label var ch_pent1_either "Pentavalente 1ra dosis vacuna -cualquier fuente"
label var ch_pent2_card	  "Pentavalente 2da dosis vacuna -tarjeta de vacunacion"
label var ch_pent2_moth	  "Pentavalente 2da dosis vacuna -reportada por la madre"
label var ch_pent2_either "Pentavalente 2da dosis vacuna -cualquier fuente"
label var ch_pent3_card	  "Pentavalente 3ra dosis vacuna -tarjeta de vacunacion"
label var ch_pent3_moth	  "Pentavalente 3ra dosis vacuna -reportada por la madre"
label var ch_pent3_either "Pentavalente 3ra dosis vacuna -cualquier fuente"

tab ch_pent1_card   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_pent1_moth   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_pent1_either [iweight=wt] if v012>14  & age<12 & b5==1

tab ch_pent2_card   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_pent2_moth   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_pent2_either [iweight=wt] if v012>14  & age<12 & b5==1

tab ch_pent3_card   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_pent3_moth   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_pent3_either [iweight=wt] if v012>14  & age<12 & b5==1


*** Polio ***
//polio  1, 2, 3 cualquier fuente
recode h4 (1 2 3=1) (else=0), gen(polio1)
recode h6 (1 2 3=1) (else=0), gen(polio2)
recode h8 (1 2 3=1) (else=0), gen(polio3)
gen poliosum=polio1 + polio2 + polio3

gen ch_polio1_either=poliosum>=1 if  dosis1==1
gen ch_polio2_either=poliosum>=2 if  dosis2==1
gen ch_polio3_either=poliosum>=3 if  dosis3==1

//polio 1, 2, 3 -reportada por la madre
gen     ch_polio1_moth=ch_polio1_either
replace ch_polio1_moth=0 if source==1 & dosis1==1

gen     ch_polio2_moth=ch_polio2_either
replace ch_polio2_moth=0 if source==1 & dosis2==1

gen     ch_polio3_moth=ch_polio3_either
replace ch_polio3_moth=0 if source==1 & dosis3==1

//polio 1, 2, 3 -tarjeta de vacunacion
gen     ch_polio1_card=ch_polio1_either
replace ch_polio1_card=0 if source==2 & dosis1==1

gen     ch_polio2_card=ch_polio2_either
replace ch_polio2_card=0 if source==2 & dosis2==1

gen     ch_polio3_card=ch_polio3_either
replace ch_polio3_card=0 if source==2 & dosis3==1

drop poliosum polio1 polio2 polio3
label values ch_polio* sino

label var ch_polio1_card   "Polio 1ra dosis vacuna -tarjeta de vacunacion"
label var ch_polio1_moth   "Polio 1ra dosis vacuna -reportada por la madre"
label var ch_polio1_either "Polio 1ra dosis vacuna -cualquier fuente"
label var ch_polio2_card   "Polio 2da dosis vacuna -tarjeta de vacunacion"
label var ch_polio2_moth   "Polio 2da dosis vacuna -reportada por la madre"
label var ch_polio2_either "Polio 2da dosis vacuna -cualquier fuente"
label var ch_polio3_card   "Polio 3ra dosis vacuna -tarjeta de vacunacion"
label var ch_polio3_moth   "Polio 3ra dosis vacuna -reportada por la madre"
label var ch_polio3_either "Polio 3ra dosis vacuna -cualquier fuente"

tab ch_polio1_card   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_polio1_moth   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_polio1_either [iweight=wt] if v012>14  & age<12 & b5==1

tab ch_polio2_card   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_polio2_moth   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_polio2_either [iweight=wt] if v012>14  & age<12 & b5==1

tab ch_polio3_card   [iweight=wt] if v012>14  & age<12 & b5==1
tab ch_polio3_moth   [iweight=wt] if v012>14  & age<12 & b5==1
