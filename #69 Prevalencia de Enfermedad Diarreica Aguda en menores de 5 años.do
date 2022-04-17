*INCIDENCIA DE ENFERMEDAD DIARREICA AGUDA (EDA)

*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
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
gen edadm=v008-b3

recode edadm (0/5=1 "Menos de 6 meses")(6/11=2 "6-11")(12/23=3 "12-23") ///
 (24/35=4 "24-35")(36/47=5 "36-47")(48/59=6 "48-59")(nonm=.), gen(gedadm) 

recode h11(0 8=1 "No")(2=2 "Si") if b5==1 & edadm<60 & v012>14 , gen(eda)


tab eda [iweight=wt] 

tab gedadm eda         [iweight=wt], nofreq row

tab b4 eda             [iweight=wt], nofreq row

tab v463a eda          [iweight=wt], nofreq row

tab v190 eda           [iweight=wt], nofreq row

tab v025 eda           [iweight=wt], nofreq row

tab region_natural eda [iweight=wt], nofreq row

tab etnia eda [iweight=wt], nofreq row

tab lmaterna eda [iweight=wt], nofreq row
