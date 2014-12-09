import csv


team_dict = {}

with open("mlbdata.csv") as openmlb:
    csvreader = csv.reader(openmlb)


    for row in csvreader:
        if len(row) != 0:
            if row[0].upper() == "YEAR":
                header = row
            else:
                team_dict[ (int(row[0]), row[1]) ] = row

newteams = {}
for year, teamsymbol in team_dict:
    nextyear = (year + 1, teamsymbol)
    lst = team_dict[(year, teamsymbol)][:]
    newteams[(year, teamsymbol)] = lst
    
    if nextyear in team_dict:
        lst.insert(0, str(year + 1))
        lst.insert(1, team_dict[nextyear][8])
    else:
        lst.insert(0, "")
        lst.insert(1, "")
        
with open("mlbout.csv", "w") as output:
    csvwriter = csv.writer(output)

    keylst = sorted(newteams.keys(), reverse=True)
    for key in keylst:
        csvwriter.writerow(newteams[key])
