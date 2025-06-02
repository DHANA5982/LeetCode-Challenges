from collections import defaultdict

n, m = map(int, input().split())

gr_A = [input().strip() for _ in range(n)]
gr_B = [input().strip() for _ in range(m)]

position = defaultdict(list)
for index, word in enumerate(gr_A):
    position[word].append(index+1)
    
for word in gr_B:
    if word in position:
        print(' '.join(map(str, position[word])))
    else:
        print(-1)