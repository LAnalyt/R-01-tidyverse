# 1 IMPORTING DATA

# 1.1 Paths and the working directory ####
# The first step when importing data from a spreadsheet is to locate the file containing the data.
# directories:  folders that contain data.
# root directory: folder that contain all other folders
# working directory: the directory in which we are currently located. Get the full path of the current working directory without writing out explicitly:
wd <- getwd()
wd
# Change working directory with setwd() or Ctrl+Shift+H in Rstudio.
# Explore the working directory:
dir()

# The path of a file is a list of directory names that can be thought of as instructions on what folders to click on, and in what order, to find the file. 
# full path: finding the file from the root directory.
# relative path: finding the file starting in the working directory. It is recommended to use relative paths because full paths are unique to each computer and the code should be portable.

# 1.2 readr ####
# The readr library includes functions for reading data stored in text file spreadsheets into R. 
library(readr)
# We can open the file to examine or have a look at a few lines.
read_lines("bakeoff.csv", n_max = 3)
# When creating spreadsheets with text files, a new row is defined with return and columns are separated with some predefined special character. The most common characters are comma (,), semicolon (;), space ( ), and tab (a preset number of spaces or \t).
# This also shows that there is a header. Now we are ready to read-in the data into R. From the .csv suffix and the peek at the file, we know to use read_csv:
dat <- read_csv("bakeoff.csv")
# header: he first row contains column names rather than data. When we read-in data from a spreadsheet it is important to know if the file has a header or not. Most reading functions assume there is a header. 
dat
# The result is a tibble, not a just data frame, because read_csv is a tidyverse parser. We can confirm that the data has in fact been read-in with:
View(dat)

# Other functions inr readr are available to read-in spreadsheets:
# read_csv2: semicolon separated values format, typical .csv suffix
# read_tsv: tab delimited separated values, typical .tsv suffix
# read_table: white space separated values, typical .txt suffix
# read_delim: general text file format, must define delimiter, typical .txt suffix.

# 1.3 Downloading files ####
# Another common place for data to reside is on the internet. When these data are in files, we can download them and then import them or even read them directly from the web.
url <- "https://raw.githubusercontent.com/ltrangng/R-01-tidyverse/master/0_data/bakeoff.csv"
# The read_csv file can read these files directly:
read_csv(url)
# To have a local copy of the file, you can use the download.file(). 
download.file(url, "test.csv")
# This will download the file and save it on your system with the custom name.
# Two functions that are sometimes useful when downloading data from the internet:
# tempdir():  creates a directory with a random name that is very likely to be unique.
# tempfile(): creates a character string, not a file, that is likely to be a unique filename. 
tmp_filename <- tempfile()
download.file(url, tmp_filename)
dat <- read_csv(tmp_filename)
file.remove(tmp_filename) # This command erases the temporary file once it imports the data.
  