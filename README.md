# Atwood Measles Vaccine Replication

This project replicates parts of the analysis from:

> **"The Long-Term Effects of Measles Vaccination on Earnings and Employment"**  
> Alicia Atwood (2021), *AEJ: Applied Economics*

The original replication files come from the author.  
This version runs the analysis step-by-step **without using `master.do`**.

---

## 📁 Folder Structure

├── README.md       # This file  
├── do/        # All Stata .do files  
├── rawdata/       # Original data files  
├── workdata/           # Cleaned data (output of cleaning scripts)  
├── pic/         # Tables and figures generated  
└── log/           # (Optional) Stata log files  

---

## ▶️ How to Use

### 1. Open Stata and set your working directory

cd "your/local/path/to/project"

### 2. Run data cleaning scripts

do do_file/rates.do  
do do_file/NHESII_cleaning.do  
do do_file/NHESIII_cleaning.do  
do do_file/NHANESI_cleaning.do  
do do_file/acs_cleaning.do  
do do_file/census_cleaning_false.do  

### 3. Run figure or table scripts

do do_file/Figure1.do  
do do_file/Figure2.do  
do do_file/Figure3.do  
do do_file/Figure4.do  

do do_file/Table1.do  
do do_file/Table2.do  
do do_file/Table3.do  
do do_file/Table4.do  
do do_file/Table5.do  

### 4. (Optional) Run appendix tables

do do_file/AppendixTable1.do  
do do_file/AppendixTable2.do  
do do_file/AppendixTable3.do  
do do_file/AppendixTable4.do  

All outputs will be saved into the `pic/` folder.

---

## ⚙️ Requirements

- **Stata 15** or later  
- Internet access (for installing user-written commands on first run)

The following packages are automatically installed when needed:
- `outreg2`
- `winsor2`
- `regsave`

---

## 📦 Data

All raw data files are publicly available and stored in the `raw_data/` folder.  
This includes:
- Infectious disease data from CDC MMWR reports  
- NHES, NHANES survey files  
- ACS and Census microdata from IPUMS  
- SEER population estimates  

The full list and links are provided in the original paper’s `README.pdf`.

---

## 🛑 Disclaimer

This repository is for **educational and replication purposes only**.  
All data and original code were created by **Alicia Atwood**.  
This simplified version is maintained for coursework and learning.
