/* La Encuesta Demográfica y de Salud Familiar-ENDES es una investigacion que se 
realiza en el marco del programa mundial de las Encuestas de Demografia y Salud (DHS)

a. Violencia fisica ejercida por el esposo o compahnero
	a.1 Empujo, sacudio o tiro algo (D105A)
	a.2 Abofeteo  (D105B)
	a.3 Golpeo con el puhno o algo que pudo dahnarla (D105C)
	a.4 Pateo o arrastro (D105D)
	a.5 Trato de estrangularla o quemarla (D105E)
	a.6 Amenazo con cuchillo, pistola u otra arma (D105F)
	a.7 Ataco, agredio con cuchillo, pistola u otra arma (D105G)
	a.8 Retorcio el brazo (D105J)
	
b. Violencia sexual
	b.1 obligadas a tener relaciones sexuales contra su voluntad (D105H)
	b.2 obligadas a realizar actos sexuales que no aprobaban (D105I)
	
c. Violencia psicologica y/o verbal
	c.1 Situaciones humillantes (D103A)
	c.2 Situaciones de control (D101A, D101B, D101C, D101D, D101E, D101F)
	c.3 Amenazas (D103B & D103D)
	
-Violencia ejercida alguna vez
-Violencia ejercida los ultimos 12 meses

*Factor Mujer (V005)
Este factor permite recomponer la estructura poblacional de las mujeres en edad fértil 
y está ajustado a la no respuesta, se utiliza para el cálculo de indicadores 
relacionados con esta poblacion, por ejemplo: Planificacion familiar de 
mujeres en edad fértil, parto institucional, demanda insatisfecha de planificacion familiar, 
control prenatal, entre otros. En la base de datos ENDES-2017 se encuentra en el modulo REC0111.

Fuentes:
Encuesta Demografica y de Salud Familia-ENDES 2017, Nacional y Departamental
https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib1525/index.html

Sintaxis De Programas De Los Indicadores Identificados En Los Programas Estratégicos
https://proyectos.inei.gob.pe/endes/recursos/endes2008_sintaxis.pdf

Guia de estadisticas del DHS (en ingles)
https://www.dhsprogram.com/Data/Guide-to-DHS-Statistics/index.cfm

El programa DHS proporciona la sintaxis en SPSS y Stata para generar 
los indicadores demograficos y de salud (en ingles)
https://github.com/DHSProgram
https://github.com/DHSProgram/DHS-Indicators-Stata/tree/master/Chap17_DV

Autor: Courtney Allen

Este archivo produce los siguientes cuadros en Excel:
Tables_DV_prtnr: experimento violencia por sus parejas y busqueda de ayuda */


*Configurar la carpeta en la que voy a trabajar
cd "D:\ENDES 2017"

*Bajar los modulos 73, 71, 70, 67 y 66 de la ENDES 2017
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/605-Modulo73.zip" 605-Modulo73.zip, replace
unzipfile 605-Modulo73.zip, replace

copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/605-Modulo71.zip" 605-Modulo71.zip, replace
unzipfile 605-Modulo71.zip, replace

copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/605-Modulo70.zip" 605-Modulo70.zip, replace
unzipfile 605-Modulo70.zip, replace

copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/605-Modulo67.zip" 605-Modulo67.zip, replace
unzipfile 605-Modulo67.zip, replace

copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/605-Modulo66.zip" 605-Modulo66.zip, replace
unzipfile 605-Modulo66.zip, replace

*Importar las bases en formato dbf al Stata
import dbase Modulo73\rec84dv.dbf, clear
save         2017_rec84dv.dta, replace

import dbase Modulo71\re516171.dbf, clear
save         2017_re516171.dta, replace

import dbase Modulo70\rec42.dbf, clear
save         2017_rec42.dta, replace

import dbase Modulo67\re223132.dbf, clear
save         2017_re223132.dta, replace

import dbase 605-Modulo66\rec91.dbf, clear
sort CASEID
save         605-Modulo66\rec91.dta, replace

