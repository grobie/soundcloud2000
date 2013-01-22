# soundcloud2000

The next generation SoundCloud client. Without all these stupid CSS files.

![Screen Shot 2013-01-20 at 15 37 03](https://f.cloud.github.com/assets/3432/81282/06c44c7e-630f-11e2-9a91-85c9b917835c.png)
![Screen Shot 2013-01-20 at 15 37 54](https://f.cloud.github.com/assets/3432/81281/06b05df4-630f-11e2-8b55-7f3c18126831.png)

This hack was built at the [Music Hack Day Stockholm 2013](http://stockholm.musichackday.org/2013).

There are currently some issues with filling the play buffer while still downloading the mp3 file.

## Requirements
 
  * ruby 1.9
  * Core Audio (only available on OSX and iOS)
  * FFTW

## Installation

    brew install fftw
    bundle install
    bin/soundcloud2000

## Features

  * stream SoundCloud tracks in your terminal (`enter`)
  * scroll through sound lists (`down` / `up`)
  * play / pause support (`space`)
  * forward / rewind support (`right` / `left`)
  * play tracks of different users (`u`)
  * basic spectrum analyzer

## Planned

  * no more hardcoded four-tet profile, play any streams, sets or sounds
  * better browsing between users and sound lists
  * fix playback glitches during file download
  * Linux support

## Authors

  * [Matthias Georgi](https://github.com/georgi) ([@mgeorgi](https://twitter.com/mgeorgi))
  * [Tobias Schmidt](https://github.com/grobie) ([@dagrobie](https://twitter.com/dagrobie))

## Contributors

 *  [Travis Thieman](https://github.com/tthieman) ([@tthieman](https://twitter.com/thieman))
