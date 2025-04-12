CREATE TABLE dw_student_course_optimized (
  student_id STRING,
  student_name STRING,
  email_id STRING,
  member_id STRING,
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
PARTITIONED BY (program STRING, batch STRING, period STRING)
CLUSTERED BY (student_id) INTO 8 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

SET hive.enforce.bucketing = true;
SET hive.enforce.sorting = true;

INSERT INTO TABLE dw_student_course_optimized
PARTITION (program, batch, period)
SELECT student_id, student_name, email_id, member_id,
       course, course_type, course_variant, instructor, primary_faculty,
       classes_attended, classes_absent, avg_attendance_pct,
       course_credit, obtained_grade, out_of_grade, exam_result,
       admission_id, admission_status, student_status,
       subject_code_name, section, academy_location, load_timestamp,
       program, batch, period
FROM dw_student_course_summary;
