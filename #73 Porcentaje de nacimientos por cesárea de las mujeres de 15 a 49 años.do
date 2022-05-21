*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajamos, descomprimimos los sgtes archivos y exportamos los archivos a Stata:
*Modulo66\rec0111, 
*Modulo66\rec91, 
*Modulo67\rec21, 
*Modulo69\rec41, 

use    rec0111.dta, clear
merge 1:1 caseid using "rec91", nogen
save rec0111_rec91.dta, replace

use    rec21.dta, clear
merge 1:1 caseid midx using "rec41"
keep if _m==3
drop _m
save rec21_rec41.dta, replace

use rec0111_rec91.dta, clear
merge 1:m caseid using "rec21_rec41"
keep if _m==3
drop _m
save rec0111_rec91_rec21_rec41.dta, replace

*Factor de expansion
gen wt=v005/1000000

*Orden de nacimiento
recode bord (1=1 "Primer Nacimiento")(2 3=2 "2-3")(4 5=3 "4-5")(nonm=4 "6 y más"),gen(orden_nac)

*Departamento
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
replace dpto=26 if dpto==15 & sregion==1
replace dpto=27 if dpto==15 & sregion~=1
label variable dpto "Departamento"
label define dpto 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho"  ///
 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin"  ///
 13 "La_Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre_de_Dios" 18 "Moquegua"  /// 
 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San_Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali" ///
 26 "Provincia de Lima" 27 "Región Lima 2/"
label values dpto dpto

*Edad en meses
gen    edadm=v008-b3
recode edadm (0/59=1), gen(edad_0a59)

tab v025 m17 [iweight=wt] if v012>14 & edad_0a59==1, nofreq row
tab sregion m17 [iweight=wt] if v012>14 & edad_0a59==1, nofreq row
tab v106 m17 [iweight=wt] if v012>14 & edad_0a59==1, nofreq row
tab v190 m17 [iweight=wt] if v012>14 & edad_0a59==1, nofreq row
tab dpto m17 [iweight=wt] if v012>14 & edad_0a59==1, nofreq row
