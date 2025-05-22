def merge_the_tools(string, k):
    # your code goes here
    n = len(string)
    for i in range(int(n/k)):
        a = (string[i*k: i*k+k])
        first_occur = ''
        my_set = set()
        for j in a:
            if j not in my_set:
                my_set.add(j)
                first_occur += j
        print(first_occur)

if __name__ == '__main__':
    string, k = input(), int(input())
    merge_the_tools(string, k)