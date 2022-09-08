*Especificamos nuestra carpeta de trabajo
cd "H:\ENDES2019"

*Bajar y descomprimmir los sgtes archivos
*REC0111.sav
*REC91.sav
*REC21.sav
*REC41.sav
*REC42.sav

import spss REC0111.sav, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC0111.dta, replace

import spss REC91.sav, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC91.dta, replace

import spss REC21.sav, clear
rename BIDX MIDX
sort CASEID MIDX
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC21.dta, replace

import spss REC41.sav, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC41.dta, replace

import spss REC42.sav, clear
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save 		 REC42.dta, replace


use  rec0111, clear
keep ubigeo caseid v001 v002 v003 v005 v008 v012 v022 v025 v106 v190 
save rec0111_aux,replace

use  rec91, clear
keep caseid sregion
save rec91_aux,replace

use  rec42, clear
keep caseid v404 v409* v410* v411* v412* v413* v414*
save rec42_aux,replace

use   rec91_aux, clear
merge 1:1 caseid using rec0111_aux, nogenerate
merge 1:1 caseid using rec42_aux, nogenerate
save  rec91_rec0111_rec42.dta, replace

use   rec21, clear
merge 1:1 caseid midx using rec41, nogenerate
keep  id1 caseid bord midx b0 b3 b4 b5 b9 m4 m38
save  rec21_rec41.dta, replace


use   rec91_rec0111_rec42, clear
merge 1:m caseid using rec21_rec41, nogen

*Variables que utilizaremos
*V001:  Conglomerado
*V002:  Número de vivienda
*V003:  Número de línea de entrevistada
*V005:  Factor de ponderación mujer
*V008:  Fecha de la entrevista, Codificación centenaria de meses (CMC)
*V012:  Edad actual - entrevistada
*V022:  Estratos
*V025:  Área de residencia
*V106:  Nivel educativo más alto
*V190:  Índice de riqueza
*B3:    Fecha de nacimiento, Codificación centenaria de meses (CMC)
*B9:    Con quien vive el niño (0: Entrevistada - 4: Vive en otro lugar)
*MIDX:  Orden de historia de nacimiento
*M4:    Duración de la lactancia
*M38:   El día de ayer o noche tomó algo en biberón
*V404:  Actualmente amamantando
*V409:  Ayer durante el dìa o la noche dio agua sola al niño
*V409A: Ayer durante el dìa o la noche dio agua azucarada
*V410:  Ayer durante el dìa o la noche dio jugo de fruta al niño
*V410A: Ayer durante el dìa o la noche dio al niño té o café
*V411:  Ayer durante el dìa o la noche dio al niño leche materna refrigerada/conservada
*V411A: Ayer durante el dìa o la noche dio al niño leche en polvo
*V412:  Ayer durante el dìa o la noche dio al niño otra leche fresca, evaporada o en polvo
*V412A: Ayer durante el dìa o la noche dio al niño cereales para bebes
*V412B: Ayer durante el dìa o la noche dio al niño otros cereales
*V413:  Ayer durante el dìa o la noche dio al niño otro líquido como bebidas gaseosas, caldo
*V413A: Ayer durante el dìa o la noche dio líquido CS infantil
*V413B: Ayer durante el dìa o la noche dio líquido CS infantil
*V413C: Ayer durante el dìa o la noche dio líquido CS infantil
*V413D: Ayer durante el dìa o la noche dio líquido CS infantil
*V414A: Ayer durante el dìa o la noche dio al niño naranjas mandarina, lima, otro
*V414B: Ayer durante el dìa o la noche dio al niño papillas de programas sociales
*V414C: Ayer durante el dìa o la noche dio al niño frutas secas
*V414D: Ayer durante el dìa o la noche dio alimentos CS para niños
*V414E: Ayer durante el dìa o la noche dio al niño harina, pan u cualquier comida hecha de cereales
*V414F: Ayer durante el dìa o la noche dio al niño comida hecha de tubérculos o raíces
*V414G: Ayer durante el dìa o la noche dio al niño huevos
*V414H: Ayer durante el dìa o la noche dio al niño carne res, pollo, pescado, otras 
*V414I: Ayer durante el dìa o la noche dio al niño camote, zanahorias, zapallo
*V414J: Ayer durante el dìa o la noche dio al niño cualquier vegetal de hoja verde oscuro
*V414K: Ayer durante el dìa o la noche dio al niño mango, papaya aguaje y otras frutas de vitamina A
*V414L: Ayer durante el dìa o la noche dio al niño otras frutas
*V414M: Ayer durante el dìa o la noche dio hígado, corazón y otros órganos al niño
*V414N: Ayer durante el dìa o la noche dio al niño pescado o mariscos
*V414O: Ayer durante el dìa o la noche dio al niño habas, frijol, lenteja, soya
*V414P: Ayer durante el dìa o la noche dio al niño queso, yogurt u otros productos lácteos
*V414Q: Ayer durante el dìa o la noche dio al niño comida hecha con aceite, grasas, mantequilla, productos hechos de ellos
*V414R: Ayer durante el dìa o la noche dio al niño alimento azucarado como chocolates, caramelos u otros
*V414S: Ayer durante el dìa o la noche dio al niño otro alimento sólido-semisólido
*V414T: Ayer durante el dìa o la noche dio alimentos CS para niños
*V414U: Ayer durante el dìa o la noche dio alimentos CS para niños


