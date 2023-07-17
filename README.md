# Mobile Application Slavia

This repository contains the mobile application Slavia, which is divided into two parts: Front-end and Back-end. The Front-end is developed in Flutter, while the Back-end is implemented in Python and Node.js using TypeScript.

## Front-end

The Front-end part of the application is written in Flutter and consists of the following screens:

### Introduction Screen

Upon launching the application, the user is presented with an introduction screen that provides information about the application and its key features.

### Home Page

After clicking the button on the introduction screen, the user is taken to the main core of the application, the Home Page. The Home Page includes a bottom navigation bar that allows the user to navigate through the following screens:

- **Post Page**:
  - This screen displays all the posts related to the Slavia football club.
  - The posts can be filtered using a tab selector in the following categories:
    - A-Team
    - B-Team
    - Woman
    - U-19
    - Club
  - In the background, there is a script running that constantly updates the posts to keep them up to date.
  - When the user clicks on a post, they are redirected to the Post Screen, where they can read the full article.
  - To return to the menu, the user can click on the arrow icon in the top left corner or swipe from the edge of the screen.

- **Video Screen**:
  - This screen provides access to all the club videos with preview images and short descriptions.
  - When the user clicks on a video, they are redirected to the VideoView Screen, where a built-in video player allows them to watch the video without being redirected to another application.

- **Matches Screen**:
  - This is the most complex section of the application. It includes all the upcoming and previous football matches of the Slavia club. The match data and details are obtained from the Back-end, which is implemented in Python and Node.js using TypeScript. The Back-end provides real-time match data using the Server-Sent Events (SSE) technology, allowing automatic updates on the page when there are changes in the server data.
  - **Upcoming Match**:
    - Displays the upcoming match with a countdown, league name, team logos, and names.
    - When the user clicks on the upcoming match, a dialog window appears with all the available information about the match, such as the date and time, venue, teams, and league.
  - **Upcoming Matches**:
    - Displays a list of all the upcoming matches of the Slavia club.
    - Each match includes information about the league name, date and time, venue, and participating teams.
    - When the user clicks on an upcoming match, a dialog window appears with the match details, including league information, date and time, venue, teams, and other relevant details.
  - **Previous Matches**:
    - Displays a list of all the previous matches of the Slavia club, sorted from newest to oldest.
    - When the user clicks on a previous match, they are redirected to the MatchScreen with the details of the selected match.
  - **MatchScreen**:
    - Displays the details of a specific match, including the league name, teams, result, date and time, venue, and other relevant information.
    - Includes a timeline of events during the match, team lineups, and match comments.

- **Forum Page Screen**:
  - When users first visit this section, the application prompts them to enter a username to be used within the application.
  - This section displays posts from all application users.
  - **Post List**:
    - Each post in the list includes the author, date added, title, a partial text, tags (if added by the author), and the number of comments.
  - **Post Sorting and Filtering**:
    - Users have the option to sort posts by creation date or the most recent ones.
    - They can also apply filters based on tags to view posts with specific tags.
  - **Forum Screen**:
    - When users click on any post, they are redirected to the Forum Screen, where the author's name, date added, title, complete text, and tags (if added by the author) are displayed.
    - Comments with a hierarchical structure are displayed below the post.
  - **Comments with Hierarchy**:
    - Users can reply to other users, creating a hierarchical structure of comments.
    - Each comment includes the number of comments replying to that comment.
    - Users can toggle the visibility of comments under each comment.

- **Setting Screen**:
  - On the Setting Screen, users can customize various settings related to the application.
  - **User Name**:
    - Users can view and edit their user name.
  - **Notifications**:
    - Users can toggle notifications for the application on or off.
  - **Delete Stored Offline Data**:
    - Users can delete all the stored data used for offline functionality, including downloaded posts, videos, matches, and other cached data on their device.
  - **Refresh Connection to Server**:
    - Users can manually refresh the connection to the server, updating the data and ensuring synchronization with the latest information from the server.

## Back-end

The Back-end part of the application is divided into several sections:

### API-Services

This section of the back-end handles the communication and data distribution through the API. It provides an interface for the front-end to communicate with the back-end and retrieve the necessary data.

### Python

This back-end section is implemented in Python and is responsible for retrieving club posts and videos. The data obtained is then sent to the API section using an internal Docker network.

### Slavia-A

This back-end section contains a complex algorithm for retrieving data from previous and upcoming matches of the Slavia-A team. The algorithm takes care of storing and filtering the data. It also daily checks if there is a match scheduled for the day and, if so, triggers the Live_Match function. The Live_Match function retrieves, checks, evaluates, and stores the data using the algorithm. It sends application notifications through SSE (Server-Sent Events) in case of any data changes.

### Slavia-B, Slavia U-19, Slavia-Woman

These back-end sections function similarly to the Slavia-A section but are focused on the Slavia-B, Slavia U-19, and Slavia-Woman teams, respectively. Each section handles data retrieval, storage, and filtration specific to the corresponding team.

These back-end sections ensure the management and distribution of data in the Slavia application.

If you have any questions or need further information, please don't hesitate to contact us.
