WITH ordered_tasks AS (
    SELECT 
        Task_ID, 
        Start_Date, 
        End_DatE,
        ROW_NUMBER() OVER (ORDER BY Start_Date) AS rn
    FROM Projects
),
grouped_projects AS (
    SELECT *,
           DATEADD(DAY, -rn, Start_Date) AS group_key
    FROM ordered_tasks
),
final_projects AS (
    SELECT 
        MIN(Start_Date) AS project_start,
        MAX(End_Date) AS project_end,
        DATEDIFF(DAY, MIN(Start_Date), Max(End_Date)) AS duration
    FROM grouped_projects
    GROUP BY group_key
)
SELECT project_start, project_end
FROM final_projects
ORDER BY duration, project_start;