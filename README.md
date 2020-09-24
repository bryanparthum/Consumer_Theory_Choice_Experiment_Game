# A Choice Experiment Game for Intermediate Microeconomics

> Click on the "fork" button at the very top right of the page to create an independent copy of the repo within your own GitHub account. Alternatively, click on the green "clone or download" button just below that to download the repo to your local computer.

## Overview

This repo contains some templates for creating and executing a discrete choice experiment as a tool for teaching consumer theory. During the first couple of weeks in a typical Intermediate Microeconomics course, students are introduced to the concepts of consumer choice and preferences. Leaving students asking: "but how do these concepts relate to a demand curve? 

Using tired examples of goods that they can purchase at a store does a pretty poor job of mapping preferences to demand. The price of a soda from the store is just the price of the soda—if a person wants a soda at a given price, they will buy it (put yourself in the shoes of the student, preferences are still pretty foreign and closely related to having or not having money for something). Having students trace a demand curve for this type of "market" good is pretty boring. To abstract away from retail prices (where people simply face a given price) I like to introducing the concept of "nonmarket" goods (i.e. things you cannot buy at the store). Cue the discrete choice experiment! 

## Learning Outcomes

1. Consumer theory: choices, preferences, transitivity
2. Marginal utility and marginal rates of substitution
4. Demand curves and WTP distributions across populations

## Workflow

The general workflow goes as follows: 

- Introduce consumer theory and willingness to pay (WTP) curves
  - This should include the derivation of marginal utility and marginal rates of substitution. Setting the stage for MWTP as the ratio of two preference parameters: <img src="https://latex.codecogs.com/gif.latex?MU_{x}/MU_{\$}" /> 
- Using the templates in this game: 
  - Randomly assign an annual household income to students (a budget constraint that is not correlated with their current ramen budget)
  - Link students to the online choice experiment (I use Qualtrics, but any online survey platform will work. However, the generating and cleaning scripts provided here are set up to integrate into Qualtrics)
  - Export and clean data
  - Run regressions that estimate MWTP (and plot)
    - I do this in real time in class (it takes seconds to run) as it is also a good opportunity to introduce students to statistical software (after which many will come and ask for research assistantships, neat!) 

## Generate Student Incomes 

Generating annual household incomes for your students can be done using the Stata script `1_generate_incomes.do`. Depending on which learning management system you use for your class (Blackboard, etc.), you might need to import your roster differently. The example roster `store\student_roster.xlsx` provided here is a typical roster exported from Blackboard, but adjust as needed. 

This script randomly assigns incomes to students using a modified beta distribution (trying to mimic real-world income distributions, which makes for a fun side conversation about how income is not randomly assigned in the real world). The income assignment will result in some students being really rich, and other being really poor (it is also fun to have them guess the moments of income distribution). Their choices (and subsequent WTP) should reflect this. The script also generates the necessary contact information (email) and external data (income) that will be read by Qualtrics. 

- Input: `student_roster.xlsx`
- Output: `student_incomes.csv`

## The Online Choice Experiement

Setting up the online choice experiment can be done at any time; however, when using Qualtrics, the `student_incomes.csv` file (the output of `1_generate_incomes.do`) will be an input for the online Qualtrics survey. The ordering and wording of the questions is outlined in `2_survey_questions.docx`. The introduction and post-survey questions are simply plain text. The choice questions themselves are in HTML and will call the image of the choice question in real time from any designated server. For this example, I use AWS S3 as the host for the image, although this can be done using any hosting service (although AWS is fast and reliable). I have also included the file `survey.docx` where you can make changes to any piece of the survey, and export the pages of the revised survey as images. In turn, piping the new images (your new choice questions) into the Qualtrics survey. 

Example survey link: https://tinyurl.com/y367ot4v

One thing to note is that the choice experiment provided in this example is not an 'efficient' design. Meaning, the levels of the attributes are not orthogonal. This is intentional. I have incorporated two concepts of consumer theory into the choice experiment: 1) transitivity, and 2) strictly dominated alternatives. This allows the instructor to test if students were paying attention (and call the ones out who clearly were not... just kidding, maybe), but also to reiterate axioms of choice and how they can be observed in the real world. More on this below. 

### Choice Questions

In the document `2_survey_questions.docx` I have provided text that you can copy and paste into your own Qualtrics survey. In the first intructions section, you will notice that the `ExternalDataReference` is being piped in from the spreadsheet that you upload to Qualtrics. The spreadsheet that you generated in the previous step (`student_incomes.csv`) is uploaded as the contact list (distribution list) for Qualtrics and will send students an email inviting them to take the survey. At some point I will walk you all through how to do this, but it is pretty straightforward, just follow the instructions on Qualtrics for uploading an existing contact list.

### Transitivity

There are three scenarios in the survey that are the same across choice cards. This allows us to rank preferences such that <img src="https://latex.codecogs.com/gif.latex?A\succsim%20B\succsim%20C" />. These particular bundles are not strictly dominated by other bundles and any combination of preference relations could be perfectly rational. However, we can test the students choices against the weak axiom of revealed preferences. This doesn't really matter other than to say something along the lines of "seven student's chocies were not consistent with preferences exhibiting the property of transitivity."

Moreover: 

  - Preference bundle <img src="https://latex.codecogs.com/gif.latex?A="/> Scenario A on Choice Card 1 and Scenario B on Choice Card 2
  - Preference bundle <img src="https://latex.codecogs.com/gif.latex?B="/> Scenario B on Choice Card 1 and Scenario A on Choice Card 4
  - Preference bundle <img src="https://latex.codecogs.com/gif.latex?C="/> Scenario A on Choice Card 2 and Scenario B on Choice Card 4

 ### Strictly Dominated Alternatives

Choice card number 3 includes the choice between Scenario A and Scenario B, where Scenario B is strictly dominated by Scenario A. It is perfectly rational for a student to choose the No Change option, but the only policy scenario that would be rational is Scenario A as it includes attributes that are all more improved at a lower cost than Scenario B. Again, you can call out students who were clearly not paying attention (do not actually do this, just let them know that you know). 

## License

The software code contained within this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). The data and figures are made available under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) license.
