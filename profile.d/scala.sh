scala-new() {
    sbt new sbt/scala-seed.g8
    # what a piece of sh...
    if [[ -x ./target ]]; then
        rm -r ./target
    fi
}
