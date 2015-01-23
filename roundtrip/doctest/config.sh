# generalconfiguration for test tools
# to be included in all tests

# Sequence of operations
# ../convall.sh on the target computer
# ../printall.sh on the source system
# ../compareall.sh
# ../gencsv.sh > all.csv
# ../genods.py -i all.csv -o rslt.ods

format="doc"
sourcedir="orig"

# apps, by which test documents were created, i.e. for which directories exist
rtripapps="GD LO40 MS07 MS10 LO41 LO42 LO43 LO44"
rtripapps="GD MS07 MS10 OO33 AO40 AO41 LO40 LO41 LO42 LO43 LO44"
rtripapps="LO40 LO41 LO42 LO43 LO44"
rtripapps="LO44"
#rtripapps="OO33 AO40 AO41"

# apps to be used for printing
sourceapp="MS13"
