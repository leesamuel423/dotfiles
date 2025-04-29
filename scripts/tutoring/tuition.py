import os
from dotenv import load_dotenv
from openai import OpenAI
import re

load_dotenv()

def process_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        lines = [line.strip() for line in content.split('#') if line.strip()]
        """
        0. Student Name
        1. Student Info
        2. Parent Contact Info (phone number or kakao)
        3. Current Month
        4. Archived
        """
        student_name = lines[0]
        student_info = lines[1]
        parent_contact = lines[2]
        current_month = lines[3]

        return student_name, student_info, parent_contact, current_month

def generate_message(name, info, month):
    OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

    client = OpenAI()

    # Prep GPT prompt
    prompt = f"""
    You are an assistant that helps generate personalized tutoring update messages to parents. Below is the student's information and a log of classes for the current month.

    Student Name: {name}
    Student Info: {info}

    The "Current Month" information contains the dates of classes, tuition charge, and a brief update for each class, separated by "|". 
    Your tasks are:
    1. Parse the "Current Month" information to extract the dates of the classes and calculate the total tuition cost.
    2. Summarize the updates provided for each class into a cohesive student progress report.

    Current Month: {month}

    The final message should follow this exact format:

    ```
    Hi! Hope you have been doing well~

    The tuition for the month of [MONTH] is $[TOTAL_TUITION]. ([LIST_OF_DATES])

    [UPDATE]

    As always, if you have any questions or concerns, please feel free to reach out!
    ```

    [UPDATE] should be a well-structured paragraph summarizing the student's progress based on the updates provided in the "Current Month" section.

    Make sure to keep the tone professional yet friendly and keep the message concise.
    """

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "You are a helpful assistant that creates personalized tutoring update messages based on provided information."},
            {"role": "user", "content": prompt}
        ]
    )

    full_message = response.choices[0].message.content

    # Ensure that full_message is not None
    if full_message:
        # Extract the content between the triple backticks using regex
        extracted_message = re.search(r'```(.*?)```', full_message, re.DOTALL)
        if extracted_message:
            return extracted_message.group(1).strip()
        else:
            return full_message.strip()
    else:
        return ""



def main():
    folder_path = "./tutoring/students"

    # Iterate through each file in folder
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            # Process file
            print(f"Processing file: {filename}")
            student_name, student_info, parent_contact, current_month = process_file(file_path)

            # Generate custom message
            message = generate_message(student_name, student_info, current_month)

            print("\n" + "-"*50 + "\n")  # Separator between messages
            print(f"Custom message for {student_name}:")
            print(message)
            print("\n" + "-"*50 + "\n")  # Separator between messages


if __name__ == "__main__":
    main()



"""
TODOs
- Add validation to check if month exists for student
    - aka check if month content exists
- Cron job
- Messaging
    - If Kakao option, provide message only

"""
