cd "E:\ENDES" 

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*638-Modulo64\rech0.dbf
*638-Modulo64\rech1.dbf
*638-Modulo64\rech4.dbf
*Modulo65\rech23.dbf
*638-Modulo74\RECH6.dbf


*UNIENDO LAS BASES DE DATOS
use                      Modulo65\rech23.dta, clear
merge 1:1 HHID using 638-Modulo64\rech0.dta, nogenerate
save rech0_rech23.dta, replace
 
use                         638-Modulo64\rech1.dta, clear
merge 1:1  HHID HC0  using  638-Modulo64\rech4.dta, nogenerate
merge 1:1  HHID HC0  using  638-Modulo74\RECH6.dta
rename _m rech6
save rech1_rech4_rech6.dta, replace
 
use rech1_rech4_rech6.dta, clear
merge m:1 HHID using rech0_rech23.dta
save rech1_rech4_rech6_rech0_rech23.dta, replace

  
*GENERANDO LAS VARIABLES USADAS EN LOS TABULADOS
use rech1_rech4_rech6_rech0_rech23.dta, clear
*Generando el PESO y luego lo expandimos (Utilizar la variable HV005A para calcular resultados departamentales)
gen peso =HV005/1000000

*Quintil de riqueza
tab HV270
label define HV270 1 "Quintil_inferior" 2 "Segundo_quintil" 3 "Quintil_intermedio" ///
 4 "Cuarto_quintil" 5 "Quintil_superior"
label values HV270 HV270

*Variables geograficas
tab HV025
label define HV025 1 "Urbano" 2 "Rural"
label values HV025 HV025

tab SHREGION 
label define SHREGION 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra" 4 "Selva"
label values SHREGION SHREGION
label var SHREGION "Region Natural"

gen      ambito=0
replace ambito=1 if SHREGION==1
replace ambito=2 if SHREGION==2
replace ambito=3 if SHREGION==3 & HV025==1
replace ambito=4 if SHREGION==3 & HV025==2
replace ambito=5 if SHREGION==4 & HV025==1
replace ambito=6 if SHREGION==4 & HV025==2
label define ambito 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra_urbana" ///
 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural"
label values ambito ambito
label var ambito "Dominio geografico"

destring UBIGEO, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
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
label define dpto 15 "Lima", add
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

* GENERANDO LA VARIABLE "ANEMIA" 
********************************************************************************
*HC1 Edad en meses
*HV103 ¿Durmió aquí anoche?
*HV040 Altitud del conglomerado en metros
*HC53 Nivel de hemoglobina (g-dl - 1 decimal)
*HC56 Nivel de Hemoglobina ajustado por altitud (g-dl - 1 decimal)
*HC57 Nivel de Anemia

*opcion 1
gen alt=(HV040/1000)*3.3
*Se ajusta el nivel de hemoglobina segun la altitud (alt)
gen HAJ= HC53/10 -(-0.032*alt + 0.022*alt*alt)
gen     ANEMIA=1 if (HAJ>1   & HAJ<11) &  HV103==1 & (HC1>5 & HC1<36) 
replace ANEMIA=2 if (HAJ>=11 & HAJ<94) &  HV103==1 & (HC1>5 & HC1<36) 
label define ANEMIA 1 "Anemia" 2 "No_anemia"
label values ANEMIA ANEMIA
tab HV025 ANEMIA [iweight=peso] , row

*opcion 2
gen     nt_ch_any_anem=0 if HV103==1 & (HC1>5 & HC1<36) 
replace nt_ch_any_anem=1 if HC56<110 & HV103==1 & (HC1>5 & HC1<36)
replace nt_ch_any_anem=. if HC56==. | HC56==999
cap label define yesno 0 "No" 1 "Si"
label values nt_ch_any_anem yesno
label var nt_ch_any_anem "Anemia - 6-35 meses"
tab HV025 nt_ch_any_anem [iweight=peso], row

* Anemia leve, moderada y severa
*1) Anemia: hemoglobina count is less than 11 grams per deciliter (g/dl) (hc57 in 1:3)
*2) Leve: hemoglobin count is between 10.0 and 10.9 grams per deciliter (g/dl) (hc57 = 3)
*3) Moderada: hemoglobin count is between 7.0 and 9.9 grams per deciliter (g/dl) (hc57 = 2)
*4) Severa: hemoglobin count is less than 7.0 grams per deciliter (g/dl) (hc57 = 1)

tab     HC57
gen     NV_ANEMIA=HC57 if HV103==1 & (HC1>5 & HC1<36) 
replace NV_ANEMIA=.    if HC57==9
label define NV_ANEMIA 1 "Severa" 2 "Moderada" 3 "Leve" 4 "No_anemia"
label values NV_ANEMIA NV_ANEMIA 
tab HV025 NV_ANEMIA [iweight=peso], row
tab SHREGION NV_ANEMIA [iweight=peso], row

* Establecemos el diseño muestral
svyset HV001 [w=peso], strata(HV022)
svy, over(HV025):    proportion ANEMIA
svy, over(SHREGION): proportion ANEMIA
svy, over(ambito):   proportion ANEMIA
svy, over(HV270):    proportion ANEMIA