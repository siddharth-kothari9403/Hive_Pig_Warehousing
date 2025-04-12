start-dfs.sh
start-yarn.sh

hdfs dfs -mkdir -p /user/hive/warehouse/mydata
hdfs dfs -put ../cleaned_courses.csv /user/hive/warehouse/mydata/
hdfs dfs -put ../Enrollment_Data.csv /user/hive/warehouse/mydata/
hdfs dfs -put ../GradeRosterReport.csv /user/hive/warehouse/mydata/

beeline -u jdbc:hive2:// -f ./Scripts/delete_tables.hql
beeline -u jdbc:hive2:// -f ./Scripts/setup_hive_tables.hql
beeline -u jdbc:hive2:// -f ./Scripts/warehouse_creation.hql
beeline -u jdbc:hive2:// -f ./Scripts/warehouse_creation_optimized.hql

beeline -u jdbc:hive2:// --outputformat=tsv2 -e "SELECT * FROM dw_student_course_summary" > dw_student_course_summary.tsv