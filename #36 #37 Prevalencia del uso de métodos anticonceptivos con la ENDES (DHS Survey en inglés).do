*Especificamos nuestra carpeta de trabajo
cd "D:\ENDES"

*Bajar los siguientes modulos, descomprimir las carpetas y pasar los archivos a Stata:
*Modulo66\rec91.dbf
*Modulo66\rec0111.dbf
*Modulo67\re223132.dbf
*Modulo71\re516171.dbf


*Uniendo los archivos ||| MERGE FILES
use     rec0111.dta, clear
*V005 V025 V190 V149
merge 1:1 CASEID using "rec91", keepusing(SREGION) nogen

merge 1:1 CASEID using "re516171", keepusing(V502) nogen

merge 1:1 CASEID using "RE223132", nogen

label var V005   "Factor Mujer -Sample weight"
label var V012   "Edad actual -Age in single years"


*Generando el PESO para luego expandirlo
*Woman's individual sample weight
gen peso=V005/1000000

*Área de residencia
*Urban/rural area
label define V025 1 "Urban" 2 "Rural"
label values V025 V025

*Región natural
label define SREGION 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra" 4 "Selva"
label values SREGION SREGION
label var SREGION "Region Natural"


*Quintil de riqueza
*Wealth index quintile
label define V190 1 "Quintil_inferior" 2 "Segundo_quintil"  ///
 3 "Quintil_intermedio" 4 "Cuarto_quintil" 5 "Quintil_superior"
label values V190 V190

*Nivel de educación
*Educational achievement recodes the education of the respondent into 
*the following categories: 1 (None, incomplete primary, complete primary),  
*2 (incomplete secondary, complete secondary) , 3 (higher education)
gen     educa=1 if V149<3
replace educa=2 if V149>2 &  V149<5
replace educa=3 if V149==5
label define educa 1 "Sin_nivel_Primaria" 2 "Secundaria" 3 "Superior"
label values educa educa


*Mujeres actualmente unidas (casadas o convivientes)
*Married women (married women and women in consensual unions)
recode  V502 (1=1)(0 2=2), gen(unidas)
label define sino 1 "SI" 2 "NO"
label values unidas sino
label var unidas "Unidas"

*Uso actual de métodos anticonceptivos
*Type of contraceptive method categorizes the current contraceptive method 
*as either a modern method, a traditional method, or a folkloric method

recode V313 (1 2 3=1)(0=2), gen(any_method)
label values any_method sino
label var any_method "Usa algun metodo"
tab any_method [iw=peso] if unidas==1 & V012>14

recode V313 (1 2=2)(3=1)(0=3), gen(usa_metodo)
label define usa_metodo 1 "Moderno" 2 "Tradicional_folklorico" 3 "No_usa"
label values usa_metodo usa_metodo
tab usa_metodo [iw=peso] if unidas==1 & V012>14

graph bar   [aw=peso] if unidas==1 & V012>14, over(usa_metodo) ///
 asyvars blabel(bar, format(%9.1f)) percentages ytitle("Percentages") /// 
 title("Mujeres de 15 a 49 años de edad actualmente unidas" ///
  "que usan algún Método de planificación familiar" " ")

graph bar   [aw=peso] if unidas==1 & V012>14, over(any_method) over(V025) ///
 asyvars blabel(bar, format(%9.1f)) percentages ytitle("Percentages") /// 
 title("Mujeres de 15 a 49 años de edad actualmente unidas" ///
  "que usan algún Método de planificación familiar" /// 
  "por área de residencia" " ")
  
graph bar   [aw=peso] if unidas==1 & V012>14, over(any_method) over(SREGION)  ///
 asyvars blabel(bar, format(%9.1f)) percentages ytitle("Percentages") /// 
 title("Mujeres de 15 a 49 años de edad actualmente unidas" ///
  "que usan algún Método de planificación familiar" /// 
  "por region natural" " ")
