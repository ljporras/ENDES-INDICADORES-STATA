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
merge m:1 CASEID using "rec0111", keep(master match) keepusing(V001 ///
V005 V012 V022 V024 V025 V149 V190) nogen
merge m:1 CASEID using "rec91", keep(master match) keepusing(SREGION S119 S108N) nogen


*Variables para cruzar:
 label define SREGION_NUM 1 "Lima_Metropolitana" 2 "Resto_Costa" ///
 3 "Sierra" 4 "Selva"
 label values SREGION SREGION_NUM
 label var SREGION "Región Natural"
 
 label define V025_NUM 1 "Urbano" 2 "Rural"
 label values V025 V025_NUM
 
 label define B4_NUM 1 "NIÑO" 2 "NIÑA"
 label values B4 B4_NUM
 
 label define V190_NUM 1 "Quintil inferior" 2 "Segundo quintil" /// 
 3 "Quintil intermedio" 4 "Cuarto quintil" 5 "Quintil superior"
 label values V190 V190_NUM
 
 label define V024_NUM 1 "Amazonas" 2 "Ancash" 3 "Apurímac" 4 "Arequipa" ///
 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" ///
10 "Huanuco" 11 "Ica" 12 "Junín" 13 "La Libertad" ///
14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" ///
18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" ///
22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali" 
label values V024 V024_NUM
  
 gen      educa=1 if V149<3
 replace  educa=2 if V149>2 & V149<5
 replace  educa=3 if V149==5
 label define educa_num 1 "Sin nivel/Primaria" 2 "Secundaria" 3 "Superior"
 label values educa educa_num

*Cambiando de mayúscula a minúscula
rename (QI478H5 QI478H6 QI478H7 QI478H9 QI478H10 QI478H11 QI478A QI478 ///
        QI478I5 QI478I6 QI478I7 ///
        QI478J5 QI478J6 QI478J7)  ///
	   (qi478h5 qi478h6 qi478h7 qi478h9 qi478h10 qi478h11 qi478a qi478 ///
	    qi478i5 qi478i6 qi478i7 ///
        qi478j5 qi478j6 qi478j7)


*24-36 meses 
*==========
/* qi478h5: Cuando (NOMBRE) hace un garabato o dibujo ¿dice lo que dibujó?: 
1=Si, 2=No, 8=No responde/No sabe
qi478h6: (NOMBRE) ¿imita lo que hace una
          persona o personaje cuando esta(este)
          no se encuentra presente?: 1=Si, 2=No, 8=No responde/No sabe
qi478h7: (NOMBRE) ¿le habla a sus
          muñecos o juguetes?: 1=Si, 2=No, 8=No responde/No sabe */

recode qi478h5 (1=1) (2=0) (else=.), gen(h5conv)
recode qi478h6 (1=1) (2=0) (else=.), gen(h6conv)
recode qi478h7 (1=1) (2=0) (else=.), gen(h7conv)

*qi478a=0: Vivir con su madre y No tener diagnóstico de una discapacidad...
*..permanente
gen h567 = h5conv + h6conv + h7conv if (qi478a==0 &(qi478>=24 & qi478<=36))

*Para el R7
recode h567 (0/2=0 "No")(3=1 "Si"),gen(R7)
lab var R7 "R7: niñ@s 24-36 meses que juegan y dibujan"   
	   
*V001: conglomerado, V022: estrato, peso=V005/1000000
gen peso = V005/1000000

tab R7 [iw=peso]   

tab R7 V025 [iw=peso], nofreq col

tab R7 SREGION [iw=peso], nofreq col

tab R7 B4 [iw=peso], nofreq col

tab R7 educa [iw=peso], nofreq col

tab R7 V190 [iw=peso], nofreq col
