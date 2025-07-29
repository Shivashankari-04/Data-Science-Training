# Part_4 JSON Task- Data Manipulation
# 6. Add status based on stock
import json

with open("inventory.json", "r") as f:
    inventory = json.load(f)

for product in inventory:
    product["status"] = "In Stock" if product["stock"] > 0 else "Out of Stock"

with open("inventory_updated.json", "w") as f:
    json.dump(inventory, f, indent=2)

print("inventory_updated.json created.")
