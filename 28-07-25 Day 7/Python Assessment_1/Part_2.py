# Part- 2 Classes and Inheritance
# Question4- Cresting base class and derived class
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def display(self):
        print(f"Name: {self.name}, Age: {self.age}")

class Employee(Person):
    def __init__(self, name, age, employee_id, department):
        super().__init__(name, age)
        self.employee_id = employee_id
        self.department = department

    def display(self):
        super().display()
        print(f"Employee ID: {self.employee_id}, Department: {self.department}")

name = input("Enter name: ")
age = int(input("Enter age: "))
employee_id = input("Enter employee ID: ")
department = input("Enter department: ")

emp = Employee(name, age, employee_id, department)
emp.display()

# 5. Method overriding
class Vehicle:
    def drive(self):
        print("The vehicle is moving.")

class Car(Vehicle):
    def drive(self):
        print("The car is being driven smoothly.")

choice = input("Enter 'car' or 'vehicle': ").lower()
if choice == "car":
    obj = Car()
else:
    obj = Vehicle()

obj.drive()
