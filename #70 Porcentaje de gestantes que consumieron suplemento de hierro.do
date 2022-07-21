*GESTANTES QUE RECIBIERON SUPLEMENTO DE HIERRO

*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar y descomprimir los sgtes modulos:
*Modulo66\rec0111, 
*Modulo66\rec91, 
*Modulo67\re223132, 
*Modulo69\rec41, 

import dbase Modulo66\REC0111.dbf, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC0111.dta, replace

import dbase Modulo66\REC91.dbf, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC91.dta, replace

import dbase Modulo67\RE223132.dbf, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 RE223132.dta, replace

import dbase Modulo69\REC41.dbf, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 rec41.dta, replace

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re223132", nogen
merge 1:m caseid using "rec41", nogen
save rec0111_rec91_re223132_rec41.dta, replace

use rec0111_rec91_re223132_rec41.dta, clear
*Factor de expansion
gen wt=v005/1000000

recode v106 (0 1=1 "Sin nivel/Primaria") (2=2 "Secundaria") /// 
 (3=3 "Superior") if v012>14, gen(edu_madre)

gen     dominio=1 if region_natural==1 & v025==1 
replace dominio=2 if region_natural==1 & v025==2
replace dominio=3 if region_natural==2 & v025==1
replace dominio=4 if region_natural==2 & v025==2
replace dominio=5 if region_natural==3 & v025==1
replace dominio=6 if region_natural==3 & v025==2

label define dominio 1 "Costa urbana" 2 "Costa rural" 3 "Sierra urbana" ///
 4 "Sierra rural" 5 "Selva urbana" 6"Selva rural"
label values dominio dominio

*SE TOMA M13 PARA TOMAR EL ULTIMO NACIMIENTO
gen          hierro_emb=2 if m13>=0 & m13<99 & v012>14
replace      hierro_emb=1 if hierro_emb==2 & m45==1 & v012>14
label define hierro_emb 1"Si" 2"No"
label val    hierro_emb hierro_emb

tab hierro_emb 
tab hierro_emb [iweight=wt]  

tab v025 hierro_emb [iweight=wt] , nofreq row

tab region_natural hierro_emb [iweight=wt] , nofreq row

tab dominio hierro_emb [iweight=wt] , nofreq row

tab edu_madre hierro_emb [iweight=wt], nofreq row

tab v190 hierro_emb [iweight=wt], nofreq row

*Mujeres que tomó hierro por 90 días o más durante el embarazo
gen     nt_wm_micro_iron=.
replace nt_wm_micro_iron=0 if m45==0
replace nt_wm_micro_iron=1 if inrange(m46,0,59)
replace nt_wm_micro_iron=2 if inrange(m46,60,89)
replace nt_wm_micro_iron=3 if inrange(m46,90,300)
replace nt_wm_micro_iron=4 if m45==8 | m45==9 | m46==998 | m46==999
replace nt_wm_micro_iron=. if v208==0
label define nt_wm_micro_iron 0"No tomó" 1"<60" 2"60-89" 3"90+" 4"No sabe/missing"
label values nt_wm_micro_iron nt_wm_micro_iron
label var    nt_wm_micro_iron "# de dias que tomó hierro durante el ultimo embarazo"

tab      nt_wm_micro_iron [iweight=wt] if v012>14
tab v025 nt_wm_micro_iron [iweight=wt] if v012>14, nofreq row