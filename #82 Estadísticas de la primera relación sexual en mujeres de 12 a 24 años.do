
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"


*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
*Modulo66\rec0111 
*Modulo66\rec91
*Modulo72\RE758081.dbf

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re758081", nogen

/*
V012 Edad actual
V013 Edad actual por grupos de 5 años
V820 En su primera relación sexual usaron condón
V830 Edad de la primera pareja sexual
*/

*Factor de expansion
gen wt=v005/1000000

//Uso Condon
recode v820 (0 8=2 "No/No sabe")(1=1 "Si"),gen(uso_condon)
tab v013    uso_condon  if v012<25
tab v013    uso_condon [iweight=wt] if v012<25, nofreq row
tab v025    uso_condon [iweight=wt] if v012<25, nofreq row
tab sregion uso_condon [iweight=wt] if v012<25, nofreq row


//Edad de la persona con la que tuvo relaciones
recode v830 (12/19 =1 "<20")(20/24=2 "20-24")(98=4 "No sabe")(nonmiss=3 ">24"),gen(edad_persona)
tab v013    edad_persona  if v012<25
tab v013    edad_persona [iweight=wt] if v012<25, nofreq row
tab v025    edad_persona [iweight=wt] if v012<25, nofreq row
tab sregion edad_persona [iweight=wt] if v012<25, nofreq row

