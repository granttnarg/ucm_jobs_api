# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version
  3.2.0

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- TODOS:

# Models:

<!--
# User (job applicant)

- unique email
- password -->

# Admin User

- we could perhaps the concept of admin user to make the job listing

# Job (Listing) - connected to Admin User.

- title
- hourly salary
- spoken language -> give room to expand this via gem or dedicated model
- shift dates

display on a job:

- Title, Total earnings, Spoken Languages

# Job Application - connected to job and users

# Shift - connected to job

- date
- job_id

## SEARCH functionality:

- On jobs by title and spoken language.

# an Admin User has many Jobs

# a user has many jobs_applications

# a job has many job_applications

# a job has many shifts

# languages. There is nothing mentioned about expanding languages.
