
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar, descomprimir y exportar a Stata los siguientes archivos:
*Modulo66\rec0111
*Modulo66\rec91
*Modulo70\REC42


*Unir los archivos

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "rec42", nogen

label define sino 0"No" 1"Si"

*Factor de expansion
gen wt=v005/1000000

*** Educacion ***
//Nivel de educación 1/
recode v149 (0=0 "Sin educación")(1 2=1 "Primaria")(3 4=2 "Secundaria") (5=3 "Superior"), gen(rc_edu)
label var rc_edu "Logro educativo"

*** Seguro de Salud ***
//ESSALUD
gen           rc_hins_ess = v481e==1
label value   rc_hins_ess sino
label var     rc_hins_ess "Tipo de seguro de salud: ESSALUD/IPSS"

//Seguro Integral de Salud
gen           rc_hins_sis = v481g==1
label value   rc_hins_sis sino
label var     rc_hins_sis "Tipo de seguro de salud: Seguro Integral de Salud"

//Fuerzas armadas/policiales
gen         rc_hins_fap = v481f==1
label value rc_hins_fap sino
label var   rc_hins_fap "Tipo de seguro de salud: fuerzas armadas/policiales"

//Entidad prestadora de salud
gen         rc_hins_eps = v481h==1
label value rc_hins_eps sino
label var   rc_hins_eps "Tipo de seguro de salud: entidad prestadora de salud"

//Otro
gen rc_hins_other=0
	foreach i in a b c d x {
	replace rc_hins_other=1 if v481`i'==1
	} 
label value rc_hins_other sino
label var   rc_hins_other "Tipo de seguro de salud: otro"

//Cualquier tipo de seguro de salud
gen rc_hins_any=0
	foreach i in a b c d e f g h x {
	replace rc_hins_any=1 if v481`i'==1
	}
label value rc_hins_any sino
label var   rc_hins_any "Cualquier tipo de seguro de salud"

//Ningun tipo de seguro de salud
gen         rc_hins_non=rc_hins_any==0
label value rc_hins_non sino
label var   rc_hins_non "Ningun tipo de seguro de salud"


tab   v025 rc_hins_ess  [iweight=wt]  if v012>14, nofreq row
tab   v025 rc_hins_sis  [iweight=wt]  if v012>14, nofreq row
tab   v025 rc_hins_non  [iweight=wt]  if v012>14, nofreq row

tab   v013 rc_hins_ess   [iweight=wt]  if v012>14, nofreq row
tab   v013 rc_hins_fap   [iweight=wt]  if v012>14, nofreq row
tab   v013 rc_hins_sis   [iweight=wt]  if v012>14, nofreq row
tab   v013 rc_hins_eps   [iweight=wt]  if v012>14, nofreq row
tab   v013 rc_hins_other [iweight=wt]  if v012>14, nofreq row
tab   v013 rc_hins_non   [iweight=wt]  if v012>14, nofreq row

tab   rc_edu rc_hins_ess   [iweight=wt]  if v012>14, nofreq row
tab   rc_edu rc_hins_fap   [iweight=wt]  if v012>14, nofreq row
tab   rc_edu rc_hins_sis   [iweight=wt]  if v012>14, nofreq row
tab   rc_edu rc_hins_eps   [iweight=wt]  if v012>14, nofreq row
tab   rc_edu rc_hins_other [iweight=wt]  if v012>14, nofreq row
tab   rc_edu rc_hins_non   [iweight=wt]  if v012>14, nofreq row

*Para hacerlo por quintiles usar la variable v190
*Para hacerlo por regiones natuales usar la variable sregion
