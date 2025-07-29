# Part 5 Enrichment with NumPy
# 7. Generate an array of 20 random student scores between 35 and 100 using NumPy
import numpy as np
import pandas as pd

scores = np.random.randint(35, 101, size=20)

print("Scores:", scores)

above_75 = np.sum(scores > 75)
mean = np.mean(scores)
std = np.std(scores)

print(f"Students scoring >75: {above_75}")
print(f"Mean: {mean:.2f}")
print(f"Standard Deviation: {std:.2f}")

df = pd.DataFrame({"Score": scores})
df.to_csv("scores.csv", index=False)
print("scores.csv saved.")
