# bs23_flutter_task
The apk can be found the below drive link:
https://drive.google.com/file/d/1N4X2B3dlCGcG4d3gnV2Pn4_AGiJnr2QG/view?usp=sharing

Key features: 
1. The fetch data is stored in the local database using hive.
2. Scrolling will fetch 10 new items by maintaining pagination. Hold on some moments to see the data while scrolling since the data is being saved to the local storage.
3. The data cannot be fetched no more than once in every 30 minutes (Snackbar will visible after one fetch) .
4. Showed list of repositories on the homepage.
5. A repo details page by navigating by clicking on a item.
6. Sorting option persist in session.
7. details page contains stars, repo description, name, image, last update date time in the required format.
8. stored all fetched data.
9. Sort based on stars and updated

Extra:
Wrote Some Unit Tests, UI Tests and used flutter bloc as State Management by maintaing domain driven architechture.

Note: I have not completely refactored the code. I tried to maintain as much as possible in two days. Any suggestion would be greatful for my learning.

Screen Shots: 
Home Page:
![Screenshot_1705066591](https://github.com/Tarikul-Islam-Tuhin/flutter_2024/assets/119291006/9fe79c76-4a3f-405c-9803-34fc11dd911a)

Details Page: 
![Screenshot_20240113-113938](https://github.com/Tarikul-Islam-Tuhin/flutter_2024/assets/119291006/25dd0b29-55a8-4d61-bfd3-a1205b26208c)
