
EULA_STUFF="-e MSSQL_PID=Developer -e ACCEPT_EULA=Y -e ACCEPT_EULA_ML=Y "
ddir=/mnt/c/var/lib/mssql/data
mkdir -p $ddir
. .env &> /dev/null && echo "ENvironment loaded" || echo "Environment loading failed"
if [ ! -f ".env" ] || [ "$SAPWD" == "" ];then echo ".env file not found or \$SAPWD variable not defined.";echo "echo \"SAPWD='MyP9ssw0rd2022' >> .env'\"";echo "wont do more ;)"
else # Do the work
mlocation=/data

RUNMODE="run -d"
dockertag="docker.io/guillaumeai/server:mssql-mls-220312"

dockertag="docker.io/guillaumeai/server:zeuz"

dockertag="docker.io/guillaumeai/server:mssql-mls-220312-ssis"
dockertag="docker.io/guillaumeai/server:zeuz-mssql-ml-ubuntu-16.04-ssis"

dockertag="docker.io/jgwill/zeus:zeuzis-2206150918"
dockertag="docker.io/guillaumeai/server:zeuz-mssql-ml-ubuntu-16.04-ssis2"

containername=zeuzis

if [ "$1" == "--rm" ]; then docker rm -f $containername ;fi

MSSQL_PORTMAP="-p 1433:1433"
SSIS_PORTMAP="-p 3882:3882"

cmd="docker $RUNMODE $EULA_STUFF --name $containername \
     -e MSSQL_SA_PASSWORD="$SAPWD" \
     -v $ddir:$mlocation -v $(pwd):/work \
     $MSSQL_PORTMAP $SSIS_PORTMAP \
     $dockertag"

echo "$cmd"
$cmd

#jgwill/zeus:zeuz-2206150813 







fi # we did the work if the env was fine