import dbase 605-Modulo66\rec0111.dbf, clear
save         605-Modulo66\rec0111.dta, replace

*Unir las bases
use                             605-Modulo66\rec91.dta, clear
merge 1:1 CASEID      using     605-Modulo66\rec0111.dta, nogenerate
save 2017_rec91_rec0111.dta, replace

use                             2017_re223132.dta, clear
merge 1:1 CASEID      using     2017_rec42.dta, nogenerate
merge 1:1 CASEID      using     2017_re516171.dta, nogenerate
merge 1:1 CASEID      using     2017_rec84dv.dta, nogenerate
save 2017_re223132_rec42_re516171_rec84dv.dta, replace

use                     2017_rec91_rec0111.dta, clear
merge 1:1 CASEID  using 2017_re223132_rec42_re516171_rec84dv.dta
rename _m merge
save 2017_rec91_rec0111_re223132_rec42_re516171_rec84dv.dta, replace


*Seleccionar las variables con las que vamos a trabajar y las reetiquetamos en minusculas
use 2017_rec91_rec0111_re223132_rec42_re516171_rec84dv.dta, clear

rename (V044 V021 V002 V022 V005 V007 D101A D101B D101C D101D D101E D101F D101G D101H D101I D101J D105A D105B D105C D105D D105E D105F D105G D105H D105I D105J D105K D103A D103B D103D V012 V501 V502 V106 V201 V503 V701 D113 SREGION V025 V190 V481 D121 D104 D108 V013) (v044 v021 v002 v022 v005 v007 d101a d101b d101c d101d d101e d101f d101g d101h d101i d101j d105a d105b d105c d105d d105e d105f d105g d105h d105i d105j d105k d103a d103b d103d v012 v501 v502 v106 v201 v503 v701 d113 sregion v025 v190 v481 d121 d104 d108 v013)

*Generar factor de ponderacion
gen    peso=v005/1000000

label define yesno 0 "no" 1 "yes"

*Grupos de edad
gen          dv_age = v013
label define dv_age 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49"
label values dv_age dv_age
label var    dv_age "Grupos de edad"

label define v025 1 "Urbano" 2 "Rural"
label values v025 v025

label define sregion 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra" 4 "Selva"
label values sregion sregion
label var    sregion "Region Natural"


*VIOLENCIA FISICA EJERCIDA POR EL ESPOSO O COMPAHNERO
********************************************************************************
********************************************************************************
//Empujo, sacudio o tiro algo
		gen       dv_prtnr_push = 0 if v044==1 & v502>0
		replace   dv_prtnr_push = 1 if d105a>0 & d105a<=3
		label val dv_prtnr_push yesno
		label var dv_prtnr_push		"Empujo, sacudio o tiro algo"
tab dv_prtnr_push [iweight=peso]	
	
//Abofeteo
		gen       dv_prtnr_slap = 0 if v044==1 & v502>0
		replace   dv_prtnr_slap = 1 if d105b>0 & d105b<=3
		label val dv_prtnr_slap yesno
		label var dv_prtnr_slap		"Abofeteo"
tab dv_prtnr_slap [iweight=peso]	

//Golpeo con el puhno o algo que pudo dahnarla
		gen       dv_prtnr_punch = 0 if v044==1 & v502>0
		replace   dv_prtnr_punch = 1 if d105c>0 & d105c<=3
		label val dv_prtnr_punch yesno
		label var dv_prtnr_punch	"Golpeo con el puhno o algo que pudo dahnarla"
tab dv_prtnr_punch [iweight=peso]	

//Pateo o arrastro
		gen       dv_prtnr_kick = 0 if v044==1 & v502>0
		replace   dv_prtnr_kick = 1 if d105d>0 & d105d<=3
		label val dv_prtnr_kick yesno
		label var dv_prtnr_kick		"Pateo o arrastro"
tab dv_prtnr_kick [iweight=peso]	
		
//Trato de estrangularla o quemarla 
		gen       dv_prtnr_choke = 0 if v044==1 & v502>0
		replace   dv_prtnr_choke = 1 if d105e>0 & d105e<=3
		label val dv_prtnr_choke yesno
		label var dv_prtnr_choke	"Trato de estrangularla o quemarla"
