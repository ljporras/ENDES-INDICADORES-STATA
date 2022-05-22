*Establecer carpeta de trabajo
cd "D:\ENDES" 

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*691-Modulo66.zip, replace
*691-Modulo67.zip, replace
*691-Modulo70.zip, replace

*Importar los archivos del formato dbf a Stata
import dbase DIT.dbf, clear
save         DIT.dta, replace
import dbase REC21.dbf, clear
save         REC21.dta, replace

import dbase REC0111.dbf, clear
save         REC0111.dta, replace
import dbase REC91.dbf, clear
save         REC91.dta, replace

*Debo dejar sin datos la menoria antes de ...
*..solucionar el problema de ñ y tildes

clear all
*Soluciono problemas de ñ y tildes
unicode analyze "DIT.dta"
unicode encoding set "latin1" 
unicode translate "DIT.dta"

*Soluciono problemas de ñ y tildes
unicode analyze "REC21.dta"
unicode encoding set "latin1" 
unicode translate "REC21.dta"

*Soluciono problemas de ñ y tildes
unicode analyze "REC0111.dta"
unicode encoding set "latin1" 
unicode translate "REC0111.dta"

*Soluciono problemas de ñ y tildes
unicode analyze "REC91.dta"
unicode encoding set "latin1" 
unicode translate "REC91.dta"

*Merge datasets:
use "DIT.dta", clear
merge 1:1 CASEID BIDX using "rec21", keep(master match) keepusing(B4) nogen   
*B4: Sexo del niño

merge m:1 CASEID      using "rec0111", keep(master match) keepusing(V001 ///
V005 V012 V022 V024 V025 V149 V190) nogen
*V001: Conglomerado
*V005: Factor Mujer -Sample weight
*V012: Edad actual
*V022: Estrato
*V024: Region
*V025: Lugar de residencia
*V149: Logro educativo
*V190: Índice de riqueza

merge m:1 CASEID      using "rec91", keep(master match) /// 
keepusing(SREGION S119 S108N) nogen
*SREGION: Región natural 
*S119: Idioma o lengua materna que aprendió hablar en su niñez 
*S108N: Nivel educativo aprobado
*Variables para cruzar:
label define SREGION_NUM 1 "Lima_Metropolitana" 2 "Resto_Costa" ///
 3 "Sierra" 4 "Selva"
label values SREGION SREGION_NUM
label var SREGION "Región Natural"
 
label define V025_NUM 1 "Urbano" 2 "Rural"
label values V025 V025_NUM
 
label define B4_NUM 1 "NIÑO" 2 "NIÑA"
label values B4 B4_NUM
 
label define V190_NUM 1 "Quintil inferior" 2 "Segundo quintil" 3 "Quintil intermedio" ///
 4 "Cuarto quintil" 5 "Quintil superior"
label values V190 V190_NUM
 
label define V024_NUM 1 "Amazonas" 2 "Ancash" 3 "Apurímac" 4 "Arequipa" ///
5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" ///
10 "Huanuco" 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" ///
16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" ///
22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali" 
label values V024 V024_NUM

gen        educa=1 if V149<3
replace  educa=2 if V149>2 & V149<5
replace  educa=3 if V149==5
label define educa_num 1 "Sin nivel/Primaria" 2 "Secundaria" 3 "Superior"
label values educa educa_num
*Cambiando de mayúscula a minúscula
rename (QI478A QI478 /// 
        QI478H9 QI478H10 QI478H11 ///
        QI478I5 QI478I6 QI478I7 ///
        QI478J5 QI478J6 QI478J7)  ///
	   (qi478a qi478 /// 
	    qi478h9 qi478h10 qi478h11 ///
	    qi478i5 qi478i6 qi478i7 ///
        qi478j5 qi478j6 qi478j7)


*Indicadores:
*24-36 meses
*==========
/*
qi478h9: Ella (él) llora, grita o hace pataleta la mayor parte del tiempo: 
1=Si, 2=No, 8=No responde/No sabe
qi478h10: Cuando ella (él) quiere algo y Ud. le dice que espere generalmente 
espera "tranquila(o)": 1=Si espera tranquilamente, 2=Si espera pero no 
tranquilamente, 3=No espera, 8=No responde/No sabe
qi478h11: Cuando ella (él) quiere algo y Ud. le dice que NO, 
generalmente se hace daño, agrede a los demás o daña las cosas: 
1=Si, 2=No, 8=No responde/No sabe   */

