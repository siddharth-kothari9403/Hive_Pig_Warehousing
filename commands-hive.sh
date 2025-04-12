start-dfs.sh
start-yarn.sh

hdfs dfs -mkdir -p /user/hive/warehouse/mydata
hdfs dfs -put cleaned_courses.csv /user/hive/warehouse/mydata/
hdfs dfs -put Enrollment_Data.csv /user/hive/warehouse/mydata/
hdfs dfs -put GradeRosterReport.csv /user/hive/warehouse/mydata/

beeline -u jdbc:hive2:// -f ./delete_tables.hql
beeline -u jdbc:hive2:// -f ./setup_hive_tables.hql
beeline -u jdbc:hive2:// -f ./warehouse_creation.hql
beeline -u jdbc:hive2:// -f ./warehouse_creation_optimized.hql

beeline -u jdbc:hive2:// --outputformat=tsv2 -e "SELECT * FROM dw_student_course_summary" > dw_student_course_summary.tsv