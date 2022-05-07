
*Especificamos nuestra carpeta de trabajo
cd "F:\ENDES"

*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
*Modulo66\rec0111 
*Modulo66\rec91
*Modulo71\re516171

*Variables que necesitamos
*v005  "Factor de ponderación mujer"
*v025  "Tipo de lugar de residencia"
*v502  "Actualmente, antes o nunca casada"
*v605  "Deseo de tener más hijos"
*s119  "Idioma o lengua materna que aprendió hablar en su niñez"
*s119d "Por sus antepasados y costumbres, Ud. Se considera"

*Factor de expansion
gen wt=v005/1000000

*Mujeres actualmente unidas (casadas o convivientes)
recode  v502 (1=1)(0 2=2), gen(unidas)
label define sino 1 "Si" 2 "No"
label values unidas sino
label var unidas "Unidas"

*Preferencia de Fecundidad
recode v605  (5=1 "No quiere mas")(6=2 "Esterilizada")  (1=3 "Desea tener otro pronto") ///
 (2=4 "Desea tener otro pero más tarde")  (3=5 "Desea tener más, no sabe cuando") ///
 (4=6 "Indecisa") (7=7 "Infértil") if unidas==1, gen(pre_fe_1)
label var pre_fe_1 "Preferencia de Fecundidad en detalle"

recode v605 (5 6 =1 "No quiere")(1/3=2 "Desea más")(4 7=3 "Otro") if unidas==1, gen(pre_fe_2)
label var pre_fe_2 "Preferencia de Fecundidad"

tab  pre_fe_1 v025  [iweight=wt] if v012>14 , nofreq col
tab  pre_fe_1 etnia [iweight=wt] if v012>14 , nofreq col
tab  pre_fe_1 lmaterna [iweight=wt] if v012>14 , nofreq col


tab  pre_fe_2 v025  [iweight=wt] if v012>14 , nofreq col
tab  pre_fe_2 etnia [iweight=wt] if v012>14 , nofreq col
tab  pre_fe_2 lmaterna [iweight=wt] if v012>14 & lmaterna<3, nofreq col

graph hbar [aw=wt] if unidas==1 & v012>14 & lmaterna<3, over(pre_fe_2) over(lmaterna) ///
 asyvars blabel(bar, format(%9.1f)) percentages ytitle("Porcentaje") /// 
 title("Preferencia de Fecundidad en Mujeres" "de 15 a 49 años actualmente unidas," ///
 "según lengua materna") bar(1, color(pink*.8)) bar(2, color(pink*.3)) bar(3, color(gray)) bargap(10) 
