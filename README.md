# Auraforce
## Project Description
Auraforce is a custom project that leverages lightning communities, process automation, service cloud, sales cloud, and the lightning aura framework to fulfill the requirements of creating an interactive experience that consumes an external rest API.

## Technologies Used
- Salesforce
- Aura Components
- Apex
- SOQL
- Data Modeling
## Features
- Log in to community as an external user
- Search an external database for a video game title
- Add selected video game to 'I Want' or 'I Have' list

To-do list:
- Paginate returned results from external database
- Allow search and sort by other fields, such as available platforms or genre
- Allow creation of custom wishlists
- Create dynamic actions for games on lists
- Add link to purchase game

## Getting Started
Below are the basic steps to deploy this community to an org.
1. Enable communities in your org (the domain name you pick does not matter)
2. Make a community with the name "MyGamesPortal" (do not add a URL extension) and the template must be "Help Center" 
3. Activate the community
4. In git, navigate to the directory of your choice and run the command "git clone SourceURL" where SourceURL is provided from this repo
5. Open Visual Studio Code. Open the directory from the previous step from VS Code
6. Run the command sfdx force:auth:web:login or, from the command palette, run SFDX: Authorize an Org
7. In the browser window that opens, log in to your org and then close the window
8. In VS Code, run the command sfdx force:source:deploy or, from the command palette, run SFDX: Deploy Source to Org

## Usage
Look for game portal in app launcher, then search for any game and click the action to add to want or have
