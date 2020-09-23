# A Choice Experiment Game for Intermediate Microeconomics

> Click on the "fork" button at the very top right of the page to create an independent copy of the repo within your own GitHub account. Alternatively, click on the green "clone or download" button just below that to download the repo to your local computer.

## Overview

This repo contains some templates for creating and executing a discrete choice experiment as a tool for teaching consumer theory. During the first couple of weeks in a typical Intermediate Microeconomics course, students are introduced to the concepts of consumer choice and preferences. But how do those relate to a demand curve? Using tired examples of goods that they can purchase at a store does a pretty poor job of mapping preferences to demand. The price of a soda from the store is just the price of the soda—if a person wants a soda at a given price, they will buy it (put yourself in the shoes of the student, preferences are still pretty foreign and closely related to having or not having money for something). Having students trace a demand curve for this type of "market" good is pretty boring (speaking from experience). Introducing the concept of "nonmarket" goods (i.e. things you cannot buy at the store) helps to abstract away from retail prices where people are simply facing given prices. Cue the discrete choice experiment! 

## Workflow

The general workflow goes as follows: 

- Introduce consumer theory and willingness to pay (WTP) curves
  - This should include derivation of marginal utility and marginal rates of substitution. Setting the stage for MWTP as the ratio of two preference parameters: $` \dfrac{\beta_{attribute}}{\beta_{cost}}`$
- Using the templates in this game: 
  - Assign an annual household income to students (a budget constraint that is not correlated with their current ramen budget)
  - Link students to the online choice experiment (I use Qualtrics, and the cleaning scripts are set up to clean data exported from Qualtrics)
  - Export and clean data
  - Run regressions that estimate MWTP
   - I do this in real time in class (it takes seconds to run) as it is also a good opportunity to introduce students to statistical software (after which many will come and ask for research assistant support, neat!) 

## Vitae



## Statements



## Cover Letter

This folder contains one cover letter template. I chose to use the same template for all applications (academic, LA schools, federal, postdocs, and industry). Inside of this template I typically had one paragraph that would be a foundation for all letters. I then had a block section for each type of institution/agency that the letter would be written to. I found this to work well for me and all 130+ applications I submitted. You might find otherwise.

Many people will use a single template for *all* letters. They would then loop through a database of job listings and simply have a script replace the necessary fields. I realize this brings the marginal cost of an application to near zero. I am not a fan of this type of approach to a job search. I catered my letters to each institution, including faculty or colleagues that I would like to work with or projects that I am particularly excited about. This made the application process much longer, but much more personal. It worked well for me and I knew that I was deeply interested in every application I submitted. Find what works for you: either a shotgun approach—apply to everything—or the more piecewise approach of applying to only the jobs you are excited about.

There is also varying advice on how long the cover letter should be. I went great lengths to make some letters a single page (one side of one page) and even went as far as making some 10pt font (*not* very kind to your reader, both ableist and ageist). I eventually became comfortable with two pages (two sides of one piece of paper), which allowed for both 12pt font and a more personalized letter to the committee. For most applications I would say two pages is more than fine. For some industry-type jobs or postdocs, you might keep it short, sweet, and direct. 

## Job Spreadsheet

This is a spreadsheet that I created to help me keep track of job postings, closing dates, letters, etc. It is pretty self-explanatory, but here are a few tips. There are four worksheets (Jobs, Postdocs, Responses, and Data). I chose to keep full-time positions separate from postdocs, just for bookkeeping purposes. I also kept a worksheets for the responses in case there was additional information that was requested, or about the date and time of the interview. This way I wasn't frantically searching through emails to find something important, or even worse, missing an interview all together. 

The `data (do not change)` worksheet is one that the other worksheets reference in their date column. This is how I color-code items that are approaching their deadline. The parameters can be changed. For example, if you want the entry to change to yellow when the due date is 7 days away, instead of the 14 as I have it set now, you would simply change cell A2 to `=TODAY()+7` instead of `=TODAY()+14`.  

## License

The software code contained within this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). The data and figures are made available under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) license.
