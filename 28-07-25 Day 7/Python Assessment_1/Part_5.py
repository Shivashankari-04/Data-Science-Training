import json

with open("products.json", "r") as f:
    products = json.load(f)

for product in products:
    product["price"] = round(product["price"] * 1.10, 2)

with open("products_updated.json", "w") as f:
    json.dump(products, f, indent=2)

print("Updated prices saved in products_updated.json")
