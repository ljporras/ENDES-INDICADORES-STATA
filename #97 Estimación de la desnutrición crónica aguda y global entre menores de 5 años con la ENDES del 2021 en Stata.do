cd "D:\ENDES" 

 use                     rech23.dta, clear
 merge 1:1 HHID using rech0.dta, nogenerate
 save rech0_rech23.dta, replace
 
 use                         rech4.dta, clear
 rename IDXH4 HVIDX
 merge 1:1 HHID HVIDX  using rech1.dta, nogenerate
 rename HVIDX HC0  
 merge 1:1 HHID HC0    using rech6.dta
 rename _m rech6
 save rech1_rech4_rech6.dta, replace 
 
 use rech1_rech4_rech6.dta, clear
 merge m:1 HHID using rech0_rech23.dta
 save rech1_rech4_rech6_rech0_rech23.dta, replace
 
 
use rech1_rech4_rech6_rech0_rech23.dta, clear
/* 
Desnutrición crónica (talla para la edad o retardo del crecimiento).
Desnutrición aguda (peso para la talla)
Desnutrición global (peso para la edad)

hv103 Slept last night
hc70 Height/Age    standard deviation (new WHO)
hc72 Weight/Height standard deviation (new WHO)
hc71 Weight/Age    standard deviation (new WHO)
*/

sum HC70 HC71 HC72

label define sino 1 "Si" 0 "No"

*D. Cronica
gen          nt_ch_stunt=0 if HV103==1
replace      nt_ch_stunt=. if HC70>=9996
replace      nt_ch_stunt=1 if HC70<-200 & HV103==1 
label var    nt_ch_stunt "Desnutricion cronica total OMS"
label values nt_ch_stunt sino

gen          nt_ch_sev_stunt=0 if HV103==1
replace      nt_ch_sev_stunt=. if HC70>=9996
replace      nt_ch_sev_stunt=1 if HC70<-300 & HV103==1 
label var    nt_ch_sev_stunt "Desnutricion cronica severa OMS"
label values nt_ch_sev_stunt sino

*D. Aguda
gen          nt_ch_wast=0 if HV103==1
replace      nt_ch_wast=. if HC72>=9996
replace      nt_ch_wast=1 if HC72<-200 & HV103==1 
label var    nt_ch_wast "Desnutricion aguda total OMS"
label values nt_ch_wast sino

gen          nt_ch_sev_wast=0 if HV103==1
replace      nt_ch_sev_wast=. if HC72>=9996
replace      nt_ch_sev_wast=1 if HC72<-300 & HV103==1 
label var    nt_ch_sev_wast "Desnutricion aguda severa OMS"
label values nt_ch_sev_wast sino

*D. Global
gen          nt_ch_underwt=0 if HV103==1
replace      nt_ch_underwt=. if HC71>=9996
replace      nt_ch_underwt=1 if HC71<-200 & HV103==1 
label var    nt_ch_underwt "Desnutricion global total OMS"
label values nt_ch_underwt sino

gen          nt_ch_sev_underwt=0 if HV103==1
replace      nt_ch_sev_underwt=. if HC71>=9996
replace      nt_ch_sev_underwt=1 if HC71<-300 & HV103==1 
label var    nt_ch_sev_underwt	"Desnutricion global severa OMS"
label values nt_ch_sev_underwt sino

*Generando la variable quintil & dominio geografico
tab HV270
recode HV270 (1=1 "Q_infe")(2=2 "2do_quintil")(3=3 "3er_quintil") ///
(4=4 "4to_quintil")(5=5 "Q_super"), gen(quintil)

recode SHREGION (1 2=1 "Costa") (3=2 "Sierra")(4=3 "Selva"), generate(ambito)
label var ambito "Dominio geografico"

*Generando el factor de expansion
gen peso =HV005/1000000

*Establecemos el diseño muestral
svyset HV001 [w=peso], strata(HV022)

********************************************************************************
svy: tab HV025    nt_ch_wast, format(%12.1fc) percent row obs
svy: tab ambito   nt_ch_wast, format(%12.1fc) percent row obs
svy: tab HV024    nt_ch_wast, format(%12.1fc) percent row obs
svy: tab HC27     nt_ch_wast, format(%12.1fc) percent row obs
svy: tab quintil  nt_ch_wast, format(%12.1fc) percent row obs

svy: tab HV025  nt_ch_sev_wast, format(%12.1fc) percent row obs
svy: tab ambito nt_ch_sev_wast, format(%12.1fc) percent row obs
svy: tab HV024  nt_ch_sev_wast, format(%12.1fc) percent row obs


svy: tab HV025  nt_ch_stunt, format(%12.1fc) percent row obs
svy: tab ambito nt_ch_stunt, format(%12.1fc) percent row obs
svy: tab HV024  nt_ch_stunt, format(%12.1fc) percent row

svy: tab HV025  nt_ch_sev_stunt, format(%12.1fc) percent row obs
svy: tab ambito nt_ch_sev_stunt, format(%12.1fc) percent row obs
svy: tab HV024  nt_ch_sev_stunt, format(%12.1fc) percent row


svy: tab HV025   nt_ch_underwt, format(%12.1fc) percent row obs
svy: tab ambito  nt_ch_underwt, format(%12.1fc) percent row obs
svy: tab HV024   nt_ch_underwt, format(%12.1fc) percent row

svy: tab HV025   nt_ch_sev_underwt, format(%12.1fc) percent row obs
svy: tab ambito  nt_ch_sev_underwt, format(%12.1fc) percent row obs
svy: tab HV024   nt_ch_sev_underwt, format(%12.1fc) percent row obs
