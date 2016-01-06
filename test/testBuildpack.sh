#!/bin/bash
OUTPUT=`cf buildpacks | grep "bwce-buildpack"`
if [ -z "$OUTPUT" ]; then
    echo "bwce-buildpack is not found in the buildpacks. Run ../build/createBuildpack.sh and ../build/uploadBuildpack.sh to create/upload the buildpack."
    exit 1
fi


echo "***** Starting BWCE Sanity *****"

echo "***** Pushing HTTP Greetings App to CF *****"
URL=`cf push -f manifest.yml | grep "urls:" | cut -d ' ' -f 2`
sleep 5
a=$(curl "http://$URL/greetings/")
BWCE_MESSAGE=`grep -E "RESPONSE_MESSAGE:" manifest.yml | cut -d ':' -f 2 | tr -d ' ' `
if [ "${a}" = "Greetings from $BWCE_MESSAGE" ]; then
    echo "----------------------------------------------------------------------";
        echo "******* HTTP Greetings App - running successfully! *******";
     echo "******* HTTP Greetings App - test passed! *******";
    echo "----------------------------------------------------------------------";
else
    echo ${a}
    echo "----------------------------------------------------------------------";
    echo "******* HTTP Greetings App Failed ! Deleting App *******";
    echo "----------------------------------------------------------------------";
    echo "----------------------------------------------------------------------";
    echo "******* bwce-buildpack test Failed ! *******";
    echo "----------------------------------------------------------------------";
    cf delete httpapp -f
    exit -1

fi

cf delete httpapp -f
