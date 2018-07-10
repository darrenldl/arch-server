all : setup test

setup :
	powscript --compile setup.pow > setup.sh.tmp
	echo "#!/bin/bash" > setup.sh
	cat setup.sh.tmp >> setup.sh
	rm setup.sh.tmp
	chmod u+x setup.sh

test :
	powscript --compile test.pow > test.sh.tmp
	echo "#!/bin/bash" > test.sh
	cat test.sh.tmp >> test.sh
	rm test.sh.tmp
	chmod u+x test.sh

utils :
	powscript --compile utils.pow > utils.sh
	chmod u+x utils.sh
