*Especificamos nuestra carpeta de trabajo
cd "D:\ENDES"

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*Modulo64\rech0.dbf
*Modulo66\rech23.dbf

*Uniendo las bases de datos
use                    Modulo64\rech0.dta, clear
merge 1:1 HHID  using  Modulo66\rech23.dta, nogenerate
*37,474 obs

*renombrando las variables a minusculas
rename (SHREGION HV002A) (shregion hv002a)
rename HV* hv*
rename SH* sh*
rename *A *a
rename *D *d
rename *E *e
rename *P *p

*Area de residencia
label define hv025 1 "Urbano" 2 "Rural"
label values hv025 hv025

*Region natural
label define shregion 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra" 4 "Selva"
label values shregion shregion
label var shregion "Region Natural"

*Crear el factor de ponderacion de los hogares
gen peso =hv005/1000000

*Crear etiqueta yesno
cap label define yesno 0 "No" 1 "Si"


*SERVICIOS BÁSICOS Y PRINCIPAL MATERIAL DEL PISO DE LAS VIVIENDAS, SEGÚN ÁREA DE RESIDENCIA
//Electricidad
gen ph_electric= hv206 
label values ph_electric yesno
label var ph_electric "Tiene electricidad"
tab ph_electric [iw=peso] if hv002a==1


//Fuente de agua para beber
gen ph_water=hv201
cap label define hv201 11 "Dentro de la vivienda" 12 "Fuera de la vivienda, pero dentro del edificio" 13 "Pilon/Grifo publico" 21 "Pozo en la vivienda/patio/lote" 22 "Pozo publico" 41 "Manantial (puquio)" 43 "Rio/acequia/laguna" 51 "Agua de lluvia" 61 "Camion cisterna" 71 "Agua embotellada" 96 "Otro"
label values ph_water hv201
label var ph_water "Fuente de agua para beber"
tab ph_water [iw=peso] if hv002a==1


//Tiempo para ir a fuente de agua 
recode hv204  (0 996 1/14 = 1 "< 15 minutos") (15/900 = 2 "de 15 minutos a mas")  (998 = 3 "no sabe"), gen(ph_wtr_time)
label var ph_wtr_time "Tiempo para ir a fuente de agua"
tab ph_wtr_time [iw=peso] if hv002a==1


//Servicio sanitario
cap label define hv205 11 "Dentro de la vivienda" 12 "Fuera de la vivienda, pero dentro del edificio" 21 "Letrina mejorada ventilada" 22 "Pozo septico" 23 "Letrina (pozo ciego o negro)" 24 "Letrina mejorada colgada/flotante" 31 "Rio, acequia o canal" 32 "Sin servicio (matorral/campo)" 96 "Otro"
label values hv205 hv205
gen    ph_sani_type=hv205
recode ph_sani_type (11 12=1) (21 22 23 24=2) (31 32 96=3)
cap label define sani 1 "Red Publica 1/" 2 "Letrina 2/" 3 "No hay servicio 3/"
label values ph_sani_type sani 
label var ph_sani_type "Servicio sanitario"
tab ph_sani_type [iw=peso] if hv002a==1


//Principal material del piso
gen ph_floor= hv213 
cap label define hv213 11 "Tierra/arena" 21 "Madera" 31 "Parquet o madera pulida" 32 "Laminas asfalticas, vinilicos o similares" 33 "Losetas, terrazos o similares" 34 "Cemento/ladrillo" 96 "Otro"
label values ph_floor hv213
label var ph_floor "Principal material de los pisos"
tab ph_floor [iw=peso] if hv002a==1


*Cuadros en excel
tabout ph_electric hv025 using Tables1.xls [iw=peso] if hv002a==1, c(col) f(2) clab(_ _ _) layout(rb) h3(nil) replace
tabout ph_water    hv025 using Tables1.xls [iw=peso] if hv002a==1, c(col) f(2) clab(_ _ _) layout(rb) h3(nil) append
tabout ph_wtr_time       using Tables1.xls [iw=peso] if hv002a==1, c(col) f(2) append
tabout ph_sani_type hv025 using Tables1.xls [iw=peso] if hv002a==1, c(col) f(2) clab(_ _ _) layout(rb) h3(nil) append
tabout ph_floor    hv025 using Tables1.xls [iw=peso] if hv002a==1, c(col) f(2) clab(_ _ _) layout(rb) h3(nil) append


*BIENES DE CONSUMO DURADERO DEL HOGAR, POR ÁREA DE RESIDENCIA
//Radio
gen ph_radio= hv207==1
label values ph_radio yesno
label var ph_radio "Radio"

//TV
gen ph_tv= hv208==1
label values ph_tv yesno
label var ph_tv "Televisor"

//Telefono residencial
gen ph_tel= hv221==1
label values ph_tel yesno
label var ph_tel "Telefono residencial"

//Refrigeradora
gen ph_frig= hv209==1
label values ph_frig yesno
label var ph_frig "Refrigeradora"

//Computadora
gen ph_comp= sh61p==1
label values ph_comp yesno
label var ph_comp "Computadora"
tab ph_comp hv025 [iw=peso], col nofre

//Bicicleta
gen ph_bike= hv210==1
label values ph_bike yesno
label var ph_bike "Bicicleta"

//Motocicleta
gen ph_moto= hv211==1
label values ph_moto yesno
label var ph_moto "Motocicleta"

//Carro/camion
gen ph_car= hv212==1
label values ph_car yesno
label var ph_car "Carro/camion"

//Bote a motor
gen ph_boat= hv243d==1
label values ph_boat yesno
label var ph_boat "Bote con motor"

tabout ph_radio ph_tv ph_tel ph_frig ph_comp ph_bike ph_moto ph_car ph_boat hv025 using Tables2.xls [iw=peso], c(col) f(1) clab(_ _ _) layout(rb) h3(nil) replace


*DISTRIBUCIÓN DE LOS HOGARES, POR ÁREA DE RESIDENCIA Y REGIÓN NATURAL, SEGÚN QUINTILES DE RIQUEZA

*Quintil de riqueza
label define hv270 1 "Quintil inferior" 2 "Segundo quintil" 3 "Quintil intermedio" 4 "Cuarto quintil" 5 "Quintil superior"
label values hv270 hv270 

tabout hv270 hv025 using   Tables3.xls [iw=peso] , c(col) f(2) clab(_ _ _) layout(rb) h3(nil) replace
tabout hv270 shregion using Tables3.xls [iw=peso] , c(col) f(2) clab(_ _ _) layout(rb) h3(nil) append
