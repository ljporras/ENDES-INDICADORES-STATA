*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*Modulo66\rec0111 
*Modulo66\rec91
*Modulo67\rec21 
*Modulo70\rec42 
*Modulo70\rec43 

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "rec42", nogen
save rec0111_rec91_rec42.dta, replace

use rec21, clear
merge 1:1 caseid midx using "rec43", nogen
save rec21_rec43.dta, replace

use rec0111_rec91_rec42.dta, clear
merge 1:m caseid using "rec21_rec43", nogen

*Factor de expansion
gen wt=v005/1000000

*Generamos la variable EDADM
gen edadm=v008-b3 if v012>14

recode edadm (0/5=1 "Menos de 6 meses")(6/11=2 "6-11")(12/23=3 "12-23") ///
 (24/35=4 "24-35")(36/47=5 "36-47")(48/59=6 "48-59")(nonm=.), gen(gedadm) 

gen     ira0a59=0 if b5==1 & edadm<60
replace ira0a59=1 if b5==1 & edadm<60 & h31b==1 
label define ira0a59 0 "No" 1 "Si"
label values ira0a59 ira0a59

tab   ira0a59 [iweight=wt]
tab   gedadm       ira0a59 [iweight=wt], nofreq row
tab   b4           ira0a59 [iweight=wt], nofreq row
tab   v463a        ira0a59 [iweight=wt], nofreq row
tab   v190         ira0a59 [iweight=wt], nofreq row
tab v025           ira0a59 [iweight=wt], nofreq row
tab region_natural ira0a59 [iweight=wt], nofreq row
