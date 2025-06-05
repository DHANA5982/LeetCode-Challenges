class Solution:
    def TwoSum(self, nums: list[int], target: int) -> list[int]:
        first = {}
        for index, B in enumerate(nums):
            A = target - B
            if A in first:
                return [first[A], index]
            first[B] = index
        return None
    

if __name__=='__main__':
    nums = list(map(int, input('Enter Space Seperated Intergers: ').split()))
    target = int(input('Enter Targat Value to Check: '))
    solver = Solution()
    result = solver.TwoSum(nums = nums, target= target)
    print(result)