recode qi478h9  (1=0) (2=1)       (else=.), gen(h9conv)
recode qi478h10 (1=1) (2=0) (3=0) (else=.), gen(h10conv)
recode qi478h11 (1=0) (2=1)       (else=.), gen(h11conv)

*qi478a=0: Vivir con su madre y No tener diagnóstico de una discapacidad...
*..permanente
gen    h91011 = h9conv + h10conv + h11conv if (qi478a==0 & (qi478>=24 & qi478<=36))
recode h91011 (0/2=0 "No")(3=1 "Si"), gen(R6_24_36m)
lab var    R6_24_36m "niñ@s 24-36 meses que regulan sus emociones"
*lab values R4_9_12m R4_9_12m


*37-54 meses
*===========
/*
qi478i5: Ella (él) llora, grita o hace pataleta la mayor parte del tiempo: 
1=Si, 2=No, 8=No responde/No sabe
qi478i6: Cuando ella (él) quiere algo y Ud. le dice que espere generalmente 
espera "tranquila(o)": 1=Si espera tranquilamente, 2=No espera tranquilamente, 
3=No espera, 8=No responde/No sabe
qi478i7: Cuando ella (él) quiere algo y Ud. le dice que NO, 
generalmente se hace daño, agrede a los demás o daña las cosas: 
1=Si, 2=No, 8=No responde/No sabe    */

recode qi478i5 (1=0) (2=1)      (else=.), gen(i5conv)
recode qi478i6 (1=1) (2=0) (3=0)(else=.), gen(i6conv)
recode qi478i7 (1=0) (2=1)      (else=.), gen(i7conv)
gen i567 = i5conv + i6conv + i7conv if (qi478a==0 & (qi478>=37 & qi478<=54))
recode i567 (0/2=0 "No") (3=1 "Si"),gen(R6_37_54m)
lab var R6_37_54m "niñ@s 37-54 meses que regulan sus emociones"
*lab values R4_13_18m  R4_13_18m


*55-71 meses
*===========
/*
qi478j5: Ella (él) llora, grita o hace pataleta la mayor parte del tiempo: 
1=Si, 2=No, 8=No responde/No sabe
qi478j6: Cuando ella (él) quiere algo y Ud. le dice que espere generalmente 
espera "tranquila(o)": 1=Si espera tranquilamente, 2=No espera tranquilamente, 
3=No espera, 8=No responde/No sabe
qi478j7: Cuando ella (él) quiere algo y Ud. le dice que NO, 
generalmente se hace daño, agrede a los demás o daña las cosas: 
1=Si, 2=No, 8=No responde/No sabe   */

recode qi478j5 (1=0) (2=1)      (else=.), gen(j5conv)
recode qi478j6 (1=1) (2=0) (3=0)(else=.), gen(j6conv)
recode qi478j7 (1=0) (2=1)      (else=.), gen(j7conv)
gen j567 = j5conv + j6conv + j7conv if (qi478a==0 & (qi478>=55 & qi478<=71))
recode j567 (0/2=0 "No") (3=1 "Si"),gen(R6_55_71m)
lab var R6_55_71m "niñ@s 55-71 meses que regulan sus emociones"


*Para el R6
egen R6 = rowtotal(R6_24_36m R6_37_54m R6_55_71m) ///
	 if !missing(R6_24_36m) | !missing(R6_37_54m) |  ///
        !missing(R6_55_71m) 
	   
lab var R6 "Resultado 6: regula sus emociones"	   
lab define R6_num 1"Si" 0"No"
lab values R6 R6_num


*ESTABLECIENDO EL DISEÑO DE MUESTRA
*V001: conglomerado, V022: estrato, peso=V005/1000000
gen peso = V005/1000000
svyset V001 [pw=peso], strata(V022) vce(linearized) singleunit(centered)

tab R6 [iw=peso]  

tab R6 V025 [iw=peso], nofreq col

graph bar [aw=peso], over(R6) over(V025) asyvars blabel (bar, format(%9.1f)) ///
percentages title ("Niñ@s 24-71 meses que regula sus emociones por área de residencia")

tab R6 SREGION [iw=peso], nofreq col

graph bar [aw=peso], over(R6) over(SREGION) asyvars blabel (bar, format(%9.1f)) ///
percentages title ("Niñ@s 24-71 meses con comunicación efectiva por región natural")

tab R6 B4 [iw=peso], nofreq col

tab R6 educa [iw=peso], nofreq col

tab R6 V190 [iw=peso], nofreq col

tab V024 R6 [iw=peso], nofreq col
