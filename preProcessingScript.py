import pandas as pd
import re

# Load the CSV file
df = pd.read_csv("Course_Attendance.csv")  # replace with your actual filename

def clean_course_name(course):
    if pd.isna(course):
        return course  # handle NaN values gracefully

    # Remove prefix like "T1-24-25-"
    course = re.sub(r'^T1-\d{2}-\d{2}-', '', course)
    # Remove any trailing pattern like "(BT1-IMT1-CSE)"
    course = re.sub(r'\s*\([^)]*\)$', '', course)
    # Remove the trailing "[Meeting]"
    course = re.sub(r'\s*\[Meeting\]$', '', course)
    # Remove the trailing '-'
    course = re.sub(r'-$', '', course)
    # Replace the first '-' with ' / '
    course = re.sub(r'-', ' / ', course, count=1)

    return course.strip()

# Apply cleaning function to the 'Course' column
if 'Course' in df.columns:
    df['Course'] = df['Course'].apply(clean_course_name)
else:
    raise ValueError("The 'Course' column does not exist in the input CSV.")

# Save to a new CSV file
df.to_csv("cleaned_courses.csv", index=False)
