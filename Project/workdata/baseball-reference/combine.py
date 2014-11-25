import csv
import os




def read_file(csv_in, csv_out, team):

   for row in csv_in:
       if len(row) > 0 and row[0].upper() != "RK":
           rowlist = [row[1], team] + row[2:]
           row[-1] = row[-1].strip()
           csv_out.writerow(rowlist)
    


with open("mlbdata.csv", "w") as outputfile:

    csv_writer = csv.writer(outputfile)

    for file in os.listdir():
        if file.upper().endswith("CSV") and \
                file.upper().startswith("TEAMS_"):

            with open(file, mode="r") as infile:
                csv_input = csv.reader(infile)
                team = file.split("_")[1]
                read_file(csv_input, csv_writer, team)
                
