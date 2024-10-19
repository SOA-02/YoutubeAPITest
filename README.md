# LFM - TitleTOC
application that allows users to transfer the **title of videos in a playlist** to markdown language of **Table of Content(TOC)**.

## Objectives
### short term
* create **TOC** 
* recommend related learning resources on **YouTube**

### long term 
* add title of timestamp 
* recommend other online learning resources summarized by ChatGPT 

## User Scenario
### Gherkin
```gherkin=
Feature: List of Table of Content
  As a eager student
  I want to have a table of content from Gate Smasher 
  Because I want to take notes faster

  Scenario: User opens up YouTube & Note-taking app 
    Given I'm a logged-in YouTube User
    When I open up the web page
    And I click "Transfer to TOC"
    Then the TOC should be generated 
    And H1: # Title of Playlist
    And H2: ## Title of each video
```

## Resource
### YouTube API 
* **Entities:**
    * Channel
    * Playlist
    * Video

* **Elements**
    * Title
    * id
    * Thumbnail URL
    * description

## Setup
* Create a personal YouTube Token with ```public_repo``` scope
* Copy ```config/secrets_example.yml``` to ```config/secrets.yml``` and update token 
* Ensure correct version of Ruby install (see ```.ruby-version``` for ```rbenv```)
* run bundle install

## Running Tests
To run the test: 
```
rake spec
```







