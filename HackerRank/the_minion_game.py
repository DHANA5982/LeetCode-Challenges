def minion_game(string):
    vowels = 'AEIOU'
    kevin_score = 0
    stuart_score = 0
    n = len(string)

    for i in range(n):
        if string[i] in vowels:
            kevin_score += n - i
        else:
            stuart_score += n - i

    if kevin_score > stuart_score:
        print('Kevin', kevin_score)
    elif kevin_score < stuart_score:
        print('Stuart', stuart_score)
    else:
        print('Draw')
          
if __name__ == '__main__':
    s = input()
    minion_game(s)