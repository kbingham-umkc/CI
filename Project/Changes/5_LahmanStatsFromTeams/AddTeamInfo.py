import csv

teams = {}
with open("Teams.csv") as teamsin:
    teamcsv = csv.reader(teamsin)

    for row in teamcsv:
        if len(row) > 0:
            if row[0].upper() == "YEARID":
                teamheader = row
            else:
                key = (row[0].strip(), row[3].strip())
                teams[key] = row

#We want the following new fields
addfields = ["GHome", "DivWin", 'WCWIN', 'LGWIN', 'WSWIN', 'AB', 'H', '2b', \
             '3b', 'hr', 'bb', 'so', 'so', 'sb', 'cs', 'hbp', 'sf', 'ra', \
             'ER', 'ERA', 'CG', 'SHO', 'SV', 'IPOuts', 'HA', 'HRA', 'BBA', \
             'SOA', 'E', 'DP', 'FP', 'attendance', 'BPF', 'PPF']


upheader = [e.upper().strip() for e in teamheader]
for fld in addfields:
    if fld.upper() not in upheader:
        print("Could not find field ", fld)


        
                      
mlbdata = {}
with open("mlbdata.csv") as mlbin:
    mlbcsv = csv.reader(mlbin)

    for row in mlbcsv:
        if len(row) > 0:
            if row[0].upper().strip() == "YEARP1":
                mlbheader = row
                for fld in addfields:
                    row.append(fld)
            else:
                key = (row[2].strip(), row[3].strip())
                mlbdata[key] = row
                if key in teams:
                    for fld in addfields:
                        row.append( teams[key][ upheader.index(fld.upper())])
                else:
                    for fld in addfields:
                        row.append("")



with open("mlbdataout.csv", "w") as mlbout:
    mlboutcsv = csv.writer(mlbout)
    mlboutcsv.writerow(mlbheader)
    sortlist = sorted(mlbdata.keys(), reverse = True)
    for key in sortlist:
        mlboutcsv.writerow(mlbdata[key])
