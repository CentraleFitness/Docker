#!/bin/sh

cat -e src/intra_gerant/src/utils/Paths.js | grep HOST
sed -i '2s/HOST:.*/HOST:"https:\/\/api.intranet.centrale-fitness.fr.nf",/' src/intra_gerant/src/utils/Paths.js
cat -e src/intra_gerant/src/utils/Paths.js | grep HOST
echo;
cat -e src/intra_admin/src/utils/Paths.js | grep HOST
sed -i '5s/HOST:.*/HOST:"https:\/\/api.admin.centrale-fitness.fr.nf",/' src/intra_admin/src/utils/Paths.js
cat -e src/intra_admin/src/utils/Paths.js | grep HOST
echo;
cat -e src/Server/src/main/java/model/Database.java | grep "ip = "
sed -i '54s/private static String ip = ".*/private static String ip = "mango";/' src/Server/src/main/java/model/Database.java
cat -e src/Server/src/main/java/model/Database.java | grep "ip = "