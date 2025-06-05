class Solution:
    def fourSums(self, nums, target):
        nums.sort()
        quad = []
        n = len(nums)

        for i in range(n):
            if i > 0 and nums[i] == nums[i-1]:
                continue
            for j in range(i+1, n):
                if j > i+1 and nums[j] == nums[j-1]:
                    continue
                
                left = j + 1
                right = n - 1

                while left < right:
                    total = nums[i] + nums[j] + nums[left] + nums[right]

                    if total == target:
                        quad.append([nums[i], nums[j], nums[left], nums[right]])

                        while left < right and nums[left] == nums[left + 1]:
                            left += 1
                        while left < right and nums[right] == nums[right - 1]:
                            right -= 1
                        
                        left += 1
                        right -= 1

                    elif total < target:
                        left += 1
                    else: 
                        right -= 1
        return quad
    

if __name__ == '__main__':
    try:
        l_n = list(map(int, input('Enter space separated integers: ').split()))
        tar = int(input('Enter target number: '))
    except Exception as e:
        print(f"Error: {e}")
    solver = Solution()
    print(solver.fourSums(l_n, tar))