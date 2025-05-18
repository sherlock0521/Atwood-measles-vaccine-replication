**整理 1952–1975 年美國各州的傳染病資料，計算每 10 萬人的發病率、定義疫苗前的平均麻疹盛行率、建立事件時間變數，並為後續 Event Study 分析合併與清理資料。**


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

log using "rates", replace
* "log using"：開始紀錄指令與輸出結果
* "rates"：指定 log 檔名稱（副檔名預設為 .smcl）
* "replace"：若該檔已存在，直接覆蓋



**---把 NHESII.dta 匯入 Stata---

use "$rawdata\case_counts_population.dta", clear
* "use"：讀資料進Stata
* "$rawdata\case_counts_population.dta"：從 rawdata 這個資料夾匯入 case_counts_population.dta
* "clear"：如果 Stata 裡已經有資料，先清除



**---保留分析所需的變數---

keep population state statefip bpl_region4 bpl_region9 year measles
* "keep"：只保留指定的變數，其餘全部刪除
* "population state statefip bpl_region4 bpl_region9 year measles"：保留人口數、州名、州FIPS碼、地區分類、年份、麻疹發病率等欄位



**---將資料由長格式轉為寬格式---

reshape wide population measles, i(state) j(year)
* "reshape wide"：將資料由長格式（每年一列）轉為寬格式（每州一列，多個年度欄位）
* "population measles"：要轉成寬格式的變數，會變成 population1952、measles1952 等欄位
* "i(state)"：指定每一列的單位是州（state）
* "j(year)"：依年份將變數展開成多個欄位



**---依年份計算每 10 萬人的麻疹發病率---

*generate measles rate by year
local i = 1952 
* "local i = 1952"：設定區域變數 i，初始值為 1952，作為迴圈的起始年份

while `i' <= 1975 {
    * "while `i' <= 1975"：當 i 小於等於 1975 時，執行以下指令（1952 到 1975 共 24 年）

    gen measles_rate_`i'=((measles`i')/population`i')*100000
    * "gen measles_rate_`i' = ..."：產生一個新的變數 measles_rate_年份
    * "measles`i'"：表示麻疹發病人數的欄位（例如 measles1952）
    * "population`i'"：表示當年人口數的欄位（例如 population1952）
    * "*100000"：將每人發病率轉為每 10 萬人的標準化指標

    label variable measles_rate_`i' "measles rate in `i' per 100,000"
    * "label variable"：為新變數加上標籤，說明這是每十萬人的麻疹發病率

    local i = `i' + 1 
    * "local i = `i' + 1"：讓 i 每次增加 1，進入下一年的計算
}



**---計算疫苗問世前（1963 年前）的平均麻疹發病率---

gen avg_2yr_measles_rate = (measles_rate_1962 + measles_rate_1963)/2
* "gen"：建立新變數 avg_2yr_measles_rate
* "(measles_rate_1962 + measles_rate_1963)/2"：取 1962 和 1963 兩年的麻疹發病率平均

