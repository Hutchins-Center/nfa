*** THIS FILE CONSTRUCTS DATA AND STATS FOR THE NEW EXTERNAL WEALTH DATASET (February 2019) ****

capture log close
 
* drop _all

set virtual on   

set more 1

set matsize 1600
* use "Q:\DOC\OE\CGER\Data\try_linked\nfa_2017\nfa_final_2017.dta", clear

sort ifs_code date

# delimit; 

* tsset ifs_code date;

**** DROP BELUX **;
drop if ifs_code==126;

*** drop Liechtenstein (duplication) **;

drop if ifs_code==147; 

*** drop Far Oer, ECCU etc ****=;

drop if ifs_code==309 | ifs_code==816;


* DEFINE REGIONAL DUMMIES * ;
g off=0;
replace off=1 if ifs_code==113 | ifs_code==117 | ifs_code==118 | ifs_code==135 | ifs_code==171 | ifs_code==313 | ifs_code==316 | ifs_code==319 | ifs_code==353 | ifs_code==354 | ifs_code==377 | ifs_code==379 | ifs_code==381  | ifs_code==718 | ifs_code==823;

******* DUMMY FOR OFFSHORE COUNTRIES NOT INCLUDED IN PAPER ON OFFSHORE CENTERS ****;
g off_lg=0;
replace off_lg=1 if ifs_code==112 | ifs_code==124 | ifs_code==137 | ifs_code==138 | ifs_code==146 | ifs_code==178 | ifs_code==181 | ifs_code==283 | ifs_code==419 | ifs_code==423 | ifs_code==532 | ifs_code==546 | ifs_code==576 | ifs_code==684;

*** DEFINE ADVANCED ECONOMIES EXCLUDING SMALL OFFSHORE CENTERS *****;
** note: the AE definition is the IMF one and thus includes Malta, Cyprus, Czech and Slovak republic, Slovenia, the Baltics, Israel, HK, Korea, Macao, SGP, Taiwan **;

g ind=1;
replace ind=0 if ifs_code>196 | ifs_code==186;
replace ind=0 if off==1; 
replace ind=0 if ifs_code==163;
replace ind=1 if ifs_code==423 | ifs_code==436 | ifs_code==528 | ifs_code==532 | ifs_code==546 | ifs_code==542 | ifs_code==576 | ifs_code==935 | ifs_code==936 | ifs_code==939 | ifs_code==941 | ifs_code==944 | ifs_code==961;

******** DEFINE AEs excluding FINANCIAL CENTERS **** ;
g ind_nfc=ind;
replace ind_nfc=0 if off_lg==1; 

******** DEFINE EMDEs excluding FINANCIAL AND OFFSHORE CENTERS ****; 

*** note: larger offshore centers such as Bahrain and Panama are thus excluded from EMDEs ***;

g dev=1;
replace dev=0 if ind==1 | off==1 | ifs_code==163 | off_lg==1;

g euro=0;
replace euro=1 if ifs_code==122 | ifs_code==124 | ifs_code==132 | ifs_code==134 | ifs_code==136 | ifs_code==137 | ifs_code==138 | ifs_code==172 | ifs_code==174 | ifs_code==178 | ifs_code==181 | ifs_code==182 | ifs_code==184 | ifs_code==423 | ifs_code==936 | ifs_code==961;
replace euro=1 if ifs_code==939 | ifs_code==941;

g ind_euro=ind;
replace ind_euro=1 if ifs_code==163;
replace ind_euro=0 if euro==1;

g othadv=0;

replace othadv=1 if (ifs_code==156 | ifs_code==158 | ifs_code==193 | ifs_code==196);

g otheur=0;
replace otheur=1 if (ifs_code==112 | ifs_code==128 | ifs_code==142 | ifs_code==144 | ifs_code==146 | ifs_code==176);

g north=0;
replace north=1 if ifs_code==128 | (ifs_code>140 & ifs_code<150) | ifs_code==176;

g anglo=0;
replace anglo=1 if (ifs_code==156 | ifs_code==193 | ifs_code==196);

g asia=1;
replace asia=0 if (ifs_code<500 | (ifs_code>600&ifs_code<800) | ifs_code>900) & ifs_code~=924;
replace asia=0 if off==1;
replace asia=0 if ind==1;

g em_asia=0;
replace em_asia=1 if (ifs_code==528 | ifs_code==532 | ifs_code==536 | ifs_code==542 | ifs_code==548 | ifs_code==566 | ifs_code==576 | ifs_code==578 | ifs_code==924);

g em_asia1=em_asia;

replace em_asia1=0 if ifs_code==924;
replace em_asia=0 if off==1;

g weshem=1;
replace weshem=0 if ifs_code<200 | ifs_code>399;
replace weshem=0 if off==1;

g weshem2=weshem;

replace weshem2=0 if (ifs_code==248 | ifs_code==299 | ifs_code==369);

g latam=weshem;

replace latam=0 if ifs_code>300;

g latam2=latam;

replace latam2=0 if ifs_code==263 | ifs_code==278 | ifs_code==268;

g carib=1;
replace carib=0 if ifs_code<300 | ifs_code>399;
replace carib=0 if off==1;

g c_am=0;

replace c_am=1 if ifs_code==238 | ifs_code==243 | ifs_code==253 | ifs_code==258 | ifs_code==263 | ifs_code==268 | ifs_code==278 | ifs_code==283;

g mideast=0;
replace mideast=1 if ifs_code>400 & ifs_code<500;
replace mideast=1 if ifs_code==672 | ifs_code==612 | ifs_code==686 | ifs_code==744;
replace mideast=0 if ifs_code==423;

g mideast1=mideast;
replace mideast1=0 if ifs_code==436;

g oil=mideast1;
replace oil=0 if ifs_code==439 | ifs_code==446 | ifs_code==463 | ifs_code==469 | ifs_code==487 | ifs_code==686 | ifs_code==744;
replace oil=1 if ifs_code==248 | ifs_code==299 | ifs_code==369 | ifs_code==516 | ifs_code==537 | ifs_code==614 | ifs_code==634 | ifs_code==642 
| ifs_code==646 | ifs_code==694 | ifs_code==628 | ifs_code==912 | ifs_code==916 | ifs_code==922 | ifs_code==925;

g afr=0;
replace afr=1 if ifs_code==199 | (ifs_code>600 & ifs_code<800);
replace afr=0  if ifs_code==672 | ifs_code==612 | ifs_code==686 | ifs_code==744;
replace afr=0 if off==1;

g trans=0;
replace trans=1 if ifs_code>900 & ifs_code~=924;

g em_eur_2=0;
replace em_eur_2=1  if ifs_code>934 & ifs_code~=961 & ifs_code~=936;
replace em_eur_2=1 if ifs_code==186 | ifs_code==914 | ifs_code==918 | ifs_code==926;
replace em_eur_2=0 if ifs_code==948;

g em_eur=em_eur_2;
replace em_eur=1 if ifs_code==922 | ifs_code==913 | ifs_code==921;
replace em_eur=0 if ind==1;


g fsu=0;
replace fsu=1 if trans==1 & em_eur==0;
replace fsu=0 if ind==1;

replace mideast1=1 if fsu==1;

g europe=1 if ifs_code<185;
replace europe=0 if ifs_code==111 | ifs_code==156 | ifs_code==158;
replace europe=1 if em_eur==1;
replace europe=0 if ifs_code==962 | ifs_code==963 | ifs_code==914 | ifs_code==965;

g dev_small=0;
replace dev_small=1 if ifs_code==186 | ifs_code==199 | ifs_code==213 | ifs_code==223 | ifs_code==228 | ifs_code==233 | ifs_code==273 | ifs_code==299 | ifs_code==534 | ifs_code==536 | ifs_code==542 | ifs_code==548 | ifs_code==564 | ifs_code==566 | ifs_code==578 | ifs_code==924;

g em_eur1=em_eur;
replace em_eur1=0 if oil==1;

g eur_def=em_eur1;
replace eur_def=1 if ifs_code==112 | ifs_code==136 | ifs_code==174 | ifs_code==176 | ifs_code==178 | ifs_code==182 | ifs_code==184 | ifs_code==936 | ifs_code==961;

gen eur_sur=0;
replace eur_sur=1 if ifs_code==122 | ifs_code==124 | ifs_code==128 | ifs_code==134 | ifs_code==137 | ifs_code==138 | ifs_code==144 | ifs_code==146 | ifs_code==172;

*** dummies for bilateral project ** ;
g em_asia_b=0;
replace em_asia_b=1 if (ifs_code==528  | ifs_code==536 | ifs_code==542 | ifs_code==548 | ifs_code==566 | ifs_code==578);

g em_asia_imb=em_asia_b;
replace em_asia_imb=1 if ifs_code==576 | ifs_code==532;

g oth_adv=0;
replace oth_adv=1 if ifs_code==128 | ifs_code==142 | ifs_code==144 | ifs_code==193 | ifs_code==196;

