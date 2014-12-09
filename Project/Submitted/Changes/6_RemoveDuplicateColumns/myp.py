import csv


mlblst = []
with open("mlbdata.csv") as mlbin:
    mlbcsv = csv.reader(mlbin)
    for row in mlbcsv:
        if len(row) != 0:
            if row[0].upper().strip() == "YEARP1":
                header = row
                row = [e.upper().strip() for e in row]
                fi = row.index("RA", row.index("RA") + 1)
                si = row.index("SO", row.index("SO") + 1)
                if fi > si: fi, si = si, fi
            else:
                row.pop(si)
                row.pop(fi)
                mlblst.append(row)

header.pop(si)
header.pop(fi)
with open("mlbdataout.csv", "w", newline="") as mlbout:
    mlbcsv = csv.writer(mlbout)

    mlbcsv.writerow(header)
    for row in mlblst:
        mlbcsv.writerow(row)
    
