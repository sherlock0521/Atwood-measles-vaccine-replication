**---目標：建立 1–5 歲美國本土出生兒童是否接種麻疹疫苗的指標變數，用於描述疫苗實際覆蓋率（Table 1）---***




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

log using "NHANESI_cleaning", replace 
* "log using"：開始紀錄指令與輸出結果
* "NHANESI_cleaning"：指定 log 檔名稱（副檔名預設為 .smcl）
* "replace"：若該檔已存在，直接覆蓋



**---把 NHANESI.dta 匯入 Stata---

use "$rawdata\NHANESI.dta", clear
* "use"：讀資料進Stata
* "$rawdata\NHANESI.dta"：從 rawdata 這個資料夾匯入 NHANESI.dta
* "clear"：如果 Stata 裡已經有資料，先清除



**---建立 measles_vac 變數：是否接種麻疹疫苗（僅限 1–5 歲兒童）---

gen measles_vac = n1ch0264 == 1
* "gen"：建立新變數 measles_vac
* "n1ch0264 == 1"：代表受訪者的照顧者回答「有接種麻疹疫苗」，設為 1；其他預設為 0

replace measles_vac = . if n1ch0264 == 9
* "replace"：若回答為 9（不知道），視為無效資料，設為遺漏值（missing）

replace measles_vac = . if n1ch0264 == .
* "replace"：若該問題未作答（系統缺值），同樣設為遺漏值



**---建立 state_of_birth 變數：受訪兒童的出生州---

gen state_of_birth = n1ch0110
* "gen"：建立新變數 state_of_birth
* "n1ch0110"：原始變數，代表受訪者的出生地州別代碼（通常為 1–51，美國各州；部分為
*             52–55，代表海外或特殊地區）     



**---建立 native 變數：是否出生於美國本土---

gen native = n1ch0110 < 57
* "gen"：建立新變數 native
* 當出生地代碼 n1ch0110 小於 57 時，代表受訪者出生於美國 50 州或屬地（包括
* DC、部分海外軍事基地）native 設為 1，否則為 0 或缺值



**---建立 black 變數：是否為黑人---

gen black = n1ch0103 == 2
* "gen"：建立新變數 black
* 當 n1ch0103 等於 2 時，代表受訪者為黑人，black 設為 1；否則為 0

replace black = . if n1ch0103 == 3
* 若 n1ch0103 為 3（其他或不明種族），將 black 設為遺漏值，排除分類不明的樣本



**---建立 age 變數：受訪者年齡---

gen age = n1ch0101
* "gen"：建立新變數 age
* "n1ch0101"：原始變數，紀錄受訪者的實際年齡（單位為歲）



**---建立 female 變數：是否為女性---

gen female = n1ch0104 == 2
* "gen"：建立新變數 female
* 當 n1ch0104 等於 2 時，代表受訪者為女性，female 設為 1；否則為 0（男性或未回答）



**---篩選分析樣本：僅保留 native-born 且有填寫性別與種族的 1–5 歲兒童---

drop if native == 0
* 移除非美國本土出生者（native = 0）

drop if missing(black)
* 移除種族為其他或未填答者（black 為遺漏值）

drop if missing(female)
* 移除未填寫性別的樣本（female 為遺漏值）

drop if age > 5
* 移除超過 5 歲的樣本，因為只有 1–5 歲兒童被問到疫苗接種問題



**---把整理好的資料存檔---

cd "$workdata"
* "cd"：切換到你設定的 workdata 資料夾，用來存放清理後的資料檔案

save "NHANESI_native.dta", replace
* "save"：將目前記憶體中的資料儲存為 NHANESI_native.dta
* "replace"：如果該檔案已經存在，就直接覆蓋



**---關閉 log file，完成此次程式執行紀錄---

log close
* "log close"：關閉目前開啟的 log file，將指令與輸出儲存完成
