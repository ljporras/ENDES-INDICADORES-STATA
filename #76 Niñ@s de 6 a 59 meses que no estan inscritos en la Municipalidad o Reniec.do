*niñ@s de 6 a 59 meses que no estan inscritos en la municipalidad/oficina del Reniec


*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar, descomprimir y exportar a Stata los archivos de los modulos 66, 67 y 69

use rec21, clear
merge 1:1 caseid midx using "rec94", nogen
save rec21_rec94.dta, replace

use rec0111.dta, clear
merge 1:m caseid using "rec21_rec94", nogen

*Extraido de la ficha tecnica de la ENDES
*Para la obtención de los indicadores con los softwares estadísticos actuales 
*para determinar el plan del diseño muestral (muestras complejas), 
*se debe considerar las siguientes variables:
*V001: conglomerado, V022: estrato, peso=V005/1000000

*Factor de expansion
gen wt=v005/1000000

*Edad
gen age=v008-b3
gen age6_59=age>5 & age<60

recode v106 (0 1=1 "Sin_nivel_Primaria")(2=2 "Secundaria") (3=3 "Superior"), gen(edumadre)

recode s430c (1 2 8=0 "Si")(0=100 "No"), gen(noinscrito) 
label var noinscrito "No inscritos en muni./of. Reniec"
 
svyset v001 [w=wt], strata(v022)

svy:                 mean noinscrito if v012>14 & age6_59==1

svy, over(v025):     mean noinscrito if v012>14 & age6_59==1

svy, over(edumadre): mean noinscrito if v012>14 & age6_59==1

