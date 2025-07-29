# Part 1 Python Basics
# 1. Factorial using loop
def factorial(n):
    result = 1
    for i in range(2, n+1):
        result *= i
    return result

num = int(input("Enter a number: "))
print(f"Factorial of {num} is {factorial(num)}")


# 2. List of tuples: Filter and average
def process_scores():
    num = int(input("How many students? "))
    student_scores = []

    for _ in range(num):
        name = input("Enter student name: ")
        score = int(input(f"Enter {name}'s score: "))
        student_scores.append((name, score))

    print("\nStudents scoring above 75:")
    for name, score in student_scores:
        if score > 75:
            print(name)

    avg = sum(score for _, score in student_scores) / len(student_scores)
    print(f"\nAverage Score: {avg:.2f}")

process_scores()


