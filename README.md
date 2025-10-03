# ResumeRanker

It's a website built using Flask, to rank student's resume based on the job description. The project uses the following parameters to evaluate the similarities between job description and resumes.

1. Internship
2. Hackathon
3. Coding platforms
4. Industry certificate
5. NPTEL/Coursera courses
6. Github repository
7. Real time Project experience
8. CGPA and no of arrears, minor degree
9. 10th and 12th grade score
10. Research experience/project and Industry sponsored project

Weights are assigned to each of the parameters based on the job description, with the help of Gemini Model.
The job description and resumes are then embedded into numerical vectors, based on semantic similarity and the above parameters.
Vector Search is performed to rank the resumes based on cosine similarity scores.
