*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos de la ENDES, descomprimir las carpetas y exportar los archivos a Stata:
*Modulo66\rec0111 
*Modulo67\rec21 
*Modulo69\rec41 

use rec21, clear
merge 1:1 caseid midx using "rec41", nogen
save rec21_rec41.dta, replace

use rec0111, clear
merge 1:m caseid using "rec21_rec41", nogen

*Factor de expansion
gen wt=v005/1000000

*Edad de las niñas y niños
gen age=v008-b3

//Intensidad de la lactancia
gen    inte= m35+ m36
recode inte (0/5=0)(nonmis=100), gen(intensidad)

*Total
sum intensidad m35 m36 [iweight=wt]  if v012>14 & age<6

*Sexo
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & b4==1
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & b4==2

*Quintil de riqueza
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & v190==1
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & v190==2
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & v190==3
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & v190==4
sum intensidad m35 m36 [iweight=wt] if v012>14 & age<6 & v190==5


//Alimentado con biberón: Edad 0-36 meses
recode age (0/1=1 "<2")(2/3=2 "2-3")(4/5=3 "4-5")(6/8=4 "6-8")(9/11=5 "9-11") ///
  (12/17=6 "12-17")(18/23=7 "18-23")(24/35=8 "24-35")(nonmis=.), gen(grupo0_36) 

tab grupo0_36 m38 [iweight=wt] if v012>14, nofreq row