g oil_b=0;
replace oil_b=1 if ifs_code==612 | ifs_code==646 | ifs_code==672 | ifs_code==694;
replace oil_b=1 if ifs_code==419 | ifs_code==429 | ifs_code==443 | ifs_code==449 | ifs_code==453 | ifs_code==456 | ifs_code==466;

g bri=0;
replace bri=1 if ifs_code==223 | ifs_code==534 | ifs_code==922;

g dev_c=dev;
replace dev_c=0 if ifs_code==924;



*********CREATE LIDC GROUP ***************;
g lidc=0;
replace lidc=1 if ifs_code==218 | ifs_code==263 | ifs_code==268 | ifs_code==278 | ifs_code==474 | ifs_code==512 | ifs_code==513 | ifs_code==514 | ifs_code==518 | ifs_code==522 | ifs_code==544 | ifs_code==558 | ifs_code==582;
replace lidc=1 if ifs_code==813 | ifs_code==826 | ifs_code==853 | ifs_code==917 | ifs_code==921 | ifs_code==923 | ifs_code==927 | ifs_code==948;
replace lidc=1 if ifs_code>600 & ifs_code<800;
replace lidc=0 if ifs_code==612 | ifs_code==614 | ifs_code==616 | ifs_code==624 | ifs_code==642 | ifs_code==646 | ifs_code==672 | ifs_code==684 | ifs_code==686 | ifs_code==718 | ifs_code==726 | ifs_code==728 | ifs_code==728 | ifs_code==734 | ifs_code==744;

g emg=dev-lidc;


************ GENERATE ALL FINANCIAL CENTER GROUP *****;
g fc=0;
replace fc=1 if off==1 | off_lg==1;


*** SET EQUITY, FDI, DERIVATIVES TO ZERO IF DATA UNAVAILABLE BUT IIP DATA EXISTS ***
* replace ipfdia=0 if ipnfa~=. & ipfdia==. & date~=2015;
* replace ipeqa=0 if ipnfa~=. & ipeqa==.  & date~=2015;
* replace ipdera=0 if ipnfa~=. & ipdera==.  & date~=2015;
* replace ipfdil=0 if ipnfa~=. & ipfdil==.  & date~=2015;
* replace ipeql=0 if ipnfa~=. & ipeql==.  & date~=2015;
* replace ipderl=0 if ipnfa~=. & ipderl==.  & date~=2015;



*** SET K-INFLOWS TO 0 IF DATA UNAVAILABLE (FOR WORLD SUMS) ***;
replace fdil=0 if fdil==.;
replace ol=0 if ol==.;
replace pdl=0 if pdl==.;
replace eql=0 if eql==.;
replace fdia=0 if fdia==.;
replace oa=0 if oa==.;
replace pda=0 if pda==.;
replace eqa=0 if eqa==.;
replace fx=0 if fx==.;
replace fdia6=0 if fdia6==.;
replace fdil6=0 if fdil6==.;
replace pa=0 if pa==.;
replace pl=0 if pl==.;

*** make flows consistent with BOP6 sign ***;
replace fdia=-fdia;
replace fdia6=-fdia6;
replace eqa=-eqa;
replace fx=-fx;
replace dera=-dera;

*** replace FDI6 for FDI5 when latter unavailable ***;
replace fdia=fdia6 if (fdia==0 | fdia==.) & fdia6~=0;
replace fdil=fdil6 if (fdil==0 | fdil==.) & fdil6~=0;

** replace FDI5 for FDI6 when latter unavailable ***;
replace fdia6=fdia if (fdia6==0 | fdia6==.) & fdia~=0;
replace fdil6=fdil if (fdil6==0 | fdil6==.) & fdil~=0;

*** set derivatives=0 if unavailable *** ;
replace dera=0 if dera==.;
replace derl=0 if derl==.;
g der_net=dera-derl;

*** generate total K-inflows and outflows *** ; 
g k_in=fdil6+pl+ol-der_net;
g k_out=(fdia6+pa+oa+fx);

**** generate portfolio holdings if unavailable ****;
* replace ippdl=pdl_imfwb if ippdl==.;
* replace ippdl=ippdl[_n-1]+pdl if ippdl==. & ippdl[_n-1]~=. & ifs_code[_n]==ifs_code[_n-1];
* replace ippdl=max(cpis_pdl, wb_bonds, ids_bis) if (ippdl==. | ifs_code==319) & ifs_code~=312 & ifs_code~=314 & ifs_code~=351 & ifs_code~=668 & ifs_code~=733 & ifs_code~=826 & ifs_code~=867;
* replace ippdl=0 if ippdl==. & date>=1990; 


replace ipol=ipdebtl-ippdl;

* replace ippda=ippda[_n-1]+pda if ippda==. & ippda[_n-1]~=. & ifs_code[_n]==ifs_code[_n-1] & ifs_code~=316;
* replace ippda=cpis_pda if (ippda==. | ifs_code==319) & ifs_code~=316 & ifs_code~=846 & ifs_code~=867;
* replace ippda=pda_us+pda_oth if ippda==. & ifs_code~=867;
* replace ipoa=ipdebta-ippda if ifs_code~=316;

* replace ippda=ippda[_n+1]-pda[_n+1] if ippda==. & ippda[_n+1]~=. & pda[_n+1]~=. & ifs_code[_n]==ifs_code[_n+1] & ifs_code~=316;
* replace ippda=0.1*ipdebta if ippda==. & ipoa==. & ipdebta~=. & date>=1990 & date<=1999;
* replace ippda=0.1*ipdebta if ippda==. & ipoa==. & ipdebta~=. & date>=2000;
* replace ipoa=ipdebta-ippda if ipoa==. & ipdebta~=. & ippda~=.;

replace gdpd=gdpd[_n-1] if gdpd==. & date==2016;

replace gdpd=gdpd[_n-1] if gdpd==. & date==2017;
replace gdpd=gdpd[_n-1] if gdpd==. & date==2018;

* replace ippda=ippda[_n-1] if ippda==. & date==2018;
* replace ipoa=ipoa[_n-1] if ipoa==. & date==2018;
* replace ippdl=ippdl[_n-1] if ippdl==. & date==2018;
* replace ipol=ipol[_n-1] if ipol==. & date==2018;

** DEFINE RATIOS TO GDP ***;
g cay=ca/gdpd*100;
g ca_abs=abs(ca);
g fa=ca+eo;

g ipfay=ipfa/gdpd*100*e_eop/e_avg;
g ipfly=ipfl/gdpd*100*e_eop/e_avg;
g ipeqay=ipeqa/gdpd*100*e_eop/e_avg;
g ipeqly=ipeql/gdpd*100*e_eop/e_avg;
g ipfdiay=ipfdia/gdpd*100*e_eop/e_avg;
g ipfdily=ipfdil/gdpd*100*e_eop/e_avg;
g ipdebtay=ipdebta/gdpd*100*e_eop/e_avg;
g ipdebtly=ipdebtl/gdpd*100*e_eop/e_avg;
g ipfxy=ipfx/gdpd*100*e_eop/e_avg;
g ipderay=ipdera/gdpd*100*e_eop/e_avg;
g ipderly=ipderl/gdpd*100*e_eop/e_avg;
g ipnfay=ipnfa/gdpd*100*e_eop/e_avg;
g ipteqay=ipeqay+ipfdiay*e_eop/e_avg;
g ipteqly=ipeqly+ipfdily*e_eop/e_avg;
g neqy=ipteqay-ipteqly*e_eop/e_avg;
g ndebty=ipnfay-neqy*e_eop/e_avg;
g iipy=iip/gdpd*100*e_eop/e_avg;

g ippday=ippda/gdpd*100*e_eop/e_avg;
g ippdly=ippdl/gdpd*100*e_eop/e_avg;
g ipoay=ipoa/gdpd*100*e_eop/e_avg;
g ipoly=ipol/gdpd*100*e_eop/e_avg;

g nfay=ipnfa/gdpd;
g ipgfay=ipfay+ipfly;
g ipteqy=ipteqay+ipteqly;
g nfa_abs=abs(ipnfa);
g nfay_abs=nfa_abs/gdpd;
g gfa=(ipfa+ipfl)/1000;
g ca_absy=ca_abs/gdpd;

replace ipfay=ipfa/gdpd*100 if (e_eop==. | e_avg==.);
replace ipfly=ipfl/gdpd*100 if (e_eop==. | e_avg==.);
replace ipeqay=ipeqa/gdpd*100 if (e_eop==. | e_avg==.);
replace ipeqly=ipeql/gdpd*100 if (e_eop==. | e_avg==.);
replace ipfdiay=ipfdia/gdpd*100 if (e_eop==. | e_avg==.);
replace ipfdily=ipfdil/gdpd*100 if (e_eop==. | e_avg==.);
replace ipdebtay=ipdebta/gdpd*100 if (e_eop==. | e_avg==.);
replace ipdebtly=ipdebtl/gdpd*100 if (e_eop==. | e_avg==.);
replace ipfxy=ipfx/gdpd*100 if (e_eop==. | e_avg==.);
replace ipderay=ipdera/gdpd*100 if (e_eop==. | e_avg==.);
replace ipderly=ipderl/gdpd*100 if (e_eop==. | e_avg==.);
replace ipnfay=ipnfa/gdpd*100 if (e_eop==. | e_avg==.);
replace ipteqay=ipeqay+ipfdiay if (e_eop==. | e_avg==.);
replace ipteqly=ipeqly+ipfdily if (e_eop==. | e_avg==.);
replace neqy=ipteqay-ipteqly if (e_eop==. | e_avg==.);
replace ndebty=ipnfay-neqy if (e_eop==. | e_avg==.);
replace iipy=iip/gdpd*100 if (e_eop==. | e_avg==.);

