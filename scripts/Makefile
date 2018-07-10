all : setup test

setup :
	powscript --compile setup.pow > setup.sh
	chmod u+x setup.sh

test :
	powscript --compile test.pow > test.sh
	chmod u+x test.sh

utils :
	powscript --compile utils.pow > utils.sh
	chmod u+x utils.sh
