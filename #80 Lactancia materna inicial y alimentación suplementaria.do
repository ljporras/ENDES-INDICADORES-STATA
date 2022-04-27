
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
*Modulo66\rec0111 
*Modulo66\rec91
*Modulo67\rec21 
*Modulo69\rec41 

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
save rec0111_rec91.dta, replace

use rec21, clear
merge 1:1 caseid midx using "rec41", nogen
save rec21_rec41.dta, replace

use rec0111_rec91, clear
merge 1:m caseid using "rec21_rec41", nogen

*Variables que utilizaremos
*MIDX: Orden de historia de nacimiento
*M4: Duración de la lactancia
*M34: Cuando empezó a darle el pecho al niño
*M55Z: Durante los primeros 3 días despues del parto, le dieron de tomar: nada

*Factor de expansion
gen wt=v005/1000000

*Edad de las niñas y niños
gen age=v008-b3

//Alguna vez lactó, entre todas las niñas y niños
recode m4 (94=0)(95 98=1)(nonmis=1), gen(lacta)
label define sino 1 "Si" 0 "No"
label values lacta sino
label var lacta "Lactó alguna vez"

tab  v025   lacta [iweight=wt] if v012>14  & age<60, nofreq row 


//Últimas nacidas y nacidos vivos que lactaron alguna vez:
recode m34 (0/100=1) (nonmiss=0) if lacta==1 & age<60 & midx==1, gen(lac_1hora)
label values lac_1hora sino
label var lac_1hora "Empezó dentro de la primera hora de nacido"

recode m34 (0/123=1) (nonmiss=0) if lacta==1 & age<60 & midx==1, gen(lac_1dia)
label values lac_1dia sino
label var lac_1dia "Empezó durante el primer día de nacido"

gen ali_lac=m55z==0 if lacta==1 & age<60 & midx==1
label values ali_lac sino
label var ali_lac "Recibió alimentos antes de empezar a lactar"

tab v025 lac_1hora [iweight=wt] if v012>14, nofreq row 
tab v025 lac_1dia  [iweight=wt] if v012>14, nofreq row 
tab v025 ali_lac   [iweight=wt] if v012>14, nofreq row 

tab sregion lac_1hora [iweight=wt] if v012>14, nofreq row 
tab sregion lac_1dia  [iweight=wt] if v012>14, nofreq row 
tab sregion ali_lac   [iweight=wt] if v012>14, nofreq row 
