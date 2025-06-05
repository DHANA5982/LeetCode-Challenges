from typing import List

class Solution:
    def findWordsContaining(self, words: List[str], x: str) -> List[int]:
        return [index for index, word in enumerate(words) if x in word]

if __name__ == '__main__':
    word = input('Enter words seperated by space: ').split()
    search_term = input('Enter letter you want to find: ')
    solver = Solution()
    print(solver.findWordsContaining(word, search_term))