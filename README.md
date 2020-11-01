# istheweatherweird-data-hourly

This repository provides NOAA ISD hourly weather data for istheweatherweird.com. The data must be updated by running the workflow (see below) at least once per year.

## Output

- The output files are in the `csv` subdirectory.
- There is a listing of places and their metadata (station name, latitude, longitude, timezone, etc.) in `www/stations.csv`
- Files for each place (e.g. Chicago) are in a subdirectory identified as `$USAF-$WBAN`, e.g. `www/725300-94846`.
- For each place there are 366 CSV files, one for each day of the year, e.g. `www/725300-94846/0331.csv` contains data for March 31.
- The CSV format is `year,hour,temp`. Note that dates and hours are in UTC and temperatures are in the ISD format which is degrees celsius * 10 (e.g. -0122 is -12.2 degrees).

## Workflow

To generate these data we use `make`.
The task is take compressed, fixed width files from the FTP server and turn them into the output described above.
By using `make` we ensure both reproducibility and efficiency of the workflow (for example, when updating data we don't have to redownload existing files).

### First run 

To run the workflow for the first time

1. Specify the places you want in `stations_in.csv` file. 
    - You can use any name for a place. Stations are identified by the pair of `USAF` and `WBAN` codes.
    - For example the line for Chicago is
      ```
      Chicago,725300,94846
      ```
  
2. Run `make` (see `make` tips below) which will:
    - Download a station metadata file `www/isd-inventory.csv`
    - Check to see which years are available for each place
    - Download the data over FTP (in compressed fixed width format files, one per year) into the `www` subfolder
    - Decompress, convert to CSV and concatenate all data for a single station into `csv` subfolder
    - Create the outputs described above
 
3. Add it to git
    - By default all data is ignored by git. In order to save the results you must manually `git add` the output files, for example:
    ```
    git add -f csv/010080-99999/*.csv
    ```
    - To save space in the repository we do not add the intermediate files
    - When updating (see below), git will track the hitsory of the CSV files which is not necessary. If we run out of space or the repository is unbearably slow we could try deleting histories using `git filter-branch`

### Subsequent updates

`make` uses timestamps to check if an output needs to be rebuilt.
If any timestamps of any inputs are newer than those of an output, the output will be rebuilt.
After running the workflow once, subsequent `make` calls will return 

```
make: Nothing to be done for `all'.
```

However because our workflow involves files on an FTP server this isn't quite right.
The FTP files are actually being updated every day or so. Here are four cases for subsequent workflow runs. Note that the workflow will only redownload/rebuild files deemed necessary in each case.
This is usually good because it reduces unnecessary steps and so speeds things up.

#### Re-run everything
One way to do this is to just delete the `csv` and `www` directories and rerun `make`.

#### Update data in the middle of the year
To update data in the middle of the year, that year's files must be re-fetched. One way to do this is to delete the local versions
```
rm www/*-*-2019.gz
```
and re-run `make`.

#### Add data for a new year
  - As described above, the workflow uses `www/isd-inventory.csv` to figure out which years are valid.
  - When a year elapses the file is no longer valid so you can `rm www/isd-inventory.csv` and run `make`.

#### Add a new place
  - New places are added by editing the `stations_in.csv` file and running `make`. It should only need to process data for the new places and not touch the old ones.
  - For large cities with multiple potential stations you may wish to look at the `www/isd-history.csv` file which lists the first and last date of data for each station.

### Make tips

- Use `make --dry-run` before running `make` if you want to see what you are about to run
- The workflow can be run in parallel, e.g. `make --jobs=4`
