# Book Manager

Book Manager is a simple two tab application where a user can search open library.org for books and add desired ones to a wish list.

## Installation

This project uses Realm and CocoaPods. If you would like to visualize your local Realm database, please see this link regarding realm studio:

https://realm.io/products/realm-studio/

Otherwise, in terminal, you can run:

pod install

From the root directory of the project to install needed pod files.


## Usage

There is a drop down menu in the first search tab where you can choose to query by "Any", "Title", or "Author" (it defaults to "Any"). Simply enter your desired search in the text field and it will automatically populate with matching books. Selecting a row takes you to a details page where you can opt to add the book to your wish list.

The second tab is your wish list where you will see a list of the books you have added. To delete a book swipe to the left on the desired row. Selecting a row takes you to a details page where you can see more information about the saved book.

## License
[MIT](https://choosealicense.com/licenses/mit/)