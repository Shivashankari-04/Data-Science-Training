# part-1 Basics
# 1. Write a function is_prime(n) that returns True if n is a prime number, else False

def is_prime(n):
    if n <= 1:
        return False
    for i in range(2, int(n**0.5)+1):
        if n % i == 0:
            return False
    return True

num = int(input("Enter a number to check if it's prime: "))
if is_prime(num):
    print(f"{num} is a prime number.")
else:
    print(f"{num} is not a prime number.")

# Q2: Reverse string & check palindrome

def check_palindrome():
    s = input("Enter a string: ")
    reversed_s = s[::-1]
    print("Reversed:", reversed_s)
    if s == reversed_s:
        print("It's a palindrome!")
    else:
        print("Not a palindrome.")

check_palindrome()

# Q3: Remove duplicates, sort, second largest

def process_list():
    nums = input("Enter numbers separated by spaces: ")
    nums = list(map(int, nums.split()))

    unique_nums = list(set(nums))
    unique_nums.sort()
    print("Sorted without duplicates:", unique_nums)

    if len(unique_nums) >= 2:
        print("Second largest number:", unique_nums[-2])
    else:
        print("Not enough unique numbers.")
process_list()
