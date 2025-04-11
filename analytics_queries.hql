SELECT 
    course,
    instructor,
    COUNT(DISTINCT student_id) AS total_students,
    ROUND(AVG(avg_attendance_pct), 4) AS avg_attendance_pct
FROM dw_student_course_summary
WHERE avg_attendance_pct IS NOT NULL
GROUP BY course, instructor
ORDER BY avg_attendance_pct DESC
LIMIT 15;
