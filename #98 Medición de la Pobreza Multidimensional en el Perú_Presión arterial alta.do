
*Especificamos nuestra carpeta de trabajo
cd "D:\Rutinas_PMultidimensional"

*Bajar los archivoz zipeados y los descomprimimos:
/*
*Bases de datos
copy "https://proyectos.inei.gob.pe/iinei/srienaho/descarga/STATA/854-Modulo1791.zip" ENDES.zip, replace

*Rutina de indicadores
copy "https://proyectos.inei.gob.pe/iinei/srienaho/descarga/DocumentosZIP/2023-188/4_Presion_arterial_alta_en_la_poblacion_de_15_anios_a_mas.zip" arterial.zip, replace
*/

use presion-2014-2022_tmp.dta, clear

gen     lima=.
replace lima=2 if hv024==7 
replace lima=1 if hv024==15 & shprovin==1 
replace lima=3 if hv024==15 & shprovin !=1
label define  lima  1"Provincia de Lima" 2"Callao" 3"Region Lima"
label val lima lima

recode qs23 (15 / 17=1)  (18 / 59=2) (60 /max=3),gen(grupos_edad1)
label define grupos_edad1 1 "15 - 17" 2 "18 - 59" 3 "60 +"
label val grupos_edad1 grupos_edad1
format grupos_edad1 %1.0f

/*
recode qs23 (15/ 19=1) (20 / 29=2) (30 / 39=3) (40 / 49=4) (50 / 59=5) (60 / max=6),gen (grupos_edad2)
label define grupos_edad2 1"15 - 19" 2"20 - 29" 3"30 - 39" 4"40 - 49" 5"50 - 59" 6"60 +"
label val grupos_edad2 grupos_edad2

recode qs23 (15 / 19=1) (20 / max=2), gen(grupos_edad3)
label define grupos_edad3 1"15 - 19" 2"20 +"
label val grupos_edad3 grupos_edad3

recode qs23 (15 / 19=1) (20 / max=2),gen(gedad2)
label define gedad2 1"15 - 19" 2"20 +"
label val gedad2 gedad2
*/


* Mujer embarazada
gen     pregnant=.
replace pregnant=0 if  qssexo==2  
replace pregnant=1 if  qssexo==2 & v213==1 

label define  pregnant 1"Embarazada" 0 "No embarazada"
label val pregnant pregnant

* Total de medidas de presion arterial
gen medida=9.
  replace medida=1 if qssexo==1 & (qs903s < 999 | qs903d < 999) & (qs905s==. | qs905d==.) & qs906==1
  replace medida=1 if qssexo==1 & (qs903s==. | qs903d==.) & (qs905s < 999 | qs905d < 999) & qs906==1 
  replace medida=2 if qssexo==1 & (qs903s < 999 & qs903d < 999) & (qs905s < 999 & qs905d < 999) & qs906==1

  replace medida=1 if pregnant==0 & (qs903s < 999 & qs903d < 999) & (qs905s==. & qs905d==.)  & qs906==1
  replace medida=1 if pregnant==0 & (qs903s==. | qs903d==.) & (qs905s < 999 & qs905d < 999)  & qs906==1
  replace medida=2 if pregnant==0 & (qs903s < 999 & qs903d < 999) & (qs905s < 999 & qs905d < 999) & qs906==1

label define medida 1"Una medida" 2"Dos medidas" 9"No medidos"

* Para las dos medidas de la presión arterial.
  gen     dif_pas=.
  replace dif_pas=qs905s if abs(qs903s-qs905s ) >=20 & medida==2 & qs906==1 
  replace dif_pas= (qs903s+qs905s)/2 if abs(qs903s-qs905s )  < 20  & medida==2 & qs906==1 

  recode dif_pas (min / 119.9=1) (120 / 139.9=2) (140/ 159.9=3) (160 / max=4 )if dif_pas>0 & medida==2 & qs906==1 ,gen(pas) 
  label define pas 1"Normal" 2"Pre hipertensión sistólica"  3 "Hipertensión sistólica estadio1" 4 "Hipertensión sistólica estadio2"
  label val  pas pas	
  
  gen     dif_pad=. 
  replace dif_pad=qs905d if  abs(qs903d-qs905d)>=10  & medida==2 & qs906==1 
  replace dif_pad= (qs903d + qs905d)/2 if  abs(qs903d-qs905d)  < 10   & medida==2 & qs906==1 
	
  recode dif_pad (min/ 79.9=1) (80/ 89.9=2) (90/ 99.9=3) (100/ max=4) if dif_pas>0 &  medida==2 & qs906==1 ,gen(pad)
  label define pad 1"Normal" 2"Pre hipertensión diastólica" 3"Hipertensión diastólica estadio1" 4"Hipertensión diastólica estadio2"
  label val pad pad

  
gen          ind1_1=0 if  medida==2 & qs906==1 
replace      ind1_1=1 if (pas >= 3 | pad >= 3 ) & medida==2 & qs906==1 
replace      ind1_1=. if pregnant==1 & medida==2 & qs906==1 
label var    ind1_1 "Presión Arterial Alta"
label define ind1_1 1"Tiene" 0"No tiene"
label val    ind1_1 ind1_1

gen filtro=(qsresinf==1 & qs23>=15 & qs906==1)


recode  ind1_1 (1=100)

table hv025 id1 [pw=peso] if filtro==1, c(mean ind1_1 ) row

table hv025 id1 [pw=peso] if filtro==1 & id1==2022, c(mean ind1_1 ) row

table hv024  [pw=peso] if filtro==1 & id1==2022, c(mean ind1_1 ) row

table  grupos_edad1  [pw=peso] if filtro==1 & id1==2022, c(mean ind1_1 ) row

table  lima  [pw=peso] if filtro==1 & id1==2022, c(mean ind1_1 ) row
