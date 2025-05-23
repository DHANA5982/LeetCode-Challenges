import math

def polar_cordinates(z):
    x = int(z.real)
    y = int(z.imag)
    r = abs(math.sqrt((x**2 + y**2)))
    p = math.atan2(y, x)
    print(r, '\n', p)


z = complex(input())
polar_cordinates(z)
