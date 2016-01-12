#!/usr/bin/env bash
#
# Build a RPM for magerun
#
# David Wooldridge - 11 Jan 2016

[[ $TRACE ]] && set -x
set -e
set -o pipefail

build_number="${1:-1}"
package_name='magerun'
prefix_dir='usr'
build_dir='buildroot'
user='root'
group="$user"
git_user=$(git config --get-all user.name)
git_email=$(git config --get-all user.email)
maintainer="$git_user <$git_email>"
root_dir=$(git rev-parse --show-toplevel)
tmp_dir='tmp'

which curl >/dev/null || exit 1
which fpm >/dev/null || exit 1
which php >/dev/null || exit 1

cd "$root_dir"

# Create temp directory
if [[ ! -d "$tmp_dir" ]]; then
  mkdir "$tmp_dir"
fi

# Clean up old builds
if [[ -d "$build_dir" ]]; then
  rm -rf "$build_dir"
fi
mkdir -p "$build_dir"

download_file() {
  local url=$1
  local file=${url##*/}

  if [[ ! -f "${tmp_dir}/${file}" ]]; then
    echo "Downloading: $file"
    curl $url -o "${tmp_dir}/${file}"
    if [[ ! -f "${tmp_dir}/${file}" ]]; then
      echo "Could not download file: $file"
      exit 1
    fi
  fi
}

download_file http://files.magerun.net/n98-magerun-latest.phar

mkdir -p ${build_dir}/${prefix_dir}/bin
cp ${tmp_dir}/n98-magerun-latest.phar ${build_dir}/${prefix_dir}/bin/magerun
chmod 755 ${build_dir}/${prefix_dir}/bin/magerun
version=$(${build_dir}/${prefix_dir}/bin/magerun --no-ansi --version | awk '{print $3}')

cd "$build_dir"

echo "Building RPM..."
fpm \
  -s dir \
  -t rpm \
  --name "$package_name" \
  --provides "$package_name" \
  --version $version \
  --license 'MIT' \
  --description "$package_name - $version" \
  --architecture 'noarch' \
  --maintainer "$maintainer" \
  --iteration $build_number \
  --url "https://github.com/netz98/n98-magerun" \
  --rpm-user "$user" \
  --rpm-group "$group" \
  --package $root_dir \
  "$prefix_dir"

