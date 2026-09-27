const STORAGE_KEY="geldtipp-finanz-app-v21"; const PREV_STORAGE_KEY="geldtipp-finanz-app-v10"; const PREV2_STORAGE_KEY="geldtipp-finanz-app-v9"; const LEGACY_STORAGE_KEY="geldtipp-finanz-app-v7"; const OLD_STORAGE_KEY="geldtipp-finanz-app-v3"; const OLDER_STORAGE_KEY="geldtipp-finanz-app-v2"; const TEAL="#12B8A6", BLUE="#3478F6", GREEN="#20A464", PURPLE="#7657D9", RED="#D9534F", ORANGE="#F0A23B";
const defaultState={
 budget:{income:3200,child:250,side:0,other:0,rent:900,utilities:200,internet:40,insurance:80,transport:300,subs:30,loans:100,fixedOther:50,food:350,leisure:100,shopping:100,varOther:100},
 wohnung:{extraIncome:0,rent:900,utilities:250,heating:100,electricity:60,parking:0,other:0,compare:[[1200,280,100,60],[1050,250,90,60],[1300,220,80,60]]},
 sparen:{target:10000,saved:2500,monthly:500,months:15},
 notgroschen:{essentials:1800,months:3,saved:3000},
 auto:{lease:300,insurance:80,tax:20,fuel:180,maintenance:80,tyres:30,parking:40,other:30,kmYear:12000},
 schulden:{balance:8000,rate:0.069,payment:250},
 year:{months:Array.from({length:12},()=>({income:null,fixed:null,variable:null,saving:null}))},
 meta:{firstRun:true,theme:"light",lastPage:"dashboard",profileName:"Mein Haushalt",currentMonth:new Date().getMonth(),currentYear:new Date().getFullYear(),onboarded:false,closedMonths:{},lastBackup:null,appVersion:"2.1.0",privacyVersion:1,plan:"free",lastCategory:"Lebensmittel",lastType:"Ausgabe",lastAccountId:"giro",recentCategories:["Lebensmittel","Wohnen","Mobilität","Freizeit"]},
 categories:["Wohnen","Lebensmittel","Mobilität","Freizeit","Verträge","Gesundheit","Shopping","Essen gehen","Sparen","Sonstiges","Einkommen"],
 categoryColors:{},
 accounts:[{id:"giro",name:"Girokonto",type:"Girokonto",balance:3200,color:"#3478F6"},{id:"save",name:"Sparkonto",type:"Sparen",balance:4200,color:"#12B8A6"}],
 transactions:[],
 budgets:{},
 netWorthHistory:[],
 goals:[{name:"Notgroschen",target:5400,saved:3000,color:"#20A464"},{name:"Urlaub",target:2500,saved:850,color:"#3478F6"},{name:"Große Anschaffung",target:4000,saved:1200,color:"#7657D9"}],
 recurring:[{name:"Miete",amount:900,category:"Wohnen",type:"Ausgabe",active:true,day:1,frequency:"monthly"},{name:"Internet",amount:40,category:"Verträge",type:"Ausgabe",active:true,day:5,frequency:"monthly"},{name:"Gehalt",amount:3200,category:"Einkommen",type:"Einnahme",active:true,day:28,frequency:"monthly"}]
};
const names=["Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember"];

