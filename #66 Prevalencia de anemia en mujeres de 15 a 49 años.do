
*Especificamos nuestra carpeta de trabajo
cd "E:\ANEMIA"

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*Modulo1631\REC0111
*Modulo1631\REC91
*Modulo1632\RE223132
*Modulo1634\REC42

 
use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "rec42", nogen
merge 1:1 caseid using "re223132", nogen
save rec0111_rec91_rec42_re223132.dta, replace
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
 26 "Lima Metropolitana 1/" 27 "Dpto de Lima 2/"
label values dpto dpto

//Total anemia
gen          nt_wm_any_anem=0 if v042==1 & v457<9 & v012>14
replace      nt_wm_any_anem=100 if v012>14 & v457<4 
label define yesno 0 "No" 100 "Si"
label values nt_wm_any_anem yesno
label var nt_wm_any_anem "Total con anemia- mujeres 15-49"


gen wt=v005a/1000000
 
*cierra cualquier archivo postfile que este abierto
cap postutil clear
postfile anemia str60(Grupo Subgrupo) Anemia using anemia.dta, replace
*Total
sum nt_wm_any_anem [iweight=wt] 
post anemia ("Total 2020") ("") (r(mean))

*Grupo de edad
sum nt_wm_any_anem [iweight=wt] if gedad==1
post anemia ("Edad") ("15-19") (r(mean))
sum nt_wm_any_anem [iweight=wt] if gedad==2
post anemia ("Edad") ("20-29") (r(mean))
sum nt_wm_any_anem [iweight=wt] if gedad==3
post anemia ("Edad") ("30-39") (r(mean))
sum nt_wm_any_anem [iweight=wt] if gedad==4
post anemia ("Edad") ("40-49") (r(mean))

*Número de nacidos vivos
sum nt_wm_any_anem [iweight=wt] if nvivo==0
post anemia ("Número de nacidos vivos") ("0") (r(mean))
sum nt_wm_any_anem [iweight=wt] if nvivo==1
post anemia ("Número de nacidos vivos") ("1") (r(mean))
sum nt_wm_any_anem [iweight=wt] if nvivo==2
post anemia ("Número de nacidos vivos") ("2-3") (r(mean))
sum nt_wm_any_anem [iweight=wt] if nvivo==3
post anemia ("Número de nacidos vivos") ("4-5") (r(mean))
sum nt_wm_any_anem [iweight=wt] if nvivo==4
post anemia ("Número de nacidos vivos") ("6 y más") (r(mean))

*Usando DIU
sum nt_wm_any_anem [iweight=wt] if v307_02==1
post anemia ("Usando DIU") ("Si") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v307_02~=1
post anemia ("Usando DIU") ("No") (r(mean))

*Consumo de cigarrillo de la madre
sum nt_wm_any_anem [iweight=wt] if v463a==1
post anemia ("Consumo de cigarrillo de la madre") ("Si") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v463a==0
post anemia ("Consumo de cigarrillo de la madre") ("No") (r(mean))

*Educacion
sum nt_wm_any_anem [iweight=wt] if v106==0
post anemia ("Educacion") ("Sin educación") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v106==1
post anemia ("Educacion") ("Primaria") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v106==2
post anemia ("Educacion") ("Secundaria") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v106==3
post anemia ("Educacion") ("Superior") (r(mean))

*Quintil de riqueza
sum nt_wm_any_anem [iweight=wt] if v190==1
post anemia ("Quintil de riqueza") ("Q1") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v190==2
post anemia ("Quintil de riqueza") ("Q2") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v190==3
post anemia ("Quintil de riqueza") ("Q3") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v190==4
post anemia ("Quintil de riqueza") ("Q4") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v190==5
post anemia ("Quintil de riqueza") ("Q5") (r(mean))

*Etnia
sum nt_wm_any_anem [iweight=wt] if etnia==1
post anemia ("Autoidentificación étnica") ("Origen nativo 2/") (r(mean))
sum nt_wm_any_anem [iweight=wt] if etnia==2
post anemia ("Autoidentificación étnica") ("Negro, moreno, zambo 3/") (r(mean))
sum nt_wm_any_anem [iweight=wt] if etnia==3
post anemia ("Autoidentificación étnica") ("Blanco") (r(mean))
sum nt_wm_any_anem [iweight=wt] if etnia==4
post anemia ("Autoidentificación étnica") ("Mestizo") (r(mean))
sum nt_wm_any_anem [iweight=wt] if etnia==5
post anemia ("Autoidentificación étnica") ("Otro/ No sabe") (r(mean))

*Lengua Materna
sum nt_wm_any_anem [iweight=wt] if lmaterna==1
post anemia ("Lengua Materna") ("Castellano") (r(mean))
sum nt_wm_any_anem [iweight=wt] if lmaterna==2
post anemia ("Lengua Materna") ("Lengua nativa 4/") (r(mean))
sum nt_wm_any_anem [iweight=wt] if lmaterna==3
post anemia ("Lengua Materna") ("Extranjera") (r(mean))

*Area de residencia
sum nt_wm_any_anem [iweight=wt] if v025==1
post anemia ("Area") ("Urbana") (r(mean))
sum nt_wm_any_anem [iweight=wt] if v025==2
post anemia ("Area") ("Rural") (r(mean))

*Region
sum nt_wm_any_anem [iweight=wt] if region_natural==1
post anemia ("Region") ("Costa") (r(mean))
sum nt_wm_any_anem [iweight=wt] if region_natural==2
post anemia ("Region") ("Sierra") (r(mean))
sum nt_wm_any_anem [iweight=wt] if region_natural==3
post anemia ("Region") ("Selva") (r(mean))

*Dpto
sum nt_wm_any_anem [iweight=wt] if dpto==1
post anemia ("Departamento") ("Amazonas") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==2
post anemia ("Departamento") ("Ancash") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==3
post anemia ("Departamento") ("Apurimac") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==4
post anemia ("Departamento") ("Arequipa") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==5
post anemia ("Departamento") ("Ayacucho") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==6
post anemia ("Departamento") ("Cajamarca") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==7
post anemia ("Departamento") ("Callao") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==8
post anemia ("Departamento") ("Cusco") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==9
post anemia ("Departamento") ("Huancavelica") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==10
post anemia ("Departamento") ("Huanuco") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==11
post anemia ("Departamento") ("Ica") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==12
post anemia ("Departamento") ("Junin") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==13
post anemia ("Departamento") ("La_Libertad") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==14
post anemia ("Departamento") ("Lambayeque") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==16
post anemia ("Departamento") ("Loreto") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==17
post anemia ("Departamento") ("Madre_de_Dios") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==18
post anemia ("Departamento") ("Moquegua") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==19
post anemia ("Departamento") ("Pasco") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==20
post anemia ("Departamento") ("Piura") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==21
post anemia ("Departamento") ("Puno") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==22
post anemia ("Departamento") ("San_Martin") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==23
post anemia ("Departamento") ("Tacna") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==24
post anemia ("Departamento") ("Tumbes") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==25
post anemia ("Departamento") ("Ucayali") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==26
post anemia ("Departamento") ("Lima Metropolitana 1/") (r(mean))
sum nt_wm_any_anem [iweight=wt] if dpto==27
post anemia ("Departamento") ("Dpto de Lima 2/") (r(mean))
*Cerramos el archivo postfile
postclose anemia

*Exportar a Excel
use                anemia.dta, clear
export excel using anemia.xlsx, sheet("Anemia") sheetreplace firstrow(variables)
