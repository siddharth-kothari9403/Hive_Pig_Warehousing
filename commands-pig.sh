hdfs dfs -mkdir /user/pig
hdfs dfs -put ./dw_student_course_summary.tsv /user/pig/dw_student_course_summary.tsv

pig -x mapreduce Pig/pig_rank_query.pig
pig -x mapreduce Pig/pig_window_query.pig
pig -x mapreduce Pig/pig_cte_query.pig