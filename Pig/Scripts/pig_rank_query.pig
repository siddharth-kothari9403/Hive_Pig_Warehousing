-- Load the data
student_data = LOAD '/user/pig/dw_student_course_summary.tsv'
  USING PigStorage('\t')
  AS (
    student_id:chararray,
    student_name:chararray,
    email_id:chararray,
    member_id:chararray,
    program:chararray,
    batch:chararray,
    period:chararray,
    course:chararray,
    course_type:chararray,
    course_variant:chararray,
    instructor:chararray,
    primary_faculty:chararray,
    classes_attended:int,
    classes_absent:int,
    avg_attendance_pct:float,
    course_credit:float,
    obtained_grade:chararray,
    out_of_grade:chararray,
    exam_result:chararray,
    admission_id:chararray,
    admission_status:chararray,
    student_status:chararray,
    subject_code_name:chararray,
    section:chararray,
    academy_location:chararray,
    load_timestamp:chararray 
  );

-- Filter out rows with NULL attendance
filtered = FILTER student_data BY avg_attendance_pct IS NOT NULL;

-- Group by course and instructor
grouped = GROUP filtered BY (course, instructor);

-- Aggregate: count distinct students, average attendance
aggregated = FOREACH grouped {
    unique_students = DISTINCT filtered.student_id;
    GENERATE
        group.course AS course,
        group.instructor AS instructor,
        COUNT(unique_students) AS total_students,
        AVG(filtered.avg_attendance_pct) AS avg_attendance_pct;
};


-- Order by descending avg_attendance_pct
sorted = ORDER aggregated BY avg_attendance_pct DESC;

-- Get top 15
top15 = LIMIT sorted 15;