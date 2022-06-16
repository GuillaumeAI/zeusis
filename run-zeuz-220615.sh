
EULA_STUFF="-e MSSQL_PID=Developer -e ACCEPT_EULA=Y -e ACCEPT_EULA_ML=Y "
ddir=/mnt/c/var/lib/mssql/data
mkdir -p $ddir
. .env &> /dev/null && echo "ENvironment loaded" || echo "Environment loading failed"
if [ ! -f ".env" ] || [ "$SAPWD" == "" ];then echo ".env file not found or \$SAPWD variable not defined.";echo "echo \"SAPWD='MyP9ssw0rd2022' >> .env'\"";echo "wont do more ;)"
else # Do the work
mlocation=/data

RUNMODE="run -d"
if [ "$1" == "fg" ] ; then RUNMODE="run -it --rm ";fi

dockertag="docker.io/guillaumeai/server:mssql-mls-220312"

dockertag="docker.io/guillaumeai/server:zeuz"

dockertag="docker.io/guillaumeai/server:mssql-mls-220312-ssis"
dockertag="docker.io/guillaumeai/server:zeuz-mssql-ml-ubuntu-16.04-ssis"

dockertag="docker.io/jgwill/zeus:zeuzis-2206150918"
dockertag="docker.io/guillaumeai/server:zeuz-mssql-ml-ubuntu-16.04-ssis2"

containername=zeuzis

if [ "$1" == "--rm" ]; then docker rm -f $containername ;fi

#Ports
MSSQL_PORTMAP="-p 1433:1433"
WWW_PORTMAP="-p 8433:8433" #futur Web access
MSSQL_PORTMAP_1431="-p 1431:1431"
SSIS_PORTMAP="-p 3882:3882"

#volument
AppSuiteDataRootPathMount="-v $AppSuiteDataRootPath:/var/lib/caishen/data"
AppSuiteConfigRootPathMount="-v $AppSuiteConfigRootPath:/var/lib/caishen/config"

cmd="docker $RUNMODE $EULA_STUFF --name $containername \
     $AppSuiteDataRootPathMount $AppSuiteConfigRootPathMount \
     -e MSSQL_SA_PASSWORD="\'$SAPWD\'" \
     -v $ddir:$mlocation -v $(pwd):/work \
     $MSSQL_PORTMAP $SSIS_PORTMAP $MSSQL_PORTMAP_1431 $WWW_PORTMAP \
     $dockertag $2 $3 $4 $5 $6"

echo "$cmd"
$cmd

#jgwill/zeus:zeuz-2206150813 







fi # we did the work if the env was fine
