hdfs dfs -mkdir /user/pig
hdfs dfs -put ./dw_student_course_summary.tsv /user/pig/dw_student_course_summary.tsv

pig -x mapreduce Pig/pig_rank_query_output.txt