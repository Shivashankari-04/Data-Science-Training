# Part 2 Classess and inheritance
# 3. BankAccount with deposit, withdraw, exception
# python
# Copy code
class BankAccount:
    def __init__(self, holder_name, balance):
        self.holder_name = holder_name
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount
        print(f"Deposited ₹{amount}. New balance: ₹{self.balance}")

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError("Insufficient balance!")
        self.balance -= amount
        print(f"Withdrew ₹{amount}. New balance: ₹{self.balance}")

name = input("Enter account holder name: ")
balance = float(input("Enter initial balance: "))
acc = BankAccount(name, balance)

action = input("Do you want to deposit or withdraw? ").lower()
amount = float(input("Enter amount: "))

try:
    if action == "deposit":
        acc.deposit(amount)
    elif action == "withdraw":
        acc.withdraw(amount)
    else:
        print("Invalid action.")
except ValueError as ve:
    print("Error:", ve)


# 4. SavingsAccount inherits from BankAccount
class SavingsAccount(BankAccount):
    def __init__(self, holder_name, balance, interest_rate):
        super().__init__(holder_name, balance)
        self.interest_rate = interest_rate

    def apply_interest(self):
        interest = self.balance * (self.interest_rate / 100)
        self.balance += interest
        print(f"Interest ₹{interest:.2f} applied. New balance: ₹{self.balance:.2f}")

name = input("Enter name for savings account: ")
balance = float(input("Enter starting balance: "))
rate = float(input("Enter interest rate (%): "))

s_acc = SavingsAccount(name, balance, rate)
s_acc.apply_interest()