function clone(x){return JSON.parse(JSON.stringify(x))}
function merge(a,b){Object.keys(b||{}).forEach(k=>{if(b[k]&&typeof b[k]==="object"&&!Array.isArray(b[k]))a[k]=merge(a[k]||{},b[k]);else a[k]=b[k]});return a}
function load(){
 try{
   const raw=localStorage.getItem(STORAGE_KEY)||localStorage.getItem(PREV_STORAGE_KEY)||localStorage.getItem(PREV2_STORAGE_KEY)||localStorage.getItem(LEGACY_STORAGE_KEY)||localStorage.getItem(OLD_STORAGE_KEY)||localStorage.getItem(OLDER_STORAGE_KEY);
   const base=clone(defaultState);
   const extra={
     meta:{firstRun:true,theme:"light",lastPage:"dashboard",profileName:"Mein Haushalt",currentMonth:new Date().getMonth(),currentYear:new Date().getFullYear(),onboarded:false,closedMonths:{},lastBackup:null,appVersion:"2.1.0",privacyVersion:1,plan:"free",lastCategory:"Lebensmittel",lastType:"Ausgabe",lastAccountId:"giro",recentCategories:["Lebensmittel","Wohnen","Mobilität","Freizeit"]},
     accounts:[
       {id:"giro",name:"Girokonto",type:"Girokonto",balance:3200,color:"#3478F6"},
       {id:"save",name:"Sparkonto",type:"Sparen",balance:4200,color:"#12B8A6"}
     ],
     transactions:[], budgets:{}, netWorthHistory:[], categories:["Wohnen","Lebensmittel","Mobilität","Freizeit","Verträge","Gesundheit","Shopping","Essen gehen","Sparen","Sonstiges","Einkommen"],
     goals:[
       {name:"Notgroschen",target:5400,saved:3000,color:"#20A464"},
       {name:"Urlaub",target:2500,saved:850,color:"#3478F6"},
       {name:"Große Anschaffung",target:4000,saved:1200,color:"#7657D9"}
     ],
     recurring:[
       {name:"Miete",amount:900,category:"Wohnen",type:"Ausgabe",active:true,day:1},
       {name:"Internet",amount:40,category:"Verträge",type:"Ausgabe",active:true,day:5},
       {name:"Gehalt",amount:3200,category:"Einkommen",type:"Einnahme",active:true,day:28}
     ]
   };
   stateSeed=merge(base,extra);
   if(raw) stateSeed=merge(stateSeed,JSON.parse(raw));
   if(!stateSeed.accounts)stateSeed.accounts=extra.accounts;
   if(!stateSeed.transactions)stateSeed.transactions=[];
   if(!stateSeed.goals)stateSeed.goals=extra.goals;
   if(!stateSeed.recurring)stateSeed.recurring=extra.recurring;
   if(!stateSeed.budgets)stateSeed.budgets={};
   if(!stateSeed.netWorthHistory)stateSeed.netWorthHistory=[];
   if(!stateSeed.categories)stateSeed.categories=extra.categories;
   if(!stateSeed.categoryColors)stateSeed.categoryColors={};
   stateSeed.meta=merge(extra.meta,stateSeed.meta||{});
   if(!Array.isArray(stateSeed.categories)||!stateSeed.categories.length)stateSeed.categories=extra.categories;
   if(!stateSeed.categories.includes("Sonstiges"))stateSeed.categories.push("Sonstiges");
   if(!stateSeed.categories.includes("Einkommen"))stateSeed.categories.push("Einkommen");
   if(!stateSeed.categoryColors)stateSeed.categoryColors={};
   stateSeed.recurring=(stateSeed.recurring||[]).map(x=>({...x,frequency:x.frequency||"monthly",day:x.day||1,active:x.active!==false}));
   stateSeed.meta=merge({plan:"free",lastCategory:"Lebensmittel",lastType:"Ausgabe",lastAccountId:stateSeed.accounts?.[0]?.id||"",recentCategories:["Lebensmittel","Wohnen","Mobilität","Freizeit"]},stateSeed.meta||{});
   return stateSeed;
 }catch{return clone(defaultState)}
}
function makeInitialState(){
 const st=clone(defaultState);
 st.meta=merge(st.meta,{profileName:"Mein Haushalt",currentMonth:new Date().getMonth(),currentYear:new Date().getFullYear(),onboarded:false,closedMonths:{},lastBackup:null});
 st.accounts=[{id:"giro",name:"Girokonto",type:"Girokonto",balance:3200,color:BLUE},{id:"save",name:"Sparkonto",type:"Sparen",balance:4200,color:TEAL}];
 st.transactions=[];st.budgets={};st.netWorthHistory=[];st.categoryColors={};
 st.categories=["Wohnen","Lebensmittel","Mobilität","Freizeit","Verträge","Gesundheit","Shopping","Essen gehen","Sparen","Sonstiges","Einkommen"];
 st.goals=[{name:"Notgroschen",target:5400,saved:3000,color:GREEN},{name:"Urlaub",target:2500,saved:850,color:BLUE},{name:"Große Anschaffung",target:4000,saved:1200,color:PURPLE}];
 st.recurring=[{name:"Miete",amount:900,category:"Wohnen",type:"Ausgabe",active:true,day:1,frequency:"monthly"},{name:"Internet",amount:40,category:"Verträge",type:"Ausgabe",active:true,day:5,frequency:"monthly"},{name:"Gehalt",amount:3200,category:"Einkommen",type:"Einnahme",active:true,day:28,frequency:"monthly"}];
 return st;
}
let stateSeed; let state=load(), current=state.meta.lastPage||"dashboard";
state.transactions=Array.isArray(state.transactions)?state.transactions:[];state.accounts=Array.isArray(state.accounts)&&state.accounts.length?state.accounts:makeInitialState().accounts;state.goals=Array.isArray(state.goals)?state.goals:makeInitialState().goals;state.recurring=Array.isArray(state.recurring)?state.recurring:makeInitialState().recurring;state.budgets=state.budgets&&typeof state.budgets==="object"?state.budgets:{};
function save(){state.meta.lastPage=current;try{recordNetWorth()}catch{}try{localStorage.setItem(STORAGE_KEY,JSON.stringify(state));const ss=document.getElementById("saveState"),sh=document.getElementById("storageHint");if(ss)ss.textContent="Gespeichert • "+new Date().toLocaleTimeString("de-DE",{hour:"2-digit",minute:"2-digit"});if(sh)sh.textContent="Daten lokal auf diesem Gerät gespeichert"}catch(e){const ss=document.getElementById("saveState"),sh=document.getElementById("storageHint");if(ss)ss.textContent="Sitzung aktiv";if(sh)sh.textContent="Lokale Speicherung ist in diesem Browser eingeschränkt"}}
function esc(v){return String(v??"").replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#39;")}
function num(v){return Math.max(0,Number(String(v).replace(",", "."))||0)}
function eur(v){return new Intl.NumberFormat("de-DE",{style:"currency",currency:"EUR",maximumFractionDigits:0}).format(Number(v)||0)}
function pct(v){return (Number(v)||0).toLocaleString("de-DE",{style:"percent",maximumFractionDigits:1})}
function pageTitle(p){return ({dashboard:"Dashboard",konten:"Konten",budget:"Budget",wohnung:"Wohnungs-Check",sparen:"Sparziel",notgroschen:"Notgroschen",auto:"Auto-Kosten",schulden:"Schulden-Check",jahr:"Jahresübersicht",abschluss:"Monatsabschluss",transaktionen:"Transaktionen",ziele:"Meine Ziele",wiederkehrend:"Wiederkehrend",einstellungen:"Einstellungen",vermoegen:"Vermögen",coach:"Geldtipp Coach",report:"Jahresreport"})[p]||"Dashboard"}
function setPage(p){current=p;state.meta.lastPage=p;save();document.querySelectorAll(".nav button").forEach(b=>b.classList.toggle("active",b.dataset.page===p));document.querySelectorAll("#mobileDock button").forEach(b=>b.classList.toggle("active",b.dataset.page===p));document.getElementById("pageTitle").textContent=pageTitle(p);render();if(innerWidth<820)document.getElementById("sidebar").classList.remove("open")}
document.querySelectorAll(".nav button").forEach(b=>b.addEventListener("click",()=>setPage(b.dataset.page)));
document.querySelectorAll("#mobileDock button").forEach(b=>b.addEventListener("click",()=>setPage(b.dataset.page)));
document.getElementById("mobileMenu").addEventListener("click",()=>document.getElementById("sidebar").classList.toggle("open"));
document.getElementById("prevMonth").addEventListener("click",()=>shiftMonth(-1));
document.getElementById("nextMonth").addEventListener("click",()=>shiftMonth(1));
document.getElementById("themeBtn").addEventListener("click",()=>{state.meta.theme=state.meta.theme==="dark"?"light":"dark";applyTheme();save()});
document.getElementById("helpBtn").addEventListener("click",()=>showHelp());
function applyTheme(){document.documentElement.dataset.theme=state.meta.theme==="dark"?"dark":"light";document.getElementById("themeBtn").textContent=state.meta.theme==="dark"?"☀":"◐"}
applyTheme()

function totals(){const b=state.budget;const income=num(b.income)+num(b.child)+num(b.side)+num(b.other);const fixed=num(b.rent)+num(b.utilities)+num(b.internet)+num(b.insurance)+num(b.transport)+num(b.subs)+num(b.loans)+num(b.fixedOther);const variable=num(b.food)+num(b.leisure)+num(b.shopping)+num(b.varOther);return {income,fixed,variable,surplus:income-fixed-variable,saverate:income?(income-fixed-variable)/income:0}}
function housing(){const t=totals(),w=state.wohnung,income=t.income+num(w.extraIncome),costs=num(w.rent)+num(w.utilities)+num(w.heating)+num(w.electricity)+num(w.parking)+num(w.other);return {income,costs,ratio:income?costs/income:0,buffer:income-costs,limit:income*.30}}
function savings(){const s=state.sparen,remaining=Math.max(num(s.target)-num(s.saved),0),req=num(s.months)?remaining/num(s.months):0,progress=num(s.target)?Math.min(num(s.saved)/num(s.target),1):0,months=num(s.monthly)>0?Math.ceil(remaining/num(s.monthly)):0;return {remaining,req,progress,months}}
function emergency(){const x=state.notgroschen,target=num(x.essentials)*num(x.months);return {target,missing:Math.max(target-num(x.saved),0),coverage:target?Math.min(num(x.saved)/target,1):0}}
function car(){const a=state.auto,monthly=num(a.lease)+num(a.insurance)+num(a.tax)+num(a.fuel)+num(a.maintenance)+num(a.tyres)+num(a.parking)+num(a.other),annual=monthly*12;return {monthly,annual,kmCost:num(a.kmYear)?annual/num(a.kmYear):0}}
function debt(){const d=state.schulden,i=num(d.rate)/12,p=num(d.payment),bal=num(d.balance);if(!bal||!p||p<=bal*i)return {months:null,interest:null};const months=Math.ceil(-Math.log(1-bal*i/p)/Math.log(1+i));return {months,interest:Math.max(p*months-bal,0)}}

function allAccountsBalance(){return (state.accounts||[]).reduce((s,a)=>s+num(a.balance),0)}
function netWorth(){return allAccountsBalance()-num(state.schulden?.balance)}
function monthTx(){
 const m=state.meta.currentMonth,y=state.meta.currentYear;
 return (state.transactions||[]).filter(x=>{const d=new Date(x.date);return d.getMonth()===m&&d.getFullYear()===y})
}
function monthTxTotals(){
 const list=monthTx(),income=list.filter(x=>x.type==="Einnahme").reduce((s,x)=>s+num(x.amount),0),expense=list.filter(x=>x.type==="Ausgabe").reduce((s,x)=>s+num(x.amount),0);
 return {income,expense,balance:income-expense,count:list.length}
}
function categoryTotals(){
 const out={};
 monthTx().filter(x=>x.type==="Ausgabe").forEach(x=>out[x.category]=(out[x.category]||0)+num(x.amount));
 return Object.entries(out).sort((a,b)=>b[1]-a[1]);
}
function annualTotals(){
 const y=state.meta.currentYear, arr=[];
 for(let m=0;m<12;m++){
  const xs=(state.transactions||[]).filter(x=>{const d=new Date(x.date);return d.getFullYear()===y&&d.getMonth()===m});
  const income=xs.filter(x=>x.type==="Einnahme").reduce((s,x)=>s+num(x.amount),0);
  const expense=xs.filter(x=>x.type==="Ausgabe").reduce((s,x)=>s+num(x.amount),0);
  arr.push({month:m,income,expense,balance:income-expense});
 }
 return arr;
}
function accountName(id){return (state.accounts||[]).find(a=>a.id===id)?.name||"—"}
function scoreLabel(score){return score>=80?"Sehr solide":score>=60?"Gute Basis":score>=40?"Ausbaufähig":"Budget prüfen"}

function monthKey(y=state.meta.currentYear,m=state.meta.currentMonth){return `${y}-${String(m+1).padStart(2,"0")}`}
function budgetFor(cat){return num((state.budgets||{})[monthKey()]?.[cat]||0)}
function monthBudgetTotal(){return Object.values((state.budgets||{})[monthKey()]||{}).reduce((a,b)=>a+num(b),0)}
function recurringMonthly(){return (state.recurring||[]).filter(x=>x.active&&x.type==="Ausgabe").reduce((sum,x)=>sum+num(x.amount)*(x.frequency==="yearly"?1/12:1),0)}
function subscriptionTotal(){return (state.recurring||[]).filter(x=>x.active&&x.type==="Ausgabe"&&["Abos","Verträge"].includes(x.category)).reduce((a,x)=>a+num(x.amount)*(x.frequency==="yearly"?1/12:1),0)}
function smartAlerts(){
 const alerts=[],t=monthTxTotals(),cats=categoryTotals();
 if(t.balance<0)alerts.push({kind:"red",title:"Monat im Minus",text:"Deine erfassten Ausgaben liegen über den Einnahmen."});
 if(monthBudgetTotal()>0&&t.expense>monthBudgetTotal())alerts.push({kind:"red",title:"Budget überschritten",text:`Du liegst ${eur(t.expense-monthBudgetTotal())} über deinem Monatsbudget.`});
 const food=(cats.find(x=>x[0]==="Lebensmittel")?.[1]||0)+(cats.find(x=>x[0]==="Essen gehen")?.[1]||0);
 if(t.income>0&&food/t.income>.2)alerts.push({kind:"amber",title:"Lebensmittel & Essen",text:"Dieser Bereich macht mehr als 20 % deiner Monatseinnahmen aus."});
 if(recurringMonthly()>0&&t.income>0&&recurringMonthly()/t.income>.5)alerts.push({kind:"amber",title:"Hohe Fixkosten",text:"Wiederkehrende Ausgaben binden mehr als die Hälfte der Einnahmen."});
 if(alerts.length===0)alerts.push({kind:"green",title:"Keine kritischen Hinweise",text:"Deine aktuelle Finanzübersicht enthält keine auffälligen Werte."});
 return alerts;
}
function previousMonthTotals(){
 let m=state.meta.currentMonth-1,y=state.meta.currentYear;if(m<0){m=11;y--}
 const xs=(state.transactions||[]).filter(x=>{const d=new Date(x.date);return d.getMonth()===m&&d.getFullYear()===y});
 const income=xs.filter(x=>x.type==="Einnahme").reduce((a,x)=>a+num(x.amount),0),expense=xs.filter(x=>x.type==="Ausgabe").reduce((a,x)=>a+num(x.amount),0);
 return {income,expense,balance:income-expense};
}
function smartInsights(){
 const now=monthTxTotals(),prev=previousMonthTotals(),items=[];
 if(now.expense>0&&prev.expense>0){const d=(now.expense-prev.expense)/prev.expense;items.push({label:"Ausgaben",title:`${d<=0?"Weniger":"Mehr"} ausgegeben`,text:`Im Vergleich zum Vormonat sind deine erfassten Ausgaben ${Math.abs(d*100).toFixed(0)} % ${d<=0?"gesunken":"gestiegen"}.`});}
 const cats=categoryTotals();if(cats[0])items.push({label:"Top-Kategorie",title:cats[0][0],text:`Mit ${eur(cats[0][1])} ist das aktuell deine größte erfasste Ausgabenkategorie.`});
 const s=savings();if(s.remaining>0)items.push({label:"Sparziel",title:`Noch ${eur(s.remaining)}`,text:`Bei ${eur(num(state.sparen.monthly))} monatlicher Sparrate wären rechnerisch etwa ${s.months||"—"} Monate nötig.`});
 const e=emergency();items.push({label:"Notgroschen",title:`${pct(e.coverage)} abgedeckt`,text:e.missing>0?`Es fehlen noch ${eur(e.missing)} bis zu deinem definierten Ziel.`:"Dein definiertes Notgroschen-Ziel ist vollständig erreicht."});
 const rw=recurringMonthly();if(now.income>0)items.push({label:"Fixkosten",title:`${pct(rw/now.income)} der Einnahmen`,text:`Aktive regelmäßige Ausgaben entsprechen etwa ${eur(rw)} pro Monat.`});
 return items.slice(0,3);
}
function recentCategoryList(){const r=Array.isArray(state.meta?.recentCategories)?state.meta.recentCategories:[];return r.filter((x,i)=>r.indexOf(x)===i&&state.categories?.includes(x)).slice(0,5)}
function rememberCategory(cat){if(!cat)return;const arr=[cat,...recentCategoryList().filter(x=>x!==cat)];state.meta.recentCategories=arr.slice(0,5)}
function coachData(){
 const t=monthTxTotals(), prev=previousMonthTotals(), cats=categoryTotals(), e=emergency(), s=savings(), h=housing(), n=netWorth();
 const items=[];
 if(t.income>0&&t.expense>0){const rate=t.balance/t.income;items.push({tone:rate>=.2?'green':rate>=0?'amber':'red',icon:rate>=.2?'✓':rate>=0?'!':'!',title:rate>=.2?'Du bist auf Kurs':'Monat im Blick behalten',text:`Dein aktueller Buchungssaldo liegt bei ${pct(rate)} der erfassten Einnahmen.`,action:'transaktionen'});}
 if(prev.expense>0){const d=(t.expense-prev.expense)/prev.expense;items.push({tone:d<=0?'green':'amber',icon:d<=0?'↓':'↑',title:`${d<=0?'Weniger':'Mehr'} Ausgaben als im Vormonat`,text:`Die erfassten Ausgaben ${d<=0?'sind':'liegen'} ${Math.abs(d*100).toFixed(0)} % ${d<=0?'unter':'über'} dem Vormonat.`,action:'dashboard'});}
 if(cats[0])items.push({tone:cats[0][1]>Math.max(t.income*.25,1)?'amber':'blue',icon:'€',title:`${cats[0][0]} im Fokus`,text:`${eur(cats[0][1])} entfallen diesen Monat auf deine größte Ausgabenkategorie.`,action:'budget'});
 items.push({tone:e.coverage>=1?'green':'blue',icon:'⌂',title:e.coverage>=1?'Notgroschen erreicht':'Notgroschen aufbauen',text:e.coverage>=1?'Dein definiertes Ziel ist vollständig abgedeckt.':`Noch ${eur(e.missing)} bis zu deinem Ziel.`,action:'notgroschen'});
 if(h.ratio>0.3)items.push({tone:'amber',icon:'⌂',title:'Wohnkosten prüfen',text:`Die Wohnkostenquote liegt bei ${pct(h.ratio)}.`,action:'wohnung'});
 if(s.remaining>0&&num(state.sparen.monthly)>0)items.push({tone:'green',icon:'★',title:'Sparziel planbar',text:`Bei ${eur(state.sparen.monthly)} pro Monat bleiben rechnerisch noch etwa ${s.months} Monate.`,action:'ziele'});
 items.push({tone:n>=0?'blue':'red',icon:'◈',title:`Nettovermögen ${eur(n)}`,text:'Kontostände abzüglich der hinterlegten Schulden.',action:'vermoegen'});
 return items.slice(0,6);
}
function annualReport(){
 const y=state.meta.currentYear,rows=annualTotals();
 const income=rows.reduce((a,x)=>a+x.income,0),expense=rows.reduce((a,x)=>a+x.expense,0),balance=income-expense;
 const best=rows.reduce((a,b)=>b.balance>a.balance?b:a,rows[0]||{month:0,balance:0});
 const worst=rows.reduce((a,b)=>b.balance<a.balance?b:a,rows[0]||{month:0,balance:0});
 const cats={};(state.transactions||[]).filter(x=>x.type==='Ausgabe'&&new Date(x.date).getFullYear()===y).forEach(x=>cats[x.category]=(cats[x.category]||0)+num(x.amount));
 const top=Object.entries(cats).sort((a,b)=>b[1]-a[1]).slice(0,5);
 const start=(state.netWorthHistory||[]).find(x=>new Date(x.date).getFullYear()===y); const hist=(state.netWorthHistory||[]).filter(x=>new Date(x.date).getFullYear()===y); const end=hist.length?hist[hist.length-1]:null;
 const wealthDelta=end&&start?num(end.value)-num(start.value):0;
 const savingRate=income?balance/income:0;
 const fixedRecurring=yearlyRecurringCost();
 return {y,rows,income,expense,balance,savingRate,best,worst,top,wealthDelta,fixedRecurring,endValue:end?num(end.value):netWorth()};
}
function renderCoach(){
 const items=coachData(),s=financeScore();
 return `<div class="report-hero"><div class="eyebrow"><span class="brand-mark">✦</span> GELDTIPP COACH</div><h2>Dein Geld. Deine nächsten Schritte.</h2><p>Geldtipp analysiert deine eigenen Daten und macht daraus konkrete, nachvollziehbare Hinweise.</p><div class="report-actions"><button class="btn btn-teal" onclick="openQuickAdd()">＋ Jetzt buchen</button><button class="btn btn-secondary" onclick="setPage('report')">Jahresreport ansehen →</button></div></div>
 <div class="report-kpis"><div class="card"><small>Finanz-Score</small><strong>${s}/100</strong><div class="chart-caption">${scoreLabel(s)}</div></div><div class="card"><small>Sparquote</small><strong>${pct(totals().saverate)}</strong><div class="chart-caption">Budgetplanung</div></div><div class="card"><small>Nettovermögen</small><strong>${eur(netWorth())}</strong><div class="chart-caption">Konten minus Schulden</div></div><div class="card"><small>Fixkosten</small><strong>${eur(recurringMonthly())}</strong><div class="chart-caption">pro Monat</div></div></div>
 <div class="panel" style="margin-top:18px"><div class="panel-head"><div><h2>Deine aktuellen Empfehlungen</h2><p>Rein datenbasiert aus deinen gespeicherten Werten.</p></div></div><div class="coach-list">${items.map(x=>`<div class="coach-item"><div class="coach-icon">${x.icon}</div><div><strong>${esc(x.title)}</strong><p>${esc(x.text)}</p></div><button class="btn btn-secondary" onclick="setPage('${x.action}')">Öffnen</button></div>`).join('')}</div></div>
 <div class="panel"><div class="panel-head"><div><h2>Coach-Grundsätze</h2><p>Geldtipp erklärt, statt Entscheidungen für dich zu treffen.</p></div></div><div class="feature-grid"><div>✓ Keine erfundenen Finanzwerte</div><div>✓ Hinweise aus deinen eigenen Daten</div><div>✓ Transparente Berechnungen</div><div>✓ Keine automatische Handlung ohne dich</div></div></div>`;
}
function renderReport(){
 const r=annualReport(), topRows=r.top.map(([c,v])=>`<tr><td>${esc(c)}</td><td>${eur(v)}</td><td>${r.expense?pct(v/r.expense):pct(0)}</td></tr>`).join('');
 const monthRows=r.rows.map(x=>`<tr><td>${names[x.month]}</td><td>${eur(x.income)}</td><td>${eur(x.expense)}</td><td class="${x.balance>=0?'money-positive':'money-negative'}">${eur(x.balance)}</td></tr>`).join('');
 return `<div class="report-hero"><div class="eyebrow"><span class="brand-mark">▤</span> GELDTIPP JAHRESREPORT</div><h2>Dein Finanzjahr ${r.y}</h2><p>Eine kompakte Jahresanalyse aus deinen erfassten Buchungen, Budgets, Zielen und Vermögenswerten.</p><div class="report-actions"><button class="btn btn-teal" onclick="window.print()">Drucken / als PDF sichern</button><button class="btn btn-secondary" onclick="setPage('coach')">Coach öffnen →</button></div></div>
 <div class="report-kpis"><div class="card"><small>Einnahmen</small><strong>${eur(r.income)}</strong><div class="chart-caption">erfasst</div></div><div class="card"><small>Ausgaben</small><strong>${eur(r.expense)}</strong><div class="chart-caption">erfasst</div></div><div class="card"><small>Gespart / Überschuss</small><strong class="${r.balance>=0?'money-positive':'money-negative'}">${eur(r.balance)}</strong><div class="chart-caption">Sparquote ${pct(r.savingRate)}</div></div><div class="card"><small>Nettovermögen</small><strong>${eur(r.endValue)}</strong><div class="chart-caption">${r.wealthDelta===0?'kein Jahresvergleich':`${r.wealthDelta>0?'+':''}${eur(r.wealthDelta)} im Verlauf`}</div></div></div>
 <div class="grid dashboard-grid" style="margin-top:18px"><div class="panel"><div class="panel-head"><div><h2>Monat für Monat</h2><p>Einnahmen, Ausgaben und Saldo</p></div></div><div style="overflow:auto"><table class="report-table"><thead><tr><th>Monat</th><th>Einnahmen</th><th>Ausgaben</th><th>Saldo</th></tr></thead><tbody>${monthRows}</tbody></table></div></div><div class="panel"><div class="panel-head"><div><h2>Die wichtigsten Zahlen</h2><p>Was dein Jahr geprägt hat</p></div></div><div class="stat-grid"><div class="stat-box"><small>Bester Monat</small><strong>${names[r.best.month]}</strong><div class="chart-caption">${eur(r.best.balance)}</div></div><div class="stat-box"><small>Schwächster Monat</small><strong>${names[r.worst.month]}</strong><div class="chart-caption">${eur(r.worst.balance)}</div></div><div class="stat-box"><small>Laufende Kosten</small><strong>${eur(r.fixedRecurring)}</strong><div class="chart-caption">pro Jahr</div></div></div></div></div>
 <div class="grid dashboard-grid"><div class="panel"><div class="panel-head"><div><h2>Top-Ausgabenkategorien</h2><p>Jahresanteil</p></div></div><div style="overflow:auto"><table class="report-table"><thead><tr><th>Kategorie</th><th>Betrag</th><th>Anteil</th></tr></thead><tbody>${topRows||'<tr><td colspan="3">Noch keine Jahresbuchungen.</td></tr>'}</tbody></table></div></div><div class="panel"><div class="panel-head"><div><h2>Was du mitnehmen kannst</h2><p>Automatisch aus dem Jahresverlauf</p></div></div><div class="coach-list"><div class="coach-item"><div class="coach-icon">★</div><div><strong>${r.balance>=0?'Positiver Jahres-Cashflow':'Negativer Jahres-Cashflow'}</strong><p>${r.balance>=0?`Du hast ${eur(r.balance)} mehr erfasst eingenommen als ausgegeben.`:`Deine erfassten Ausgaben liegen ${eur(Math.abs(r.balance))} über den Einnahmen.`}</p></div></div><div class="coach-item"><div class="coach-icon">◈</div><div><strong>Vermögensentwicklung</strong><p>${r.wealthDelta===0?'Noch kein belastbarer Jahresvergleich gespeichert.':`${r.wealthDelta>0?'Plus':'Minus'} ${eur(Math.abs(r.wealthDelta))} im gespeicherten Verlauf.`}</p></div></div></div></div></div>`;
}
function renderWealth(){
 const hist=(state.netWorthHistory||[]).slice(-60),current=netWorth(),start=hist.length?num(hist[0].value):current,delta=current-start;
 const max=Math.max(...hist.map(x=>num(x.value)),current,1),min=Math.min(...hist.map(x=>num(x.value)),0),range=Math.max(max-min,1);
 const bars=hist.length?hist.map((x,i)=>`<div class="wealth-bar" style="height:${Math.max(4,(num(x.value)-min)/range*100)}%" title="${new Date(x.date).toLocaleDateString("de-DE")}: ${eur(x.value)}"><span>${i===0||i===hist.length-1?new Date(x.date).toLocaleDateString("de-DE",{day:"2-digit",month:"2-digit"}):""}</span></div>`).join(""):`<div class="empty">Noch keine Verlaufsdaten vorhanden. Mit der Nutzung entsteht automatisch eine Zeitreihe.</div>`;
 const accounts=(state.accounts||[]).map(a=>`<div class="mini-row"><span>${esc(a.name)}<small style="display:block;color:var(--muted)">${esc(a.type||"Konto")}</small></span><strong>${eur(a.balance)}</strong></div>`).join("");
 return `<div class="grid dashboard-grid"><div class="card"><div class="panel-head"><div><h2>Nettovermögen</h2><p>Deine aktuellen Kontostände und deren Entwicklung.</p></div><button class="btn btn-teal" onclick="recordWealthSnapshot()">Momentaufnahme</button></div><div class="big-money">${eur(current)}</div><div class="${delta>=0?"alert green":"alert red"}"><strong>${delta>=0?"Aufwärtsentwicklung":"Rückgang"}</strong><span>${delta===0?"Seit dem ersten gespeicherten Punkt unverändert.":`${eur(Math.abs(delta))} Veränderung seit dem ersten gespeicherten Punkt.`}</span></div><div class="wealth-bars">${bars}</div><div class="chart-caption">Die Entwicklung basiert auf gespeicherten Kontoständen. Einzelne Buchungen werden nicht doppelt bewertet.</div></div><div class="card"><div class="panel-head"><div><h2>Konten</h2><p>Zusammensetzung deines Vermögens</p></div></div>${accounts||`<div class="empty">Keine Konten.</div>`}</div></div><div class="stat-grid"><div class="stat-box"><small>Aktuelles Vermögen</small><strong>${eur(current)}</strong></div><div class="stat-box"><small>Veränderung</small><strong>${delta>=0?"+":"−"}${eur(Math.abs(delta))}</strong></div><div class="stat-box"><small>Konten</small><strong>${(state.accounts||[]).length}</strong></div></div><div class="card" style="margin-top:18px"><div class="panel-head"><div><h2>Was gehört dazu?</h2><p>Nettovermögen = Kontostände minus dem im Schulden-Check hinterlegten offenen Schuldenbetrag.</p></div></div><div class="actions"><button class="btn btn-primary" onclick="setPage('konten')">Konten verwalten →</button><button class="btn btn-secondary" onclick="setPage('schulden')">Schulden prüfen →</button></div></div>`;
}
function recordWealthSnapshot(){recordNetWorth();save();render();toast("Vermögensstand gespeichert")}
function recordNetWorth(){
 const key=new Date().toISOString().slice(0,10),val=netWorth(),arr=state.netWorthHistory||[],last=arr[arr.length-1];
 if(!last||last.date!==key)arr.push({date:key,value:val});
 state.netWorthHistory=arr.slice(-180);
}
function txTotals(){const income=state.transactions.filter(x=>x.type==="Einnahme").reduce((s,x)=>s+num(x.amount),0),expense=state.transactions.filter(x=>x.type==="Ausgabe").reduce((s,x)=>s+num(x.amount),0);return {income,expense,balance:income-expense}}
function financeScore(){
 const t=totals(),h=housing(),e=emergency(),s=savings(),bal=allAccountsBalance();
 let score=0;
 if(t.surplus>0)score+=25; if(t.saverate>=.2)score+=20; else if(t.saverate>=.1)score+=14; else if(t.saverate>=0)score+=7;
 if(h.ratio<=.3)score+=20; else if(h.ratio<=.4)score+=10;
 if(e.coverage>=1)score+=20; else if(e.coverage>=.5)score+=10;
 if(s.progress>=.5)score+=10; if(bal>0)score+=5;
 return Math.min(score,100)
}
function monthLabel(){return names[state.meta.currentMonth]+" "+state.meta.currentYear}

function input(label,key,obj,opts={}){const type=opts.type||"number",step=opts.step||"0.01",value=opts.percent?(num(obj[key])*100):(obj[key]??0);return `<div class="field"><label>${label}</label><input type="${type}" inputmode="${type==="number"?"decimal":"text"}" step="${step}" value="${value}" data-key="${key}" data-group="${opts.group||""}" ${opts.percent?"data-percent=\"true\"":""}></div>`}
function wireInputs(){document.querySelectorAll("[data-key]").forEach(el=>{const obj=state[el.dataset.group];if(!obj)return;const apply=()=>{let v=el.value;if(el.dataset.percent==="true")v=num(v)/100;else if(el.type==="number")v=num(v);obj[el.dataset.key]=v;save()};el.addEventListener("input",apply);el.addEventListener("change",()=>render())});document.querySelectorAll(".ym").forEach(el=>{const apply=()=>{state.year.months[Number(el.dataset.i)][el.dataset.k]=num(el.value);save()};el.addEventListener("input",apply);el.addEventListener("change",()=>render())})}
function card(title,value,hint=""){return `<div class="card kpi"><div class="label">${title}</div><div class="value">${value}</div>${hint?`<div class="hint">${hint}</div>`:""}</div>`}
function module(page,icon,title,desc,color){return `<div class="card module" style="border-top:4px solid ${color}"><div class="icon">${icon}</div><h3>${title}</h3><p>${desc}</p><button onclick="setPage('${page}')">Öffnen →</button></div>`}
function quick(page,title,sub){return `<button onclick="setPage('${page}')"><span class="q-title">${title}</span><span class="q-sub">${sub}</span></button>`}

function yearlyRecurringCost(){return (state.recurring||[]).filter(x=>x.active&&x.type==="Ausgabe").reduce((sum,x)=>sum+num(x.amount)*(x.frequency==="yearly"?1:12),0)}
function nextRecurringItems(){
 const now=new Date(state.meta.currentYear,state.meta.currentMonth,new Date().getDate());
 return (state.recurring||[]).filter(x=>x.active).map(x=>{const day=Math.min(Number(x.day)||1,28);let d=new Date(state.meta.currentYear,state.meta.currentMonth,day);if(d<now)d=new Date(state.meta.currentYear,state.meta.currentMonth+1,day);return {...x,nextDate:d}}).sort((a,b)=>a.nextDate-b.nextDate).slice(0,6);
}
function renderClosePage(){
 const k=monthKey(),t=monthTxTotals(),budget=monthBudgetTotal(),prev=previousMonthTotals(),closed=state.meta.closedMonths?.[k],top=categoryTotals()[0],variance=budget-t.expense;
 const history=Object.entries(state.meta.closedMonths||{}).sort((a,b)=>b[0].localeCompare(a[0])).slice(0,12);
 return `<div class="close-hero"><div class="eyebrow">GELDTIPP • ${closed?"ABGESCHLOSSEN":"MONATSCHECK"}</div><h2>${monthLabel()}</h2><p>${closed?"Dieser Monat wurde gespeichert. Du kannst jederzeit die Zusammenfassung erneut öffnen.":"Schließe deinen Monat ab und halte deine finanzielle Entwicklung fest."}</p><div class="actions" style="margin-top:14px"><button class="btn btn-teal" onclick="${closed?"showCloseSummary()":"closeCurrentMonth()"}">${closed?"Abschluss ansehen":"Monat abschließen ✓"}</button><button class="btn btn-secondary" onclick="setPage('vermoegen')">Vermögen ansehen →</button></div></div>
 <div class="grid kpis">${card("Einnahmen",eur(t.income),prev.income?`Vormonat ${eur(prev.income)}`:"noch kein Vergleich")}${card("Ausgaben",eur(t.expense),prev.expense?`${t.expense<=prev.expense?"↓":"↑"} ${eur(Math.abs(t.expense-prev.expense))}`:"noch kein Vergleich")}${card("Monatssaldo",eur(t.balance),t.balance>=0?"im Plus":"im Minus")}${card("Sparquote",pct(t.income?t.balance/t.income:0),"aus erfassten Buchungen")}</div>
 <div class="grid dashboard-grid" style="margin-top:18px"><div class="card"><div class="panel-head"><div><h2>Budget-Check</h2><p>Plan gegen tatsächliche Ausgaben</p></div></div><div class="stat-grid"><div class="stat-box"><small>Budget</small><strong>${eur(budget)}</strong></div><div class="stat-box"><small>Ausgaben</small><strong>${eur(t.expense)}</strong></div><div class="stat-box"><small>${variance>=0?"Übrig":"Über Budget"}</small><strong class="${variance>=0?"money-positive":"money-negative"}">${eur(Math.abs(variance))}</strong></div></div></div>
 <div class="card"><div class="panel-head"><div><h2>Monatsfazit</h2><p>Automatisch aus deinen Daten</p></div></div>${top?`<div class="insight"><div class="eyebrow">Größte Kategorie</div><strong>${esc(top[0])} · ${eur(top[1])}</strong><p>${variance>=0?"Dein erfasstes Budget wurde eingehalten.":"Prüfe die größten Ausgaben vor dem nächsten Monat."}</p></div>`:`<div class="empty">Noch keine Ausgaben erfasst.</div>`}</div></div>
 <div class="panel" style="margin-top:18px"><div class="panel-head"><div><h2>Abschluss-Historie</h2><p>Gespeicherte Monats-Snapshots</p></div></div><div class="history-list">${history.map(([key,x])=>`<div class="history-item"><div><small>${key} · ${new Date(x.closedAt).toLocaleDateString("de-DE")}</small><strong>${eur(x.balance)} Monatssaldo</strong></div><button class="btn btn-secondary" onclick="showCloseSummary('${key}')">Ansehen</button></div>`).join("")||`<div class="empty">Noch kein Monatsabschluss gespeichert.</div>`}</div></div>`;
}

function renderDashboard(){
 const t=totals(),h=housing(),e=emergency(),s=savings(),score=financeScore(),mt=monthTxTotals(),cats=categoryTotals();
 const trend=annualTotals(), max=Math.max(...trend.map(x=>Math.max(x.income,x.expense)),1),top=cats[0];
 const upcoming=(state.recurring||[]).filter(x=>x.active).slice(0,4);
 return `<div class="hero"><div class="hero-row"><div class="hero-main"><div class="eyebrow"><span class="brand-mark">€</span> GELDTIPP • ${esc(state.meta.profileName||'MEIN HAUSHALT').toUpperCase()}</div><h2>Dein Geld im Griff.</h2><p>${monthLabel()} · ${scoreLabel(score)} · Alles Wichtige auf einen Blick.</p></div><div class="hero-meta"><div class="amount">${eur(netWorth())}</div><div class="sub">Nettovermögen</div><button class="btn btn-secondary month-close" onclick="closeCurrentMonth()">✓ ${state.meta.closedMonths?.[monthKey()]?'Monat ansehen':'Monat abschließen'}</button></div></div></div>
 <div class="dashboard-toolbar"><div><strong>${monthLabel()}</strong><span>${state.meta.closedMonths?.[monthKey()]?'✓ abgeschlossen':'offen · erfasse deine Buchungen'}</span></div><button class="btn btn-teal" onclick="openQuickAdd()">＋ Schnell erfassen</button></div>
 <div class="dashboard-focus"><div class="focus-card"><small>Verfügbar nach Planung</small><strong>${eur(Math.max(t.surplus,0))}</strong><span>${eur(t.income)} Einnahmen · ${eur(t.fixed+t.variable)} geplante Ausgaben</span></div><div class="focus-card"><small>Dieser Monat</small><strong class="${mt.balance>=0?'money-positive':'money-negative'}">${eur(mt.balance)}</strong><span>${eur(mt.income)} erfasst · ${eur(mt.expense)} ausgegeben</span></div><div class="focus-card"><small>Sparquote</small><strong>${pct(t.saverate)}</strong><span>Planwert aus deinem Budget</span></div></div>
 <div class="panel" style="margin-top:18px"><div class="panel-head"><div><h2>✦ Geldtipp Coach</h2><p>Deine drei wichtigsten Hinweise für den Moment.</p></div><button class="btn btn-secondary" onclick="setPage('coach')">Alle Empfehlungen →</button></div><div class="insight-grid">${coachData().slice(0,3).map(x=>`<div class="insight"><div class="eyebrow">${x.icon} Coach</div><strong>${esc(x.title)}</strong><p>${esc(x.text)}</p></div>`).join('')}</div></div>
 <div class="fast-book panel"><div class="fast-book-main"><div class="section-title" style="margin-top:0">Schnellbuchung</div><div class="big-money" style="margin:0">${eur(mt.balance)}</div><div class="chart-caption">Buchungssaldo ${monthLabel()}</div><div class="recent-chips">${recentCategoryList().map(c=>`<button class="chip" onclick="quickCategory('${encodeURIComponent(c)}')">${esc(c)}</button>`).join('')}</div><div class="actions"><button class="btn btn-primary" onclick="openQuickAdd()">＋ Ausgabe / Einnahme erfassen</button><button class="btn btn-secondary" onclick="openTransferModal()">⇄ Zwischen Konten</button></div></div><div class="card" style="box-shadow:none"><div class="panel-head"><div><h2 style="font-size:16px">Fixkosten</h2><p>Aktive regelmäßige Ausgaben</p></div></div><div class="big-money">${eur(recurringMonthly())}</div><div class="chart-caption">${eur(yearlyRecurringCost())} hochgerechnet pro Jahr</div><div class="actions"><button class="btn btn-secondary" onclick="setPage('wiederkehrend')">Verträge ansehen →</button></div></div></div>
 <div class="grid dashboard-grid"><div class="card"><div class="panel-head"><div><h2 style="font-size:17px">Jahres-Cashflow</h2><p>Einnahmen und Ausgaben ${state.meta.currentYear}</p></div><button class="btn btn-secondary" onclick="setPage('report')">Jahresreport →</button></div><div class="bar-chart">${trend.map(x=>`<div class="bar-col"><div class="bar-in" style="height:${x.income/max*100}%"></div><div class="bar-out" style="height:${x.expense/max*100}%"></div><small>${names[x.month].slice(0,3)}</small></div>`).join('')}</div><div class="legend"><span><i class="dot" style="background:#3478F6"></i>Einnahmen</span><span><i class="dot" style="background:#7657D9"></i>Ausgaben</span></div></div><div class="card"><div class="panel-head"><div><h2 style="font-size:17px">Notgroschen</h2><p>Sicherheitsreserve</p></div></div><div class="big-money">${pct(e.coverage)}</div><div class="progress"><div style="width:${Math.min(e.coverage*100,100)}%"></div></div><div class="chart-caption">${e.missing>0?`Noch ${eur(e.missing)} bis zum Ziel.`:'Ziel erreicht.'}</div><div class="actions"><button class="btn btn-secondary" onclick="setPage('notgroschen')">Details →</button></div></div></div>
 <div class="grid dashboard-grid"><div class="card"><div class="panel-head"><div><h2 style="font-size:17px">Größte Ausgaben</h2><p>${monthLabel()}</p></div></div>${cats.slice(0,5).map(x=>`<div class="mini-row"><span>${esc(x[0])}</span><strong>${eur(x[1])}</strong></div>`).join('')||`<div class="empty">Noch keine Ausgaben erfasst.</div>`}</div><div class="card"><div class="panel-head"><div><h2 style="font-size:17px">Nächste regelmäßige Posten</h2><p>Fixkosten & Einnahmen</p></div></div>${upcoming.map(x=>`<div class="mini-row"><span>${esc(x.name)}<small style="display:block;color:var(--muted)">${esc(x.category)}</small></span><strong>${x.type==='Einnahme'?'+':'−'} ${eur(x.amount)}</strong></div>`).join('')||`<div class="empty">Keine aktiven Wiederholungen.</div>`}</div></div>
 <div class="grid kpis">${card('Nettovermögen',eur(netWorth()),'Konten minus Schulden')}${card('Wohnkostenquote',pct(h.ratio),h.ratio<=.3?'unter 30%':'über 30%')}${card('Sparrate',pct(t.saverate),'Budgetplanung')}${card('Finanz-Score',score+'/100',scoreLabel(score))}</div>
 <div class="grid quick">${quick('transaktionen','Buchung erfassen','Ein- oder Ausgabe')}${quick('konten','Konten','Saldo & Überweisung')}${quick('ziele','Sparziele','Fortschritt verfolgen')}${quick('report','Jahresreport','Dein Finanzjahr')}</div>
 <div class="section-title">Finanzmodule</div><div class="grid module-grid">${module('budget','€','Budget','Ausgaben planen',TEAL)}${module('wohnung','⌂','Wohnung','Wohnkostenquote',BLUE)}${module('sparen','★','Sparziel','Ziele & Rate',PURPLE)}${module('notgroschen','S','Notgroschen','Sicherheitspuffer',GREEN)}${module('auto','A','Auto','Gesamtkosten',ORANGE)}${module('schulden','D','Schulden','Laufzeit & Zinsen',RED)}</div>`;
}
function renderBudget(){
 const cats=(state.categories||[]).filter(c=>c!=="Einkommen"), month=monthKey(), vals=(state.budgets||{})[month]||{}, spent=Object.fromEntries(categoryTotals());
 return `<div class="panel"><div class="panel-head"><div><h2>Monatsbudget</h2><p>Plane deine Ausgaben für ${monthLabel()}.</p></div><div class="badge">${eur(monthBudgetTotal())} geplant</div></div>
 <div class="budget-summary"><div><small>Ausgaben</small><strong>${eur(monthTxTotals().expense)}</strong></div><div><small>Budget</small><strong>${eur(monthBudgetTotal())}</strong></div><div><small>Differenz</small><strong>${eur(monthBudgetTotal()-monthTxTotals().expense)}</strong></div></div>
 <div class="budget-editor">${cats.map(cat=>{const bv=num(vals[cat]||0),sp=num(spent[cat]||0),pr=bv?Math.min(sp/bv*100,100):0;return `<div class="budget-edit"><div class="budget-title"><strong>${cat}</strong><span>${eur(sp)} ausgegeben</span></div><div class="budget-input"><input type="number" min="0" step="10" value="${bv||""}" placeholder="Budget €" onchange="setBudget('${cat}',this.value)"><span>€</span></div><div class="progress"><div style="width:${pr}%"></div></div></div>`}).join("")}</div>
 <div class="actions"><button class="btn btn-primary" onclick="copyBudgetNextMonth()">Budget in nächsten Monat kopieren</button><button class="btn btn-secondary" onclick="clearBudget()">Monatsbudget zurücksetzen</button></div></div>`;
}
function renderWohnung(){
 const w=state.wohnung,h=housing();
 return `<div class="panel"><div class="panel-head"><div><h2>Wohnungs-Check</h2><p>Gesamte monatliche Wohnkosten statt nur Kaltmiete betrachten.</p></div></div>
 <div class="form-grid">${input("Weitere sichere Einnahmen","extraIncome",w,{group:"wohnung"})}${input("Kaltmiete","rent",w,{group:"wohnung"})}${input("Nebenkosten","utilities",w,{group:"wohnung"})}${input("Heizung / Wärme","heating",w,{group:"wohnung"})}${input("Strom","electricity",w,{group:"wohnung"})}${input("Stellplatz / Garage","parking",w,{group:"wohnung"})}${input("Sonstige Wohnkosten","other",w,{group:"wohnung"})}</div>
 <div class="grid kpis" style="margin-top:18px">${card("Gesamte Wohnkosten",eur(h.costs))}${card("Wohnkostenquote",pct(h.ratio))}${card("30%-Orientierung",eur(h.limit))}${card("Puffer",eur(h.buffer))}</div>
 <div class="result ${h.ratio<=.30?"green":h.ratio<=.40?"orange":"red"}"><div class="big">${h.ratio<=.30?"Unter 30%":h.ratio<=.40?"30–40%":"Über 40%"}</div><div class="small">Nur als Orientierungsgröße: die passende Wohnkostenhöhe hängt vom gesamten Haushalt und deinen übrigen Ausgaben ab.</div></div></div>
 <div class="panel"><div class="panel-head"><div><h2>Wohnungsvergleich</h2><p>Vergleiche bis zu drei Wohnungen anhand der monatlichen Gesamtkosten.</p></div></div><div style="overflow:auto"><table class="table"><thead><tr><th>Kosten</th><th>Wohnung A</th><th>Wohnung B</th><th>Wohnung C</th></tr></thead><tbody>${["Kaltmiete","Nebenkosten","Heizung","Strom"].map((r,i)=>`<tr><td>${r}</td>${[0,1,2].map(j=>`<td><input class="mini-input compare" data-j="${j}" data-i="${i}" value="${w.compare[j][i]}"></td>`).join("")}</tr>`).join("")}<tr><th>Gesamt</th>${[0,1,2].map(j=>`<th>${eur(w.compare[j].reduce((a,b)=>a+num(b),0))}</th>`).join("")}</tr></tbody></table></div></div>`
}
function renderSparen(){
 const s=state.sparen,x=savings();
 return `<div class="panel"><div class="panel-head"><div><h2>Sparziel</h2><p>Plane dein Ziel und sieh sofort, welche Sparrate benötigt wird.</p></div></div><div class="form-grid">${input("Zielbetrag","target",s,{group:"sparen"})}${input("Bereits gespart","saved",s,{group:"sparen"})}${input("Monatliche Sparrate","monthly",s,{group:"sparen"})}${input("Zeitraum in Monaten","months",s,{group:"sparen",step:"1"})}</div>
 <div class="result green"><div class="big">${pct(x.progress)}</div><div class="small">Fortschritt</div><div class="progress"><div style="width:${x.progress*100}%"></div></div></div>
 <div class="grid kpis" style="margin-top:18px">${card("Noch offen",eur(x.remaining))}${card("Benötigte Rate",eur(x.req))}${card("Aktuelle Rate",eur(s.monthly))}${card("Bei aktueller Rate",x.months?x.months+" Mon.":"–")}</div>
 <div class="notice" style="margin-top:16px">Die Berechnung behandelt die Sparrate als konstant. Unregelmäßige Einzahlungen kannst du über das Feld „Bereits gespart“ manuell abbilden.</div></div>`
}
function renderNotgroschen(){
 const n=state.notgroschen,e=emergency();
 return `<div class="panel"><div class="panel-head"><div><h2>Notgroschen</h2><p>Plane einen Sicherheitspuffer auf Basis notwendiger Monatskosten.</p></div></div><div class="form-grid">${input("Notwendige Monatskosten","essentials",n,{group:"notgroschen"})}${input("Ziel: Monate absichern","months",n,{group:"notgroschen",step:"1"})}${input("Bereits vorhanden","saved",n,{group:"notgroschen"})}</div>
 <div class="result green"><div class="big">${pct(e.coverage)}</div><div class="small">Abdeckung des berechneten Zielpuffers</div><div class="progress"><div style="width:${e.coverage*100}%"></div></div></div>
 <div class="grid kpis" style="margin-top:18px">${card("Zielpuffer",eur(e.target))}${card("Noch nötig",eur(e.missing))}${card("Vorhanden",eur(n.saved))}</div></div>`
}
function renderAuto(){
 const a=state.auto,c=car();
 return `<div class="panel"><div class="panel-head"><div><h2>Auto-Kosten</h2><p>Erfasse nicht nur Kraftstoff, sondern alle laufenden Kosten.</p></div></div><div class="form-grid">${input("Finanzierung / Leasing","lease",a,{group:"auto"})}${input("Versicherung","insurance",a,{group:"auto"})}${input("Kfz-Steuer","tax",a,{group:"auto"})}${input("Kraftstoff / Laden","fuel",a,{group:"auto"})}${input("Wartung / Reparaturen","maintenance",a,{group:"auto"})}${input("Reifen","tyres",a,{group:"auto"})}${input("Parken","parking",a,{group:"auto"})}${input("Sonstiges","other",a,{group:"auto"})}${input("Kilometer pro Jahr","kmYear",a,{group:"auto"})}</div>
 <div class="grid kpis" style="margin-top:18px">${card("Pro Monat",eur(c.monthly))}${card("Pro Jahr",eur(c.annual))}${card("Pro Kilometer",eur(c.kmCost))}</div></div>`
}
function renderSchulden(){
 const d=state.schulden,x=debt();
 return `<div class="panel"><div class="panel-head"><div><h2>Schulden-Check</h2><p>Grobe Schätzung für Laufzeit und Zinskosten.</p></div></div><div class="form-grid">${input("Restschuld","balance",d,{group:"schulden"})}${input("Jahreszins (%)","rate",d,{group:"schulden",percent:true,value:num(d.rate)*100})}${input("Monatliche Rate","payment",d,{group:"schulden"})}</div>
 <div class="result ${x.months===null?"red":"blue"}"><div class="big">${x.months===null?"Rate zu niedrig":"ca. "+x.months+" Monate"}</div><div class="small">${x.months===null?"Die Rate deckt die laufenden Zinsen nicht ausreichend ab.":"Geschätzte Zinskosten: "+eur(x.interest)}</div></div>
 <div class="notice" style="margin-top:14px">Näherungsrechnung ohne Sondertilgungen, Gebühren oder Vertragsbesonderheiten.</div></div>`
}
function renderYear(){
 const months=state.year.months,t=totals();
 const rows=months.map((m,i)=>{if(m.income===null)m.income=t.income;if(m.fixed===null)m.fixed=t.fixed;if(m.variable===null)m.variable=t.variable;if(m.saving===null)m.saving=Math.max(t.surplus,0);return `<tr><td>${names[i]}</td>${["income","fixed","variable","saving"].map(k=>`<td><input class="mini-input ym" data-i="${i}" data-k="${k}" value="${m[k]}"></td>`).join("")}<td>${eur(num(m.income)-num(m.fixed)-num(m.variable)-num(m.saving))}</td></tr>`}).join("");
 const total=months.reduce((a,m)=>{a.income+=num(m.income);a.fixed+=num(m.fixed);a.variable+=num(m.variable);a.saving+=num(m.saving);return a},{income:0,fixed:0,variable:0,saving:0});
 return `<div class="panel"><div class="panel-head"><div><h2>Jahresübersicht 2026</h2><p>Jeder Monat kann unabhängig angepasst werden.</p></div><button class="btn btn-secondary" onclick="fillYear()">Mit Budgetwerten füllen</button></div><div style="overflow:auto"><table class="table"><thead><tr><th>Monat</th><th>Einnahmen</th><th>Fixkosten</th><th>Variable</th><th>Sparen</th><th>Ergebnis</th></tr></thead><tbody>${rows}</tbody><tfoot><tr><th>Jahr</th><th>${eur(total.income)}</th><th>${eur(total.fixed)}</th><th>${eur(total.variable)}</th><th>${eur(total.saving)}</th><th>${eur(total.income-total.fixed-total.variable-total.saving)}</th></tr></tfoot></table></div></div>
 <div class="panel"><div class="panel-head"><div><h2>Monatlicher Überschuss</h2><p>Visualisierte Jahresentwicklung auf Basis der Tabelle.</p></div></div><div class="canvas-wrap"><canvas id="yearChart"></canvas></div></div>`
}



function wealthChart(){
 const h=(state.netWorthHistory||[]).slice(-30);if(!h.length)return `<div class="empty">Noch kein Verlauf vorhanden.</div>`;
 const min=Math.min(...h.map(x=>x.value)),max=Math.max(...h.map(x=>x.value)),range=Math.max(max-min,1);
 return `<div class="wealth-chart">${h.map(x=>`<div class="wealth-point" title="${x.date}: ${eur(x.value)}" style="height:${20+(x.value-min)/range*80}%"></div>`).join("")}</div><div class="chart-caption">${h[0].date} → ${h[h.length-1].date}</div>`;
}
function renderAccounts(){
 const total=allAccountsBalance();
 return `<div class="panel"><div class="panel-head"><div><h2>Konten</h2><p>Alle Geldbestände zentral verwalten.</p></div><div class="actions"><button class="btn btn-secondary" onclick="openTransferModal()">↔ Überweisen</button><button class="btn btn-primary" onclick="addAccountPrompt()">+ Konto hinzufügen</button></div></div>
 <div class="grid module-grid">${(state.accounts||[]).map((a,i)=>`<div class="card module" style="border-top:4px solid ${a.color||TEAL}">
 <div class="icon">◉</div><h3>${a.name}</h3><p>${a.type}</p><div class="big-money">${eur(a.balance)}</div>
 <div class="actions"><button class="btn btn-secondary" onclick="editAccount(${i})">Bearbeiten</button><button class="btn btn-secondary" onclick="removeAccount(${i})">Löschen</button></div></div>`).join("")}</div>
 <div class="result green"><div class="big">${eur(total)}</div><div class="small">Gesamtsaldo aller Konten</div></div><div class="card"><div class="panel-head"><div><h2 style="font-size:17px">Vermögensverlauf</h2><p>Gespeicherte Tagesstände</p></div></div>${wealthChart()}</div></div>`;
}
function renderTransactions(){
 const list=(state.transactions||[]).slice().sort((a,b)=>new Date(b.date)-new Date(a.date));
 const total=txTotals();
 const rows=list.length?list.map((x,i)=>{const accountLabel=x.type==="Transfer"?`${accountName(x.fromAccountId)} → ${accountName(x.toAccountId)}`:accountName(x.accountId);return `<tr data-search="${(x.title+" "+x.category+" "+accountLabel).toLowerCase()}"><td>${x.date}</td><td>${esc(x.title)}</td><td>${esc(x.type==="Transfer"?"Interne Überweisung":x.category)}</td><td>${esc(accountLabel)}</td><td>${x.type}</td><td>${eur(x.amount)}</td><td><button class="icon-btn" onclick="removeTx(${i})">×</button></td></tr>`}).join(""):`<tr><td colspan="7" class="empty">Noch keine Transaktionen. Erfasse oben deinen ersten Eintrag.</td></tr>`;
 return `<div class="panel"><div class="panel-head"><div><h2>Transaktionen</h2><p>Einzelne Ein- und Ausgaben für ${monthLabel()} erfassen.</p></div></div>
 <div class="form-grid">
   <div class="field"><label>Datum</label><input id="txDate" type="date" value="${new Date().toISOString().slice(0,10)}"></div>
   <div class="field"><label>Bezeichnung</label><input id="txTitle" placeholder="z. B. Supermarkt"></div>
   <div class="field"><label>Kategorie</label><select id="txCategory">${(state.categories||[]).map(c=>`<option>${esc(c)}</option>`).join("")}</select></div>
   <div class="field"><label>Art</label><select id="txType"><option>Ausgabe</option><option>Einnahme</option></select></div>
   <div class="field"><label>Konto</label><select id="txAccount">${state.accounts.map(a=>`<option value="${a.id}">${a.name}</option>`).join("")}</select></div>
   <div class="field"><label>Betrag</label><input id="txAmount" type="number" step="0.01" placeholder="0,00"></div>
 </div>
 <div class="actions"><button class="btn btn-primary" onclick="addTx()">Transaktion speichern</button><input id="txSearch" class="search-input" placeholder="Buchungen suchen…" oninput="filterTx()"></div>
 <div class="grid kpis" style="margin-top:18px">${card("Einnahmen",eur(total.income))}${card("Ausgaben",eur(total.expense))}${card("Saldo",eur(total.balance))}${card("Buchungen",list.length)}</div></div>
 <div class="panel"><div class="panel-head"><div><h2>Letzte Buchungen</h2></div></div><div style="overflow:auto"><table class="table"><thead><tr><th>Datum</th><th>Bezeichnung</th><th>Kategorie</th><th>Konto</th><th>Art</th><th>Betrag</th><th></th></tr></thead><tbody>${rows}</tbody></table></div></div>`;
}
function renderGoals(){
 const goals=Array.isArray(state.goals)?state.goals:[];
 const totalTarget=goals.reduce((s,g)=>s+num(g.target),0),totalSaved=goals.reduce((s,g)=>s+Math.min(num(g.saved),num(g.target)),0);
 return `<div class="panel"><div class="panel-head"><div><h2>Meine Ziele</h2><p>Mehrere finanzielle Ziele gleichzeitig verfolgen.</p></div><button class="btn btn-primary" onclick="addGoalPrompt()">+ Neues Ziel</button></div>
 <div class="grid module-grid">${goals.map((g,i)=>`<div class="card module" style="border-top:4px solid ${g.color||TEAL}">
 <div class="icon">◎</div><h3>${g.name}</h3><p>${eur(g.saved)} von ${eur(g.target)}</p><div class="progress"><div style="width:${Math.min(num(g.saved)/Math.max(num(g.target),1)*100,100)}%;background:${g.color||TEAL}"></div></div><div style="margin-top:8px;font-size:12px;color:var(--muted)">${pct(num(g.saved)/Math.max(num(g.target),1))}</div>
 <div class="actions"><button class="btn btn-secondary" onclick="editGoal(${i})">Bearbeiten</button><button class="btn btn-secondary" onclick="removeGoal(${i})">Löschen</button></div></div>`).join("")}</div>
 <div class="result green"><div class="big">${pct(totalSaved/Math.max(totalTarget,1))}</div><div class="small">Gesamtfortschritt über alle Ziele</div></div></div>`;
}
function renderRecurring(){
 const list=state.recurring||[],monthly=recurringMonthly(),annual=yearlyRecurringCost(),next=nextRecurringItems();
 return `<div class="panel"><div class="panel-head"><div><h2>Verträge & wiederkehrende Kosten</h2><p>Behalte laufende Kosten, Abos und regelmäßige Einnahmen im Blick.</p></div><button class="btn btn-primary" onclick="addRecurringPrompt()">+ Hinzufügen</button></div>
 <div class="grid kpis">${card("Fixkosten / Monat",eur(monthly),"nur aktive Ausgaben")}${card("Fixkosten / Jahr",eur(annual),"hochgerechnet")}${card("Abos & Verträge",eur(subscriptionTotal()),"pro Monat")}${card("Aktive Posten",list.filter(x=>x.active).length)}</div>
 <div class="contract-grid"><div class="contract-card"><h3>Nächste Fälligkeiten</h3><p>${next.length?next.map(x=>`${esc(x.name)} · ${x.nextDate.toLocaleDateString("de-DE")} · ${x.type==="Einnahme"?"+":"−"}${eur(x.amount)}`).join("<br>"):"Keine aktiven Posten."}</p></div><div class="contract-card"><h3>Jahresblick</h3><p>${eur(annual)} laufende Ausgaben pro Jahr. Prüfe besonders große Einzelposten vor einer Verlängerung.</p></div></div>
 <div class="rec-list">${list.map((x,i)=>`<div class="rec-card ${x.active?"":"inactive"}"><div><strong>${esc(x.name)}</strong><span>${esc(x.category)} · ${x.frequency==="yearly"?"jährlich":"monatlich"} · ${x.day||1}. des Monats</span></div><div class="rec-amount">${x.type==="Einnahme"?"+":"−"} ${eur(x.amount)}</div><button class="icon-btn" onclick="toggleRecurring(${i})">${x.active?"✓":"○"}</button><button class="btn btn-secondary" onclick="deleteRecurring(${i})">Löschen</button></div>`).join("")||`<div class="empty">Noch keine wiederkehrenden Posten.</div>`}</div>
 </div>`;
}
function addRecurringPrompt(){
 document.getElementById("modalRoot").innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card">
 <button class="close" onclick="closeModal()">×</button><h2>Wiederkehrenden Posten hinzufügen</h2><p>Fixkosten oder regelmäßige Einnahmen zentral verwalten.</p>
 <div class="form-grid">
  <div class="field"><label>Bezeichnung</label><input id="rName" placeholder="z. B. Spotify"></div>
  <div class="field"><label>Betrag</label><input id="rAmount" type="number" min="0" step="0.01" placeholder="10,99"></div>
  <div class="field"><label>Art</label><select id="rType"><option>Ausgabe</option><option>Einnahme</option></select></div>
  <div class="field"><label>Kategorie</label><select id="rCategory">${(state.categories||[]).map(c=>`<option>${esc(c)}</option>`).join("")}</select></div>
  <div class="field"><label>Rhythmus</label><select id="rFrequency"><option value="monthly">Monatlich</option><option value="yearly">Jährlich</option></select></div>
  <div class="field"><label>Tag</label><input id="rDay" type="number" min="1" max="28" value="1"></div>
 </div>
 <div class="actions"><button class="btn btn-primary" onclick="saveRecurring()">Speichern</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div>
 </div></div>`;
 document.getElementById("rName")?.focus();
}
function saveRecurring(){
 const name=document.getElementById("rName")?.value.trim();
 const amount=num(document.getElementById("rAmount")?.value);
 const type=document.getElementById("rType")?.value||"Ausgabe";
 const category=document.getElementById("rCategory")?.value||"Sonstiges";
 const frequency=document.getElementById("rFrequency")?.value||"monthly";
 const day=Math.max(1,Math.min(28,parseInt(document.getElementById("rDay")?.value||"1")));
 if(!name||amount<=0){toast("Bitte Bezeichnung und Betrag eingeben");return}
 if(!Array.isArray(state.recurring))state.recurring=[];
 state.recurring.push({name,amount,type,category,frequency,day,active:true});
 save();closeModal();render();toast("Wiederkehrender Posten angelegt");
}
function toggleRecurring(i){state.recurring[i].active=!state.recurring[i].active;save();render()}
function deleteRecurring(i){if(confirm("Posten löschen?")){state.recurring.splice(i,1);save();render()}}
function renderSettings(){
 return `<div class="panel"><div class="panel-head"><div><h2>Einstellungen & Daten</h2><p>Profil, Datenschutz, Exporte und Produktfunktionen.</p></div><span class="pro-badge">GELDTIPP 2.0</span></div><div class="form-grid"><div class="field"><label>Haushaltsname</label><input id="profileName" value="${esc(state.meta.profileName)}"></div><div class="field"><label>Planungsmonat</label><input value="${monthLabel()}" disabled></div><div class="field"><label>Produktstatus</label><input value="${state.meta.plan==='pro'?'Geldtipp Pro':'Geldtipp Free'}" disabled></div></div><div class="actions"><button class="btn btn-secondary" onclick="saveProfile()">Profil speichern</button><button class="btn btn-primary" onclick="exportData()">Backup exportieren</button><button class="btn btn-secondary" onclick="exportCSV()">Buchungen als CSV</button><button class="btn btn-secondary" onclick="importData()">Backup importieren</button><button class="btn btn-secondary" onclick="showOnboarding(true)">Tour erneut starten</button><button class="btn" style="background:var(--red);color:#fff" onclick="resetAll()">Alles zurücksetzen</button></div><div class="privacy-box" style="margin-top:16px"><strong>🔐 Deine Finanzdaten bleiben bei dir.</strong><p>Geldtipp 2.0 arbeitet ohne verpflichtendes Benutzerkonto und speichert Finanzdaten lokal im Browser. Exportiere regelmäßig ein Backup. Ein Export verlässt das Gerät nur dann, wenn du ihn selbst speicherst oder teilst.</p></div><div class="notice" style="margin-top:12px">${state.meta.lastBackup?`Letztes Backup: ${new Date(state.meta.lastBackup).toLocaleString('de-DE')}`:'Noch kein Backup exportiert.'} · Lokale Speicherung aktiv</div></div>
 <div class="panel"><div class="panel-head"><div><h2>Geldtipp Free / Pro</h2><p>Die App ist technisch bereits auf erweiterte Produktfunktionen vorbereitet.</p></div><span class="pro-badge">PRO-READY</span></div><div class="pro-box"><strong>Aktueller Modus: ${state.meta.plan==='pro'?'Geldtipp Pro':'Geldtipp Free'}</strong><p class="chart-caption">Es gibt aktuell keine echte Bezahlfunktion und keine automatische Abbuchung. Der Schalter dient nur als Produktarchitektur-Vorbereitung.</p><div class="feature-grid"><div>✓ Buchungen & Konten</div><div>✓ Budget & Ziele</div><div>✓ Coach & Vermögensanalyse</div><div>✓ Jahresreport / Druck-PDF</div><div>✓ Vertragscenter</div><div>✓ Erweiterte Reports (Pro-ready)</div></div><div class="actions"><button class="btn btn-secondary" onclick="state.meta.plan=state.meta.plan==='pro'?'free':'pro';save();render();toast(state.meta.plan==='pro'?'Pro-Modus aktiviert':'Free-Modus aktiviert')">${state.meta.plan==='pro'?'Zur Free-Ansicht':'Pro-Ansicht simulieren'}</button></div></div></div>
 <div class="panel"><div class="panel-head"><div><h2>Kategorien</h2><p>Eigene Kategorien für Buchungen und Budgets.</p></div><button class="btn btn-primary" onclick="addCategory()">+ Kategorie</button></div><div class="category-manager">${(state.categories||[]).filter(c=>c!=='Einkommen').map(c=>`<div class="category-pill"><span class="category-dot" style="background:${state.categoryColors?.[c]||TEAL}"></span><strong>${esc(c)}</strong><button onclick="renameCategory('${encodeURIComponent(c)}')">Bearbeiten</button><button onclick="removeCategory('${encodeURIComponent(c)}')">×</button></div>`).join('')}</div></div>`;
}
function render(){
 const root=document.getElementById("appRoot");
 root.innerHTML=current==="dashboard"?renderDashboard():
 current==="budget"?renderBudget():
 current==="wohnung"?renderWohnung():
 current==="sparen"?renderSparen():
 current==="notgroschen"?renderNotgroschen():
 current==="auto"?renderAuto():
 current==="schulden"?renderSchulden():
 current==="jahr"?renderYear():
 current==="konten"?renderAccounts():
 current==="transaktionen"?renderTransactions():
 current==="ziele"?renderGoals():
 current==="vermoegen"?renderWealth():
 current==="coach"?renderCoach():
 current==="report"?renderReport():
 current==="abschluss"?renderClosePage():
 current==="wiederkehrend"?renderRecurring():
 renderSettings();
 wireInputs();
 if(current==="dashboard"){drawCashflow();drawTopSpend()}
 if(current==="jahr"){drawYear()}
 wireCompare();
}
function drawCashflow(){
 const c=document.getElementById("cashflow");if(!c)return;const ctx=c.getContext("2d"),w=c.clientWidth*2,h=c.clientHeight*2;c.width=w;c.height=h;
 const t=totals(),vals=[t.fixed,t.variable,Math.max(t.surplus,0)],labs=["Fixkosten","Variable","Überschuss"],cols=["#3478F6","#7657D9","#12B8A6"],total=vals.reduce((a,b)=>a+b,0)||1;
 ctx.clearRect(0,0,w,h);let x=34;const barW=w-70;vals.forEach((v,i)=>{const bw=barW*(v/total);ctx.fillStyle=cols[i];ctx.fillRect(x,95,bw,54);ctx.fillStyle=getComputedStyle(document.documentElement).getPropertyValue("--text");ctx.font="700 22px system-ui";ctx.fillText(labs[i],x,190);ctx.fillStyle=getComputedStyle(document.documentElement).getPropertyValue("--muted");ctx.font="500 18px system-ui";ctx.fillText(eur(v),x,218);x+=bw+14});
}
function drawTopSpend(){
 const el=document.getElementById("topSpend");if(!el)return;const b=state.budget,arr=[["Miete / Wohnen",b.rent],["Transport",b.transport],["Lebensmittel",b.food],["Versicherungen",b.insurance],["Strom / Heizung",b.utilities]].sort((a,b)=>b[1]-a[1]);
 el.innerHTML=arr.map(([n,v])=>`<div class="line"><div><div class="name">${n}</div><div class="bar-bg"><div class="bar-fill" style="width:${Math.min((num(v)/Math.max(num(arr[0][1]),1))*100,100)}%"></div></div></div><div class="amt">${eur(v)}</div></div>`).join("");
}
function drawYear(){
 const c=document.getElementById("yearChart");if(!c)return;const ctx=c.getContext("2d"),w=c.clientWidth*2,h=c.clientHeight*2;c.width=w;c.height=h;
 const vals=state.year.months.map(m=>num(m.income)-num(m.fixed)-num(m.variable)-num(m.saving));const max=Math.max(...vals.map(v=>Math.abs(v)),1);const pad=40,plotH=h-90,step=(w-60)/12;
 ctx.clearRect(0,0,w,h);ctx.strokeStyle="#DCE3EA";ctx.lineWidth=2;ctx.beginPath();ctx.moveTo(30,h-45);ctx.lineTo(w-20,h-45);ctx.stroke();
 vals.forEach((v,i)=>{const bh=Math.abs(v)/max*(plotH*.8),x=30+i*step+8,y=v>=0?h-45-bh:h-45;ctx.fillStyle=v>=0?"#12B8A6":"#D9534F";ctx.fillRect(x,y,Math.max(step-14,10),bh);ctx.fillStyle="#667085";ctx.font="16px system-ui";ctx.fillText(names[i].slice(0,3),x,h-18)});
}
function wireCompare(){document.querySelectorAll(".compare").forEach(el=>{el.addEventListener("input",()=>{state.wohnung.compare[Number(el.dataset.j)][Number(el.dataset.i)]=num(el.value);save();});el.addEventListener("change",()=>render())})}


function openTransferModal(){
 document.getElementById("modalRoot").innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card"><button class="close" onclick="closeModal()">×</button><h2>Zwischen Konten überweisen</h2><p>Interne Transfers verändern dein Gesamtvermögen nicht und werden nicht als Ausgabe verbucht.</p><div class="form-grid"><div class="field"><label>Von Konto</label><select id="trFrom">${(state.accounts||[]).map(a=>`<option value="${a.id}">${esc(a.name)} · ${eur(a.balance)}</option>`).join("")}</select></div><div class="field"><label>Auf Konto</label><select id="trTo">${(state.accounts||[]).map(a=>`<option value="${a.id}">${esc(a.name)}</option>`).join("")}</select></div><div class="field"><label>Betrag</label><input id="trAmount" type="number" min="0.01" step="0.01" inputmode="decimal" placeholder="500"></div><div class="field"><label>Datum</label><input id="trDate" type="date" value="${new Date().toISOString().slice(0,10)}"></div></div><div class="transfer-note">💡 Beispiel: 500 € vom Girokonto aufs Tagesgeld verschieben.</div><div class="actions"><button class="btn btn-primary" onclick="saveTransfer()">Überweisung buchen</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div></div></div>`;
}
function saveTransfer(){
 const from=document.getElementById("trFrom")?.value,to=document.getElementById("trTo")?.value,amount=num(document.getElementById("trAmount")?.value),date=document.getElementById("trDate")?.value||new Date().toISOString().slice(0,10);
 if(!from||!to||from===to){toast("Bitte zwei unterschiedliche Konten wählen");return} if(amount<=0){toast("Bitte einen Betrag eingeben");return}
 const a=(state.accounts||[]).find(x=>x.id===from),b=(state.accounts||[]).find(x=>x.id===to);if(!a||!b)return;
 if(num(a.balance)<amount){toast("Der verfügbare Kontostand reicht nicht aus");return}
 a.balance-=amount;b.balance+=amount;state.transactions.push({date,title:`Überweisung: ${a.name} → ${b.name}`,category:"Interne Überweisung",type:"Transfer",amount,fromAccountId:from,toAccountId:to});save();closeModal();render();toast("Überweisung gebucht")
}
function openAccountModal(index=null){
 const a=index===null?{name:"",type:"Girokonto",balance:0,color:TEAL}:state.accounts[index];
 document.getElementById("modalRoot").innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card"><button class="close" onclick="closeModal()">×</button><h2>${index===null?"Konto hinzufügen":"Konto bearbeiten"}</h2><div class="form-grid"><div class="field"><label>Name</label><input id="aName" value="${esc(a.name)}" placeholder="z. B. Tagesgeld"></div><div class="field"><label>Kontotyp</label><select id="aType">${["Girokonto","Tagesgeld","Sparen","Kreditkarte","Bargeld","Sonstiges"].map(x=>`<option ${x===a.type?"selected":""}>${x}</option>`).join("")}</select></div><div class="field"><label>Aktueller Saldo</label><input id="aBalance" type="number" step="0.01" value="${num(a.balance)}"></div></div><div class="actions"><button class="btn btn-primary" onclick="saveAccount(${index===null?"null":index})">Speichern</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div></div></div>`;
}
function saveAccount(index){const name=document.getElementById("aName")?.value.trim(),type=document.getElementById("aType")?.value||"Sonstiges",balance=num(document.getElementById("aBalance")?.value);if(!name){toast("Bitte einen Kontonamen eingeben");return}if(index===null)state.accounts.push({id:"acc_"+Date.now(),name,type,balance,color:TEAL});else{state.accounts[index].name=name;state.accounts[index].type=type;state.accounts[index].balance=balance}save();closeModal();render();toast(index===null?"Konto angelegt":"Konto aktualisiert")}

function addAccountPrompt(){openAccountModal(null)}
function editAccount(i){openAccountModal(i)}
function removeAccount(i){
 if(state.accounts.length<=1){alert("Mindestens ein Konto muss vorhanden bleiben.");return}
 if(confirm("Konto wirklich löschen?")){const id=state.accounts[i].id;state.transactions.forEach(x=>{if(x.accountId===id)x.accountId=null});state.accounts.splice(i,1);save();render();toast("Konto gelöscht")}
}
function filterTx(){
 const q=(document.getElementById("txSearch")?.value||"").toLowerCase();
 document.querySelectorAll("tr[data-search]").forEach(r=>r.style.display=r.dataset.search.includes(q)?"":"none");
}

function setBudget(encoded,value){const cat=decodeURIComponent(encoded);if(!state.budgets[monthKey()])state.budgets[monthKey()]={};state.budgets[monthKey()][cat]=num(value);save();render()}
function copyBudgetNextMonth(){const d=new Date(state.meta.currentYear,state.meta.currentMonth+1,1),k=`${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,"0")}`;state.budgets[k]=clone(state.budgets[monthKey()]||{});save();toast("Budget kopiert")}
function clearBudget(){if(confirm("Budget dieses Monats löschen?")){delete state.budgets[monthKey()];save();render()}}
function closeCurrentMonth(){
 const k=monthKey(),t=monthTxTotals(),budget=monthBudgetTotal(),top=categoryTotals()[0],rw=recurringMonthly();
 if(state.meta.closedMonths?.[k]){showCloseSummary(k);return}
 if(confirm(`${monthLabel()} abschließen?\n\nEinnahmen: ${eur(t.income)}\nAusgaben: ${eur(t.expense)}\nSaldo: ${eur(t.balance)}\nBudget: ${eur(budget)}`)){
  state.meta.closedMonths[k]={closedAt:new Date().toISOString(),balance:t.balance,expense:t.expense,income:t.income,budget,saverate:t.income?t.balance/t.income:0,budgetVariance:budget-t.expense,netWorth:netWorth(),topCategory:top?top[0]:null,topCategoryAmount:top?top[1]:0,recurring:rw};
  recordNetWorth();save();render();toast(`${monthLabel()} wurde abgeschlossen`)
 }
}
function showCloseSummary(k=monthKey()){
 const x=state.meta.closedMonths?.[k];if(!x)return;
 document.getElementById("modalRoot").innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card"><button class="close" onclick="closeModal()">×</button><div class="brand-mark">✓</div><h2>${k} abgeschlossen</h2><p>Gespeichert am ${new Date(x.closedAt).toLocaleString("de-DE")}</p><div class="close-summary"><div class="stat-box"><small>Einnahmen</small><strong>${eur(x.income)}</strong></div><div class="stat-box"><small>Ausgaben</small><strong>${eur(x.expense)}</strong></div><div class="stat-box"><small>Saldo</small><strong class="${x.balance>=0?"money-positive":"money-negative"}">${eur(x.balance)}</strong></div><div class="stat-box"><small>Sparquote</small><strong>${pct(x.saverate||0)}</strong></div><div class="stat-box"><small>Budget</small><strong>${eur(x.budget)}</strong></div><div class="stat-box"><small>Nettovermögen</small><strong>${eur(x.netWorth||0)}</strong></div></div><div class="insight" style="margin-top:14px"><div class="eyebrow">Monatsfazit</div><strong>${x.topCategory?`${esc(x.topCategory)} · ${eur(x.topCategoryAmount)}`:"Keine Top-Kategorie"}</strong><p>${x.budgetVariance>=0?`Noch ${eur(x.budgetVariance)} Budget übrig.`:`${eur(Math.abs(x.budgetVariance))} über dem Budget.`}</p></div><div class="actions"><button class="btn btn-primary" onclick="closeModal()">Fertig</button></div></div></div>`;
}
function shiftMonth(dir){
 let m=state.meta.currentMonth+dir,y=state.meta.currentYear;
 if(m<0){m=11;y--} if(m>11){m=0;y++}
 state.meta.currentMonth=m;state.meta.currentYear=y;save();render();
}
function addTx(){
 if(!Array.isArray(state.transactions))state.transactions=[];
 const date=document.getElementById("txDate").value,title=document.getElementById("txTitle").value.trim(),category=document.getElementById("txCategory").value,type=document.getElementById("txType").value,accountId=document.getElementById("txAccount").value,amount=num(document.getElementById("txAmount").value);
 if(!title||!amount){alert("Bitte Bezeichnung und Betrag eingeben.");return}
 state.transactions.push({date,title,category,type,accountId,amount}); state.meta.lastType=type; state.meta.lastCategory=category; state.meta.lastAccountId=accountId; rememberCategory(category);
 const acc=(state.accounts||[]).find(x=>x.id===accountId);if(acc)acc.balance+=(type==="Einnahme"?amount:-amount);
 save();render();toast("Transaktion gespeichert");
}
function removeTx(i){
 const list=(state.transactions||[]).slice().sort((a,b)=>new Date(b.date)-new Date(a.date)),target=list[i],idx=(state.transactions||[]).indexOf(target);
 if(idx>=0){
   if(target.type==="Transfer"){
    const from=(state.accounts||[]).find(x=>x.id===target.fromAccountId),to=(state.accounts||[]).find(x=>x.id===target.toAccountId);if(from)from.balance+=num(target.amount);if(to)to.balance-=num(target.amount);
   }else{
    const acc=(state.accounts||[]).find(x=>x.id===target.accountId);if(acc)acc.balance+=(target.type==="Einnahme"?-num(target.amount):num(target.amount));
   }
   state.transactions.splice(idx,1);
 }
 save();render();toast("Transaktion gelöscht");
}
function addGoalPrompt(){
 document.getElementById("modalRoot").innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card">
 <button class="close" onclick="closeModal()">×</button><h2>Neues Sparziel</h2><p>Lege Zielbetrag und aktuellen Stand fest.</p>
 <div class="form-grid">
  <div class="field"><label>Name</label><input id="gName" placeholder="z. B. Urlaub"></div>
  <div class="field"><label>Zielbetrag</label><input id="gTarget" type="number" min="0" step="50" placeholder="2500"></div>
  <div class="field"><label>Bereits gespart</label><input id="gSaved" type="number" min="0" step="50" placeholder="0"></div>
 </div>
 <div class="actions"><button class="btn btn-primary" onclick="saveGoal()">Ziel anlegen</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div>
 </div></div>`;
 document.getElementById("gName")?.focus();
}
function saveGoal(){
 const name=document.getElementById("gName")?.value.trim();
 const target=num(document.getElementById("gTarget")?.value);
 const saved=num(document.getElementById("gSaved")?.value);
 if(!name||target<=0){toast("Bitte Name und Zielbetrag eingeben");return}
 if(!Array.isArray(state.goals))state.goals=[];
 state.goals.push({name,target,saved:Math.min(saved,target),color:TEAL});
 save();closeModal();render();toast("Ziel angelegt");
}
function editGoal(i){
 const g=state.goals[i],saved=prompt("Bereits gespart?",String(g.saved));if(saved===null)return;
 const target=prompt("Zielbetrag?",String(g.target));if(target===null)return;
 g.saved=num(saved);g.target=num(target);save();render();toast("Ziel aktualisiert");
}
function removeGoal(i){if(confirm("Ziel wirklich löschen?")){state.goals.splice(i,1);save();render();toast("Ziel gelöscht")}}
function resetGroup(group){state[group]=clone(defaultState[group]);save();render();toast("Beispielwerte wiederhergestellt")}
function fillYear(){const t=totals();state.year.months=state.year.months.map(()=>({income:t.income,fixed:t.fixed,variable:t.variable,saving:Math.max(t.surplus,0)}));save();render();toast("Jahreswerte übernommen")}
function resetAll(){if(confirm("Wirklich alle Daten zurücksetzen?")){state=clone(defaultState);applyTheme();save();render();showOnboarding(false);toast("Daten zurückgesetzt")}}
function saveProfile(){const v=document.getElementById("profileName").value.trim();if(v)state.meta.profileName=v;save();render();toast("Profil gespeichert")}
function quickCategory(encoded){const cat=decodeURIComponent(encoded);state.meta.lastCategory=cat;rememberCategory(cat);save();openQuickAdd()}
function openQuickAdd(){
 const root=document.getElementById('modalRoot'), type=state.meta.lastType||'Ausgabe',cat=state.meta.lastCategory||recentCategoryList()[0]||'Sonstiges',acc=state.meta.lastAccountId||state.accounts?.[0]?.id||'';
 root.innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card quick-modal"><button class="close" onclick="closeModal()">×</button><div class="brand-mark">€</div><h2 style="margin-top:9px">Schnell buchen</h2><p>Erfasse eine Ausgabe oder Einnahme in wenigen Sekunden.</p><div class="field"><label>Betrag</label><input id="qAmount" class="big-input" type="number" step="0.01" inputmode="decimal" autofocus placeholder="0,00"></div><div class="type-toggle"><button type="button" id="qTypeOut" class="${type==='Ausgabe'?'active':''}" onclick="setQuickType('Ausgabe')">− Ausgabe</button><button type="button" id="qTypeIn" class="${type==='Einnahme'?'active':''}" onclick="setQuickType('Einnahme')">＋ Einnahme</button></div><div class="form-grid" style="margin-top:14px"><div class="field"><label>Bezeichnung</label><input id="qTitle" placeholder="z. B. REWE"></div><div class="field"><label>Kategorie</label><select id="qCategory" onchange="rememberCategory(this.value);state.meta.lastCategory=this.value">${(state.categories||[]).filter(c=>c!=='Einkommen'||type==='Einnahme').map(c=>`<option ${c===cat?'selected':''}>${esc(c)}</option>`).join('')}</select></div><div class="field"><label>Konto</label><select id="qAccount" onchange="state.meta.lastAccountId=this.value">${(state.accounts||[]).map(a=>`<option value="${a.id}" ${a.id===acc?'selected':''}>${esc(a.name)}</option>`).join('')}</select></div><div class="field"><label>Datum</label><input id="qDate" type="date" value="${new Date().toISOString().slice(0,10)}"></div></div><div class="recent-chips">${recentCategoryList().map(c=>`<button class="chip" onclick="quickChooseCategory('${encodeURIComponent(c)}')">${esc(c)}</button>`).join('')}</div><div class="actions"><button class="btn btn-primary" onclick="saveQuickAdd()">Buchen ↵</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div></div></div>`;
 document.getElementById('qAmount')?.focus();
}
function setQuickType(type){state.meta.lastType=type;openQuickAdd()}
function quickChooseCategory(encoded){state.meta.lastCategory=decodeURIComponent(encoded);openQuickAdd();setTimeout(()=>{const c=document.getElementById('qCategory');if(c)c.value=state.meta.lastCategory},0)}
function saveQuickAdd(){
 const title=document.getElementById('qTitle')?.value.trim()||'Buchung',amount=num(document.getElementById('qAmount')?.value),type=state.meta.lastType||'Ausgabe',category=document.getElementById('qCategory')?.value||'Sonstiges',accountId=document.getElementById('qAccount')?.value,date=document.getElementById('qDate')?.value||new Date().toISOString().slice(0,10);
 if(amount<=0){toast('Bitte einen Betrag eingeben');return} const acc=(state.accounts||[]).find(a=>a.id===accountId); if(!acc){toast('Bitte ein Konto wählen');return} if(type==='Ausgabe'&&num(acc.balance)<amount){toast('Der verfügbare Kontostand reicht nicht aus');return}
 if(!Array.isArray(state.transactions))state.transactions=[];state.transactions.push({date,title,category,type,accountId,amount});acc.balance+=(type==='Einnahme'?amount:-amount);state.meta.lastCategory=category;state.meta.lastAccountId=accountId;rememberCategory(category);save();closeModal();render();toast(`${type} gebucht`)
}
function addCategory(){
 const raw=prompt("Name der neuen Kategorie","Haushalt");if(!raw)return;
 const name=raw.trim();
 if(!name||name==="Einkommen"||(state.categories||[]).includes(name)){toast("Kategorie ist nicht verfügbar");return}
 state.categories.push(name);save();render();toast("Kategorie angelegt");
}
function renameCategory(encoded){
 const old=decodeURIComponent(encoded),raw=prompt("Neuer Name",old);if(!raw)return;
 const name=raw.trim();
 if(!name||name==="Einkommen"||(state.categories||[]).includes(name)){toast("Name nicht verfügbar");return}
 state.categories=state.categories.map(c=>c===old?name:c);
 (state.transactions||[]).forEach(t=>{if(t.category===old)t.category=name});
 Object.values(state.budgets||{}).forEach(month=>{if(month[old]!==undefined){month[name]=month[old];delete month[old]}});
 save();render();toast("Kategorie geändert");
}
function removeCategory(encoded){
 const old=decodeURIComponent(encoded);if(old==="Einkommen")return;
 if(!confirm(`Kategorie „${old}“ löschen? Buchungen werden zu „Sonstiges“ verschoben.`))return;
 state.categories=state.categories.filter(c=>c!==old);
 if(!state.categories.includes("Sonstiges"))state.categories.push("Sonstiges");
 (state.transactions||[]).forEach(t=>{if(t.category===old)t.category="Sonstiges"});
 Object.values(state.budgets||{}).forEach(month=>delete month[old]);
 save();render();toast("Kategorie gelöscht");
}
function downloadBlob(content,type,name){const blob=new Blob([content],{type});const a=document.createElement("a");a.href=URL.createObjectURL(blob);a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(a.href),500)}
function exportData(){state.meta.lastBackup=new Date().toISOString();state.meta.appVersion="2.1.0";save();downloadBlob(JSON.stringify({...state,exportedAt:new Date().toISOString(),formatVersion:3},null,2),"application/json","geldtipp-backup.json");toast("Backup exportiert")}
function exportCSV(){const rows=[["Datum","Bezeichnung","Kategorie","Art","Konto","Betrag"],...(state.transactions||[]).map(x=>[x.date,x.title,x.category,x.type,accountName(x.accountId),String(num(x.amount)).replace(".",",")])];const csv="\ufeff"+rows.map(r=>r.map(v=>`"${String(v??"").replaceAll('"','""')}"`).join(";")).join("\n");downloadBlob(csv,"text/csv;charset=utf-8","geldtipp-buchungen.csv");toast("CSV exportiert")}
function importData(){const input=document.createElement("input");input.type="file";input.accept=".json";input.onchange=async()=>{try{const f=input.files[0];if(!f)return;const incoming=JSON.parse(await f.text());if(!incoming||typeof incoming!=="object"||!Array.isArray(incoming.accounts)||!Array.isArray(incoming.transactions))throw new Error("invalid");state=merge(clone(defaultState),incoming);state.meta=merge(clone(defaultState.meta),incoming.meta||{});state.meta.appVersion="2.1.0";applyTheme();save();render();toast("Daten importiert")}catch{alert("Die Datei konnte nicht importiert werden. Bitte ein gültiges Geldtipp-Backup wählen.")}};input.click()}
function toast(t){const el=document.getElementById("toast");el.textContent=t;el.classList.add("show");setTimeout(()=>el.classList.remove("show"),1800)}
function showHelp(){showOnboarding(true)}
let modalStep=0;
function showOnboarding(force){
 if(!force && !state.meta.firstRun)return;
 modalStep=0;
 document.getElementById("modalRoot").innerHTML=`<div class="modal"><div class="modal-card">
 <button class="close" onclick="closeModal()">×</button>
 <div class="steps"><span class="active"></span><span></span><span></span><span></span><span></span></div>
 <div class="modal-step active" data-step="0"><div class="brand-mark">€</div><h2>Willkommen bei Geldtipp 👋</h2><p>In wenigen Schritten richten wir dein persönliches Finanz-Dashboard ein. Alles bleibt lokal auf deinem Gerät.</p><div class="actions"><button class="btn btn-primary" onclick="nextOnboard()">Einrichtung starten →</button></div></div>
 <div class="modal-step" data-step="1"><h2>Wie sollen wir dich nennen?</h2><p>Dieser Name erscheint nur in deiner App.</p><div class="field"><label>Haushaltsname</label><input id="obName" value="${esc(state.meta.profileName||"Mein Haushalt")}" placeholder="z. B. Joel & Familie"></div><div class="actions"><button class="btn btn-primary" onclick="nextOnboard()">Weiter →</button></div></div>
 <div class="modal-step" data-step="2"><h2>Dein monatliches Einkommen</h2><p>Damit Geldtipp deine verfügbare Summe und Sparquote berechnen kann.</p><div class="field"><label>Netto pro Monat</label><input id="obIncome" type="number" min="0" step="50" value="${num(state.budget?.income||0)}"></div><div class="actions"><button class="btn btn-primary" onclick="nextOnboard()">Weiter →</button></div></div>
 <div class="modal-step" data-step="3"><h2>Starte mit deinem echten Kontostand</h2><p>Dieser Betrag wird als aktueller Startwert deines Hauptkontos übernommen.</p><div class="field"><label>Girokonto-Saldo</label><input id="obBalance" type="number" step="50" value="${num(state.accounts?.[0]?.balance||0)}"></div><div class="field" style="margin-top:10px"><label>Aktuell verfügbar zum Sparen pro Monat</label><input id="obSaving" type="number" step="25" value="${num(state.sparen?.monthly||0)}"></div><div class="actions"><button class="btn btn-primary" onclick="nextOnboard()">Weiter →</button></div></div>
 <div class="modal-step" data-step="4"><h2>Bereit für deinen Geldtipp</h2><p>Du kannst alles jederzeit in den Einstellungen ändern. Deine Daten verlassen das Gerät nicht, solange du keine Datei exportierst.</p><div class="actions"><button class="btn btn-teal" onclick="finishOnboard()">Geldtipp öffnen ✓</button></div></div>
 </div></div>`;
}
function nextOnboard(){
 if(modalStep===1){const v=document.getElementById("obName")?.value.trim();if(v)state.meta.profileName=v}
 if(modalStep===2){const v=num(document.getElementById("obIncome")?.value);state.budget.income=v;state.recurring=(state.recurring||[]).map(x=>x.category==="Einkommen"?{...x,amount:v}:x)}
 if(modalStep===3){const bal=num(document.getElementById("obBalance")?.value);const sav=num(document.getElementById("obSaving")?.value);if(state.accounts?.[0])state.accounts[0].balance=bal;state.sparen.monthly=sav}
 save();modalStep++;document.querySelectorAll(".modal-step").forEach(x=>x.classList.toggle("active",Number(x.dataset.step)===modalStep));document.querySelectorAll(".steps span").forEach((x,i)=>x.classList.toggle("active",i===modalStep));
}
function finishOnboard(){state.meta.firstRun=false;state.meta.onboarded=true;save();closeModal();setPage("dashboard");toast("Willkommen bei Geldtipp")}
function closeModal(){document.getElementById("modalRoot").innerHTML=""}
/* Geldtipp 2.1 feature layer */
function ensureV21State(){
  state.meta=state.meta||{};
  state.meta.appVersion="2.1.0";
  state.meta.household=state.meta.household||{enabled:false,name:"Unser Haushalt",members:[{id:"member_1",name:"Ich",role:"Eigene Finanzen"}]};
  if(!Array.isArray(state.meta.household.members)||!state.meta.household.members.length)state.meta.household.members=[{id:"member_1",name:"Ich",role:"Eigene Finanzen"}];
  state.meta.txFilter=state.meta.txFilter||{q:"",category:"",type:"",account:"",from:"",to:""};
  state.meta.merchantRules=state.meta.merchantRules||{};
  state.meta.scenario=state.meta.scenario||{target:5000,current:1000,monthly:300,extra:0,oneTime:0,horizon:24};
  state.meta.bank=state.meta.bank||{lastImport:null,imported:0,duplicateCount:0};
  state.meta.sync=state.meta.sync||{lastExport:null};
  (state.transactions||[]).forEach((t,i)=>{if(!t.id)t.id="tx_"+(Date.now()+i)+"_"+Math.random().toString(36).slice(2,7);if(!t.memberId)t.memberId=state.meta.household.members[0]?.id||null;if(t.sharePercent==null)t.sharePercent=100});
}
function cleanText(v){return String(v||"").toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g,"").replace(/[^a-z0-9äöüß€]+/g," ").trim()}
function autoCategorize(text,type="Ausgabe"){
  const t=cleanText(text);
  if(type==="Einnahme")return "Einkommen";
  const rules=state.meta.merchantRules||{};
  for(const [merchant,cat] of Object.entries(rules)){if(merchant&&t.includes(merchant))return cat}
  const map=[
   ["Lebensmittel",["rewe","edeka","aldi","lidl","penny","netto","kaufland","dm","rossmann","supermarkt","lebensmittel","bio markt"]],
   ["Mobilität",["tank","shell","aral","esso","jet ","total","omv","uber","bolt","db ","deutsche bahn","bahn","mvg","rsvg","parkhaus","parking"]],
   ["Verträge",["telekom","vodafone","o2 ","1und1","versicher","provinzial","allianz","axa","adobe","microsoft","icloud","google one"]],
   ["Shopping",["amazon","zalando","otto","ikea","h&m","zara","saturn","mediamarkt","shop","online"]],
   ["Essen gehen",["restaurant","lieferando","mcdonald","burger","pizza","cafe","café","starbucks","kebab","imbiss"]],
   ["Freizeit",["kino","cinema","steam","playstation","xbox","ticketmaster","eventim","spotify","netflix","disney"]],
   ["Gesundheit",["apotheke","arzt","zahnarzt","praxis","gesundheit"]],
   ["Wohnen",["miete","immobil","hausverwaltung","nebenkosten","strom","gas","heizung","wasser"]]
  ];
  const hit=map.find(([,terms])=>terms.some(term=>t.includes(term)));
  return hit?hit[0]:"Sonstiges";
}
function rememberMerchantCategory(text,cat){const k=cleanText(text).slice(0,80);if(k&&cat){state.meta.merchantRules=state.meta.merchantRules||{};state.meta.merchantRules[k]=cat}}
function memberName(id){return state.meta.household.members.find(m=>m.id===id)?.name||"Ich"}
function householdShareAmount(t){return num(t.amount)*(Math.min(Math.max(num(t.sharePercent==null?100:t.sharePercent),0),100)/100)}
function filteredTransactions(){
  const f=state.meta.txFilter||{};let list=[...(state.transactions||[])];
  if(f.q){const q=cleanText(f.q);list=list.filter(x=>cleanText([x.title,x.category,accountName(x.accountId),x.type,memberName(x.memberId)].join(" ")).includes(q))}
  if(f.category)list=list.filter(x=>x.category===f.category);
  if(f.type)list=list.filter(x=>x.type===f.type);
  if(f.account)list=list.filter(x=>x.accountId===f.account);
  if(f.from)list=list.filter(x=>x.date>=f.from);
  if(f.to)list=list.filter(x=>x.date<=f.to);
  return list.sort((a,b)=>new Date(b.date)-new Date(a.date));
}
function yearlyAnalysis(){
  const y=state.meta.currentYear, xs=(state.transactions||[]).filter(x=>new Date(x.date).getFullYear()===y);
  const income=xs.filter(x=>x.type==="Einnahme").reduce((s,x)=>s+num(x.amount),0),expense=xs.filter(x=>x.type==="Ausgabe").reduce((s,x)=>s+num(x.amount),0);
  const recurring=recurringMonthly()*12, savings=Math.max(income-expense,0), months=new Set(xs.map(x=>String(new Date(x.date).getMonth()))).size;
  const cats={};xs.filter(x=>x.type==="Ausgabe").forEach(x=>cats[x.category]=(cats[x.category]||0)+num(x.amount));
  return {income,expense,savings,saverate:income?savings/income:0,recurring,months,cats,avgMonthly:months?expense/months:0,flexible:Math.max(expense-recurring,0),fixedRatio:income?recurring/income:0};
}
function trendPct(now,prev){return prev?((now-prev)/prev):0}
function coachData(){
  const t=monthTxTotals(),prev=previousMonthTotals(),a=yearlyAnalysis(),cats=categoryTotals(),e=emergency(),s=savings(),items=[];
  if(t.income>0){const rate=t.balance/t.income;items.push({tone:rate>=.2?'green':rate>=0?'amber':'red',icon:rate>=.2?'✓':'!',title:rate>=.2?'Du bist auf Kurs':'Monat im Blick behalten',text:`Dein Buchungssaldo liegt aktuell bei ${pct(rate)} der erfassten Einnahmen.`,action:'analyse'});}
  if(prev.expense>0&&t.expense>0){const d=trendPct(t.expense,prev.expense);items.push({tone:d<=0?'green':'amber',icon:d<=0?'↓':'↑',title:`${d<=0?'Weniger':'Mehr'} Ausgaben`,text:`Gegenüber dem Vormonat ${d<=0?'sind deine':'liegen deine'} erfassten Ausgaben ${Math.abs(d*100).toFixed(0)} % ${d<=0?'niedriger':'höher'}.`,action:'transaktionen'});}
  if(cats[0])items.push({tone:cats[0][1]>(t.income||1)*.25?'amber':'blue',icon:'€',title:`${cats[0][0]} im Fokus`,text:`${eur(cats[0][1])} entfallen bisher auf deine größte Ausgabenkategorie.`,action:'analyse'});
  if(s.remaining>0)items.push({tone:'blue',icon:'→',title:`Sparziel: ${eur(s.remaining)} offen`,text:`Bei ${eur(num(state.sparen.monthly))} monatlicher Sparrate brauchst du rechnerisch etwa ${s.months||"—"} Monate.`,action:'szenarien'});
  if(e.missing>0)items.push({tone:e.coverage>=.7?'green':'amber',icon:'S',title:`Notgroschen ${pct(e.coverage)}`,text:`Es fehlen noch ${eur(e.missing)} bis zu deinem definierten Ziel.`,action:'notgroschen'});
  if(a.fixedRatio>.5&&a.income>0)items.push({tone:'amber',icon:'!',title:'Fixkosten im Blick behalten',text:`Hochgerechnete laufende Ausgaben entsprechen rund ${pct(a.fixedRatio)} deines Jahres-Einkommens.`,action:'wiederkehrend'});
  return items.slice(0,5);
}
function renderCoach(){
 const items=coachData();const a=yearlyAnalysis();
 return `<div class="panel"><div class="panel-head"><div><h2>Geldtipp Coach 2.0</h2><p>Konkrete Hinweise aus deinen erfassten Daten – ohne pauschale Bewertung.</p></div><span class="pro-badge">SMART</span></div><div class="coach-list">${items.map(x=>`<div class="coach-item ${x.tone}"><div class="coach-icon">${x.icon}</div><div><strong>${esc(x.title)}</strong><p>${esc(x.text)}</p></div><button class="btn btn-secondary" onclick="setPage('${x.action}')">Ansehen →</button></div>`).join("")||`<div class="empty">Noch nicht genug Buchungen für persönliche Hinweise.</div>`}</div></div>
 <div class="grid kpis">${card("Jahreseinnahmen",eur(a.income))}${card("Jahresausgaben",eur(a.expense))}${card("Sparquote",pct(a.saverate))}${card("Fixkostenquote",pct(a.fixedRatio))}</div>`;
}
function renderAnalysis(){
 const a=yearlyAnalysis(),cats=Object.entries(a.cats).sort((x,y)=>y[1]-x[1]),arr=annualTotals();
 return `<div class="panel"><div class="panel-head"><div><h2>Finanzanalyse</h2><p>Deine wichtigsten Kennzahlen für ${state.meta.currentYear} und den aktuellen Monat.</p></div></div><div class="grid kpis">${card("Einnahmen",eur(a.income),"erfasster Zeitraum")}${card("Ausgaben",eur(a.expense),"erfasster Zeitraum")}${card("Sparquote",pct(a.saverate),"aus Buchungen")}${card("Fixkostenquote",pct(a.fixedRatio),"hochgerechnet")}</div></div>
 <div class="section-two"><div class="panel"><div class="panel-head"><div><h2>Ausgaben nach Kategorie</h2><p>${a.expense?"Top-Kategorien im aktuellen Jahr":"Noch keine Jahresbuchungen"}</p></div></div><div class="analysis-bars">${cats.slice(0,8).map(([n,v],i)=>`<div class="analysis-row"><div><span>${esc(n)}</span><span>${eur(v)}</span></div><div class="analysis-track"><div style="width:${Math.min(v/Math.max(cats[0]?.[1]||1,1)*100,100)}%;animation-delay:${i*35}ms"></div></div></div>`).join("")||`<div class="empty">Noch keine Ausgaben erfasst.</div>`}</div></div>
 <div class="panel"><div class="panel-head"><div><h2>Jahresverlauf</h2><p>Monatlicher Saldo aus erfassten Buchungen.</p></div></div><div class="analysis-months">${arr.map(x=>`<div class="analysis-month"><div class="month-bar"><i style="height:${Math.max(4,Math.min(Math.abs(x.balance)/Math.max(...arr.map(z=>Math.abs(z.balance)),1)*120,120))}px;${x.balance<0?'background:var(--red)':''}"></i></div><strong>${x.balance<0?'−':''}${eur(Math.abs(x.balance))}</strong><small>${names[x.month].slice(0,3)}</small></div>`).join("")}</div></div></div>`;
}
function renderLifestyle(){
 const t=totals(), r=recurringMonthly(), variable=Math.max(num(t.food)+num(t.leisure)+num(t.shopping)+num(t.varOther),0), total=r+variable, annual=total*12, daily=total/30.44;
 const groups=[['Wohnen',t.fixed*.55],['Mobilität',t.fixed*.18],['Verträge',t.fixed*.12],['Lebensmittel',num(t.food)],['Freizeit',num(t.leisure)],['Shopping',num(t.shopping)],['Sonstiges',num(t.varOther)]] .sort((a,b)=>b[1]-a[1]);
 return `<div class="panel lifestyle-hero"><div><div class="eyebrow">DEIN LEBENSSTANDARD</div><h2>${eur(total)} <span>/ Monat</span></h2><p>Eine Planungsrechnung aus deinen aktiven Fixkosten und deinem variablen Monatsbudget.</p></div><div class="lifestyle-big">${eur(annual)}<small>pro Jahr</small></div></div><div class="grid kpis">${card("Pro Tag",eur(daily))}${card("Fixkosten",eur(r))}${card("Variable Kosten",eur(variable))}${card("Einkommen",eur(t.income))}</div><div class="panel"><div class="panel-head"><div><h2>Wo dein Geld hingeht</h2><p>Grobe Aufteilung des aktuellen Planungsbudgets.</p></div></div><div class="analysis-bars">${groups.map(([n,v])=>`<div class="analysis-row"><div><span>${esc(n)}</span><span>${eur(v)}</span></div><div class="analysis-track"><div style="width:${Math.min(v/Math.max(groups[0][1],1)*100,100)}%"></div></div></div>`).join("")}</div><div class="notice" style="margin-top:14px">Das ist eine Planungsgröße, keine Bewertung deines Lebensstils. Prüfe selbst, welche Ausgaben für dich unverzichtbar oder flexibel sind.</div></div>`;
}
function scenarioNumbers(s){const target=num(s.target),current=num(s.current)+num(s.oneTime),monthly=num(s.monthly)+num(s.extra);let months=monthly>0?Math.max(0,Math.ceil(Math.max(target-current,0)/monthly)):null;return {target,current,monthly,months,final:current+monthly*num(s.horizon)} }
function renderScenarios(){
 const s=state.meta.scenario,n=scenarioNumbers(s),goal=state.goals?.[0];
 const horizon=Math.max(1,Math.min(120,num(s.horizon)||24));const base=scenarioNumbers({...s,extra:0}),boost100=scenarioNumbers({...s,extra:num(s.extra)+100}),boost300=scenarioNumbers({...s,extra:num(s.extra)+300});
 return `<div class="panel"><div class="panel-head"><div><h2>Szenarien</h2><p>Teste, wie sich Sparrate, Einmalbeträge und zusätzliche Einsparungen auf dein Ziel auswirken.</p></div><span class="pro-badge">PLANER</span></div><div class="form-grid"><div class="field"><label>Zielbetrag</label><input id="scTarget" type="number" min="0" step="50" value="${n.target}"></div><div class="field"><label>Aktueller Sparstand</label><input id="scCurrent" type="number" min="0" step="50" value="${num(s.current)}"></div><div class="field"><label>Monatliche Sparrate</label><input id="scMonthly" type="number" min="0" step="25" value="${num(s.monthly)}"></div><div class="field"><label>Zusätzlich pro Monat</label><input id="scExtra" type="number" min="0" step="25" value="${num(s.extra)}"></div><div class="field"><label>Einmaliger Startbetrag</label><input id="scOne" type="number" min="0" step="50" value="${num(s.oneTime)}"></div><div class="field"><label>Zeitraum</label><input id="scHorizon" type="number" min="1" max="120" value="${horizon}"></div></div><div class="actions"><button class="btn btn-primary" onclick="saveScenario()">Szenario berechnen</button>${goal?`<button class="btn btn-secondary" onclick="useGoalScenario()">Ziel „${esc(goal.name)}“ übernehmen</button>`:""}</div></div>
 <div class="grid kpis">${card("Ziel erreicht",n.months===null?"nicht berechenbar":`in ${n.months} Mon.`)}${card(`Stand in ${horizon} Mon.`,eur(n.final))}${card("Monatliche Sparrate",eur(n.monthly))}${card("Zielbetrag",eur(n.target))}</div>
 <div class="scenario-grid"><div class="scenario-card"><small>BASIS</small><strong>${base.months===null?'—':base.months+' Monate'}</strong><p>${eur(base.monthly)} monatlich</p></div><div class="scenario-card featured"><small>+100 € / MONAT</small><strong>${boost100.months===null?'—':boost100.months+' Monate'}</strong><p>${eur(boost100.monthly)} monatlich</p></div><div class="scenario-card"><small>+300 € / MONAT</small><strong>${boost300.months===null?'—':boost300.months+' Monate'}</strong><p>${eur(boost300.monthly)} monatlich</p></div></div>`;
}
function saveScenario(){state.meta.scenario={target:num(document.getElementById('scTarget')?.value),current:num(document.getElementById('scCurrent')?.value),monthly:num(document.getElementById('scMonthly')?.value),extra:num(document.getElementById('scExtra')?.value),oneTime:num(document.getElementById('scOne')?.value),horizon:Math.max(1,Math.min(120,num(document.getElementById('scHorizon')?.value)||24))};save();render();toast('Szenario gespeichert')}
function useGoalScenario(){const g=state.goals?.[0];if(!g)return;state.meta.scenario={...state.meta.scenario,target:num(g.target),current:num(g.saved)};save();render();toast('Ziel übernommen')}
function renderHousehold(){
 const h=state.meta.household, members=h.members||[], expenses=(state.transactions||[]).filter(x=>x.type==='Ausgabe'),by=members.map(m=>({m,total:expenses.filter(x=>x.memberId===m.id).reduce((s,x)=>s+householdShareAmount(x),0)}));
 return `<div class="panel"><div class="panel-head"><div><h2>Haushaltsmodus</h2><p>Gemeinsame und persönliche Ausgaben in einem Modell verwalten.</p></div><button class="btn ${h.enabled?'btn-secondary':'btn-primary'}" onclick="toggleHousehold()">${h.enabled?'Haushaltsmodus aktiv':'Haushaltsmodus aktivieren'}</button></div><div class="form-grid"><div class="field"><label>Haushaltsname</label><input id="hhName" value="${esc(h.name||'Unser Haushalt')}"></div></div><div class="actions"><button class="btn btn-secondary" onclick="saveHouseholdName()">Namen speichern</button><button class="btn btn-primary" onclick="addHouseholdMember()">+ Person</button></div></div><div class="panel"><div class="panel-head"><div><h2>Personen</h2><p>Neue Buchungen können später einem Mitglied zugeordnet werden.</p></div></div><div class="member-grid">${members.map((m,i)=>`<div class="member-card"><div class="avatar">${esc((m.name||'?').slice(0,1).toUpperCase())}</div><div><strong>${esc(m.name)}</strong><span>${esc(m.role||'Mitglied')} · ${eur(by[i]?.total||0)} Ausgaben</span></div>${members.length>1?`<button class="btn btn-secondary" onclick="removeHouseholdMember('${m.id}')">Entfernen</button>`:''}</div>`).join('')}</div></div><div class="panel"><div class="panel-head"><div><h2>Kostenaufteilung</h2><p>Bei Buchungen kann ein Anteil in Prozent gespeichert werden.</p></div></div><div class="notice">100 % bedeutet volle Zuordnung zum ausgewählten Mitglied; 50 % verteilt eine Buchung rechnerisch zur Hälfte. Die Originalbuchung bleibt unverändert.</div></div>`;
}
function toggleHousehold(){state.meta.household.enabled=!state.meta.household.enabled;save();render();toast(state.meta.household.enabled?'Haushaltsmodus aktiviert':'Haushaltsmodus deaktiviert')}
function saveHouseholdName(){const v=document.getElementById('hhName')?.value.trim();if(v)state.meta.household.name=v;save();render();toast('Haushaltsname gespeichert')}
function addHouseholdMember(){const v=prompt('Name der Person','Partner/in');if(!v?.trim())return;state.meta.household.members.push({id:'member_'+Date.now(),name:v.trim(),role:'Mitglied'});save();render();toast('Person hinzugefügt')}
function removeHouseholdMember(id){if(state.meta.household.members.length<=1)return;state.meta.household.members=state.meta.household.members.filter(m=>m.id!==id);state.transactions.forEach(t=>{if(t.memberId===id)t.memberId=state.meta.household.members[0].id});save();render();toast('Person entfernt')}
function renderBank(){
 const b=state.meta.bank||{};return `<div class="panel"><div class="panel-head"><div><h2>Bank Center</h2><p>Importiere Kontoauszüge sicher und kategorisiere Buchungen automatisch.</p></div><span class="pro-badge">BANK READY</span></div><div class="bank-provider"><div><strong>CSV-/Kontoauszugs-Import</strong><p>Geeignet für Exporte aus Banking-Apps und Online-Banking. Du behältst die Kontrolle über die Datei.</p></div><button class="btn btn-primary" onclick="openBankImport()">CSV importieren</button></div><div class="bank-provider muted"><div><strong>PSD2 / FinTS Connector</strong><p>Die App hat hier bewusst keinen direkten Bankzugriff. Eine echte Verbindung benötigt einen sicheren Backend-/Open-Banking-Anbieter, Zugangsdaten, Einwilligung und Server-Infrastruktur.</p></div><span class="pro-badge">ARCHITEKTUR VORBEREITET</span></div><div class="grid kpis">${card('Importierte Buchungen',b.imported||0)}${card('Doppelte übersprungen',b.duplicateCount||0)}${card('Letzter Import',b.lastImport?new Date(b.lastImport).toLocaleDateString('de-DE'):'—')}${card('Auto-Kategorisierung',Object.keys(state.meta.merchantRules||{}).length+' Regeln')}</div></div><div class="panel"><div class="panel-head"><div><h2>Auto-Kategorisierung</h2><p>Geldtipp nutzt Händlerregeln und merkt sich deine manuellen Korrekturen.</p></div></div><div class="rule-list">${Object.entries(state.meta.merchantRules||{}).slice(0,20).map(([k,v])=>`<div class="rule-row"><span>${esc(k)}</span><strong>${esc(v)}</strong></div>`).join('')||`<div class="empty">Noch keine gelernten Händlerregeln.</div>`}</div><div class="actions"><button class="btn btn-secondary" onclick="resetMerchantRules()">Regeln zurücksetzen</button></div></div>`;
}
function openBankImport(){document.getElementById('modalRoot').innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card"><button class="close" onclick="closeModal()">×</button><h2>Kontoauszug importieren</h2><p>Geldtipp erkennt typische CSV-Spalten für Datum, Buchungstext und Betrag. Du kannst entscheiden, ob die importierten Buchungen den Kontostand verändern sollen.</p><div class="form-grid"><div class="field"><label>Zielkonto</label><select id="bankAccount">${state.accounts.map(a=>`<option value="${a.id}">${esc(a.name)}</option>`).join('')}</select></div><div class="field"><label>Datei</label><input id="bankFile" type="file" accept=".csv,.txt"></div></div><label style="display:flex;gap:9px;align-items:center;margin-top:14px;font-size:12px"><input id="bankApply" type="checkbox"> Kontostand anhand der importierten Buchungen verändern</label><div class="actions"><button class="btn btn-primary" onclick="importBankFile()">Import starten</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div></div></div>`}
function parseCsv(text){
 const first=(text.split(/\r?\n/)[0]||'');const delim=(first.split(';').length>=first.split(',').length&&first.split(';').length>=first.split('\t').length)?';':(first.split('\t').length>first.split(',').length?'\t':',');const rows=[];let row=[],cell='',quote=false;
 for(let i=0;i<text.length;i++){const ch=text[i];if(ch==='"'){if(quote&&text[i+1]==='"'){cell+='"';i++;}else quote=!quote;continue}if(ch===delim&&!quote){row.push(cell);cell='';continue}if((ch==='\n'||ch==='\r')&&!quote){if(ch==='\r'&&text[i+1]==='\n')i++;row.push(cell);if(row.some(v=>String(v).trim()!==''))rows.push(row);row=[];cell='';continue}cell+=ch}if(cell||row.length){row.push(cell);rows.push(row)}return {delim,rows};
}
function parseBankNumber(v){let s=String(v??'').trim().replace(/\s/g,'');if(!s)return 0;if(s.includes(',')&&s.includes('.')){if(s.lastIndexOf(',')>s.lastIndexOf('.'))s=s.replace(/\./g,'').replace(',','.');else s=s.replace(/,/g,'')}else if(s.includes(','))s=s.replace(',','.');return Number(s.replace(/[^0-9+\-.]/g,''))||0}
function findHeader(headers,needles){return headers.findIndex(h=>needles.some(n=>cleanText(h).includes(cleanText(n))))}
async function importBankFile(){
 const f=document.getElementById('bankFile')?.files?.[0];if(!f){toast('Bitte eine CSV-Datei wählen');return}const text=await f.text(),p=parseCsv(text),rows=p.rows;if(rows.length<2){toast('Keine Buchungszeilen erkannt');return}
 const headers=rows[0].map(x=>x.trim().toLowerCase()),di=findHeader(headers,['datum','date','buchungstag','wertstellung']),ti=findHeader(headers,['verwendungszweck','buchungstext','beschreibung','text','empfänger','payee']),ai=findHeader(headers,['betrag','amount','umsatz','value']),debi=findHeader(headers,['lastschrift','soll','debit']),credi=findHeader(headers,['gutschrift','haben','credit']);
 if(di<0||ti<0||ai<0&&debi<0&&credi<0){toast('CSV-Spalten nicht erkannt');return}
 const accountId=document.getElementById('bankAccount').value,apply=document.getElementById('bankApply').checked;let added=0,dupes=0,delta=0;
 const existing=new Set((state.transactions||[]).map(x=>[x.date,cleanText(x.title),num(x.amount).toFixed(2),x.type].join('|')));
 for(const r of rows.slice(1)){
   const date=(r[di]||'').trim();let title=(r[ti]||'').trim()||'Bankbuchung';let signed=ai>=0?parseBankNumber(r[ai]):(parseBankNumber(r[credi]||0)-parseBankNumber(r[debi]||0));if(!date||!signed)continue;
   let type=signed<0?'Ausgabe':'Einnahme',amount=Math.abs(signed),cat=autoCategorize(title,type);const key=[date,cleanText(title),amount.toFixed(2),type].join('|');if(existing.has(key)){dupes++;continue}
   const tx={id:'tx_'+Date.now()+'_'+Math.random().toString(36).slice(2,7),date,title,category:cat,type,accountId,amount,source:'bank-import',memberId:state.meta.household.members[0]?.id||null,sharePercent:100};state.transactions.push(tx);existing.add(key);rememberMerchantCategory(title,cat);added++;delta+=type==='Einnahme'?amount:-amount;
 }
 if(apply){const a=state.accounts.find(x=>x.id===accountId);if(a)a.balance+=delta}
 state.meta.bank={...(state.meta.bank||{}),lastImport:new Date().toISOString(),imported:num(state.meta.bank?.imported)+added,duplicateCount:num(state.meta.bank?.duplicateCount)+dupes};save();closeModal();render();toast(`${added} Buchungen importiert · ${dupes} Duplikate übersprungen`);
}
function resetMerchantRules(){if(confirm('Gelernte Händlerregeln zurücksetzen?')){state.meta.merchantRules={};save();render();toast('Regeln zurückgesetzt')}}
function renderSync(){const s=state.meta.sync||{};return `<div class="panel"><div class="panel-head"><div><h2>Konto & Sync</h2><p>Lokale Geräteverwaltung und verschlüsselte Sync-Pakete.</p></div><span class="pro-badge">SECURE</span></div><div class="sync-card"><strong>Gerätedatensatz</strong><span>${esc(state.meta.profileName||'Mein Haushalt')} · lokal</span><small>Es gibt derzeit bewusst keinen externen Cloud-Server in dieser Version.</small></div><div class="actions"><button class="btn btn-primary" onclick="exportEncryptedBackup()">🔐 Verschlüsseltes Sync-Paket exportieren</button><button class="btn btn-secondary" onclick="importEncryptedBackup()">Sync-Paket importieren</button></div><div class="notice" style="margin-top:14px">Die Verschlüsselung erfolgt im Browser mit einem Passwort und AES-GCM. Für einen echten Multi-Geräte-Cloud-Dienst wäre anschließend ein sicherer Backend-Anbieter nötig.</div><div class="notice" style="margin-top:12px">Letzter verschlüsselter Export: ${s.lastExport?new Date(s.lastExport).toLocaleString('de-DE'):'noch keiner'}</div></div>`}
async function deriveKey(password,salt){const key=await crypto.subtle.importKey('raw',new TextEncoder().encode(password),'PBKDF2',false,['deriveKey']);return crypto.subtle.deriveKey({name:'PBKDF2',salt,iterations:120000,hash:'SHA-256'},key,{name:'AES-GCM',length:256},false,['encrypt','decrypt'])}
function toB64(buf){return btoa(String.fromCharCode(...new Uint8Array(buf)))}
function fromB64(s){return Uint8Array.from(atob(s),c=>c.charCodeAt(0))}
async function exportEncryptedBackup(){const pw=prompt('Passwort für das verschlüsselte Sync-Paket');if(!pw)return;try{const salt=crypto.getRandomValues(new Uint8Array(16)),iv=crypto.getRandomValues(new Uint8Array(12)),key=await deriveKey(pw,salt),payload=JSON.stringify({...state,exportedAt:new Date().toISOString(),formatVersion:3}),cipher=await crypto.subtle.encrypt({name:'AES-GCM',iv},key,new TextEncoder().encode(payload));const pkg={format:'geldtipp-sync',version:1,salt:toB64(salt),iv:toB64(iv),data:toB64(cipher)};state.meta.sync={lastExport:new Date().toISOString()};save();downloadBlob(JSON.stringify(pkg),"application/json","geldtipp-sync.gttx");toast('Verschlüsseltes Paket exportiert')}catch{toast('Sync-Export fehlgeschlagen')}}
function importEncryptedBackup(){const input=document.createElement('input');input.type='file';input.accept='.gttx,.json';input.onchange=async()=>{const f=input.files?.[0];if(!f)return;try{const pkg=JSON.parse(await f.text());if(pkg.format!=='geldtipp-sync')throw new Error('format');const pw=prompt('Passwort für dieses Sync-Paket');if(!pw)return;const key=await deriveKey(pw,fromB64(pkg.salt)),plain=await crypto.subtle.decrypt({name:'AES-GCM',iv:fromB64(pkg.iv)},key,fromB64(pkg.data)),incoming=JSON.parse(new TextDecoder().decode(plain));state=merge(clone(defaultState),incoming);ensureV21State();save();applyTheme();render();toast('Verschlüsseltes Paket importiert')}catch{alert('Sync-Paket konnte nicht entschlüsselt werden. Passwort oder Datei prüfen.')}};input.click()}
function openQuickAdd(){
 const root=document.getElementById('modalRoot'),type=state.meta.lastType||'Ausgabe',autoCat=state.meta.lastCategory||recentCategoryList()[0]||'Sonstiges',acc=state.meta.lastAccountId||state.accounts?.[0]?.id||'',h=state.meta.household,members=h.enabled?h.members:[];state.meta.quickCategoryManual=false;
 root.innerHTML=`<div class="modal" onclick="if(event.target===this)closeModal()"><div class="modal-card quick-modal"><button class="close" onclick="closeModal()">×</button><div class="brand-mark">€</div><h2 style="margin-top:9px">Schnell buchen</h2><p>Erfasse eine Ausgabe oder Einnahme in wenigen Sekunden.</p><div class="field"><label>Betrag</label><input id="qAmount" class="big-input" inputmode="decimal" placeholder="0,00"></div><div class="type-toggle"><button type="button" id="qTypeOut" class="${type==='Ausgabe'?'active':''}" onclick="setQuickType('Ausgabe')">− Ausgabe</button><button type="button" id="qTypeIn" class="${type==='Einnahme'?'active':''}" onclick="setQuickType('Einnahme')">＋ Einnahme</button></div><div class="form-grid" style="margin-top:14px"><div class="field"><label>Bezeichnung</label><input id="qTitle" placeholder="z. B. REWE"></div><div class="field"><label>Kategorie</label><select id="qCategory" onchange="state.meta.quickCategoryManual=true;state.meta.lastCategory=this.value">${(state.categories||[]).filter(c=>c!=='Einkommen'||type==='Einnahme').map(c=>`<option ${c===autoCat?'selected':''}>${esc(c)}</option>`).join('')}</select></div><div class="field"><label>Konto</label><select id="qAccount">${(state.accounts||[]).map(a=>`<option value="${a.id}" ${a.id===acc?'selected':''}>${esc(a.name)}</option>`).join('')}</select></div><div class="field"><label>Datum</label><input id="qDate" type="date" value="${new Date().toISOString().slice(0,10)}"></div>${members.length?`<div class="field"><label>Person</label><select id="qMember">${members.map((m,i)=>`<option value="${m.id}" ${i===0?'selected':''}>${esc(m.name)}</option>`).join('')}</select></div><div class="field"><label>Anteil</label><input id="qShare" type="number" min="1" max="100" value="100"></div>`:''}</div><div class="recent-chips">${recentCategoryList().map(c=>`<button class="chip" onclick="quickChooseCategory('${encodeURIComponent(c)}')">${esc(c)}</button>`).join('')}</div><div class="actions"><button class="btn btn-primary" onclick="saveQuickAdd()">Buchen ↵</button><button class="btn btn-secondary" onclick="closeModal()">Abbrechen</button></div></div></div>`;
 document.getElementById('qAmount')?.focus();
}
function saveQuickAdd(){
 const title=document.getElementById('qTitle')?.value.trim()||'Buchung',amount=num(document.getElementById('qAmount')?.value),type=state.meta.lastType||'Ausgabe',chosen=document.getElementById('qCategory')?.value||'Sonstiges',auto=autoCategorize(title,type),category=state.meta.quickCategoryManual?chosen:auto,accountId=document.getElementById('qAccount')?.value,date=document.getElementById('qDate')?.value||new Date().toISOString().slice(0,10),memberId=document.getElementById('qMember')?.value||state.meta.household.members?.[0]?.id||null,sharePercent=num(document.getElementById('qShare')?.value)||100;
 if(amount<=0){toast('Bitte einen Betrag eingeben');return}const acc=state.accounts.find(a=>a.id===accountId);if(!acc){toast('Bitte ein Konto wählen');return}if(type==='Ausgabe'&&num(acc.balance)<amount){toast('Der verfügbare Kontostand reicht nicht aus');return}
 if(state.meta.quickCategoryManual&&chosen!=='Sonstiges')rememberMerchantCategory(title,chosen);
 state.transactions.push({id:'tx_'+Date.now()+'_'+Math.random().toString(36).slice(2,7),date,title,category,type,accountId,amount,memberId,sharePercent});acc.balance+=(type==='Einnahme'?amount:-amount);state.meta.lastCategory=category;state.meta.lastAccountId=accountId;state.meta.lastType=type;rememberCategory(category);save();closeModal();render();toast(`${type} gebucht`)
}
function addTx(){
 const date=document.getElementById('txDate')?.value||new Date().toISOString().slice(0,10),title=document.getElementById('txTitle')?.value.trim()||'Buchung',type=document.getElementById('txType')?.value||'Ausgabe',accountId=document.getElementById('txAccount')?.value,amount=num(document.getElementById('txAmount')?.value),chosen=document.getElementById('txCategory')?.value||'Sonstiges',category=chosen==='Sonstiges'?autoCategorize(title,type):chosen;
 if(!amount){toast('Bitte Bezeichnung und Betrag eingeben');return}const acc=state.accounts.find(a=>a.id===accountId);if(!acc){toast('Bitte Konto wählen');return}if(type==='Ausgabe'&&num(acc.balance)<amount){toast('Der verfügbare Kontostand reicht nicht aus');return}state.transactions.push({id:'tx_'+Date.now()+'_'+Math.random().toString(36).slice(2,7),date,title,category,type,accountId,amount,memberId:state.meta.household.members?.[0]?.id||null,sharePercent:100});acc.balance+=(type==='Einnahme'?amount:-amount);state.meta.lastType=type;state.meta.lastCategory=category;state.meta.lastAccountId=accountId;rememberCategory(category);if(chosen!==autoCategorize(title,type)&&chosen!=='Sonstiges')rememberMerchantCategory(title,chosen);save();render();toast('Transaktion gespeichert')
}
function removeTxById(id){const i=state.transactions.findIndex(x=>x.id===id);if(i<0)return;const t=state.transactions[i];const acc=state.accounts.find(a=>a.id===t.accountId);if(acc&&t.type!=='Transfer')acc.balance+=(t.type==='Einnahme'?-num(t.amount):num(t.amount));state.transactions.splice(i,1);save();render();toast('Buchung gelöscht')}
function renderTransactions(){
 const f=state.meta.txFilter||{};const list=filteredTransactions(),total={income:list.filter(x=>x.type==='Einnahme').reduce((s,x)=>s+num(x.amount),0),expense:list.filter(x=>x.type==='Ausgabe').reduce((s,x)=>s+num(x.amount),0)};
 const cats=[...new Set((state.categories||[]).filter(x=>x!=='Einkommen'))];
 return `<div class="panel"><div class="panel-head"><div><h2>Transaktionen</h2><p>Suche, filtere und prüfe deine Buchungen.</p></div><button class="btn btn-primary" onclick="openQuickAdd()">+ Schnell buchen</button></div><div class="filter-grid"><div class="field"><label>Suche</label><input value="${esc(f.q||'')}" oninput="updateTxFilter('q',this.value)"></div><div class="field"><label>Kategorie</label><select onchange="updateTxFilter('category',this.value)"><option value="">Alle Kategorien</option>${cats.map(c=>`<option ${f.category===c?'selected':''}>${esc(c)}</option>`).join('')}</select></div><div class="field"><label>Art</label><select onchange="updateTxFilter('type',this.value)"><option value="">Alle</option><option ${f.type==='Ausgabe'?'selected':''}>Ausgabe</option><option ${f.type==='Einnahme'?'selected':''}>Einnahme</option><option ${f.type==='Transfer'?'selected':''}>Transfer</option></select></div><div class="field"><label>Konto</label><select onchange="updateTxFilter('account',this.value)"><option value="">Alle Konten</option>${state.accounts.map(a=>`<option value="${a.id}" ${f.account===a.id?'selected':''}>${esc(a.name)}</option>`).join('')}</select></div><div class="field"><label>Von</label><input type="date" value="${f.from||''}" onchange="updateTxFilter('from',this.value)"></div><div class="field"><label>Bis</label><input type="date" value="${f.to||''}" onchange="updateTxFilter('to',this.value)"></div></div><div class="grid kpis" style="margin-top:18px">${card('Einnahmen',eur(total.income))}${card('Ausgaben',eur(total.expense))}${card('Saldo',eur(total.income-total.expense))}${card('Treffer',list.length)}</div></div><div class="panel"><div style="overflow:auto"><table class="table"><thead><tr><th>Datum</th><th>Bezeichnung</th><th>Kategorie</th><th>Konto</th><th>Person</th><th>Art</th><th>Betrag</th><th></th></tr></thead><tbody>${list.map(x=>{const isT=x.type==='Transfer';return `<tr><td>${esc(x.date)}</td><td><strong>${esc(x.title)}</strong>${x.source==='bank-import'?'<small class="source-badge">BANK</small>':''}</td><td>${esc(isT?'Interne Überweisung':x.category)}</td><td>${esc(isT?`${accountName(x.fromAccountId)} → ${accountName(x.toAccountId)}`:accountName(x.accountId))}</td><td>${esc(memberName(x.memberId))}${state.meta.household.enabled&&x.sharePercent!=null?` · ${num(x.sharePercent)}%`:''}</td><td>${esc(x.type)}</td><td>${x.type==='Einnahme'?'+':'−'} ${eur(x.amount)}</td><td><button class="icon-btn" onclick="removeTxById('${x.id}')">×</button></td></tr>`}).join('')||`<tr><td colspan="8" class="empty">Keine passenden Buchungen.</td></tr>`}</tbody></table></div></div>`;
}
function updateTxFilter(key,value){state.meta.txFilter=state.meta.txFilter||{};state.meta.txFilter[key]=value;save();render()}
function saveEncryptedNotice(){toast('Die Daten bleiben lokal, bis du sie exportierst.')}
function pageTitle(p){return ({dashboard:'Dashboard',konten:'Konten',budget:'Budget',wohnung:'Wohnungs-Check',sparen:'Sparziel',notgroschen:'Notgroschen',auto:'Auto-Kosten',schulden:'Schulden-Check',jahr:'Jahresübersicht',abschluss:'Monatsabschluss',transaktionen:'Transaktionen',ziele:'Meine Ziele',wiederkehrend:'Verträge & Kosten',einstellungen:'Einstellungen',vermoegen:'Vermögen',coach:'Geldtipp Coach 2.0',report:'Jahresreport',analyse:'Finanzanalyse',lebensstil:'Mein Lebensstandard',szenarien:'Szenarien',haushalt:'Haushaltsmodus',bank:'Bank Center',sync:'Konto & Sync'})[p]||'Dashboard'}
function setPage(p){current=p;state.meta.lastPage=p;save();document.querySelectorAll('.nav button').forEach(b=>b.classList.toggle('active',b.dataset.page===p));document.querySelectorAll('#mobileDock button').forEach(b=>b.classList.toggle('active',b.dataset.page===p));const title=document.getElementById('pageTitle');if(title)title.textContent=pageTitle(p);render();if(innerWidth<820)document.getElementById('sidebar')?.classList.remove('open')}
function render(){
 const root=document.getElementById('appRoot');if(!root)return;ensureV21State();
 root.innerHTML=current==='dashboard'?renderDashboard():current==='budget'?renderBudget():current==='wohnung'?renderWohnung():current==='sparen'?renderSparen():current==='notgroschen'?renderNotgroschen():current==='auto'?renderAuto():current==='schulden'?renderSchulden():current==='jahr'?renderYear():current==='konten'?renderAccounts():current==='transaktionen'?renderTransactions():current==='ziele'?renderGoals():current==='vermoegen'?renderWealth():current==='coach'?renderCoach():current==='report'?renderReport():current==='abschluss'?renderClosePage():current==='wiederkehrend'?renderRecurring():current==='analyse'?renderAnalysis():current==='lebensstil'?renderLifestyle():current==='szenarien'?renderScenarios():current==='haushalt'?renderHousehold():current==='bank'?renderBank():current==='sync'?renderSync():renderSettings();
 wireInputs();if(current==='dashboard'){drawCashflow();drawTopSpend()}if(current==='jahr'){drawYear()}wireCompare();
 const nav=document.querySelectorAll('.nav button');nav.forEach(b=>b.classList.toggle('active',b.dataset.page===current));
 const pt=document.getElementById('pageTitle');if(pt)pt.textContent=pageTitle(current);
}
function showBankInfo(){setPage('bank')}
ensureV21State();

window.addEventListener("resize",()=>{if(current==="dashboard"){drawCashflow();drawTopSpend()}if(current==="jahr")drawYear()})
window.addEventListener("keydown",e=>{if(e.key==="Escape")closeModal(); if((e.key==="+"||e.key==="=")&&!e.metaKey&&!e.ctrlKey&&!e.altKey&&document.activeElement?.tagName!=="INPUT"&&document.activeElement?.tagName!=="TEXTAREA"&&document.activeElement?.tagName!=="SELECT"){e.preventDefault();openQuickAdd()}})
applyTheme();document.getElementById("pageTitle").textContent=pageTitle(current);render();setTimeout(()=>showOnboarding(false),250);
