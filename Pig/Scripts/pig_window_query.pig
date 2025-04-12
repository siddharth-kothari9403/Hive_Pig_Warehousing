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

-- Filter rows with non-null and non-empty grades
filtered = FILTER student_data BY 
    obtained_grade IS NOT NULL AND 
    TRIM(obtained_grade) != '';

-- Group by program and grade to count students per grade in each program
grouped_program_grade = GROUP filtered BY (program, obtained_grade);
grade_counts = FOREACH grouped_program_grade GENERATE
    group.program AS program,
    group.obtained_grade AS obtained_grade,
    COUNT(filtered) AS count_students;

-- Group again by program to get total students per program
grouped_program = GROUP grade_counts BY program;
program_totals = FOREACH grouped_program GENERATE
    group AS program,
    SUM(grade_counts.count_students) AS total_students;

-- Join counts with totals on program
joined_data = JOIN grade_counts BY program, program_totals BY program;

-- Compute percentage
with_percentage = FOREACH joined_data GENERATE
    grade_counts::program AS program_code_name,
    grade_counts::obtained_grade AS obtained_grade,
    grade_counts::count_students AS count_students,
    ((100.0 * grade_counts::count_students) / (program_totals::total_students)) AS percentage_within_program;

-- Sort by program, grade, and descending percentage
sorted = ORDER with_percentage BY program_code_name, obtained_grade, percentage_within_program DESC;