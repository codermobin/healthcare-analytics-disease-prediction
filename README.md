# Healthcare Data Analysis & Disease Prediction

An end-to-end data analytics and predictive modeling project analyzing patient records, diagnostic history, and lab test results to identify key health risk factors and predict disease outcomes.

---

## 📌 Project Overview
This project processes relational healthcare records across patients, clinical diagnoses, and laboratory findings. Using SQL for data aggregation and Python for exploratory data analysis (EDA) and machine learning, it identifies high-risk patient segments and generates predictive risk scores.

---

## 📂 Dataset Architecture
The database schema consists of structured clinical datasets:
- **`patients.csv`**: Demographic profiles, age, gender, and base patient identifiers.
- **`diagnoses.csv`**: Historical medical diagnoses, conditions, and admission logs.
- **`medical_records.csv`**: Encounter details, vitals, and physician notes.
- **`test_results.csv`**: Laboratory panel metrics and clinical biomarkers.
- **`healthcare_model_scored_data.csv`**: Scored model outputs containing probability metrics and predicted classifications.

---

## 🛠️ Tech Stack & Tools
- **Database / Querying:** SQL (Relational joins, CTEs, window functions, data cleaning)
- **Language & Modeling:** Python (Pandas, NumPy, Scikit-Learn)
- **Visualization:** Matplotlib, Seaborn
- **Environment:** Jupyter Notebook

---

## 🚀 Workflow & Analysis Steps
1. **Data Cleaning & Integration (SQL):** Joined disparate clinical tables into analytical views, handled missing records, and filtered outlier lab results.
2. **Exploratory Data Analysis (EDA):** Uncovered correlations between specific biomarkers, demographic age brackets, and diagnostic trends.
3. **Feature Engineering:** Aggregated frequency of hospital encounters, chronic diagnosis indicators, and abnormal test flags.
4. **Model Training & Evaluation:** Trained classification models to predict disease onset; evaluated using Precision, Recall, and ROC-AUC.
5. **Scoring:** Exported batch predictions to `healthcare_model_scored_data.csv` for downstream reporting.

---

## 💻 How to Run Locally

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/](https://github.com/)<your-username>/healthcare-analytics-disease-prediction.git
   cd healthcare-analytics-disease-prediction
