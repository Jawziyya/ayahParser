<p align="center">
    <img src="Logo.png" width="480" max-width="100%" alt="AyahParser" />
</p>

This [Marathon](https://github.com/JohnSundell/marathon)-script will parse a given Ayah from [Al Quran Cloud API](https://alquran.cloud/api) and copy it to the clipboard.

# Installation

* Install [Marathon](https://github.com/JohnSundell/marathon)
* Run `marathon install Jawziyya/AyahParser`

# How to use

To copy an ayah to the clipboard, just run `ayahparser -ayah 1:1` from the terminal.

### Arguments

* `-ayah` __(required)__
* `-editions`; refer [this page](https://alquran.cloud/api) for available editions
* `-no-arabic`; by default, origin Ayah will be parsed, if this argument is passed, it'll be excluded