
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
*Modulo66\rec0111 
*Modulo66\rec91 
*Modulo67\rec21 
*Modulo70\rec43 
*Modulo70\rec95 

use rec21, clear
merge 1:1 caseid midx using "rec43", nogen
merge 1:1 caseid midx using "rec95", nogen
save rec21_rec43_rec95.dta, replace

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
save rec0111_rec91.dta, replace

merge 1:m caseid using "rec21_rec43_rec95", nogen

*Factor de expansion
gen wt=v005/1000000

*Edad
gen age=v008-b3
gen age6_59=age>5 & age<60
gen age6_35=age>5 & age<36

*Nivel de educacion de la madre
recode v106 (0 1=1 "Sin_nivel_Primaria")(2=2 "Secundaria") (3=3 "Superior"), gen(edumadre)

*Creamos etiqueta para los valores de las variables
label define sino 1 "Si" 0 "No"

//Recibió medicamento desparasitante en los últimos 12 meses
gen     nt_ch_micro_dwm= h43==1
replace nt_ch_micro_dwm=. if b5==0
label values nt_ch_micro_dwm sino 
label var nt_ch_micro_dwm "Recibió medicamento desparasitante en los últimos 12 meses"

//Recibió suplementos de hierro en los últimos 7 días 3/
gen     nt_ch_micro_iron= s465ea==1 | s465eb==1 | s465ec==1 | s465ed==1 
replace nt_ch_micro_iron=. if b5==0
label values nt_ch_micro_iron sino 
label var nt_ch_micro_iron "Recibió suplementos de hierro en los últimos 7 días 3/"


*Niñas y niños de 6 a 59 meses de edad 
*Desparasitante
tab v025     nt_ch_micro_dwm [iweight=wt]  if v012>14 & age6_59==1, nofreq row
tab sregion  nt_ch_micro_dwm [iweight=wt]  if v012>14 & age6_59==1, nofreq row

*Hierro
tab v025     nt_ch_micro_iron [iweight=wt] if v012>14 & age6_59==1 & b9==0, nofreq row
tab sregion  nt_ch_micro_iron [iweight=wt] if v012>14 & age6_59==1 & b9==0, nofreq row


*Niñas y niños de 6 a 35 meses de edad 
*Hierro
tab v025     nt_ch_micro_iron [iweight=wt] if v012>14 & age6_35==1 & b9==0, nofreq row
tab sregion  nt_ch_micro_iron [iweight=wt] if v012>14 & age6_35==1 & b9==0, nofreq row
tab edumadre nt_ch_micro_iron [iweight=wt] if v012>14 & age6_35==1 & b9==0, nofreq row

