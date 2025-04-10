CREATE TABLE IF NOT EXISTS course_attendance (
    course STRING,
    instructor STRING,
    name STRING,
    email_id STRING,
    member_id STRING,
    classes_attended INT,
    classes_absent INT,
    avg_attendance_pct FLOAT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS enrollment_data (
    serial_no INT,
    course STRING,
    status STRING,
    course_type STRING,
    course_variant STRING,
    academia_lms STRING,
    student_id STRING,
    student_name STRING,
    program STRING,
    batch STRING,
    period STRING,
    enrollment_date STRING,
    primary_faculty STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS grade_roster (
    academy_location STRING,
    student_id STRING,
    student_status STRING,
    admission_id STRING,
    admission_status STRING,
    student_name STRING,
    program_code_name STRING,
    batch STRING,
    period STRING,
    subject_code_name STRING,
    course_type STRING,
    section STRING,
    faculty_name STRING,
    course_credit FLOAT,
    obtained_grade STRING,
    out_of_grade STRING,
    exam_result STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS error_logs (
    source_table STRING,
    column_name STRING,
    record STRING,
    error_type STRING,
    load_timestamp TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/hive/warehouse/mydata/Course_Attendance.csv' 
INTO TABLE course_attendance;

LOAD DATA INPATH '/user/hive/warehouse/mydata/Enrollment_Data.csv' 
INTO TABLE enrollment_data;

LOAD DATA INPATH '/user/hive/warehouse/mydata/GradeRosterReport.csv' 
INTO TABLE grade_roster;

INSERT INTO TABLE error_logs
SELECT
  'course_attendance',
  'member_id',
  CONCAT(course, ',', instructor, ',', name, ',', email_id, ',', member_id, ',', classes_attended, ',', classes_absent, ',', avg_attendance_pct),
  'Missing member_id',
  current_timestamp()
FROM course_attendance
WHERE member_id IS NULL OR TRIM(member_id) = '';

INSERT INTO TABLE error_logs
SELECT
  'enrollment_data',
  'student_id',
  CONCAT(serial_no, ',', course, ',', status, ',', course_type, ',', course_variant, ',', academia_lms, ',', student_id, ',', student_name, ',', program, ',', batch, ',', period, ',', enrollment_date, ',', primary_faculty),
  'Missing student_id',
  current_timestamp()
FROM enrollment_data
WHERE student_id IS NULL OR TRIM(student_id) = '';

INSERT INTO TABLE error_logs
SELECT
  'grade_roster',
  'student_id',
  CONCAT(academy_location, ',', student_id, ',', student_status, ',', admission_id, ',', admission_status, ',', student_name, ',', program_code_name, ',', batch, ',', period, ',', subject_code_name, ',', course_type, ',', section, ',', faculty_name, ',', course_credit, ',', obtained_grade, ',', out_of_grade, ',', exam_result),
  'Missing student_id',
  current_timestamp()
FROM grade_roster
WHERE student_id IS NULL OR TRIM(student_id) = '';
