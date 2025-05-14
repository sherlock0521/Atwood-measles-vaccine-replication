**---目標：估算 1963 年美國 6–12 歲兒童中，有多少人得過麻疹---



**---清除目前 Stata 記憶體中的資料。

clear



**---這類似於 R 中設定工作目錄，但我們是分別針對不同功能的資料夾設定路徑---

global do = "D:\中山學院\113-2\Methodology of empirical economic studies\Final_Project\data_code\do"
global log = "D:\中山學院\113-2\Methodology of empirical economic studies\Final_Project\data_code\log"
global rawdata = "D:\中山學院\113-2\Methodology of empirical economic studies\Final_Project\data_code\rawdata"
global workdata = "D:\中山學院\113-2\Methodology of empirical economic studies\Final_Project\data_code\workdata"
global pic = "D:\中山學院\113-2\Methodology of empirical economic studies\Final_Project\data_code\pic"
** global 是 Stata 中設定全域變數的指令，用於儲存資料夾路徑



**---把 NHESII.dta 匯入 Stata---

use "$rawdata\NHESII.dta", clear
* "use"：讀資料進Stata
* "$rawdata\NHESII.dta"：從 rawdata 這個資料夾匯入 NHESII.dta
* "clear"：如果 Stata 裡已經有資料，先清除



**---建立一個新變數 state_of_birth，它的值來自變數 h2id0115---

gen state_of_birth = h2id0115
* "gen"：建立一個新變數 
* h2id0115：受訪者的出生地編號，大多數狀況下，這個變數的值是 1 到 51（表示美國各州），
*           但對於一些人，值是 52–55，代表海外地區或無法歸類的特殊狀況（例如波多黎各、軍事基地、外國）


replace state_of_birth=14 if state_of_birth==52
replace state_of_birth=19 if state_of_birth==53
replace state_of_birth=21 if state_of_birth==54
replace state_of_birth=33 if state_of_birth==55
* "replace"：重新指定變數的值 
* 將編號 52 的人（海外出生）重新指定為 14
*        53                            19(Missouri)
*        54                            21(Maryland)
*        55                            33(New York) 
* 強制這些特殊區域歸類到美國本土的某個州，才能後續進行州層級的配對分析



**---建立 native 變數，判斷是否為美國本土出生---  

gen native = state_of_birth < 56
* "gen"：建立新變數
* "native = state_of_birth < 56"：如果出生州代碼小於 56，表示出生於美國本土，native 設為 1；否則為 0   


replace native=0 if missing(state_of_birth)
* "replace"：重新指定變數的值 
* Sets native = 0 if the state_of_birth value is missing



**---建立受訪年份 survey_year 變數---

tostring h2id0021, replace 
* "tostring"：將 h2id0021 轉為字串格式，才能擷取其中的年份
* "replace"：直接覆蓋原變數

gen survey_year = substr(h2id0021, -2, 2)
* "substr(x, -2, 2)"：從字串最後兩位擷取字元，例如「63」
* 建立 survey_year 變數，代表受訪年份的末兩位數

destring survey_year, replace
* "destring"：將字串型的 survey_year 轉為數值型態
* "replace"：直接覆蓋原本的 survey_year



**---建立 measles 變數：是否得過麻疹---

gen measles = h2id0205 == 1
* "gen"：建立新變數 measles，當受訪者回答「得過麻疹」時設為 1，否則為 0

replace measles = . if h2id0205 == 3
* 將回答「不知道是否得過麻疹」的樣本設為遺漏值

replace measles = . if h2id0205 == .
* 將未作答（缺值）的樣本設為遺漏值



**---建立 female 變數：是否為女性---

gen female = h2id0035 > 3
* "gen"：建立新變數 female
* 當 h2id0035 編碼大於 3 時，代表受訪者為女性，female 設為 1，否則為 0



**---建立 black 變數：是否為黑人---

gen black = h2id0034 == 2
* "gen"：建立新變數 black
* 當 h2id0034 等於 2 時，代表受訪者為黑人，black 設為 1，否則為 0

replace black = . if h2id0034 == 3
* 當 h2id0034 為 3（其他/不明種族）時，將 black 設為遺漏值，排除不清楚的分類



**---保留可分析樣本：native-born 且有填性別與種族---

drop if native == 0
* 移除非美國本土出生者（native = 0）

drop if missing(black)
* 移除種族為其他/未回應者（black 是遺漏值）

drop if missing(female)
* 移除未回應性別的樣本（female 是遺漏值）



**---把整理好的資料存檔---

cd "$workdata"
save "NHESII_cleaning.dta" , replace
** cd "$workdata"：切換到你設定的 workdata 資料夾
** save "NHESII_native.dta"：儲存成這個檔名
** replace：如果這個檔案已經存在，就自動覆蓋



log close


***---不確定執行到哪裡 跑這個---
clear all
set more off










 