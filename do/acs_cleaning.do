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



**---紀錄程式執行過程---

cd "$log"
* "cd"：切換目前工作資料夾到你事先設定的 logs 資料夾

log using "acs_cleaning", replace
* "log using"：開始紀錄指令與輸出結果
* "acs_cleaning"：指定 log 檔名稱（副檔名預設為 .smcl）
* "replace"：若該檔已存在，直接覆蓋



**---把 longrun_20002017_acs.dta 匯入 Stata---

use "$rawdata\longrun_20002017_acs.dta", clear
* "use"：讀資料進Stata
* "$rawdata\longrun_20002017_acs.dta"：從 rawdata 這個資料夾匯入 longrun_20002017_acs.dta
* "clear"：如果 Stata 裡已經有資料，先清除



************************************************
*---樣本篩選條件（Inclusion Criteria）---
************************************************

*---保留年齡在 25 到 60 歲之間的樣本---

keep if age > 25
keep if age < 60
* 只保留年齡介於 26 到 59 歲之間的受訪者（排除太年輕或太年長者）

*---保留出生於美國本土的樣本---

generate native = bpl < 57
* "bpl"：出生地變數，代碼 1–56 表示美國本土，native = 1 表示 native-born

replace native = . if bpl == .
* 如果出生地缺值，native 設為 missing

keep if native == 1
* 僅保留 native-born 样本

*---保留種族為白人或黑人者---

gen white = race == 1
gen black = race == 2
gen other = race > 2
* 根據 IPUMS 的 ACS 種族編碼：
* 1 = White，2 = Black，其他值為其他種族（亞裔、混血等）

gen blackwhite = 1 if white == 1 | black == 1
* 建立 blackwhite 指標變數，僅標記黑人或白人樣本為 1

keep if blackwhite == 1
* 僅保留黑人或白人觀察值，其餘種族樣本移除

