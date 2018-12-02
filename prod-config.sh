#!/bin/sh

cat -e src/intra_gerant/src/utils/Paths.js | grep HOST
sed -i '2s/HOST:.*/HOST:"\/\/api.centrale-fitness.fr.nf",/' src/intra_gerant/src/utils/Paths.js
cat -e src/intra_gerant/src/utils/Paths.js | grep HOST
echo;
cat -e src/intra_admin/src/utils/Paths.js | grep HOST
sed -i '5s/HOST:.*/HOST:"\/\/api.centrale-fitness.fr.nf",/' src/intra_admin/src/utils/Paths.js
cat -e src/intra_admin/src/utils/Paths.js | grep HOST
