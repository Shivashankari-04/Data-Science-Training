# Part4- Data Cleaning and Transformation
# 8. Data Transformation
import pandas as pd
import numpy as np

df = pd.read_csv("students_cleaned.csv")

def get_status(score):
    if score >= 85:
        return "Distinction"
    elif 60 <= score < 85:
        return "Passed"
    else:
        return "Failed"

df['Status'] = df['Score'].apply(get_status)
df['Tax_ID'] = df['ID'].apply(lambda x: f"TAX-{int(x)}")

df.to_csv("students_transformed.csv", index=False)
print("students_transformed.csv created:")
print(df)
