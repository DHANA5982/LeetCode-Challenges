# Basic definition function
def find_words_contain_char(words, letter):
    return [i for i, word in enumerate(words) if letter in word]

if __name__== '__main__':
    words = list(input('Enter words seperated by space: ').split())
    x = input('Enter letter you want to find: ')
    print(find_words_contain_char(words, x))

# Class method
from typing import List
class Solution:
    def findWordsContaining(self, words: List[str], x: str) -> List[int]:
        return [index for index, word in enumerate(words) if x in word]

if __name__ == '__main__':
    word = input('Enter words seperated by space: ').split()
    search_term = input('Enter letter you want to find: ')
    
    solver = Solution()
    result = solver.findWordsContaining(word, search_term)