replace ippday=ippda/gdpd*100 if (e_eop==. | e_avg==.);
replace ippdly=ippdl/gdpd*100 if(e_eop==. | e_avg==.);
replace ipoay=ipoa/gdpd*100 if (e_eop==. | e_avg==.);
replace ipoly=ipol/gdpd*100 if (e_eop==. | e_avg==.);

replace ipgfay=ipfay+ipfly;
replace ipteqy=ipteqay+ipteqly;


egen neqy_0407=mean(neqy) if date>2003 & date<2008,by(ifs_code);
egen ndebty_0407=mean(ndebty) if date>2003 & date<2008,by(ifs_code);
egen nfay_0407=mean(ipnfay) if date>2003 & date<2008,by(ifs_code);
egen cay_sd=sd(cay),by(date);


** GLOBAL VARIABLES (stocks AND FLOWS) *** ;

egen ipeqa_w=sum(ipeqa/1000) if ifs_code~=163,by(date);
egen ipeql_w=sum(ipeql/1000) if ifs_code~=163,by(date);
egen ipfdia_w=sum(ipfdia/1000) if ifs_code~=163,by(date);
egen ipfdil_w=sum(ipfdil/1000) if ifs_code~=163,by(date);
egen ipdebta_w=sum(ipdebta/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipdera_w=sum(ipdera/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipfx_w=sum(ipfx/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipdebtl_w=sum(ipdebtl/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipderl_w=sum(ipderl/1000) if ifs_code~=163 & ipfl~=.,by(date);
egen ipfa_w=sum(ipfa/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipfl_w=sum(ipfl/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipnfa_w=sum(ipnfa/1000) if ifs_code~=163 & ipnfa~=.,by(date);
egen gdpd_w=sum(gdpd/1000) if ifs_code~=163,by(date); 
egen nfa_abs_w=sum(nfa_abs/1000) if ifs_code~=163 & ipnfa~=.,by(date);
egen ippda_w=sum(ippda/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipoa_w=sum(ipoa/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ippdl_w=sum(ippdl/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ipol_w=sum(ipol/1000) if ifs_code~=163 & ipfa~=.,by(date);
egen ca_abs_w=sum(ca_abs/1000) if ifs_code~=163 & ca~=.,by(date);
egen ca_absy_w=median(ca_absy) if ifs_code~=163 & ca~=0,by(date);
egen eql_w=sum(eql/1000) if ifs_code~=163,by(date);
egen fdil_w=sum(fdil/1000) if ifs_code~=163,by(date);
egen pdl_w=sum(pdl/1000) if ifs_code~=163,by(date);
egen ol_w=sum(ol/1000) if ifs_code~=163,by(date);
egen nfay_abs_w=median(nfay_abs) if ifs_code~=163 & ipnfa~=0,by(date);
egen nfay_abs_w2=median(nfay_abs) if ifs_code~=163 & ipnfa~=0 & afr==0,by(date);
egen eqa_w=sum(eqa/1000) if ifs_code~=163,by(date);
egen fdia_w=sum(fdia/1000) if ifs_code~=163,by(date);
egen pda_w=sum(pda/1000) if ifs_code~=163,by(date);
egen oa_w=sum(oa/1000) if ifs_code~=163,by(date);
egen fx_w=sum(fx/1000) if ifs_code~=163,by(date);
egen dera_w=sum(dera/1000) if ifs_code~=163,by(date);
egen derl_w=sum(derl/1000) if ifs_code~=163,by(date);
egen fdia6_w=sum(fdia6/1000) if ifs_code~=163,by(date);
egen fdil6_w=sum(fdil6/1000) if ifs_code~=163,by(date);

*** euro area as a whole only *** ; 

egen ipeqa_w_euro=sum(ipeqa/1000) if euro==0,by(date);
egen ipeql_w_euro=sum(ipeql/1000) if euro==0,by(date);
egen ipfdia_w_euro=sum(ipfdia/1000) if euro==0,by(date);
egen ipfdil_w_euro=sum(ipfdil/1000) if euro==0,by(date);
egen ipdebta_w_euro=sum(ipdebta/1000) if euro==0 & ipfa~=.,by(date);
egen ipdera_w_euro=sum(ipdera/1000) if euro==0 & ipfa~=.,by(date);
egen ipfx_w_euro=sum(ipfx/1000) if euro==0 & ipfa~=.,by(date);
egen ipdebtl_w_euro=sum(ipdebtl/1000) if euro==0 & ipfa~=.,by(date);
egen ipderl_w_euro=sum(ipderl/1000) if euro==0 & ipfl~=.,by(date);
egen ipfa_w_euro=sum(ipfa/1000) if euro==0,by(date);
egen ipfl_w_euro=sum(ipfl/1000) if euro==0 & ipfa~=.,by(date);
egen ipnfa_w_euro=sum(ipnfa/1000) if euro==0,by(date);
egen gdpd_w_euro=sum(gdpd/1000) if euro==0 & ipnfa~=.,by(date); 
egen nfa_abs_w_euro=sum(nfa_abs/1000) if euro==0 & ipnfa~=.,by(date);
egen ippda_w_euro=sum(ippda/1000) if euro==0 & ipfa~=.,by(date);
egen ipoa_w_euro=sum(ipoa/1000) if euro==0 & ipfa~=.,by(date);
egen ippdl_w_euro=sum(ippdl/1000) if euro==0 & ipfa~=.,by(date);
egen ipol_w_euro=sum(ipol/1000) if euro==0 & ipfa~=.,by(date);
egen ca_abs_w_euro=sum(ca_abs/1000) if euro==0 & ca~=0,by(date);
egen ca_absy_w_euro=median(ca_absy) if euro==0 & ca~=0,by(date);
egen eql_w_euro=sum(eql/1000) if euro==0,by(date);
egen fdil_w_euro=sum(fdil/1000) if euro==0,by(date);
egen pdl_w_euro=sum(pdl/1000) if euro==0,by(date);
egen ol_w_euro=sum(ol/1000) if euro==0,by(date);

*** capital flows *** ;

egen k_in_w=sum(k_in/1000) if ifs_code~=163, by(date);
egen k_out_w=sum(k_out/1000) if ifs_code~=163, by(date);
egen k_in_i=sum(k_in/1000) if ind==1, by(date);
egen k_out_i=sum(k_out/1000) if ind==1, by(date);
egen k_in_d=sum(k_in/1000) if dev==1, by(date);
egen k_out_d=sum(k_out/1000) if dev==1, by(date);
egen k_in_w_euro=sum(k_in/1000) if euro==0, by(date);
egen k_out_w_euro=sum(k_out/1000) if euro==0, by(date);
egen k_in_i_euro=sum(k_in/1000) if ind_euro==1, by(date);
egen k_out_i_euro=sum(k_out/1000) if ind_euro==1, by(date);
egen k_in_off=sum(k_in/1000) if off==1, by(date);
egen k_out_off=sum(k_out/1000) if off==1, by(date);
egen k_in_off_lg=sum(k_in/1000) if off_lg==1, by(date);
egen k_out_off_lg=sum(k_out/1000) if off_lg==1, by(date);

************** INDUSTRIAL AND EMERGING MKT VARIABLES *****;

******* 1. ALL ADVANCED ECONOMIES **** ;
egen ipeqa_i=sum(ipeqa/1000) if ind==1,by(date);
egen ipeql_i=sum(ipeql/1000) if ind==1,by(date);
egen ipfdia_i=sum(ipfdia/1000) if ind==1,by(date);
egen ipfdil_i=sum(ipfdil/1000) if ind==1,by(date);
egen ipdebta_i=sum(ipdebta/1000) if ipfa~=. & ind==1,by(date);
egen ipdera_i=sum(ipdera/1000) if ipfa~=. & ind==1,by(date);
egen ipfx_i=sum(ipfx/1000) if ipfa~=. & ind==1,by(date);
egen ipdebtl_i=sum(ipdebtl/1000) if ipfa~=. & ind==1,by(date);
egen ipderl_i=sum(ipderl/1000) if ipfa~=. & ind==1,by(date);
egen ipfa_i=sum(ipfa/1000) if ind==1,by(date);
egen ipfl_i=sum(ipfl/1000) if ipfa~=. & ind==1,by(date);
egen ipnfa_i=sum(ipnfa/1000) if ind==1,by(date);
egen gdpd_i=sum(gdpd/1000) if ind==1,by(date); 
egen ippda_i=sum(ippda/1000) if ipfa~=. & ind==1,by(date);
egen ipoa_i=sum(ipoa/1000) if ipfa~=. & ind==1,by(date);
egen ippdl_i=sum(ippdl/1000) if ipfa~=. & ind==1,by(date);
egen ipol_i=sum(ipol/1000) if ipfa~=. & ind==1,by(date);


**** AEs excluding financial centers *********; 
egen ipeqa_infc=sum(ipeqa/1000) if ind_nfc==1,by(date);
egen ipeql_infc=sum(ipeql/1000) if ind_nfc==1,by(date);
egen ipfdia_infc=sum(ipfdia/1000) if ind_nfc==1,by(date);
egen ipfdil_infc=sum(ipfdil/1000) if ind_nfc==1,by(date);
egen ipdebta_infc=sum(ipdebta/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipdera_infc=sum(ipdera/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipfx_infc=sum(ipfx/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipdebtl_infc=sum(ipdebtl/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipderl_infc=sum(ipderl/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipfa_infc=sum(ipfa/1000) if ind_nfc==1,by(date);
egen ipfl_infc=sum(ipfl/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipnfa_infc=sum(ipnfa/1000) if ind_nfc==1,by(date);
egen gdpd_infc=sum(gdpd/1000) if ind_nfc==1,by(date); 
egen ippda_infc=sum(ippda/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipoa_infc=sum(ipoa/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ippdl_infc=sum(ippdl/1000) if ipfa~=. & ind_nfc==1,by(date);
egen ipol_infc=sum(ipol/1000) if ipfa~=. & ind_nfc==1,by(date);

******* EURO AREA COUNTRIES *************************;
egen ipeqa_eur=sum(ipeqa/1000) if euro==1,by(date);
egen ipeql_eur=sum(ipeql/1000) if euro==1,by(date);
egen ipfdia_eur=sum(ipfdia/1000) if euro==1,by(date);
egen ipfdil_eur=sum(ipfdil/1000) if euro==1,by(date);
egen ipdebta_eur=sum(ipdebta/1000) if ipfa~=. & euro==1,by(date);
egen ipdera_eur=sum(ipdera/1000) if ipfa~=. & euro==1,by(date);
egen ipfx_eur=sum(ipfx/1000) if ipfa~=. & euro==1,by(date);
egen ipdebtl_eur=sum(ipdebtl/1000) if ipfa~=. & euro==1,by(date);
egen ipderl_eur=sum(ipderl/1000) if ipfl~=. & euro==1,by(date);
egen ipfa_eur=sum(ipfa/1000) if euro==1,by(date);
egen ipfl_eur=sum(ipfl/1000) if ipfa~=. & euro==1,by(date);
egen ipnfa_eur=sum(ipnfa/1000) if euro==1,by(date);
egen gdpd_eur=sum(gdpd/1000) if euro==1,by(date); 
egen ippda_euro=sum(ippda/1000) if euro==1,by(date);
egen ipoa_euro=sum(ipoa/1000) if euro==1,by(date);
egen ippdl_euro=sum(ippdl/1000) if euro==1 ,by(date);
egen ipol_euro=sum(ipol/1000) if euro==1 ,by(date);

******* OTHER EUR COUNTRIES *************************;
egen ipeqa_otheur=sum(ipeqa/1000) if otheur==1,by(date);
egen ipeql_otheur=sum(ipeql/1000) if otheur==1,by(date);
egen ipfdia_otheur=sum(ipfdia/1000) if otheur==1,by(date);
egen ipfdil_otheur=sum(ipfdil/1000) if otheur==1,by(date);
egen ipdebta_otheur=sum(ipdebta/1000) if ipfa~=. & otheur==1,by(date);
egen ipdera_otheur=sum(ipdera/1000) if ipfa~=. & otheur==1,by(date);
egen ipfx_otheur=sum(ipfx/1000) if ipfa~=. & otheur==1,by(date);
egen ipdebtl_otheur=sum(ipdebtl/1000) if ipfa~=. & otheur==1,by(date);
egen ipderl_otheur=sum(ipderl/1000) if ipfl~=. & otheur==1,by(date);
egen ipfa_otheur=sum(ipfa/1000) if otheur==1,by(date);
egen ipfl_otheur=sum(ipfl/1000) if ipfa~=. & otheur==1,by(date);
egen ipnfa_otheur=sum(ipnfa/1000) if otheur==1,by(date);
egen gdpd_otheur=sum(gdpd/1000) if otheur==1 & ipnfa~=.,by(date); 

******* OTHER adv COUNTRIES *************************;
egen ipeqa_othadv=sum(ipeqa/1000) if othadv==1,by(date);
egen ipeql_othadv=sum(ipeql/1000) if othadv==1,by(date);
egen ipfdia_othadv=sum(ipfdia/1000) if othadv==1,by(date);
egen ipfdil_othadv=sum(ipfdil/1000) if othadv==1,by(date);
egen ipdebta_othadv=sum(ipdebta/1000) if ipfa~=. & othadv==1,by(date);
egen ipdera_othadv=sum(ipdera/1000) if ipfa~=. & othadv==1,by(date);
egen ipfx_othadv=sum(ipfx/1000) if ipfa~=. & othadv==1,by(date);
egen ipdebtl_othadv=sum(ipdebtl/1000) if ipfa~=. & othadv==1,by(date);
egen ipderl_othadv=sum(ipderl/1000) if ipfl~=. & othadv==1,by(date);
egen ipfa_othadv=sum(ipfa/1000) if othadv==1,by(date);
egen ipfl_othadv=sum(ipfl/1000) if ipfa~=. & othadv==1,by(date);
egen ipnfa_othadv=sum(ipnfa/1000) if othadv==1,by(date);
egen gdpd_othadv=sum(gdpd/1000) if othadv==1 & ipnfa~=.,by(date); 


******** LARGE FINANCIAL CENTERS **************;

egen ipeqa_off_lg=sum(ipeqa/1000) if off_lg==1,by(date);
egen ipeql_off_lg=sum(ipeql/1000) if off_lg==1,by(date);
egen ipfdia_off_lg=sum(ipfdia/1000) if off_lg==1,by(date);
egen ipfdil_off_lg=sum(ipfdil/1000) if off_lg==1,by(date);
egen ipdebta_off_lg=sum(ipdebta/1000) if ipfa~=. & off_lg==1,by(date);
egen ipdera_off_lg=sum(ipdera/1000) if ipfa~=. & off_lg==1,by(date);
egen ipfx_off_lg=sum(ipfx/1000) if ipfa~=. & off_lg==1,by(date);
egen ipdebtl_off_lg=sum(ipdebtl/1000) if ipfa~=. & off_lg==1,by(date);
egen ipderl_off_lg=sum(ipderl/1000) if ipfl~=. & off_lg==1,by(date);
egen ipfa_off_lg=sum(ipfa/1000) if off_lg==1,by(date);
egen ipfl_off_lg=sum(ipfl/1000) if ipfa~=. & off_lg==1,by(date);
egen ipnfa_off_lg=sum(ipnfa/1000) if off_lg==1,by(date);
egen gdpd_off_lg=sum(gdpd/1000) if off_lg==1 & ipnfa~=.,by(date);
egen ippda_off_lg=sum(ippda/1000) if off_lg==1 & ipnfa~=.,by(date);
egen ipoa_off_lg=sum(ipoa/1000) if off_lg==1 & ipnfa~=.,by(date);
egen ippdl_off_lg=sum(ippdl/1000) if off_lg==1 & ipnfa~=.,by(date);
egen ipol_off_lg=sum(ipol/1000) if off_lg==1 & ipnfa~=.,by(date);


************ OFFSHORE CENTERS ****************;

egen ipeqa_off=sum(ipeqa/1000) if off==1,by(date);
egen ipeql_off=sum(ipeql/1000) if off==1,by(date);
egen ipfdia_off=sum(ipfdia/1000) if off==1,by(date);
egen ipfdil_off=sum(ipfdil/1000) if off==1,by(date);
egen ipdebta_off=sum(ipdebta/1000) if off==1,by(date);
egen ipdera_off=sum(ipdera/1000) if off==1,by(date);
egen ipfx_off=sum(ipfx/1000) if off==1,by(date);
egen ipdebtl_off=sum(ipdebtl/1000) if off==1,by(date);
egen ipderl_off=sum(ipderl/1000) if off==1,by(date);
egen ipfa_off=sum(ipfa/1000) if off==1,by(date);
egen ipfl_off=sum(ipfl/1000) if off==1,by(date);
egen ipnfa_off=sum(ipnfa/1000) if off==1,by(date);
egen gdpd_off=sum(gdpd/1000) if off==1,by(date);
egen ippda_off=sum(ippda/1000) if off==1,by(date);
egen ipoa_off=sum(ipoa/1000) if off==1,by(date);
egen ippdl_off=sum(ippdl/1000) if off==1 ,by(date);
egen ipol_off=sum(ipol/1000) if off==1 ,by(date);

************ ALL FINANCIAL / OFFSHORE CENTERS ****************;

egen ipeqa_fc=sum(ipeqa/1000) if fc==1,by(date);
egen ipeql_fc=sum(ipeql/1000) if fc==1,by(date);
egen ipfdia_fc=sum(ipfdia/1000) if fc==1,by(date);
egen ipfdil_fc=sum(ipfdil/1000) if fc==1,by(date);
egen ipdebta_fc=sum(ipdebta/1000) if fc==1,by(date);
egen ipdera_fc=sum(ipdera/1000) if fc==1,by(date);
egen ipfx_fc=sum(ipfx/1000) if fc==1,by(date);
egen ipdebtl_fc=sum(ipdebtl/1000) if fc==1,by(date);
egen ipderl_fc=sum(ipderl/1000) if fc==1,by(date);
egen ipfa_fc=sum(ipfa/1000) if fc==1,by(date);
egen ipfl_fc=sum(ipfl/1000) if fc==1,by(date);
egen ipnfa_fc=sum(ipnfa/1000) if fc==1,by(date);
egen gdpd_fc=sum(gdpd/1000) if fc==1,by(date);
egen ippda_fc=sum(ippda/1000) if fc==1,by(date);
egen ipoa_fc=sum(ipoa/1000) if fc==1,by(date);
egen ippdl_fc=sum(ippdl/1000) if fc==1 ,by(date);
egen ipol_fc=sum(ipol/1000) if fc==1 ,by(date);


******* 2. INDUSTRIAL EXCLUDING US ***;
egen ipnfa_iUS=sum(ipnfa/1000) if ind==1 & ifs_code~=111,by(date);
egen gdpd_iUS=sum(gdpd/1000) if ind==1 & ipnfa~=. & ifs_code~=111,by(date); 

******* 3. INDUSTRIAL (EURO AREA AS A WHOLE) **** ;

egen ipeqa_i_euro=sum(ipeqa/1000) if ind_euro==1,by(date);
egen ipeql_i_euro=sum(ipeql/1000) if ind_euro==1,by(date);
egen ipfdia_i_euro=sum(ipfdia/1000) if ind_euro==1,by(date);
egen ipfdil_i_euro=sum(ipfdil/1000) if ind_euro==1,by(date);
egen ipdebta_i_euro=sum(ipdebta/1000) if ipfa~=. & ind_euro==1,by(date);
egen ipdera_i_euro=sum(ipdera/1000) if ipfa~=. & ind_euro==1,by(date);
egen ipfx_i_euro=sum(ipfx/1000) if ipfa~=. & ind_euro==1,by(date);
egen ipdebtl_i_euro=sum(ipdebtl/1000) if ipfa~=. & ind_euro==1,by(date);
egen ipderl_i_euro=sum(ipderl/1000) if ipfa~=. & ind_euro==1,by(date);
egen ipfa_i_euro=sum(ipfa/1000) if ind_euro==1,by(date);
egen ipfl_i_euro=sum(ipfl/1000) if ipfa~=. & ind_euro==1,by(date);
egen ipnfa_i_euro=sum(ipnfa/1000) if ind_euro==1,by(date);
egen gdpd_i_euro=sum(gdpd/1000) if ind_euro==1,by(date);

***** 4. EMERGING MARKETS AND DEVELOPING COUNTRIES ***** ;

egen ipeqa_d=sum(ipeqa/1000) if dev==1,by(date);
egen ipeql_d=sum(ipeql/1000) if dev==1,by(date);
egen ipfdia_d=sum(ipfdia/1000) if dev==1,by(date);
egen ipfdil_d=sum(ipfdil/1000) if dev==1,by(date);
egen ipdebta_d=sum(ipdebta/1000) if ipfa~=. & dev==1,by(date);
egen ipdera_d=sum(ipdera/1000) if ipfa~=. & dev==1,by(date);
egen ipfx_d=sum(ipfx/1000) if ipfa~=. & dev==1,by(date);
egen ipdebtl_d=sum(ipdebtl/1000) if ipfa~=. & dev==1,by(date);
egen ipderl_d=sum(ipderl/1000) if ipfl~=. & dev==1,by(date);
egen ipfa_d=sum(ipfa/1000) if dev==1,by(date);
egen ipfl_d=sum(ipfl/1000) if ipfa~=. & dev==1,by(date);
egen ipnfa_d=sum(ipnfa/1000) if dev==1,by(date);
egen gdpd_d=sum(gdpd/1000) if dev==1,by(date); 
egen ippda_d=sum(ippda/1000) if ipfa~=. & dev==1,by(date);
egen ipoa_d=sum(ipoa/1000) if ipfa~=. & dev==1,by(date);
egen ippdl_d=sum(ippdl/1000) if ipfa~=. & dev==1,by(date);
egen ipol_d=sum(ipol/1000) if ipfa~=. & dev==1,by(date);

**** 5. EMERGING AND DEVELOPING COUNTRIES EXCLUDING CHINA ****;

egen ipeqa_d2=sum(ipeqa/1000) if dev_c==1,by(date);
egen ipeql_d2=sum(ipeql/1000) if dev_c==1,by(date);
egen ipfdia_d2=sum(ipfdia/1000) if dev_c==1,by(date);
egen ipfdil_d2=sum(ipfdil/1000) if dev_c==1,by(date);
egen ipdebta_d2=sum(ipdebta/1000) if ipfa~=. & dev_c==1,by(date);
egen ipdera_d2=sum(ipdera/1000) if ipfa~=. & dev_c==1,by(date);
egen ipfx_d2=sum(ipfx/1000) if ipfa~=. & dev_c==1,by(date);
egen ipdebtl_d2=sum(ipdebtl/1000) if ipfa~=. & dev_c==1,by(date);
egen ipderl_d2=sum(ipderl/1000) if ipfl~=. & dev_c==1,by(date);
egen ipfa_d2=sum(ipfa/1000) if dev_c==1,by(date);
egen ipfl_d2=sum(ipfl/1000) if ipfa~=. & dev_c==1,by(date);
egen ipnfa_d2=sum(ipnfa/1000) if dev_c==1,by(date);
egen gdpd_d2=sum(gdpd/1000) if dev_c==1 & ipnfa~=.,by(date); 
egen ippda_d2=sum(ippda/1000) if ipfa~=. & dev_c==1,by(date);
egen ipoa_d2=sum(ipoa/1000) if ipfa~=. & dev_c==1,by(date);
egen ippdl_d2=sum(ippdl/1000) if ipfa~=. & dev_c==1,by(date);
egen ipol_d2=sum(ipol/1000) if ipfa~=. & dev_c==1,by(date);

*********** LIDCs **********************;

egen ipeqa_lidc=sum(ipeqa/1000) if lidc==1,by(date);
egen ipeql_lidc=sum(ipeql/1000) if lidc==1,by(date);
egen ipfdia_lidc=sum(ipfdia/1000) if lidc==1,by(date);
egen ipfdil_lidc=sum(ipfdil/1000) if lidc==1,by(date);
egen ipdebta_lidc=sum(ipdebta/1000) if lidc==1,by(date);
egen ipdera_lidc=sum(ipdera/1000) if lidc==1,by(date);
egen ipfx_lidc=sum(ipfx/1000) if lidc==1,by(date);
egen ipdebtl_lidc=sum(ipdebtl/1000) if lidc==1,by(date);
egen ipderl_lidc=sum(ipderl/1000) if lidc==1,by(date);
egen ipfa_lidc=sum(ipfa/1000) if lidc==1,by(date);
egen ipfl_lidc=sum(ipfl/1000) if lidc==1,by(date);
egen ipnfa_lidc=sum(ipnfa/1000) if lidc==1,by(date);
egen gdpd_lidc=sum(gdpd/1000) if lidc==1,by(date);
egen ippda_lidc=sum(ippda/1000) if lidc==1,by(date);
egen ipoa_lidc=sum(ipoa/1000) if lidc==1,by(date);
egen ippdl_lidc=sum(ippdl/1000) if lidc==1 ,by(date);
egen ipol_lidc=sum(ipol/1000) if lidc==1 ,by(date);


**** 6. ASIA EMERGING AND DEVELOPING COUNTRIES****;

egen ipeqa_asia=sum(ipeqa/1000) if asia==1,by(date);
egen ipeql_asia=sum(ipeql/1000) if asia==1,by(date);
egen ipfdia_asia=sum(ipfdia/1000) if asia==1,by(date);
egen ipfdil_asia=sum(ipfdil/1000) if asia==1,by(date);
egen ipdebta_asia=sum(ipdebta/1000) if ipfa~=. & asia==1,by(date);
egen ipdera_asia=sum(ipdera/1000) if ipfa~=. & asia==1,by(date);
egen ipfx_asia=sum(ipfx/1000) if ipfa~=. & asia==1,by(date);
egen ipdebtl_asia=sum(ipdebtl/1000) if ipfa~=. & asia==1,by(date);
egen ipderl_asia=sum(ipderl/1000) if ipfl~=. & asia==1,by(date);
egen ipfa_asia=sum(ipfa/1000) if asia==1,by(date);
egen ipfl_asia=sum(ipfl/1000) if ipfa~=. & asia==1,by(date);
egen ipnfa_asia=sum(ipnfa/1000) if asia==1,by(date);
egen gdpd_asia=sum(gdpd/1000) if asia==1 & ipnfa~=.,by(date); 
egen ippda_asia=sum(ippda/1000) if ipfa~=. & asia==1,by(date);
egen ipoa_asia=sum(ipoa/1000) if ipfa~=. & asia==1,by(date);
egen ippdl_asia=sum(ippdl/1000) if ipfa~=. & asia==1,by(date);
egen ipol_asia=sum(ipol/1000) if ipfa~=. & asia==1,by(date);

*** 6a. ASIA EMERGING AND DEVELOPING COUNTRIES ex China****;

egen ipeqa_asia2=sum(ipeqa/1000) if asia==1 & ifs_code~=924,by(date);
egen ipeql_asia2=sum(ipeql/1000) if asia==1 & ifs_code~=924,by(date);
egen ipfdia_asia2=sum(ipfdia/1000) if asia==1 & ifs_code~=924,by(date);
egen ipfdil_asia2=sum(ipfdil/1000) if asia==1 & ifs_code~=924, by(date);
egen ipdebta_asia2=sum(ipdebta/1000) if ipfa~=. & asia==1 & ifs_code~=924,by(date);
egen ipdera_asia2=sum(ipdera/1000) if ipfa~=. & asia==1 & ifs_code~=924,by(date);
egen ipfx_asia2=sum(ipfx/1000) if ipfa~=. & asia==1 & ifs_code~=924,by(date);
egen ipdebtl_asia2=sum(ipdebtl/1000) if ipfa~=. & asia==1 & ifs_code~=924,by(date);
egen ipderl_asia2=sum(ipderl/1000) if ipfl~=. & asia==1 & ifs_code~=924,by(date);
egen ipfa_asia2=sum(ipfa/1000) if asia==1 & ifs_code~=924,by(date);
egen ipfl_asia2=sum(ipfl/1000) if ipfa~=. & asia==1 & ifs_code~=924,by(date);
egen ipnfa_asia2=sum(ipnfa/1000) if asia==1 & ifs_code~=924, by(date);
egen gdpd_asia2=sum(gdpd/1000) if asia==1 & ipnfa~=. & ifs_code~=924,by(date); 
egen ippda_asia2=sum(ippda/1000) if asia==1 & ipnfa~=. & ifs_code~=924,by(date); 
egen ipoa_asia2=sum(ipoa/1000) if asia==1 & ipnfa~=. & ifs_code~=924,by(date); 
egen ippdl_asia2=sum(ippdl/1000) if asia==1 & ipnfa~=. & ifs_code~=924,by(date); 
egen ipol_asia2=sum(ipol/1000) if asia==1 & ipnfa~=. & ifs_code~=924,by(date); 

**** 7. LATIN AMERICA+CARIB EMERGING AND DEVELOPING COUNTRIES****;

egen ipeqa_weshem=sum(ipeqa/1000) if weshem==1,by(date);
egen ipeql_weshem=sum(ipeql/1000) if weshem==1,by(date);
egen ipfdia_weshem=sum(ipfdia/1000) if weshem==1,by(date);
egen ipfdil_weshem=sum(ipfdil/1000) if weshem==1,by(date);
egen ipdebta_weshem=sum(ipdebta/1000) if ipfa~=. & weshem==1,by(date);
egen ipdera_weshem=sum(ipdera/1000) if ipfa~=. & weshem==1,by(date);
egen ipfx_weshem=sum(ipfx/1000) if ipfa~=. & weshem==1,by(date);
egen ipdebtl_weshem=sum(ipdebtl/1000) if ipfa~=. & weshem==1,by(date);
egen ipderl_weshem=sum(ipderl/1000) if ipfl~=. & weshem==1,by(date);
egen ipfa_weshem=sum(ipfa/1000) if weshem==1,by(date);
egen ipfl_weshem=sum(ipfl/1000) if ipfa~=. & weshem==1,by(date);
egen ipnfa_weshem=sum(ipnfa/1000) if weshem==1,by(date);
egen gdpd_weshem=sum(gdpd/1000) if weshem==1 & ipnfa~=.,by(date); 
egen ippda_weshem=sum(ippda/1000) if ipfa~=. & weshem==1,by(date);
egen ipoa_weshem=sum(ipoa/1000) if ipfa~=. & weshem==1,by(date);
egen ippdl_weshem=sum(ippdl/1000) if ipfa~=. & weshem==1,by(date);
egen ipol_weshem=sum(ipol/1000) if ipfa~=. & weshem==1,by(date);

egen ipeqa_weshem2=sum(ipeqa/1000) if weshem2==1,by(date);
egen ipeql_weshem2=sum(ipeql/1000) if weshem2==1,by(date);
egen ipfdia_weshem2=sum(ipfdia/1000) if weshem2==1,by(date);
egen ipfdil_weshem2=sum(ipfdil/1000) if weshem2==1,by(date);
egen ipdebta_weshem2=sum(ipdebta/1000) if ipfa~=. & weshem2==1,by(date);
egen ipdera_weshem2=sum(ipdera/1000) if ipfa~=. & weshem2==1,by(date);
egen ipfx_weshem2=sum(ipfx/1000) if ipfa~=. & weshem2==1,by(date);
egen ipdebtl_weshem2=sum(ipdebtl/1000) if ipfa~=. & weshem2==1,by(date);
egen ipderl_weshem2=sum(ipderl/1000) if ipfl~=. & weshem2==1,by(date);
egen ipfa_weshem2=sum(ipfa/1000) if weshem2==1,by(date);
egen ipfl_weshem2=sum(ipfl/1000) if ipfa~=. & weshem2==1,by(date);
egen ipnfa_weshem2=sum(ipnfa/1000) if weshem2==1,by(date);
egen gdpd_weshem2=sum(gdpd/1000) if weshem2==1 & ipnfa~=.,by(date); 
egen ippda_weshem2=sum(ippda/1000) if ipfa~=. & weshem2==1,by(date);
egen ipoa_weshem2=sum(ipoa/1000) if ipfa~=. & weshem2==1,by(date);
egen ippdl_weshem2=sum(ippdl/1000) if ipfa~=. & weshem2==1,by(date);
egen ipol_weshem2=sum(ipol/1000) if ipfa~=. & weshem2==1,by(date);


**** 7a. LATIN AMERICA only (MEANS)****;

egen ipeqay_latam=median(ipeqay) if latam==1,by(date);
egen ipeqly_latam=median(ipeqly) if latam==1,by(date);
egen ipfdiay_latam=median(ipfdiay) if latam==1,by(date);
egen ipfdily_latam=median(ipfdily) if latam==1,by(date);
egen ipdebtay_latam=median(ipdebtay) if ipfa~=. & latam==1,by(date);
egen ipderay_latam=median(ipderay) if ipfa~=. & latam==1,by(date);
egen ipfxy_latam=median(ipfxy) if ipfa~=. & latam==1,by(date);
egen ipdebtly_latam=median(ipdebtly) if ipfa~=. & latam==1,by(date);
egen ipderly_latam=median(ipderly) if ipfl~=. & latam==1,by(date);
egen ipfay_latam=median(ipfay) if latam==1,by(date);
egen ipfly_latam=median(ipfly) if ipfa~=. & latam==1,by(date);
egen ipnfay_latam=median(ipnfay) if latam==1,by(date);
egen ippday_latam=median(ippday) if ipfa~=. & latam==1,by(date);
egen ipoay_latam=median(ipoay) if ipfa~=. & latam==1,by(date);
egen ippdly_latam=median(ippdly) if ipfa~=. & latam==1,by(date);
egen ipoly_latam=median(ipoly) if ipfa~=. & latam==1,by(date);

egen ipeqay_latam2=mean(ipeqay) if latam2==1,by(date);
egen ipeqly_latam2=mean(ipeqly) if latam2==1,by(date);
egen ipfdiay_latam2=mean(ipfdiay) if latam2==1,by(date);
egen ipfdily_latam2=mean(ipfdily) if latam2==1,by(date);
egen ipdebtay_latam2=mean(ipdebtay) if ipfa~=. & latam2==1,by(date);
egen ipderay_latam2=mean(ipderay) if ipfa~=. & latam2==1,by(date);
egen ipfxy_latam2=mean(ipfxy) if ipfa~=. & latam2==1,by(date);
egen ipdebtly_latam2=mean(ipdebtly) if ipfa~=. & latam2==1,by(date);
egen ipderly_latam2=mean(ipderly) if ipfl~=. & latam2==1,by(date);
egen ipfay_latam2=mean(ipfay) if latam2==1,by(date);
egen ipfly_latam2=mean(ipfly) if ipfa~=. & latam2==1,by(date);
egen ipnfay_latam2=mean(ipnfay) if latam2==1,by(date);
egen ippday_latam2=mean(ippday) if ipfa~=. & latam2==1,by(date);
egen ipoay_latam2=mean(ipoay) if ipfa~=. & latam2==1,by(date);
egen ippdly_latam2=mean(ippdly) if ipfa~=. & latam2==1,by(date);
egen ipoly_latam2=mean(ipoly) if ipfa~=. & latam2==1,by(date);

egen nfay_latam=median(nfay) if ipnfa~=. & latam==1,by(date);
egen nfay_latam2=mean(nfay) if ipnfa~=. & latam2==1,by(date);

**** 8. MIDDLE EAST EMERGING AND DEVELOPING COUNTRIES****;

egen ipeqa_mideast1=sum(ipeqa/1000) if mideast1==1,by(date);
egen ipeql_mideast1=sum(ipeql/1000) if mideast1==1,by(date);
egen ipfdia_mideast1=sum(ipfdia/1000) if mideast1==1,by(date);
egen ipfdil_mideast1=sum(ipfdil/1000) if mideast1==1,by(date);
egen ipdebta_mideast1=sum(ipdebta/1000) if ipfa~=. & mideast1==1,by(date);
egen ipdera_mideast1=sum(ipdera/1000) if ipfa~=. & mideast1,by(date);
egen ipfx_mideast1=sum(ipfx/1000) if ipfa~=. & mideast1==1,by(date);
egen ipdebtl_mideast1=sum(ipdebtl/1000) if ipfa~=. & mideast1==1,by(date);
egen ipderl_mideast1=sum(ipderl/1000) if ipfl~=. & mideast1,by(date);
egen ipfa_mideast1=sum(ipfa/1000) if mideast1==1,by(date);
egen ipfl_mideast1=sum(ipfl/1000) if ipfa~=. & mideast1==1,by(date);
egen ipnfa_mideast1=sum(ipnfa/1000) if mideast1==1,by(date);
egen gdpd_mideast1=sum(gdpd/1000) if mideast1==1 & ipnfa~=.,by(date); 
egen ippda_mideast1=sum(ippda/1000) if ipfa~=. & mideast1==1,by(date);
egen ipoa_mideast1=sum(ipoa/1000) if ipfa~=. & mideast1==1,by(date);
egen ippdl_mideast1=sum(ippdl/1000) if ipfa~=. & mideast1==1,by(date);
egen ipol_mideast1=sum(ipol/1000) if ipfa~=. & mideast1==1,by(date);

**** 8. EMERGING EUROPE****;

egen ipeqa_em_eur=sum(ipeqa/1000) if em_eur==1,by(date);
egen ipeql_em_eur=sum(ipeql/1000) if em_eur==1,by(date);
egen ipfdia_em_eur=sum(ipfdia/1000) if em_eur==1,by(date);
egen ipfdil_em_eur=sum(ipfdil/1000) if em_eur==1,by(date);
egen ipdebta_em_eur=sum(ipdebta/1000) if ipfa~=. & em_eur==1,by(date);
egen ipdera_em_eur=sum(ipdera/1000) if ipfa~=. & em_eur==1,by(date);
egen ipfx_em_eur=sum(ipfx/1000) if ipfa~=. & em_eur==1,by(date);
egen ipdebtl_em_eur=sum(ipdebtl/1000) if ipfa~=. & em_eur==1,by(date);
egen ipderl_em_eur=sum(ipderl/1000) if ipfl~=. & em_eur==1,by(date);
egen ipfa_em_eur=sum(ipfa/1000) if em_eur==1,by(date);
egen ipfl_em_eur=sum(ipfl/1000) if ipfa~=. & em_eur==1,by(date);
egen ipnfa_em_eur=sum(ipnfa/1000) if em_eur==1,by(date);
egen gdpd_em_eur=sum(gdpd/1000) if em_eur==1 & ipnfa~=.,by(date); 
egen ippda_em_eur=sum(ippda/1000) if ipfa~=. & em_eur==1,by(date);
egen ipoa_em_eur=sum(ipoa/1000) if ipfa~=. & em_eur==1,by(date);
egen ippdl_em_eur=sum(ippdl/1000) if ipfa~=. & em_eur==1,by(date);
egen ipol_em_eur=sum(ipol/1000) if ipfa~=. & em_eur==1,by(date);

**** 9. AFRICA****;

egen ipeqa_afr=sum(ipeqa/1000) if afr==1,by(date);
egen ipeql_afr=sum(ipeql/1000) if afr==1,by(date);
egen ipfdia_afr=sum(ipfdia/1000) if afr==1,by(date);
egen ipfdil_afr=sum(ipfdil/1000) if afr==1,by(date);
egen ipdebta_afr=sum(ipdebta/1000) if ipfa~=. & afr==1,by(date);
egen ipdera_afr=sum(ipdera/1000) if ipfa~=. & afr==1,by(date);
egen ipfx_afr=sum(ipfx/1000) if ipfa~=. & afr==1,by(date);
egen ipdebtl_afr=sum(ipdebtl/1000) if ipfa~=. & afr==1,by(date);
egen ipderl_afr=sum(ipderl/1000) if ipfl~=. & afr==1,by(date);
egen ipfa_afr=sum(ipfa/1000) if afr==1,by(date);
egen ipfl_afr=sum(ipfl/1000) if ipfa~=. & afr==1,by(date);
egen ipnfa_afr=sum(ipnfa/1000) if afr==1,by(date);
egen gdpd_afr=sum(gdpd/1000) if afr==1 & ipnfa~=0,by(date); 
egen nfay_abs_afr=median(nfay_abs) if afr==1 & ipnfa~=0,by(date);
egen ka_afr=sum(ka/1000) if afr==1,by(date);
egen ippda_afr=sum(ippda/1000) if ipfa~=. & afr==1,by(date);
egen ipoa_afr=sum(ipoa/1000) if ipfa~=. & afr==1,by(date);
egen ippdl_afr=sum(ippdl/1000) if ipfa~=. & afr==1,by(date);
egen ipol_afr=sum(ipol/1000) if ipfa~=. & afr==1,by(date);


**** CARIBBEAN ****;
egen ipeqa_car=sum(ipeqa/1000) if carib==1,by(date);
egen ipeql_car=sum(ipeql/1000) if carib==1,by(date);
egen ipfdia_car=sum(ipfdia/1000) if carib==1,by(date);
egen ipfdil_car=sum(ipfdil/1000) if carib==1,by(date);
egen ipdebta_car=sum(ipdebta/1000) if ipfa~=. & carib==1,by(date);
egen ipdera_car=sum(ipdera/1000) if ipfa~=. & carib==1,by(date);
egen ipfx_car=sum(ipfx/1000) if ipfa~=. & carib==1,by(date);
egen ipdebtl_car=sum(ipdebtl/1000) if ipfa~=. & carib==1,by(date);
egen ipderl_car=sum(ipderl/1000) if ipfl~=. & carib==1,by(date);
egen ipfa_car=sum(ipfa/1000) if carib==1,by(date);
egen ipfl_car=sum(ipfl/1000) if ipfa~=. & carib==1,by(date);
egen ipnfa_car=sum(ipnfa/1000) if carib==1,by(date);
egen gdpd_car=sum(gdpd/1000) if carib==1 & ipnfa~=.,by(date);

*** Central America ***** ;

egen ipeqa_ca=sum(ipeqa/1000) if c_am==1,by(date);
egen ipeql_ca=sum(ipeql/1000) if c_am==1,by(date);
egen ipfdia_ca=sum(ipfdia/1000) if c_am==1,by(date);
egen ipfdil_ca=sum(ipfdil/1000) if c_am==1,by(date);
egen ipdebta_ca=sum(ipdebta/1000) if ipfa~=. & c_am==1,by(date);
egen ipdera_ca=sum(ipdera/1000) if ipfa~=. & c_am==1,by(date);
egen ipfx_ca=sum(ipfx/1000) if ipfa~=. & c_am==1,by(date);
egen ipdebtl_ca=sum(ipdebtl/1000) if ipfa~=. & c_am==1,by(date);
egen ipderl_ca=sum(ipderl/1000) if ipfl~=. & c_am==1,by(date);
egen ipfa_ca=sum(ipfa/1000) if c_am==1,by(date);
egen ipfl_ca=sum(ipfl/1000) if ipfa~=. & c_am==1,by(date);
egen ipnfa_ca=sum(ipnfa/1000) if c_am==1,by(date);
egen gdpd_ca=sum(gdpd/1000) if c_am==1 & ipnfa~=.,by(date);


**** 9. OIL EXPORTERS ****;

egen ipeqa_oil=sum(ipeqa/1000) if oil==1,by(date);
egen ipeql_oil=sum(ipeql/1000) if oil==1,by(date);
egen ipfdia_oil=sum(ipfdia/1000) if oil==1,by(date);
egen ipfdil_oil=sum(ipfdil/1000) if oil==1,by(date);
egen ipdebta_oil=sum(ipdebta/1000) if ipfa~=. & oil==1,by(date);
egen ipdera_oil=sum(ipdera/1000) if ipfa~=. & oil,by(date);
egen ipfx_oil=sum(ipfx/1000) if ipfa~=. & oil==1,by(date);
egen ipdebtl_oil=sum(ipdebtl/1000) if ipfa~=. & oil==1,by(date);
egen ipderl_oil=sum(ipderl/1000) if ipfl~=. & oil,by(date);
egen ipfa_oil=sum(ipfa/1000) if oil==1,by(date);
egen ipfl_oil=sum(ipfl/1000) if ipfa~=. & oil==1,by(date);
egen ipnfa_oil=sum(ipnfa/1000) if oil==1,by(date);
egen gdpd_oil=sum(gdpd/1000) if oil==1 & ipnfa~=.,by(date); 
*****************;

**** 10. EUROPEAN DEFICIT COUNTRIES ****;

egen ipeqa_eur_def=sum(ipeqa/1000) if eur_def==1,by(date);
egen ipeql_eur_def=sum(ipeql/1000) if eur_def==1,by(date);
egen ipfdia_eur_def=sum(ipfdia/1000) if eur_def==1,by(date);
egen ipfdil_eur_def=sum(ipfdil/1000) if eur_def==1,by(date);
egen ipdebta_eur_def=sum(ipdebta/1000) if ipfa~=. & eur_def==1,by(date);
egen ipdera_eur_def=sum(ipdera/1000) if ipfa~=. & eur_def,by(date);
egen ipfx_eur_def=sum(ipfx/1000) if ipfa~=. & eur_def==1,by(date);
egen ipdebtl_eur_def=sum(ipdebtl/1000) if ipfa~=. & eur_def==1,by(date);
egen ipderl_eur_def=sum(ipderl/1000) if ipfl~=. & eur_def,by(date);
egen ipfa_eur_def=sum(ipfa/1000) if eur_def==1,by(date);
egen ipfl_eur_def=sum(ipfl/1000) if ipfa~=. & eur_def==1,by(date);
egen ipnfa_eur_def=sum(ipnfa/1000) if eur_def==1,by(date);
egen gdpd_eur_def=sum(gdpd/1000) if eur_def==1 & ipnfa~=.,by(date); 
*****************;
**** 11. EUROPEAN SURPLUS COUNTRIES ****;

egen ipeqa_eur_sur=sum(ipeqa/1000) if eur_sur==1,by(date);
egen ipeql_eur_sur=sum(ipeql/1000) if eur_sur==1,by(date);
egen ipfdia_eur_sur=sum(ipfdia/1000) if eur_sur==1,by(date);
egen ipfdil_eur_sur=sum(ipfdil/1000) if eur_sur==1,by(date);
egen ipdebta_eur_sur=sum(ipdebta/1000) if ipfa~=. & eur_sur==1,by(date);
egen ipdera_eur_sur=sum(ipdera/1000) if ipfa~=. & eur_sur,by(date);
egen ipfx_eur_sur=sum(ipfx/1000) if ipfa~=. & eur_sur==1,by(date);
egen ipdebtl_eur_sur=sum(ipdebtl/1000) if ipfa~=. & eur_sur==1,by(date);
egen ipderl_eur_sur=sum(ipderl/1000) if ipfl~=. & eur_sur,by(date);
egen ipfa_eur_sur=sum(ipfa/1000) if eur_sur==1,by(date);
egen ipfl_eur_sur=sum(ipfl/1000) if ipfa~=. & eur_sur==1,by(date);
egen ipnfa_eur_sur=sum(ipnfa/1000) if eur_sur==1,by(date);
egen gdpd_eur_sur=sum(gdpd/1000) if eur_sur==1 & ipnfa~=.,by(date); 


sort ifs_code date;

******* GENERATE CUMULATIVE CA SERIES *** ;
replace ka=0 if ka==.;
g fin_acct=ca+ka+eo;
egen cumca=sum(fin_acct),by(ifs_code);
egen cumca_80=sum(fin_acct) if date>1979,by(ifs_code);
egen cumca_90=sum(fin_acct) if date>1989,by(ifs_code);
egen cumca_00=sum(fin_acct) if date>1999,by(ifs_code);
egen cumca_9807=sum(fin_acct) if date>1997 & date<=2007,by(ifs_code);
egen cumca_0816=sum(fin_acct) if date>2007 & date<2017,by(ifs_code);
egen cumca_0817=sum(fin_acct) if date>2007 & date<=2017,by(ifs_code);
egen cay_80=mean(cay) if date>1979,by(ifs_code);
egen cay_90=mean(cay) if date>1989,by(ifs_code);
egen cay_7079=mean(cay) if date<1980,by(ifs_code);
replace cay_7079=cay_7079[_n-30] if date==2009;
egen cay_8089=mean(cay) if date>1979 & date<1990,by(ifs_code);
replace cay_8089=cay_8089[_n-20] if date==2009;
egen cay_9099=mean(cay) if date>1989 & date<2000,by(ifs_code);
replace cay_9099=cay_9099[_n-10] if date==2009;
egen cay_00=mean(cay) if date>1999,by(ifs_code);
g ipnfay_1=ipnfay[_n+1] if ifs_code==ifs_code[_n+1];

**** local currency *****;
g fin_acct_lc=(ca+ka+eo)*e_avg/1000;
egen cumca_lc_80=sum(fin_acct_lc) if date>1979,by(ifs_code);
egen cumca_lc_90=sum(fin_acct_lc) if date>1989,by(ifs_code);
egen cumca_lc_00=sum(fin_acct_lc) if date>1999,by(ifs_code);
egen cumca_lc_9807=sum(fin_acct_lc) if date>1997 & date<=2007,by(ifs_code);
egen cumca_lc_0816=sum(fin_acct_lc) if date>2007 & date<2017,by(ifs_code);
egen cumca_lc_0817=sum(fin_acct_lc) if date>2007 & date<=2017,by(ifs_code);
g cumcay_lc_90=cumca_lc_90/(gdpd*e_avg/1000)*100;
g cumcay_lc_00=cumca_lc_00/(gdpd*e_avg/1000)*100;
g cumcay_lc_9807=cumca_lc_9807/(gdpd*e_avg/1000)*100;
g cumcay_lc_0817=cumca_lc_0817/(gdpd*e_avg/1000)*100;


**** GENERATE CHANGE IN NFA to COMPARE WITH CUMULATIVE ADJUSTED CA *******;
g cumcay_80=cumca_80/gdpd*100;
g cumcay_90=cumca_90/gdpd*100;
g cumcay_00=cumca_00/gdpd*100;
egen cumeo=sum(eo),by(ifs_code);
egen cumeo_0817=sum(eo) if date>=2007,by(ifs_code);
egen cumka_0817=sum(ka) if date>=2007,by(ifs_code);
g cumeoy=cumeo/gdpd*100;

g d_ipnfa_9707=ipnfa-ipnfa[_n-10] if date==2007;
g d_ipnfay_9707=d_ipnfa_9707/gdpd*100;
g d_ipnfa_0716=ipnfa-ipnfa[_n-9] if date==2016;
g d_ipnfay_0716=d_ipnfa_0716/gdpd*100;
g d_ipnfa_0717=ipnfa-ipnfa[_n-10] if date==2017 & ipnfa~=.;
g d_ipnfay_0717=d_ipnfa_0717/gdpd*100;

g d_ipnfa_lc_9707=ipnfa*e_eop/1000-ipnfa[_n-10]*e_eop[_n-10]/1000 if date==2007;
g d_ipnfay_lc_9707=d_ipnfa_lc_9707/(gdpd*e_avg/1000)*100;
g d_ipnfa_lc_0716=ipnfa*e_eop/1000-ipnfa[_n-9]*e_eop[_n-9]/1000 if date==2016;
g d_ipnfay_lc_0716=d_ipnfa_lc_0716/(gdpd*e_avg/1000)*100;
g d_ipnfa_lc_0717=ipnfa*e_eop/1000-ipnfa[_n-10]*e_eop[_n-10]/1000 if date==2017;
g d_ipnfay_lc_0717=d_ipnfa_lc_0717/(gdpd*e_avg/1000)*100;

egen cumeo_lc_0717=sum(eo*e_avg/1000) if date>2007, by (ifs_code);
g sfay_0717_ca=(d_ipnfa_0717-cumca_0817)/(gdpd/1000);
g cumeoy_0717=cumeo_lc_0717/(gdpd*e_avg/1000);

**** GENERATE AVERAGE AND MEDIAN DEBT RATIOS FOR DEVELOPING COUNTRIES*** ;
egen debty_avg=mean(ipdebtly) if ind==0,by(date);
egen debty_mdn=median(ipdebtly) if ind==0 & ipdebtly~=0,by(date);

*** AVG AND MEDIAN EXCLUDING SUB-SAHARAN AFRICA, NICARAGUA, AND PANAMA ****;
egen debty_avg1=mean(ipdebtly) if ind==0 & afr==0 & ifs_code~=278 & ifs_code~=283,by(date);
egen debty_mdn1=median(ipdebtly) if ind==0 & afr==0 & ifs_code~=278 & ifs_code~=283 & ipdebtly~=0,by(date);


********** DEFINE CHANGE IN NFA **** ;
g dnfa=ipnfa-ipnfa[_n-1] if ifs_code==ifs_code[_n-1];
g dnfay=dnfa/gdpd*100;
g gdpd1=gdpd/1000;