*Departamento
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
replace dpto=26 if dpto==15 & sregion==1
replace dpto=27 if dpto==15 & sregion~=1
label variable dpto "Departamento"
label define dpto 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" ///
 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huanuco" 11 "Ica" ///
 12 "Junin" 13 "La_Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" /// 
 17 "Madre_de_Dios" 18 "Moquegua"  19 "Pasco" 20 "Piura" 21 "Puno" 22 "San_Martin" ///
 23 "Tacna" 24 "Tumbes" 25 "Ucayali" 26 "Pro_Lima 4/" 27 "Reg_Lima 5/"
label values dpto dpto

*Educacion
recode v106 (0 1=1 "Sin_nivel /Primaria")(2=2 "Secundaria")(3=3 "Superior"), gen(edu)

*Quintil de riqueza
label define v190 1 "Quintil_inferior" 2 "Segundo_quintil"  ///
3 "Quintil_intermedio" 4 "Cuarto_quintil" 5 "Quintil_superior"
label values v190 v190

*Factor de expansion
gen wt=v005/1000000

*Edad de las niñas y niños
gen age=v008-b3


gen breast   =0
gen agua     =0
gen liquidos =0
gen leche    =0
gen solidos  =0
	
// Lactando
replace breast=1 if m4==95 

// Recibe agua
replace agua=1 if (v409>=1 & v409<=7) 
				   
// Recibe agua azucarada, jugos, te u otro
	foreach xvar of varlist v409a v410 v410* v413 {
	replace liquidos=1 if `xvar'>=1 & `xvar'<=7
	}
							 
// Leche no materna
	foreach xvar of varlist v411 v411a v412 v414p {
	replace leche=1 if `xvar'>=1 & `xvar'<=7
	}

// Complementos
*This is different than analyzing recode m39; look for country specific foods
	foreach xvar of varlist v414* {
	replace solidos=1 if `xvar'>=1 & `xvar'<=7
	}
replace solidos=1 if v412a==1 | v412b==1 

gen     diet=7
replace diet=0 if breast==0 //No está lactando
replace diet=1 if breast==1 & agua==0 & liquidos==0 & leche==0 & solidos==0 //Solo lactan
replace diet=2 if breast==1 & agua==1 & liquidos==0 & leche==0 & solidos==0 //Lactan y agua
replace diet=3 if breast==1 &           liquidos==1 & leche==0 & solidos==0 //Lactan y liquidos
replace diet=4 if breast==1 &                         leche==1 & solidos==0 //Lactan y Leche no materna
replace diet=5 if breast==1 &                         leche==0 & solidos==1 //Lactan y solidos
replace diet=5 if breast==1 &                         leche==1 & solidos==1 //Lactan, leche y solidos

label define diet 0 "No_lac" 1 "Lactan1/"  2 "Lac_agua" 3 "Lac_liqui" /// 
 4 "Lac_le_nomat" 5 "Lac_comple" 
label values diet diet

*Cuadro 10.3B: NIÑ@S MENORES DE 6, 10, 36 MESES DE EDAD CON LACTANCIA MATERNA
*POR AREA DE RESIENCIA, REG NATURAL, EDUCACION, QUINTIL DE RIQUEZA

*Multiplico la variable por 100 para presentarla como porcentaje
gen          lactan=diet==1
replace      lactan=100 if diet==1
label define lactan 0 "no" 100 "Lactan"
label values lactan lactan

tab v025    lactan [iweight=wt] if v012>14 & age<6 & midx==1 & b9==0, row nofreq
tab sregion lactan [iweight=wt] if v012>14 & age<6 & midx==1 & b9==0, row nofreq
tab edu     lactan [iweight=wt] if v012>14 & age<6 & midx==1 & b9==0, row nofreq
tab v190    lactan [iweight=wt] if v012>14 & age<6 & midx==1 & b9==0, row nofreq


*El comando postfile declara los nombres de las variables y 
*el nombre de un (nuevo) archivo de Stata donde se guardarán los resultados.
*cierra cualquier archivo postfile que este abierto
cap postutil clear

postfile lactan str60(Grupo Subgrupo) Porcentaje using lactan.dta, replace
/* Utilizamos el comando postfile para crear un espacio en la memoria 
con nombre brecha, en donde se almacenarán las observaciones de 4 variables 
(Grupo, Subgrupo, Sexo y Brecha digital) 
y que será una base de datos llamada brechadigital.dta. 
La opción replace especifica que el archivo brechadigital.dta 
se debe reemplazar, en caso de que ya exista. */

sum     lactan [w=wt] if  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("Total") ("") (r(mean)) 

sum     lactan [w=wt] if v025==1 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("Área de residencia") ("Urbano") (r(mean)) 
qui sum lactan [w=wt] if v025==2 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("") ("Rural") (r(mean))

qui sum lactan [w=wt] if sregion==1 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("Región natural") ("MML 1/") (r(mean)) 
qui sum lactan [w=wt] if sregion==2 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("") ("Resto_Costa") (r(mean)) 
qui sum lactan [w=wt] if sregion==3 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("") ("Sierra") (r(mean)) 
qui sum lactan [w=wt] if sregion==4 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("") ("Selva") (r(mean)) 

qui sum lactan [w=wt] if edu==1 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("Nivel de educación") ("Sin_nivel / Primaria") (r(mean)) 
qui sum lactan [w=wt] if edu==2 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("") ("Secundaria") (r(mean)) 
qui sum lactan [w=wt] if edu==3 &  v012>14 & age<6 & midx==1 & b9==0
post    lactan ("") ("Superior") (r(mean)) 


*Cerramos el archivo postfile
postclose lactan

*Exportar a Excel
use                lactan.dta, clear
export excel using lactan.xlsx, sheet("datos") sheetreplace firstrow(variables)
