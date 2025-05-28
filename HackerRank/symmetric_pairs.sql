SELECT DISTINCT f1.X, f1.Y 
FROM Functions f1 
JOIN Functions f2 
    ON f1.X = f2.Y AND f2.X = f1.Y 
WHERE f1.X < f1.Y
UNION
SELECT X,Y 
FROM Functions 
GROUP BY X,Y 
HAVING COUNT(*) > 1 
ORDER BY X;