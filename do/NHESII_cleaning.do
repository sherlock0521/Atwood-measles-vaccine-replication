**---目標：估算 1963 年美國 6–12 歲兒童中，有多少人得過麻疹---



**---初始化：清除記憶體與取消分頁顯示---

clear all
* "clear all"：清除記憶體中所有資料與設定（變數、結果、繪圖等）

set more off
* "set more off"：取消每頁暫停顯示，讓程式可以一次跑完不被中斷



**---這類似於 R 中設定工作目錄，但我們是分別針對不同功能的資料夾設定路徑---

global do = "D:\Desktop\wenson\final_project\data_code\do"
global log = "D:\Desktop\wenson\final_project\data_code\log"
global rawdata = "D:\Desktop\wenson\final_project\data_code\rawdata"
global workdata = "D:\Desktop\wenson\final_project\data_code\workdata"
global pic = "D:\Desktop\wenson\final_project\data_code\pic"
** global 是 Stata 中設定全域變數的指令，用於儲存資料夾路徑



**---紀錄程式執行過程：啟用 log file---

cd "$log"
* "cd"：切換目前工作資料夾到你事先設定的 logs 資料夾

log using "NHESII_cleaning", replace
* "log using"：開始紀錄指令與輸出結果
* "NHESII_cleaning"：指定 log 檔名稱（副檔名預設為 .smcl）
* "replace"：若該檔已存在，直接覆蓋
 


**---把 NHESII.dta 匯入 Stata---

use "$rawdata\NHESII.dta", clear
* "use"：讀資料進Stata
* "$rawdata\NHESII.dta"：從 rawdata 這個資料夾匯入 NHESII.dta
* "clear"：如果 Stata 裡已經有資料，先清除



**---建立一個新變數 state_of_birth，其值來自 h2id0115---

gen state_of_birth = h2id0115
* "gen"：建立一個新變數
* "h2id0115"：受訪者的出生地編號，正常值為 1–51（代表美國各州）
*             但部分人為 52–55，代表海外或特殊地區（如波多黎各、軍事基地、外國）

*---將編號 52–55 的特殊地區強制對應到美國本土州，方便後續州層級分析---

replace state_of_birth = 14 if state_of_birth == 52    // Vermont
replace state_of_birth = 19 if state_of_birth == 53    // Missouri
replace state_of_birth = 21 if state_of_birth == 54    // Maryland
replace state_of_birth = 33 if state_of_birth == 55    // New York
* "replace"：重新指定變數的值
* 這些對應是研究者自訂的，目的在於將海外出生者納入分析樣本中




**---建立 native 變數，判斷是否為美國本土出生---

gen native = state_of_birth < 56
* "gen"：建立新變數 native
* "state_of_birth < 56"：若出生州代碼小於 56，表示出生於美國 50 州或華盛頓特區，native 設為 1；否則為 0
 


replace native = 0 if missing(state_of_birth)
* "replace"：重新指定變數的值
* "missing(state_of_birth)"：判斷 state_of_birth 是否為缺值
* 若出生州資訊缺失，明確將 native 設為 0，避免遺漏值干擾後續分析



**---建立受訪年份 survey_year 變數---

tostring h2id0021, replace 
* "tostring"：將 h2id0021 轉為字串格式，方便後續擷取字元
* "replace"：直接覆蓋原變數（不產生新的變數）

gen survey_year = substr(h2id0021, -2, 2)
* "substr(x, -2, 2)"：從字串最後兩位擷取字元，例如 "63"
* 建立 survey_year 變數，代表受訪年份的末兩位數

destring survey_year, replace
* "destring"：將字串型的 survey_year 轉為數值型態，方便數值分析
* "replace"：直接覆蓋原本的 survey_year 變數




**---建立 measles 變數：是否得過麻疹---

gen measles = h2id0205 == 1
* "gen"：建立新變數 measles
* 當受訪者回答 h2id0205 == 1（得過麻疹）時，measles 設為 1，否則為 0

replace measles = . if h2id0205 == 3
* 若受訪者回答「不知道是否得過麻疹」（h2id0205 == 3），則將 measles 設為遺漏值

replace measles = . if h2id0205 == .
* 若受訪者未作答（h2id0205 為缺值），也將 measles 設為遺漏值




**---建立 female 變數：是否為女性---

gen female = h2id0035 > 3
* "gen"：建立新變數 female
* 當 h2id0035 編碼大於 3 時，代表受訪者為女性，female 設為 1，否則為 0


**---建立 black 變數：是否為黑人---

gen black = h2id0034 == 2
* "gen"：建立新變數 black
* 當 h2id0034 等於 2 時，代表受訪者為黑人，black 設為 1，否則為 0

replace black = . if h2id0034 == 3
* 若 h2id0034 為 3（其他／不明種族），則將 black 設為遺漏值，排除分類不明的樣本



**---保留可分析樣本：native-born 且有填寫性別與種族---

drop if native == 0
* 移除非美國本土出生者（native = 0）

drop if missing(black)
* 移除種族為其他或未填答者（black 為遺漏值）

drop if missing(female)
* 移除未填寫性別的樣本（female 為遺漏值）



**---把整理好的資料存檔---

cd "$workdata"
* "cd"：切換到你設定的 workdata 資料夾，用來存放清理後的資料檔

save "NHESII_native.dta", replace
* "save"：將目前記憶體中的資料儲存為 NHESII_native.dta
* "replace"：如果該檔案已經存在，就直接覆蓋




**---關閉 log file，結束紀錄此次程式執行過程---

log close
* "log close"：關閉目前開啟的 log file，完成紀錄並儲存輸出內容











 