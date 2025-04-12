SELECT *
FROM (
    SELECT 
        course,
        instructor,
        COUNT(DISTINCT student_id) AS total_students,
        ROUND(AVG(avg_attendance_pct), 4) AS avg_attendance_pct,
        RANK() OVER (ORDER BY AVG(avg_attendance_pct) DESC) AS rnk
    FROM dw_student_course_optimized
    WHERE avg_attendance_pct IS NOT NULL
        AND program in ("Integrated Master of Technology CSE", "Integrated Master of Technology ECE", "Master of Technology CSE", "Master of Technology ECE")
        AND batch in ("2024-25 IMtech", "2024-25 IMtech ECE", "2023-28 iMtech", "2024-2026 CSE", "2024-2026 ECE")          
    GROUP BY course, instructor
) ranked_courses
WHERE rnk <= 15;



SELECT 
    program AS program_code_name,
    obtained_grade,
    COUNT(*) AS count_students,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY program), 2) AS percentage_within_program
FROM dw_student_course_optimized
WHERE obtained_grade IS NOT NULL 
    AND TRIM(obtained_grade) != ''
    AND program in ("Integrated Master of Technology CSE", "Integrated Master of Technology ECE", "Master of Technology CSE", "Master of Technology ECE")
    AND batch in ("2024-25 IMtech", "2024-25 IMtech ECE", "2023-28 iMtech", "2024-2026 CSE", "2024-2026 ECE")
GROUP BY program, obtained_grade
ORDER BY program, obtained_grade, percentage_within_program DESC;




WITH attendance_classification AS (
    SELECT
        student_id,
        student_name,
        course,
        obtained_grade,
        CASE 
            WHEN avg_attendance_pct >= 90 THEN '90-100%'
            WHEN avg_attendance_pct >= 80 THEN '80-89%'
            WHEN avg_attendance_pct >= 70 THEN '70-79%'
            WHEN avg_attendance_pct >= 60 THEN '60-69%'
            ELSE '<60%'
        END AS attendance_bucket
    FROM dw_student_course_optimized
    WHERE avg_attendance_pct IS NOT NULL 
        AND obtained_grade IS NOT NULL
        AND program in ("Integrated Master of Technology CSE", "Integrated Master of Technology ECE", "Master of Technology CSE", "Master of Technology ECE")
        AND batch in ("2024-25 IMtech", "2024-25 IMtech ECE", "2023-28 iMtech", "2024-2026 CSE", "2024-2026 ECE")
)
SELECT
    attendance_bucket,
    obtained_grade,
    COUNT(*) AS student_count
FROM attendance_classification
GROUP BY attendance_bucket, obtained_grade
ORDER BY attendance_bucket, obtained_grade;