
cd "C:\ENAHO"

use  enaho01-2019-200, clear
gen      TI_5_17=0 if  (p208a >= 5 & p208a <= 17)
replace  TI_5_17=1 if ((p208a >= 5 & p208a <= 17) & ((p210==1) | (p210==2 & (t211~=9 & t211~=11)))) 
lab def  TI_5_17 0 "No trabaja" 1 "Si trabaja", modify
lab val  TI_5_17 TI_5_17

gen      hombre=p207==1
lab def  hombre 0 "Femenino" 1 "Masculino", modify
lab val  hombre hombre

gen      area=estrato
recode   area (1/5=1) (6/8=2)
lab def  area 1 "Urbana" 2 "Rural", modify
lab val  area area
lab var  area "Area de residencia"

gen            edad=1 if p208a>4  & p208a<14
replace        edad=2 if p208a>13 & p208a<18
label   define edad 1 "5-13" 2 "14-17" 
lab val        edad edad

*Departamento
*1/ Comprende los 43 distritos que conforman la provincia de Lima.
*2/ Comprende las provincias de Barranca, Cajatambo, Canta, Cañete, Huaral, Huarochirí, Huaura, Oyón y Yauyos.
destring ubigeo, generate(dpto)
replace dpto=dpto/10000  
replace dpto=round(dpto) 
replace dpto=151 if substr(ubigeo,1,4)=="1501"
label variable dpto "Departamento"
label define dpto 1 "Amazonas"
label define dpto 2 "Ancash", add
label define dpto 3 "Apurimac", add
label define dpto 4 "Arequipa", add
label define dpto 5 "Ayacucho", add
label define dpto 6 "Cajamarca", add
label define dpto 7 "Callao", add
label define dpto 8 "Cusco", add
label define dpto 9 "Huancavelica", add
label define dpto 10 "Huanuco", add
label define dpto 11 "Ica", add
label define dpto 12 "Junin", add
label define dpto 13 "La_Libertad", add
label define dpto 14 "Lambayeque", add
label define dpto 15 "Lima_region", add
label define dpto 151 "Lima_MML", add
label define dpto 16 "Loreto", add
label define dpto 17 "Madre_de_Dios", add
label define dpto 18 "Moquegua", add
label define dpto 19 "Pasco", add
label define dpto 20 "Piura", add
label define dpto 21 "Puno", add
label define dpto 22 "San_Martin", add
label define dpto 23 "Tacna", add
label define dpto 24 "Tumbes", add
label define dpto 25 "Ucayali", add
label values dpto dpto

*Establecemos las caracteristicas de la encuesta usando las variable factor de expansion, conglomerado y estrato
svyset [pweight=facpob07], psu(conglome) strata(estrato)
svy: tab        TI_5_17 ,  percent 
svy: tab hombre TI_5_17 ,  percent format(%10.3g) row
svy: tab area   TI_5_17 ,  percent format(%10.3g) row
svy: tab edad   TI_5_17 ,  percent format(%10.3g) row
svy: tab dpto   TI_5_17 ,  percent format(%10.3g) row

*Graficar el porcentaje de niños, niñas y adolescentes que trabajan (% de población con edades 5-17) por departamento
gen gra_TI_5_17=TI_5_17*100
graph bar gra_TI_5_17 [pweight=facpob07], over(dpto, sort(1) descending label(labsize(*0.5) angle(45))) ///
 title("Porcentaje de niños, niñas y adolescentes que trabajan (% de población con edades 5-17)," "según Región, 2019", justification(left) size(small) color(black)) ///
 ytitle("Porcentaje",size(vsmall)) ylabel(,labsize(vsmall)) yline(25.97, lwidth(0.4)) /// 
 blabel(total,size(vsmall) format(%5.3g)) ///
 note("Lima MML comprende los 43 distritos que conforman la provincia de Lima." "Lima region comprende las provincias de: Barranca, Cajatambo, Canta, Cañete, Huaral, Huarochirí, Huaura, Oyón y Yauyos.""Fuente: Encuesta Nacional de Hogares 2019",size(tiny)) ///
 saving(gra_TI_5_17, asis replace) 
 
*Cerrar archivo log 
log close
