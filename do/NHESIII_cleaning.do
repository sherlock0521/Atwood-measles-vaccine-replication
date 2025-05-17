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

log using "NHESIII_cleaning", replace
* "log using"：開始紀錄指令與輸出結果
* "NHESII_cleaning"：指定 log 檔名稱（副檔名預設為 .smcl）
* "replace"：若該檔已存在，直接覆蓋
 


**---把 NHESIII.dta 匯入 Stata---

use "$rawdata\NHESIII.dta", clear
* "use"：讀資料進Stata
* "$rawdata\NHESIII.dta"：從 rawdata 這個資料夾匯入 NHESIII.dta
* "clear"：如果 Stata 裡已經有資料，先清除



**---建立 state_of_birth 變數：受訪者的出生州---

gen state_of_birth = h3ed0125
* "gen"：建立新變數 state_of_birth
* "h3ed0125"：原始變數，紀錄受訪者的出生地代碼（1–51 為美國州別；52–55 為海外或特殊區域）

*---將編號 52–55 的特殊地區強制對應到美國本土州，方便後續州層級分析---

replace state_of_birth = 14 if state_of_birth == 52    // Vermont
replace state_of_birth = 19 if state_of_birth == 53    // Missouri
replace state_of_birth = 21 if state_of_birth == 54    // Maryland
replace state_of_birth = 33 if state_of_birth == 55    // New York
* "replace"：重新指定變數的值
* 將特殊地區對應到具代表性的美國州，以保留樣本並維持資料可合併性



**---建立 native 變數：是否出生於美國本土---

gen native = state_of_birth < 56
* "gen"：建立新變數 native
* 當 state_of_birth 小於 56 時，代表出生於美國 50 州或 DC，native 設為 1；否則為 0 或缺值

replace native = 0 if missing(state_of_birth)
* 若 state_of_birth 為缺值，明確將 native 設為 0（視為非本土出生）



**---建立 measles 變數：是否得過麻疹---

gen measles = h3ed0195 == 1
* "gen"：建立新變數 measles
* 當受訪者回答 h3ed0195 == 1（得過麻疹）時，measles 設為 1；否則為 0

replace measles = . if h3ed0195 == 3
* 若受訪者回答「不知道是否得過麻疹」（h3ed0195 == 3），將 measles 設為遺漏值

replace measles = . if h3ed0195 == .
* 若受訪者未作答（h3ed0195 為系統缺值），也將 measles 設為遺漏值



**---建立 female 變數：是否為女性---

gen female = h3ed0049 > 3
* "gen"：建立新變數 female
* 當 h3ed0049 編碼大於 3 時，代表受訪者為女性，female 設為 1；否則為 0（表示男性）



**---建立 black 變數：是否為黑人---

gen black = h3ed0048 == 2
* "gen"：建立新變數 black
* 當 h3ed0048 等於 2 時，代表受訪者為黑人，black 設為 1；否則為 0（如白人）

replace black = . if h3ed0048 == 3
* 若 h3ed0048 為 3（其他或不明種族），將 black 設為遺漏值，排除分類不明的樣本



**---篩選分析樣本：僅保留 native-born 且有填寫性別與種族的受訪者---

drop if native == 0
* 移除非美國本土出生的樣本（native = 0）

drop if missing(black)
* 移除種族為其他或未填答者（black 為遺漏值）

drop if missing(female)
* 移除未填寫性別的樣本（female 為遺漏值）



**---把整理好的資料存檔---

cd "$workdata"
* "cd"：切換到你設定的 workdata 資料夾，用來存放清理後的資料檔案

save "NHESIII_native.dta", replace
* "save"：將目前記憶體中的資料儲存為 NHESIII_native.dta
* "replace"：如果該檔案已經存在，就直接覆蓋



**---關閉 log file，完成此次程式執行紀錄---

log close
* "log close"：關閉目前開啟的 log file，將指令與輸出完整寫入檔案中

