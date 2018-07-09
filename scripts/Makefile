all : setup test

setup :
	powscript --compile setup.pow > setup.sh
	chmod u+x setup.sh

test :
	powscript --compile test.pow > test.sh
	chmod u+x test.sh
