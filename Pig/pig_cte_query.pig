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

-- Filter records where attendance and grade are present
filtered = FILTER student_data BY avg_attendance_pct IS NOT NULL AND obtained_grade IS NOT NULL;

-- Bucket attendance
bucketed = FOREACH filtered GENERATE
    student_id,
    student_name,
    course,
    obtained_grade,
    ( 
      (avg_attendance_pct >= 90.0 ? '90-100%' :
       (avg_attendance_pct >= 80.0 ? '80-89%' :
       (avg_attendance_pct >= 70.0 ? '70-79%' :
       (avg_attendance_pct >= 60.0 ? '60-69%' : '<60%')))) 
    ) AS attendance_bucket;

-- Group by attendance_bucket and grade
grouped = GROUP bucketed BY (attendance_bucket, obtained_grade);

-- Count students in each group
counts = FOREACH grouped GENERATE
    group.attendance_bucket AS attendance_bucket,
    group.obtained_grade AS obtained_grade,
    COUNT(bucketed) AS student_count;

-- Sort by attendance_bucket and obtained_grade
sorted = ORDER counts BY attendance_bucket, obtained_grade;

-- Output the results
DUMP sorted;
