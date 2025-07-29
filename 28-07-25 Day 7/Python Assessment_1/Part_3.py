# Part 3 CSV and JSON handling
# 6. Cleaning CSV
import pandas as pd
df = pd.read_csv("students.csv")

avg_age = df['Age'].dropna().astype(float).mean()
df['Age'] = df['Age'].fillna(avg_age)

df['Score'] = df['Score'].fillna(0)

df.to_csv("students_cleaned.csv", index=False)
print("Cleaned data saved to students_cleaned.csv")

# 7. Convert to JSON
import pandas as pd

df = pd.read_csv("students_cleaned.csv")

df.to_json("students.json", orient="records", indent=2)
print("Saved JSON as students.json")


