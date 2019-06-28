# Project 2 - Flix

Flix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [X] User can search for a movie.
- [x] All images fade in as they are loading.
- [X] User can view the large movie poster by tapping on a cell.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the selection effect of the cell.
- [X] Customize the navigation bar.
- [x] Customize the UI.

The following **additional** features are implemented:

- [X] Added activity indicator while page is being loaded.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would like to know how to load just the video and not the youtube page when loading in the trailer from the database into my modal segue.
2. I'd like to learn more about using different features and functions of web kit.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/aSSw1uQpi5.gif' title='Video Walkthrough' width='' alt='Video Walkthrough'/>

GIF created with [Recordit](http://recordit.co/).

## Notes

The biggest challenge for me was understanding how to make requests for API databases and collecting the data from them using dictionaries and arrays. It was also difficult working with many different classes and view controllers, but this project helped me feel more comfortable working with them.
## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2019] [Yu Jin Kim]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
