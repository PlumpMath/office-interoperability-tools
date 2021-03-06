#!/bin/bash
#set -o xtrace #be verbose

. $FTPATH/officeconf.sh

dpi=400		#dpi to render pdfs
threshold=166	#threshold to identify foreground

function usage
{
	echo "$0: Compare pdf files and generate pair pdfs" 1>&2
	echo "Usage: $0 applist" 1>&2
	#not functional
	#echo "    -d int ............ dpi for rendering of pdf files {$dpi}" 1>&2
	#echo "    -t int ............ threshold to identify foreground {$threshold}" 1>&2
	echo "If applist is not specified, all applications specified in config.sh will be processed." 1>&2
}

function cmp ()
{
	#echo 1 $1
	refpdf=`basename $1` 	#source document with suffix
    refpdf=${refpdf//$2.}   #Remove $app from file name
	refpdfn=`basename $refpdf .pdf`	#source document without suffix
	ddd=`dirname $1`
	subdir=${ddd/\.\//}	# nice subdir path
	spdf=$sourceapp/$subdir/$refpdf	#source document with nice path
	tpdf=$4/$subdir/$refpdfn	#target document with nice path without suffix
	
	if [ ! -e "${tpdf}-pair-l.pdf" ] || [ "${tpdf}-pair-l.pdf" -ot "$spdf" ];
	then
		echo $3 - Creating pairs for  $tpdf
		time timeout 120s  docompare.py -t $threshold -d $dpi -a -o $tpdf-pair $spdf $tpdf.pdf 2>/dev/null

	    if [ ! -e "${tpdf}-pair-l.pdf" ] || [ "${tpdf}-pair-l.pdf" -ot "$spdf" ];
	    then
            rm /tmp/*.tif
        fi

        if [ ! -e "${tpdf}.$2-pair-l.pdf" ] || [ "${tpdf}.$2-pair-l.pdf" -ot "$spdf" ];
        then
	        echo $3 - Creating pairs for  $tpdf.$2
	        time timeout 120s docompare.py -t $threshold -d $dpi -a -o $tpdf.$2-pair $spdf $tpdf.$2.pdf 2>/dev/null

            if [ ! -e "${tpdf}.$2-pair-l.pdf" ] || [ "${tpdf}.$2-pair-l.pdf" -ot "$spdf" ];
            then
                rm /tmp/*.tif
            fi
        fi
	fi
}

# read the options
TEMP=`getopt -o h --long help -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -h|--help) 
		usage; exit 1;;
	-g)
		shift
		dpi=$1
		shift
		;;
	-t)
		shift
		threshold=$1
		shift
		;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done
shift $(expr $OPTIND - 1 )

# file names: bullets.docx.pdf


if [[ $# -gt 0 ]] 
then
	while test $# -gt 0; 
	do
		if [ -d "$1" ]; then
  			echo Processing $1
			#for pdfdoc in $pdfs; do cmp `basename $pdfdoc` $1; done
			count=0
			for pdfdoc in $pdfs; do ((count++)); cmp $pdfdoc $1 $count; done
		else
  			echo Directory $1 does not exist
		fi
  		shift
	done
else
	for app in `echo $rtripapps`; do
  		echo Processing $app
		#for pdfdoc in $pdfs; do cmp `basename $pdfdoc` $app; done
        folder=$app'-'$(ver$app)
        cd $folder
        pdfs=`find . -name \*.pdf|grep -v pair|sort -n -k 1.7,1.9`
        cd ..
		count=0
		for pdfdoc in $pdfs; do ((count++)); cmp $pdfdoc $app $count $folder; done
	done
fi
