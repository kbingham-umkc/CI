#Takes CSV files from
#       http://www.baseball-reference.com/leagues/NL/
#       and http://www.baseball-reference.com/leagues/AL/
#       and creates a new output csv with each team year and % listed as a separate file.


import csv

def read_file(filename, outputfilename):

    with open(filename, mode="r") as input_file:

        with open(outputfilename, mode = "a") as output_file:

            csv_read = csv.reader(input_file)
            csv_write = csv.writer(output_file)

            for row in csv_read:
                if len(row) > 0:
                    if row[0].upper() == "YEAR":  #It's the header row.
                        header = row[:]
                    else:                         #It's a data row.
                        year = row[0]
                        games = row[1]
                        for index, teamvalue in enumerate(row[2:]):  # Go through the rest of the columns.
                            outputrow = [year, games, header[index + 2], teamvalue]
                            csv_write.writerow(outputrow)
                
    

read_file("leagues_AL__teams_team_wins3000.csv", "mlbdata.csv")
read_file("leagues_NL__teams_team_wins3000.csv", "mlbdata.csv")
