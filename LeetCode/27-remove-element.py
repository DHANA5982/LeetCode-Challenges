from typing import List

class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        k = 0 
        for j in nums:
            if val != j:
                nums[k] = j
                k += 1
        return k

if __name__=='__main__':
    try:
        num = list(map(int, input('Enter space seperated integers: ').split()))
        val = int(input('Enter the removing element: '))
    except Exception as e:
        print(f'Error:{e}')
    
    solver = Solution()
    print(num[:solver.removeElement(num, val)])