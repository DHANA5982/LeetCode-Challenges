from typing import List

class Solution:
    def maxArea(self, height: List[int]) -> int:
        left = 0
        right = len(height) - 1
        max_area = 0

        while left < right:
            w = right - left
            h = min(height[left], height[right])
            current_area = w*h
            max_area = max(max_area, current_area)

            if height[left] < height[right]:
                left += 1
            else:
                right -=1
        return max_area

if __name__ == "__main__":
    data = input().strip().split()
    height = list(map(int, data))
    solution = Solution()
    result = solution.maxArea(height)
    print(result)