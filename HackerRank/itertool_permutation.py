# To use the Permutation function
from itertools import permutations

# Giving two space seperated inputs
# A is to capture the first string value
# k is to capture the second integer value
A, k = input().split()

# Performing the permutation operation using given inputs
# Unpacking tuple values (i) and join them together
# Adding to the list called a
a = ["".join(i) for i in permutations(A, int(k))]

# Printing the sorted elements one by one.
for i in (sorted(a)):
    print(i)