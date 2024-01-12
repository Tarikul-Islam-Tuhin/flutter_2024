# bs23_flutter_task


Screen Shots: 
Home Page:
![Screenshot_1705066591](https://github.com/Tarikul-Islam-Tuhin/flutter_2024/assets/119291006/9fe79c76-4a3f-405c-9803-34fc11dd911a)

Details Page: 
![Screenshot_1705066599](https://github.com/Tarikul-Islam-Tuhin/flutter_2024/assets/119291006/dfcfc097-e562-4d5e-a1b5-23cfeb0764b2)

Key features: 
1. The fetch data is stored in the local database using hive.
2. Scrolling will fetch 10 new items by maintaining pagination.
3. The data cannot be fetched no more than once in every 30 minutes (Snackbar will visible after one fetch) .
4. Showed list of repositories on the homepage.
5. A repo details page by navigating by clicking on a item.
6. Sorting option persist in session.
7. details page contains repo description, name, image, last update date time in the required format.
8. stored all fetched data.

Extra:
Wrote Some Unit Tests, UI Tests and used flutter bloc as State Management by maintaing domain driven architechture.

Note: I have not sorted the list locally based on updated date time and stars. Right now, I sorted the list through query params during api call. I will do it by tonight. I missed the business somehow. In additon to that, I have not completely refactored the code. I tried to maintain as much as possible in two days. Any suggestion would be greatful for my learning.

