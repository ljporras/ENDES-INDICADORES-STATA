*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*Modulo66\rec0111 
*Modulo66\rec91
*Modulo67\rec21 
*Modulo69\rec41
*Modulo70\rec42

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "rec42", nogen
save rec0111_rec91_rec42.dta, replace

use rec21, clear
merge 1:1 caseid midx using "rec41", nogen
save rec21_rec41.dta, replace

use rec0111_rec91_rec42.dta, clear
merge 1:m caseid using "rec21_rec41", nogen


*Factor de expansion
gen wt=v005/1000000

*Generamos la variable EDADM
gen edadm=v008-b3
gen e_0a35=edadm<36
gen e_0a59=edadm<60

// Peso al nacer (Información basada en la tarjeta de salud o por información de la madre. La estimación corresponde solo a niñas y niños pesados.)
gen     pesonac=1 if m19<2500 &  v012>14
replace pesonac=2 if (m19>2499  & m19<=8000) &  v012>14
replace pesonac=3 if m19==9996 &  v012>14
replace pesonac=4 if m19==9998 &  v012>14
label define pesonac 1 "Menos de 2.5kg" 2 ">=2.5 kg" 3"No pesados al nacer" 4"No sabe, sin informacion"
label values pesonac pesonac

tab pesonac [iweight=wt] if e_0a59==1 
tab pesonac [iweight=wt] if e_0a59==1  & pesonac<3
tab v463a pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
tab v190 pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
tab etnia pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
tab lmaterna pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
tab v025 pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
tab sregion pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row

//Tamaño de la niña o niño al nacer 
recode m18 (5=1 "Muy pequeño") (4=2 "Menor que promedio") (1/2 =3 "Promedio o mayor") ///
 (8/9=9 "No sabe/ sin información") if v012>14, gen(ch_size_birth)
label var ch_size_birth "Tamaño de la niña o niño al nacer"
tab ch_size_birth [iweight=wt] if e_0a59==1
tab v463a ch_size_birth [iweight=wt] if e_0a59==1, nofreq row
tab v190 ch_size_birth [iweight=wt] if e_0a59==1, nofreq row
tab etnia ch_size_birth [iweight=wt] if e_0a59==1, nofreq row
tab lmaterna ch_size_birth [iweight=wt] if e_0a59==1, nofreq row
tab v025 pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
tab sregion pesonac [iweight=wt] if e_0a59==1 & pesonac<3, nofreq row
