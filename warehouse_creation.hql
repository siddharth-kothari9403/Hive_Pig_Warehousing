CREATE TABLE IF NOT EXISTS dw_student_course_summary (
    student_id STRING,
    student_name STRING,
    email_id STRING,
    member_id STRING,
    program STRING,
    batch STRING,
    period STRING,
    course STRING,
    course_type STRING,
    course_variant STRING,
    instructor STRING,
    primary_faculty STRING,
    classes_attended INT,
    classes_absent INT,
    avg_attendance_pct FLOAT,
    course_credit FLOAT,
    obtained_grade STRING,
    out_of_grade STRING,
    exam_result STRING,
    admission_id STRING,
    admission_status STRING,
    student_status STRING,
    subject_code_name STRING,
    section STRING,
    academy_location STRING,
    load_timestamp TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

INSERT INTO TABLE dw_student_course_summary
SELECT 
    ed.student_id,
    ed.student_name,
    ca.email_id,
    ca.member_id,
    ed.program,
    ed.batch,
    ed.period,
    ed.course,
    ed.course_type,
    ed.course_variant,
    ca.instructor,
    ed.primary_faculty,
    ca.classes_attended,
    ca.classes_absent,
    ca.avg_attendance_pct,
    gr.course_credit,
    gr.obtained_grade,
    gr.out_of_grade,
    gr.exam_result,
    gr.admission_id,
    gr.admission_status,
    gr.student_status,
    gr.subject_code_name,
    gr.section,
    gr.academy_location,
    current_timestamp()
FROM enrollment_data ed
JOIN course_attendance ca 
    ON ed.student_id = ca.member_id AND ed.student_name = ca.name
JOIN grade_roster gr
    ON ed.student_id = gr.student_id AND ed.course = gr.subject_code_name AND ed.student_name = gr.student_name
WHERE 
    ed.student_id IS NOT NULL AND ed.course IS NOT NULL;

INSERT INTO TABLE error_logs
SELECT
    'enrollment_data' AS table_name,
    'student_id' AS error_column,
    concat_ws(',', 
        student_id,
        student_name,
        program,
        batch,
        period,
        course,
        course_type,
        course_variant,
        primary_faculty
    ) AS row_data,
    'Missing student_id' AS error_message,
    current_timestamp() AS load_time
FROM enrollment_data
WHERE student_id IS NULL;