from typing import List

class Solution:
    def threeSumClosest(self, nums: List[int], target : int) -> int:
        nums.sort()
        closest = nums[0]+nums[1]+nums[2]
        n = len(nums)

        for i in range(n-2):
            left , right = i + 1, n - 1

            while left < right:
                current_sum = nums[i] + nums[left] + nums[right]

                if current_sum == target:
                    return current_sum

                if abs(current_sum - target) < abs(closest - target):
                    closest = current_sum

                if current_sum < target:
                    left += 1
                else:
                    right -= 1
        return closest
    
if __name__=='__main__':
    lt = list(map(int, input("Enter space seperated integers: ").split()))
    tr = int(input('Enter target number: '))
    solver = Solution()
    print(solver.threeSumClosest(lt, tr))