tab dv_prtnr_choke [iweight=peso]	

//Amenazo con cuchillo, pistola u otra arma
		gen       dv_prtnr_weapon1 = 0 if v044==1 & v502>0
		replace   dv_prtnr_weapon1 = 1 if d105f>0 & d105f<=3
		label val dv_prtnr_weapon1 yesno
		label var dv_prtnr_weapon1	"Amenazo con cuchillo, pistola u otra arma"
tab dv_prtnr_weapon1 [iweight=peso]	

//Ataco, agredio con cuchillo, pistola u otra arma
		gen       dv_prtnr_weapon2 = 0 if v044==1 & v502>0
		replace   dv_prtnr_weapon2 = 1 if d105g>0 & d105g<=3
		label val dv_prtnr_weapon2 yesno
		label var dv_prtnr_weapon2	"Ataco, agredio con cuchillo, pistola u otra arma"
tab dv_prtnr_weapon2 [iweight=peso]	

//Retorcio el brazo
		gen       dv_prtnr_twist = 0 if v044==1 & v502>0
		replace   dv_prtnr_twist = 1 if d105j>0 & d105j<=3
		label val dv_prtnr_twist yesno
		label var dv_prtnr_twist	"Retorcio el brazo"
tab dv_prtnr_twist [iweight=peso]	
	

//Total
		gen dv_prtnr_phy = 0 if v044==1 & v502>0
		foreach x in a b c d e f g j {
			replace dv_prtnr_phy = 1 if d105`x'>0 & d105`x'<=3
			
			}
		label val dv_prtnr_phy yesno
		label var dv_prtnr_phy	"Violencia Fisica"
tab dv_prtnr_phy [iweight=peso]



*VIOLENCIA SEXUAL EJERCIDA POR EL ESPOSO O COMPAhnERO
**************************************************************
**************************************************************
//Esposo alguna vez la forzo a tener relaciones sexuales aunque no queria
		gen       dv_prtnr_force = 0 if v044==1 & v502>0
		replace   dv_prtnr_force = 1 if d105h>0 & d105h<=3
		label val dv_prtnr_force yesno
		label var dv_prtnr_force	"forzo a tener relaciones sexuales aunque no queria"
tab dv_prtnr_force [iweight=peso]
		
//Esposo alguna vez la obligo a realizar otros actos sexuales cuando no queria
		gen       dv_prtnr_force_act = 0 if v044==1 & v502>0
		replace   dv_prtnr_force_act = 1 if d105i>0 & d105i<=3
		label val dv_prtnr_force_act yesno
		label var dv_prtnr_force_act "obligo a realizar otros actos sexuales cuando no queria"
tab dv_prtnr_force_act [iweight=peso]
	
//Total
		gen dv_prtnr_sex = 0 if v044==1 & v502>0
		foreach x in h i k {
			replace dv_prtnr_sex = 1 if d105`x'>0  & d105`x'<=3
			}
		label val dv_prtnr_sex yesno
		label var dv_prtnr_sex	"Violencia Sexual"
tab dv_prtnr_sex [iweight=peso]


*VIOLENCIA PSICOLOGICA Y/O VERBAL EJERCIDA POR EL ESPOSO O COMPAhnERO
*****************************************************************************
*****************************************************************************
*Situaciones humillantes
		gen       dv_prtnr_humil = 0 if v044==1 & v502>0
		replace   dv_prtnr_humil = 1 if d103a>0 & d103a<=3
		label val dv_prtnr_humil yesno
		label var dv_prtnr_humil "Situaciones humillantes"
tab  dv_prtnr_humil [iweight=peso]

*Situaciones de control
//Es celoso o molesto
	gen       dv_prtnr_jeals = 0 if v044==1 & v502>0
	replace   dv_prtnr_jeals = 1 if d101a==1
	label val dv_prtnr_jeals yesno
	label var dv_prtnr_jeals "Es celoso o molesto"
