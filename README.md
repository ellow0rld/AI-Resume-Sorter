# ResumeRanker

It's a website built using Flask, to rank student's resume based on the job description. The project uses the parameters given by the user to evaluate the similarities between job description and resumes. Weights are assigned to each of the parameters based on the job description, with the help of Gemini Model.

# Similarity Score Calculation
This project ranks resumes based on a job description using semantic similarity and keyword matching. Resumes and the job description are preprocessed to remove noise, irrelevant words, and standardize text, then converted into SBERT embeddings. Key skills and requirements are extracted from the job description using Gemini-2.0-Flash and dynamically weighted. Each resume is scored by combining a Context-Based Score (CBS) (cosine similarity between resume and job description embeddings) and a Keyword-Based Score (KBS):

KBS = (Σ Matchᵢ × Weightᵢ) ÷ (Σ Weightᵢ)
Total Score = α × KBS + (1 - α) × CBS, α = 0.4

Resumes are ranked by total score, with matching keywords highlighted, and ties broken by the number of activities (projects, internships, research).

<img width="2343" height="1090" alt="Screenshot 2025-04-23 190720" src="https://github.com/user-attachments/assets/1692d1af-d4c1-47c6-9395-ec5747cb5043" />


# Highlighted Resume
<img width="789" height="1020" alt="Screenshot 2025-04-23 192535" src="https://github.com/user-attachments/assets/525e1a73-5b3b-49ae-a66a-48cbdaaaa079" />

# Output
<img width="3300" height="1663" alt="Screenshot 2025-04-23 192514" src="https://github.com/user-attachments/assets/5a7898c5-46b3-4ee7-80b4-d6ae406a510a" />
