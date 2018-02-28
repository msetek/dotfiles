unpackrpm() {
    local pkgname=$(basename "$1" .rpm)
    if mkdir "$pkgname"; then
        (cd "$pkgname" && rpm2cpio "$1" | cpio -idmv)
    else
        echo "Could not create the directory $pkgname" &2>1
    fi
}