tab dv_prtnr_jeals [iweight=peso]	

//Acusa de ser infiel
	gen       dv_prtnr_accus = 0 if v044==1 & v502>0
	replace   dv_prtnr_accus = 1 if d101b==1
	label val dv_prtnr_accus yesno
	label var dv_prtnr_accus "Acusa de ser infiel"
tab dv_prtnr_accus [iweight=peso]	

//Impide que visite o la visiten sus amistades/familiares
	gen       dv_prtnr_friends = 0 if v044==1 & v502>0
	replace   dv_prtnr_friends = 1 if d101c==1
	replace   dv_prtnr_friends = 1 if d101d==1
	label val dv_prtnr_friends yesno
	label var dv_prtnr_friends	"Impide que visite o la visiten sus amistades/familiares"
tab dv_prtnr_friends [iweight=peso]	

//Insiste en saber donde va
	gen       dv_prtnr_where = 0 if v044==1 & v502>0
	replace   dv_prtnr_where = 1 if d101e==1
	label val dv_prtnr_where yesno
	label var dv_prtnr_where "Insiste en saber donde va"
tab dv_prtnr_where [iweight=peso]	

//Desconfia con el dinero
	gen       dv_prtnr_money = 0 if v044==1 & v502>0
	replace   dv_prtnr_money = 1 if d101f==1
	label val dv_prtnr_money yesno
	label var dv_prtnr_money "Desconfia con el dinero"
tab  dv_prtnr_money [iweight=peso]	

//Algún control
	egen         dv_prtnr_cntrl = rowtotal(dv_prtnr_jeals dv_prtnr_accus dv_prtnr_where dv_prtnr_money dv_prtnr_friends) if v044==1 & v502>0
	recode       dv_prtnr_cntrl  (1/6=1)
	label val    dv_prtnr_cntrl  yesno 
	label var    dv_prtnr_cntrl "Algun control"
tab dv_prtnr_cntrl [iweight=peso]	


*Amenazas
//Amenaza con hacerle dahno
		gen       dv_prtnr_ame1 = 0 if v044==1 & v502>0
		replace   dv_prtnr_ame1 = 1 if d103b>0 & d103b<=3
		label val dv_prtnr_ame1 yesno
		label var dv_prtnr_ame1	"Amenaza con hacerle dahno"
tab dv_prtnr_ame1 [iweight=peso]	

//Amenaza con irse de casa, quitarle hijos, detener ayuda economica 
		gen       dv_prtnr_ame2 = 0 if v044==1 & v502>0
		replace   dv_prtnr_ame2 = 1 if d103d>0 & d103d<=3
		label val dv_prtnr_ame2 yesno
		label var dv_prtnr_ame2	"Amenaza con irse de casa, quitarle hijos, detener ayuda economica"
tab dv_prtnr_ame2 [iweight=peso]	
	

***Total Violencia psico-logica y/o verbal
		gen       dv_prtnr_psi = 0 if v044==1 & v502>0
        replace   dv_prtnr_psi =1 if dv_prtnr_humil == 1 | dv_prtnr_cntrl == 1 | dv_prtnr_ame1 ==1 |  dv_prtnr_ame2 == 1
		label val dv_prtnr_psi yesno
		label var dv_prtnr_psi "Violencia psicologica"
tab  dv_prtnr_psi [iweight=peso]



*VIOLENCIA TOTAL (FISICA, SEXUAL & PSICOLOGICA)
***************************************************
***************************************************
gen       dv_prtnr_vt = 0 if v044==1 & v502>0
replace   dv_prtnr_vt = 1 if dv_prtnr_phy==1 | dv_prtnr_sex==1 | dv_prtnr_psi ==1
label val dv_prtnr_vt yesno
label var dv_prtnr_vt "Violencia total"
tab       dv_prtnr_vt [iweight=peso]
tab       dv_prtnr_vt v025 [iweight=peso], nofreq col

*********************************************************************************
tabout dv_prtnr_*   using Tables_DV_prtnr.xls [iw=peso] , c(cell) oneway npos(col) nwt(peso) f(1) replace