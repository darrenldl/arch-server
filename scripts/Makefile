all : setup add_ssh_keys test

setup :
	powscript --compile setup.pow > setup.sh.tmp
	echo "#!/bin/bash" > setup.sh
	cat setup.sh.tmp >> setup.sh
	rm setup.sh.tmp
	chmod u+x setup.sh

add_ssh_keys :
	powscript --compile add_ssh_keys.pow > add_ssh_keys.sh.tmp
	echo "#!/bin/bash" > add_ssh_keys.sh
	cat add_ssh_keys.sh.tmp >> add_ssh_keys.sh
	chmod u+x add_ssh_keys.sh

test :
	powscript --compile test.pow > test.sh.tmp
	echo "#!/bin/bash" > test.sh
	cat test.sh.tmp >> test.sh
	rm test.sh.tmp
	chmod u+x test.sh

utils :
	powscript --compile utils.pow > utils.sh
	chmod u+x utils.sh
