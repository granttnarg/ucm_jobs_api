## Task Part 2: How Would You Implement AI?

- AI-powered job creation
  Automated title and requirement suggestions based on user profiles and market data

Feature:
I can imagine two ways this might be implemented in an useful way from a product point of view. When an admin user is typing a title for a job we would want to analyze their typed input in real time, to give back suggestions much like we do predictive text when googling. For example if someone was to type Ruby Programmer. You might see industry standard or popular suggests like "Senior Ruby on Rails Software Engineer", which might be helpful to keep the job inline with industry norms for jobs.

With regard to the requirements I don't see this being that useful without some kind larger starting point from the user input. Here I would suggest something more like, an admin user gives a list of bullet points they want for a job description, and AI is able to turn this into a more substantial and "professional" text description that could then be further edited by the user before being saved to the job entity.

Technology Required:

NLP models like OpenAI's GPT-4 could expand bullet points into detailed descriptions, while a BERT model would be better suited for real-time title suggestions. For a more specialized approach, we could train custom models on industry job data from sources like Glassdoor.

Implementation:

We would want a dedicated GET suggested_titles collection endpoint for the predictive text that would take a query parameter of a full or partial string. It would be up to the FE to deal with how often we send this (per key stroke for example, but that might also be expensive). Ideally here we get back a response with 3-5 suggestions that then were displayed and can then used as their title or further edited. In the background this endpoint would call a dedicated our Jobs:AI:TitleSuggestionService that would query a BERT model like Google Natural Language API/

For the job description expansion, we can extend our existing Jobs::Creator service, adding an AI enhancement step. Perhaps we would have a params flag [:ai_enhance] here where we can queue a background to query another Service Jobs::AI::EnhancementService, within the service we would manage different prompts that enhance the description in different ways depending on options and gives back a suggestion. That suggestions can then edited and saved to the job during the job creation process.

    - Frontend submits bullet points to your API via the job creation with ai_enhance tag
    - Backend starts a background job and returns a job ID, the Background triggers our AI service
    - Frontend polls a status endpoint to check when processing is complete.
    - When complete, frontend fetches the expanded description

- Salary recommendations based on market trends

Feature:

For salary recommendations, we would analyze market trends to suggest appropriate salary ranges based on the job title, required skills, location, and company size. This helps employers set competitive compensation while remaining attractive to candidates.

Technology Required:
A regression model (Random Forest or Gradient Boosting) would be most appropriate, trained on historical job data and integrated with salary APIs like PayScale or LinkedIn Talent Insights for market benchmarks.

Implementation:

Here we could implement a dedicated GET salary_recommendation collection endpoint, this would also point to a Jobs::AI::SalaryRecommendation Service that uses a regression model under the hood. If we had the budget we train our own regreesion model on something like Google Cloud ML Tables or AWS SageMaker with our own data or from public apis (Glassdoor for example.) We may also want to consider batch retraining of the model monthly to update the model with new data as our job data set grows to improve the suggestions.

- Personalized job search

AI-driven recommendations based on previous applications and user profile tags.

Feature:

This would provide students with personalized job recommendations based on their user profile with dedicated tags (perhaps we can also use these tags on jobs), application history, and behavior on the platform. The system would prioritize positions most relevant to each individual user in there user feed, perhaps giving a personalized default to their api/v1/jobs collection.

Implementation:
Implementing this would be an nice extension of our Jobs::Search Adaptor pattern. Here we could have a flag params[:personalized] and make sure to toggle a PersonalizedAdaptor (rather than our StandardAdaptor) in those use cases. Each user could have an AI profile model that has a build vector representation of their preferences (updated as a background, perhaps weekly or monthly). Jobs would be scored based on our user profile vector and could be ordered in terms of relevance.

Technology Required:
A hybrid recommendation system combining content-based filtering (matching job tags to user profiles tags) and collaborative filtering ("students who applied to these jobs also applied to..."). This could leverage our existing search adapter pattern with a new RecommendationAdapter implementation. Amazon Personlize or Algolia Advanced Search API are tech that leveraged here that makes use of vector-based searching. The recommendation vectors would be updated weekly in a background job, and retrained monthly to adapt to user behavior changes and new job data.

- Automated language translation for job postings

Feature:
This feature would automatically translate job postings into the user's preferred language, making jobs accessible regardless of the original language used.

Implementation:

We would integrate with a professional translation API such as DeepL, which provides superior quality translations compared to many alternatives, especially for European languages. Each job posting would be stored in its original language in the database, and translations would be generated:

- On-demand when a user requests the content in another language
- Proactively for common language pairs to reduce latency
- With caching to avoid repeated translation of the same content

We could also build our own glossary of technical terms and common translations which is seeded by DeepL, perhaps this is useful to translate common terminology.

Technology Required:
Integration with DeepL or Google Cloud Translation API, with special attention to maintaining technical terminology accuracy through a custom terminology database.

- Intelligent application filtering

AI-based skill matching: Does the candidate's profile match the job?

Feature:
This would analyze student profiles against job requirements to determine match quality, helping employers identify qualified candidates and students focus on suitable opportunities.

Implementation:
Here we could leverage a candidate matching API (using AI under the hood) like HireEZ API or Linkedin Recruiter API. Admin users might set a "acceptable" match score that candidates need to pass before getting a real world interview. Similarly to some of the suggestions above, we could trigger a background job once a user makes a job application.
This could then be processed using matching scores from the third parties APIs help. Perhaps then we might use an event driven architecture within our app, eg. if a job first stage AI evaluation is suggestful, we schedule an email to the company admin and start to schedule an interview, if it is not they candidate might get an automated email thanking them and saying they unfortunatley did not meet the requirements. These decisions (e.g., sending emails, scheduling interviews) could be modeled as events using Rails Event Store, allowing us to track application progress and decouple evaluation logic from user-facing flows.

Technology Required:
NLP techniques for extracting skills from both job descriptions and profiles, combined with semantic matching algorithms to identify related skills and calculate an overall match percentage.

Identification of missing qualifications with recommendations for upskilling

Feature:
For partial matches, the system would identify specific missing qualifications and suggest relevant learning resources to help students acquire these skills.

Implementation:
When a student views a job where they have a partial match (e.g., 60-80% of required skills), the system would:

- Identify the specific skills or qualifications they're missing.
- Rank these gaps by importance to the role
- Search a database of learning resources to find relevant upskilling opportunities (based on skill tags)
- Present personalized recommendations for courses, tutorials, or certifications

Technology Required:
Gap analysis algorithms paired with learning resource APIs (Coursera, Udemy) to recommend appropriate courses or tutorials for addressing specific skill gaps.
We would also manage a limited glossary of seeded "skills" (100-200 per industry) in our DB that our AI would have to use to match against to avoid similar skills being mismatched or duplicated.
