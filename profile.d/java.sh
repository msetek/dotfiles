java-skeleton-project() {
    if [[ $# != 1 ]]; then
        return 1
    fi

    local appname="$1"
    local appnamelc=$(echo -n "$appname" | tr A-Z a-z)

    if hash mvn 2> /dev/null; then
        mvn archetype:generate \
            -DgroupId="no.setek.$appnamelc" \
            -DartifactId=$appname \
            -DarchetypeArtifactId=maven-archetype-quickstart \
            -DinteractiveMode=false

    else
        echo "maven is not installed"
    fi
}

export JAVA_HOME=$(/usr/libexec/java_home)

