#!/usr/bin/env bash


# To add a new python version, just add a folder.
# E.g. mkdir -p python3.8/stretch/onbuild



set -e;
declare -A blacklist=(
 [bot]=1  [templates]=1  [examples]=1
)
# set -x;
set -o nounset;  # Treat undefined variables as errors, not as null.
set -o pipefail; # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully.
set -o errtrace;
shopt -s nullglob;


# cd "$(dirname "$(readlink -f "$BASH_SOURCE")")" # todo?

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#

	EOH
}

travisEnv=
appveyorEnv=
readme=
echo "versions:" ${versions[@]};
for folder in "${versions[@]}"; do
    if [[ -n "${blacklist[$folder]:-}" ]]; then
        echo "Skipping $folder, blacklist"
        continue
    fi
    version=${folder#python}
    if [ "python$version" != "$folder" ]; then
		echo "Skipping $folder, not python*"
        continue
	fi

    echo "Trying $version"

    # check if is '-rc' version
	rcVersion="${version%-rc}"
	rcVersion="${rcVersion#python}"
	rcGrepV='-v'
	if [ "$rcVersion" != "${version#python}" ]; then
		rcGrepV=
	fi

    # get possible versions, via the tags on github.
	possibles=( $(
		{
			git ls-remote --tags https://github.com/python/cpython.git "refs/tags/v${rcVersion}.*" \
				| sed -r 's!^.*refs/tags/v([0-9.]+).*$!\1!' \
				|| :

			# this page has a very aggressive varnish cache in front of it, which is why we also scrape tags from GitHub
			curl -fsSL 'https://www.python.org/ftp/python/' \
				| grep '<a href="'"$rcVersion." \
				| sed -r 's!.*<a href="([^"/]+)/?".*!\1!' \
				|| :
		} | sort -ruV  # todo
	) )
	echo "possibles: ${possibles[@]}";
	fullVersion=
	for possible in "${possibles[@]}"; do
		possibleVersions=( $(
			curl -fsSL "https://www.python.org/ftp/python/$possible/" \
				| grep '<a href="Python-'"$rcVersion"'.*\.tar\.xz"' \
				| sed -r 's!.*<a href="Python-([^"/]+)\.tar\.xz".*!\1!' \
				| grep $rcGrepV -E -- '[a-zA-Z]+' \
				| sort -rV \
				|| true
		) )
		if [ "${#possibleVersions[@]}" -gt 0 ]; then
			fullVersion="${possibleVersions[0]}"
			break
		fi
	done

	if [ -z "$fullVersion" ]; then
		{
			echo
			echo
			echo "  error: cannot find $version (alpha/beta/rc?)"
			echo
			echo
		} >&2
		exit 1
	fi

	echo "$version: $fullVersion"

	# "python3.6/stretch/port/onbuild"
	# $dir: "python3.6/stretch/port/onbuild"
	# $version: "3.6"
	# $template_version: "port" | "socket"
	# $v: "stretch/port/onbuild"
	# $variant: "onbuild" | "alpine" | "windowsserver"
	# $template: "debian" | "onbuild"
	#
    for template_version in \
        port \
        socket \
    ; do
        for v in \
            alpine{3.4,3.6} \
            {wheezy,jessie,stretch,buster}/${template_version}{/slim,/onbuild,} \
            windows/{windowsservercore,nanoserver} \
        ; do
            dir="python$version/$v"
            echo "dir: $dir"

            # check if exists
            if [ ! -d "$dir" ]; then
                echo "folder: not found, skipping"
                continue
            fi
            echo "folder: found, let's go"

            echo "…"
            variant="$(basename "$v")"  # python3.6/port/onbuild -> onbuild    python3.6/port -> port
            echo "version: $version"
            echo "template: $template_version";
            echo "variant: $variant"

            case "$variant" in
                slim|onbuild)  # python3.6/port/onbuild -> onbuild
                    template="$variant";  # onbuild
                    variant=="$(basename "$(dirname "$dir")")";  # port
                    tag="$(basename "$(dirname "$dir")")";  # port
                ;;
                alpine*) template='alpine'; tag="${variant#alpine}" ;;
                *) template='debian'; tag="$variant" ;;
            esac
            template="templates/Dockerfile.${template_version}.${template}.template"
            echo "template: $template"

            if [[ "$version" == 2.* ]]; then
                echo "  TODO: vimdiff ${versions[-1]}/$v/Dockerfile $version/$v/Dockerfile"
            else
                { generated_warning; cat "$template"; } > "$dir/Dockerfile"
            fi

            sed -ri \
                -e 's/^(FROM python):%%PLACEHOLDER%%/\1:'"$version-$tag"'/' \
                -e 's/^(FROM luckydonald\/telegram-bot):%%PLACEHOLDER%%/\1:'"$version-$tag"'/' \
                -e 's!^(LABEL docker\.image\.base="luckydonald/telegram-bot:)%%PLACEHOLDER%%(")!\1'"${version}-${tag}"'\2!' \
                -e 's!^(LABEL docker\.image\.base="luckydonald/telegram-bot:)%%PLACEHOLDER%%(-onbuild")!\1'"${version}-${tag}"'\2!' \
                "$dir/Dockerfile"

            case "$v" in
                */onbuild) ;;
                windows/*)
                    appveyorEnv="$appveyorEnv"'\n    - version: '"$version"'\n      variant: '"$variant"
                    ;;
                *)
                    travisEnv="$travisEnv"'\n  - VERSION='"$version"' VARIANT='"$v"' MODE=build'
                    # travisEnv="$travisEnv"'\n  - VERSION='"$version"' VARIANT='"$v"' MODE=tests'
                    ;;
            esac
        done
    done
done
echo -e '=== <travisEnv> ==='"$travisEnv\n"'=== </travisEnv> ==='
travis=$(sed '/env:/,/before_install:/c\env:'"$travisEnv"'\nbefore_install:' .travis.yml)
echo "$travis" > .travis.yml



#appveyor="$(awk -v 'RS=\n' '$1 == "environment:" { $0 = "environment:\n  matrix:'"$appveyorEnv"'" } { printf "%s%s", $0, RS }' .appveyor.yml)"
#echo "$appveyor" > .appveyor.yml
