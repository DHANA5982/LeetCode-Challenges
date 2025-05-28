from typing import List

a = [1, 1, 2]

class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        if not nums:
            return 0
        k = 1
        for i in range(1, len(nums)):
            if nums[i] != nums[i-1]:
                nums[k] = nums[i]
                k += 1
        return k

if __name__=="__main__":
    solver = Solution()
    result = (solver.removeDuplicates(a))
    print(a[:result])