gen avg_3yr_measles_rate = (measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/3
* 建立 3 年期平均發病率（1961~1963）

gen avg_4yr_measles_rate = (measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/4
* 建立 4 年期平均發病率（1960~1963）

gen avg_5yr_measles_rate = (measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/5
* 建立 5 年期平均發病率（1959~1963）

gen avg_6yr_measles_rate = (measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/6
* 建立 6 年期平均發病率（1958~1963）

gen avg_7yr_measles_rate = (measles_rate_1957 + measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/7
* 建立 7 年期平均發病率（1957~1963）

gen avg_8yr_measles_rate = (measles_rate_1956 + measles_rate_1957 + measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/8
* 建立 8 年期平均發病率（1956~1963）

gen avg_9yr_measles_rate = (measles_rate_1955 + measles_rate_1956 + measles_rate_1957 + measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/9
* 建立 9 年期平均發病率（1955~1963）

gen avg_10yr_measles_rate = (measles_rate_1954 + measles_rate_1955 + measles_rate_1956 + measles_rate_1957 + measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/10
* 建立 10 年期平均發病率（1954~1963）

gen avg_11yr_measles_rate = (measles_rate_1953 + measles_rate_1954 + measles_rate_1955 + measles_rate_1956 + measles_rate_1957 + measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/11
* 建立 11 年期平均發病率（1953~1963）

gen avg_12yr_measles_rate = (measles_rate_1952 + measles_rate_1953 + measles_rate_1954 + measles_rate_1955 + measles_rate_1956 + measles_rate_1957 + measles_rate_1958 + measles_rate_1959 + measles_rate_1960 + measles_rate_1961 + measles_rate_1962 + measles_rate_1963)/12
* 建立 12 年期平均發病率（1952~1963）



**---儲存轉換與處理後的資料檔---

cd "$workdata"
* "cd"：切換目前工作資料夾的路徑
* "$workdata"：代表儲存處理後資料的資料夾位置

save inc_rate.dta, replace
* "save"：儲存目前在記憶體中的資料為 inc_rate.dta
* "inc_rate.dta"：設定儲存的檔名為 inc_rate.dta
* "replace"：如果該檔案已經存在，就覆蓋原檔



**---準備 Event Study 分析所需的資料---

cd "$workdata"
* "cd"：切換目前工作資料夾路徑
* "$workdata"：進入 workdata 資料夾（儲存處理後資料的資料夾）

use inc_rate.dta, clear
* "use"：讀取剛剛儲存的 inc_rate.dta
* "clear"：如果 Stata 裡已有資料，先清除

keep state* avg_12yr_measles_rate
* "keep"：只保留以 state 開頭的欄位（例如 state, statefip）以及 avg_12yr_measles_rate
* "state*"：用萬用字元保留所有與 state 有關的變數
* "avg_12yr_measles_rate"：保留 1952~1963 年的麻疹平均發病率（用來定義 exposure）

cd "$workdata"
* 再次切回 workdata 資料夾

save inc_rate_ES.dta, replace
* "save"：將目前保留的欄位資料儲存為 inc_rate_ES.dta
* "replace"：如果 inc_rate_ES.dta 已存在就覆蓋

cd "$rawdata"
* 切換到 rawdata 資料夾

use case_counts_population.dta, clear
* 讀取原始的麻疹與人口數據（包含所有年份與疾病）
* "clear"：清除記憶體中原有資料

cd "$workdata"
* 切換回 workdata 資料夾（為了合併準備好的 avg_12yr_measles_rate 資料）

merge m:1 statefip using inc_rate_ES.dta
* "merge m:1"：進行多對一合併（case_counts_population 中有多列，每列對應一個州）
* "statefip"：使用州的 FIPS 編碼作為合併依據
* "using inc_rate_ES.dta"：合併的外部資料來源為剛儲存的 avg_12yr_measles_rate 檔案

drop _merge
* "drop"：合併後自動產生的 _merge 欄位刪除
* "_merge"：標示合併狀態的變數，不需要保留



**---計算每 10 萬人的麻疹發病率---

gen measles_rate = ((measles) / population) * 100000
* "gen"：建立新變數 measles_rate
* "measles / population"：計算每人麻疹發病率
* "* 100000"：換算成每 10 萬人的發病率

label variable measles_rate "measles rate in  per 100,000"
* "label variable"：給變數加上標籤，方便後續理解或輸出表格



**---計算每 10 萬人的百日咳發病率---

gen pertussis_rate = ((pertussis) / population) * 100000
* 建立 pertussis_rate 變數，計算百日咳發病率（每十萬人）

label variable pertussis_rate "pertussis rate in  per 100,000"
* 加上變數標籤，註明單位



**---計算每 10 萬人的水痘發病率---

gen cp_rate = ((chicken_pox) / population) * 100000
* 建立 cp_rate 變數，計算水痘發病率（每十萬人）

label variable cp_rate "chicken pox rate in  per 100,000"
* 加上變數標籤，註明單位



**---計算每 10 萬人的腮腺炎發病率---

gen mumps_rate = ((mumps) / population) * 100000
* 建立 mumps_rate 變數，計算腮腺炎發病率（每十萬人）

label variable mumps_rate "mumps rate in  per 100,000"
* 加上變數標籤，註明單位



**---計算每 10 萬人的德國麻疹發病率---

gen rubella_rate = ((rubella) / population) * 100000
* 建立 rubella_rate 變數，計算德國麻疹發病率（每十萬人）

label variable rubella_rate "rubella rate in  per 100,000"
* 加上變數標籤，註明單位



**---建立事件研究（Event Study）所需的州與時間虛擬變數---

xi i.statefip
* "xi"：讓 Stata 自動建立虛擬變數（dummy variables）
* "i.statefip"：針對州（statefip）建立一組虛擬變數（例如 _Istatefip_01、_Istatefip_02...）

gen exp = year - 1964
* "gen"：建立新變數 exp，代表事件時間（相對於基準年 1964 年）
* "year - 1964"：例如 1965 年變成 1，1963 年變成 -1

recode exp (. = -1) (-1000/-6 = -6) (11/1000 = 11)
* "recode"：重編變數值
* ". = -1"：將缺漏值改成 -1（代表 omitted base group）
* "(-1000/-6 = -6)"：所有早於 -6 的年份都設為 -6（合併成 event time -6）
* "(11/1000 = 11)"：所有大於 10 的年份都設為 11（合併成 event time 11）

char exp[omit] -1
* "char exp[omit] -1"：指定 -1 為要省略的基準類別（Stata 在回歸時不會對 -1 計算係數）

xi i.exp, pref(_T)
* "xi"：產生事件時間的虛擬變數
* "i.exp"：針對事件時間（exp）產生 dummy 變數
* "pref(_T)"：產生的變數前綴為 _T，例如 _Texp_0, _Texp_1 等



**---刪除原始疾病發病數據，只保留發病率---

drop measles pertussis chicken_pox mumps rubella
* "drop"：刪除指定的變數
* "measles pertussis chicken_pox mumps rubella"：刪除這五種疾病的原始病例數欄位（只留下每十萬人發病率）

**---重新命名疾病發病率的變數，改成圖表用的格式---

rename pertussis_rate Pertussis
* "rename"：重新命名變數
* "pertussis_rate" 改名為 "Pertussis"

rename mumps_rate Mumps
* "mumps_rate" 改名為 "Mumps"

rename rubella_rate Rubella
* "rubella_rate" 改名為 "Rubella"

rename cp_rate ChickenPox
* "cp_rate" 改名為 "ChickenPox"

rename measles_rate Measles
* "measles_rate" 改名為 "Measles"



**---儲存為 Event Study 分析使用的最終版本資料---

cd "$workdata"
* "cd"：切換目前工作資料夾路徑
* "$workdata"：進入 workdata 資料夾

save inc_rate_ES.dta, replace
* "save"：儲存目前資料為 inc_rate_ES.dta
* "inc_rate_ES.dta"：檔名為 inc_rate_ES，表示為 Event Study 使用的版本
* "replace"：如果已存在同名檔案則覆蓋



**---對資料做 Winsorize 處理（避免極端值影響分析）---

cd "$workdata"
* "cd"：切換到儲存處理後資料的資料夾

use inc_rate_ES.dta, clear
* "use"：讀取先前處理完成的 Event Study 分析資料
* "clear"：清除目前記憶體中資料

rename Pertussis r_Pertussis
rename Mumps r_Mumps
rename Rubella r_Rubella
rename ChickenPox r_ChickenPox
* "rename"：先將疾病變數重新命名，加上 r_ 前綴，準備進行 winsorize 處理

winsor2 r_Pertussis r_Mumps r_Rubella r_ChickenPox
* "winsor2"：使用 winsor2 函數對資料進行 Winsorize 處理（預設去除上下 1% 極端值）
* winsorize：將極端值縮至臨界值，以減少離群值影響
* "_w"：winsor2 預設會產生新變數，變數名稱為原名加 _w，例如 r_Pertussis_w

rename r_Pertussis_w Pertussis
rename r_Mumps_w Mumps
rename r_Rubella_w Rubella
rename r_ChickenPox_w ChickenPox
* "rename"：將 winsorize 處理後的變數改回原本名稱（方便後續分析使用）

cd "$workdata"
* 切換回 workdata 資料夾，準備儲存處理後資料

save inc_rate_ES_winsor.dta, replace
* "save"：儲存 winsorize 處理後的資料為 inc_rate_ES_winsor.dta
* "replace"：若已有同名檔案則覆蓋



log close




