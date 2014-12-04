import csv

teamname_dict = {}
#Teams have a teamid and a franchise id.  we need to go from the team id to the franchise id
with open("teams.csv") as teamsin:
    csvteams = csv.reader(teamsin)
    for row in csvteams:
        if len(row) > 0 and row[0].upper() != "YEARID":
            teamname_dict[row[2].strip()] = row[3].strip()
                

salary_dict = {}
with open("salaries.csv") as infile:
    csvin = csv.reader(infile)

    for row in csvin:
        if row[0].upper() != "YEARID":
            key = (row[0].strip(), teamname_dict[row[1].strip()])
            salary = float(row[4])
            if key not in salary_dict:
                salary_dict[key] = []
            salary_dict[key].append(salary)

team_dict = {}
with open("mlbdata.csv") as mlbdata:
    csvmlb = csv.reader(mlbdata)

    for row in csvmlb:
        if len(row) > 0 and row[0].upper() != "YEARP1":
            key = (row[2].strip(), row[3].strip())
            ttlsalary = ""
            avgsalary = ""
            if key in salary_dict:
                ttlsalary = sum(salary_dict[key])
                avgsalary = str(ttlsalary / len(salary_dict[key]))
                ttlsalary = str(ttlsalary)
            row.append(ttlsalary)
            row.append(avgsalary)
            team_dict[key] = row
        elif len(row) > 0:
            header = row
            header.append("ttlsalary")
            header.append("avgsalary")

with open("mlbdataout.csv", "w") as mlbdata:
    csvout = csv.writer(mlbdata)
    csvout.writerow(header)

    sortlist = sorted(team_dict.keys(), reverse=True)
    for key in sortlist:
        csvout.writerow(team_dict[key])

        
