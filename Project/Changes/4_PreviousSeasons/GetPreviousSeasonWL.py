import csv

stat_dict = {}
with open("mlbdata.csv", "r") as mlbin:
    mlbcsv = csv.reader(mlbin)

    for row in mlbcsv:
        if len(row) > 0:
            if row[0].upper() == "YEARP1":
                header = row
            else:
                stat_dict[ (row[2].strip(), row[3]) ] = row


#Now go through each key in hte dictionary and if the year exists, we will get the previous 5 years

for year, teamid in stat_dict:
    yearint = int(year)
    currentrow = stat_dict[(year, teamid)]
    for prev in range(1, 6):
        yearint -= 1

        newkey = (str(yearint), teamid)
        if newkey in stat_dict:
            currentrow.append( stat_dict[newkey][10] )
        else:
            currentrow.append("")


header.append("YPN2")
header.append("YPN3")
header.append("YPN4")
header.append("YPN5")
header.append("YPN6")

with open("mlboutput.csv", "w") as mlbout:
    mlbcsv = csv.writer(mlbout)

    mlbcsv.writerow(header)

    sortlst = sorted(stat_dict.keys(), reverse=True)
    for key in sortlst:
        mlbcsv.writerow(stat_dict[key])

        
